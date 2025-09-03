import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// SymEngine wrapper function signatures
typedef SymEngineEvaluateC = Pointer<Utf8> Function(Pointer<Utf8> expression);
typedef SymEngineSolveC = Pointer<Utf8> Function(Pointer<Utf8> expression, Pointer<Utf8> symbol);
typedef SymEngineFreeStringC = Void Function(Pointer<Utf8> str);
typedef SymEngineFactorC = Pointer<Utf8> Function(Pointer<Utf8> expression);
typedef SymEngineExpandC = Pointer<Utf8> Function(Pointer<Utf8> expression);

typedef SymEngineEvaluateDart = Pointer<Utf8> Function(Pointer<Utf8> expression);
typedef SymEngineSolveDart = Pointer<Utf8> Function(Pointer<Utf8> expression, Pointer<Utf8> symbol);
typedef SymEngineFreeStringDart = void Function(Pointer<Utf8> str);
typedef SymEngineFactorDart = Pointer<Utf8> Function(Pointer<Utf8> expression);
typedef SymEngineExpandDart = Pointer<Utf8> Function(Pointer<Utf8> expression);

// Direct GMP signatures - EXACT copy from your working version
typedef MpzInitSetStrNative = Int32 Function(Pointer<Void> rop, Pointer<Utf8> str, Int32 base);
typedef MpzGetStrNative = Pointer<Utf8> Function(Pointer<Utf8> str, Int32 base, Pointer<Void> op);
typedef MpzClearNative = Void Function(Pointer<Void> x);
typedef MpzPowUiNative = Void Function(Pointer<Void> rop, Pointer<Void> base, Uint64 exp);
typedef FreeNative = Void Function(Pointer<Void> ptr);

typedef MpzInitSetStrDart = int Function(Pointer<Void> rop, Pointer<Utf8> str, int base);
typedef MpzGetStrDart = Pointer<Utf8> Function(Pointer<Utf8> str, int base, Pointer<Void> op);
typedef MpzClearDart = void Function(Pointer<Void> x);
typedef MpzPowUiDart = void Function(Pointer<Void> rop, Pointer<Void> base, int exp);
typedef FreeDart = void Function(Pointer<Void> ptr);

/// Combined bridge class using your EXACT working GMP code + working SymEngine
class CasBridge {
  late final DynamicLibrary _dylib;
  
  // SymEngine wrapper functions
  late final SymEngineEvaluateDart _evaluate;
  late final SymEngineSolveDart _solve;
  late final SymEngineFreeStringDart _freeString;
  late final SymEngineFactorDart _factor;
  late final SymEngineExpandDart _expand;
  
  // Direct GMP functions - EXACT from your working version
  late final MpzInitSetStrDart _mpzInitSetStr;
  late final MpzGetStrDart _mpzGetStr;
  late final MpzClearDart _mpzClear;
  late final MpzPowUiDart _mpzPowUi;
  late final FreeDart _free;
  
  bool _symengineAvailable = false;
  bool _gmpDirectAvailable = false;

  CasBridge() {
    if (Platform.isIOS) {
      _dylib = DynamicLibrary.executable();
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('libgmp_bridge.so');
    } else {
      throw UnsupportedError('This platform is not supported.');
    }

    // Initialize SymEngine first
    try {
      _evaluate = _dylib.lookup<NativeFunction<SymEngineEvaluateC>>('symengine_evaluate').asFunction();
      _solve = _dylib.lookup<NativeFunction<SymEngineSolveC>>('symengine_solve').asFunction();
      _freeString = _dylib.lookup<NativeFunction<SymEngineFreeStringC>>('symengine_free_string').asFunction();
      _factor = _dylib.lookup<NativeFunction<SymEngineFactorC>>('symengine_factor').asFunction();
      _expand = _dylib.lookup<NativeFunction<SymEngineExpandC>>('symengine_expand').asFunction();
      _symengineAvailable = true;
    } catch (e) {
      print('SymEngine not available: $e');
    }

    // Initialize direct GMP - EXACT same as your working version
    try {
      _mpzInitSetStr = _dylib.lookup<NativeFunction<MpzInitSetStrNative>>('__gmpz_init_set_str').asFunction();
      _mpzGetStr = _dylib.lookup<NativeFunction<MpzGetStrNative>>('__gmpz_get_str').asFunction();
      _mpzClear = _dylib.lookup<NativeFunction<MpzClearNative>>('__gmpz_clear').asFunction();
      _mpzPowUi = _dylib.lookup<NativeFunction<MpzPowUiNative>>('__gmpz_pow_ui').asFunction();
      _free = _dylib.lookup<NativeFunction<FreeNative>>('free').asFunction();
      _gmpDirectAvailable = true;
    } catch (e) {
      print('GMP Direct not available: $e');
    }
  }

  // SymEngine wrapper functions
  String evaluate(String expression) {
    if (!_symengineAvailable) return 'SymEngine not available';
    
    final Pointer<Utf8> exprPtr = expression.toNativeUtf8();
    try {
      final Pointer<Utf8> resultPtr = _evaluate(exprPtr);
      final String result = resultPtr.toDartString();
      _freeString(resultPtr);
      return result;
    } catch (e) {
      return 'Error: $e';
    } finally {
      calloc.free(exprPtr);
    }
  }

  String solve(String expression, String symbol) {
    if (!_symengineAvailable) return 'SymEngine not available';
    
    final Pointer<Utf8> exprPtr = expression.toNativeUtf8();
    final Pointer<Utf8> symbolPtr = symbol.toNativeUtf8();
    try {
      final Pointer<Utf8> resultPtr = _solve(exprPtr, symbolPtr);
      final String result = resultPtr.toDartString();
      _freeString(resultPtr);
      return result;
    } catch (e) {
      return 'Error: $e';
    } finally {
      calloc.free(exprPtr);
      calloc.free(symbolPtr);
    }
  }

  String factor(String expression) {
    if (!_symengineAvailable) return 'SymEngine not available';
    
    final Pointer<Utf8> exprPtr = expression.toNativeUtf8();
    try {
      final Pointer<Utf8> resultPtr = _factor(exprPtr);
      final String result = resultPtr.toDartString();
      _freeString(resultPtr);
      return result;
    } catch (e) {
      return 'Error: $e';
    } finally {
      calloc.free(exprPtr);
    }
  }

  String expand(String expression) {
    if (!_symengineAvailable) return 'SymEngine not available';
    
    final Pointer<Utf8> exprPtr = expression.toNativeUtf8();
    try {
      final Pointer<Utf8> resultPtr = _expand(exprPtr);
      final String result = resultPtr.toDartString();
      _freeString(resultPtr);
      return result;
    } catch (e) {
      return 'Error: $e';
    } finally {
      calloc.free(exprPtr);
    }
  }

  /// Test GMP: Calculate 2^exponent - EXACT copy from your working version
  String testGMPDirect(int exponent) {
    if (!_gmpDirectAvailable) return 'GMP Direct not available';
    
    final Pointer<Void> base = calloc<Uint8>(32).cast();
    final Pointer<Void> result = calloc<Uint8>(32).cast();
    try {
      final baseStr = '2'.toNativeUtf8();
      _mpzInitSetStr(base, baseStr, 10);
      calloc.free(baseStr);
      _mpzPowUi(result, base, exponent);
      final Pointer<Utf8> resultStrPtr = _mpzGetStr(nullptr, 10, result);
      final String resultString = resultStrPtr.toDartString();
      _free(resultStrPtr.cast());
      return resultString;
    } finally {
      _mpzClear(base);
      _mpzClear(result);
      calloc.free(base);
      calloc.free(result);
    }
  }

  /// Test GMP via SymEngine
  String testGMPViaSymEngine(int exponent) {
    return evaluate('2^$exponent');
  }

  /// Get comprehensive test results
  Map<String, List<String>> getTestResults() {
    final results = <String, List<String>>{};
    
    if (_symengineAvailable) {
      results['SymEngine (High-level)'] = [
        'Basic: ${evaluate('2+3*4')}',
        'Expand: ${expand('(x+1)^2')}', 
        'Factor: ${factor('x^2-1')}',
        'Solve: ${solve('x^2-4', 'x')}',
        'Via SymEngine 2^64: ${testGMPViaSymEngine(64)}',
      ];
    } else {
      results['SymEngine (High-level)'] = ['Not available'];
    }
    
    if (_gmpDirectAvailable) {
      results['GMP (Direct)'] = [
        'Direct 2^64: ${testGMPDirect(64)}',
        'Direct 2^128: ${testGMPDirect(128)}',
        'Direct 2^256: ${testGMPDirect(256)}',
      ];
    } else {
      results['GMP (Direct)'] = ['Not available'];
    }

    // For other libraries, show available symbols
    try {
      final symbolFinder = SymbolFinder();
      final symbols = symbolFinder.findAvailableSymbols();
      
      results['MPFR (Symbols)'] = symbols['MPFR']!.isNotEmpty 
          ? symbols['MPFR']!.take(3).toList()
          : ['No symbols found'];
          
      results['MPC (Symbols)'] = symbols['MPC']!.isNotEmpty
          ? symbols['MPC']!.take(3).toList() 
          : ['No symbols found'];
          
      results['FLINT (Symbols)'] = symbols['FLINT']!.isNotEmpty
          ? symbols['FLINT']!.take(3).toList()
          : ['No symbols found'];
    } catch (e) {
      results['MPFR (Symbols)'] = ['Error: $e'];
      results['MPC (Symbols)'] = ['Error: $e'];
      results['FLINT (Symbols)'] = ['Error: $e'];
    }
    
    return results;
  }

  /// Get library availability status
  Map<String, bool> getLibraryStatus() {
    return {
      'SymEngine Wrapper': _symengineAvailable,
      'GMP Direct': _gmpDirectAvailable,
    };
  }
}

// Simple symbol finder
class SymbolFinder {
  late final DynamicLibrary _dylib;
  
  SymbolFinder() {
    if (Platform.isIOS) {
      _dylib = DynamicLibrary.executable();
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('libgmp_bridge.so');
    } else {
      throw UnsupportedError('This platform is not supported.');
    }
  }
  
  bool symbolExists(String symbolName) {
    try {
      _dylib.lookup(symbolName);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Map<String, List<String>> findAvailableSymbols() {
    final results = <String, List<String>>{};
    
    final mpfrCandidates = ['mpfr_init2', 'mpfr_const_pi', 'mpfr_get_str'];
    results['MPFR'] = mpfrCandidates.where(symbolExists).toList();
    
    final mpcCandidates = ['mpc_init2', 'mpc_mul', 'mpc_clear'];
    results['MPC'] = mpcCandidates.where(symbolExists).toList();
    
    final flintCandidates = ['fmpz_init', 'fmpz_fac_ui', 'fmpz_clear'];
    results['FLINT'] = flintCandidates.where(symbolExists).toList();
    
    return results;
  }
}