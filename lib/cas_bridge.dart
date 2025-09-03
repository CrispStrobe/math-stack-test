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

// Direct GMP signatures (your existing working ones)
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

// MPFR function signatures
typedef MpfrInit2Native = Void Function(Pointer<Void> x, Int64 prec);
typedef MpfrClearNative = Void Function(Pointer<Void> x);
typedef MpfrSetUiNative = Int32 Function(Pointer<Void> rop, Uint64 op, Int32 rnd);
typedef MpfrSetDNative = Int32 Function(Pointer<Void> rop, Double op, Int32 rnd);
typedef MpfrGetStrNative = Pointer<Utf8> Function(Pointer<Utf8> str, Pointer<Int64> expptr, Int32 base, Uint64 n, Pointer<Void> op, Int32 rnd);
typedef MpfrGetDNative = Double Function(Pointer<Void> op, Int32 rnd);
typedef MpfrAddNative = Int32 Function(Pointer<Void> rop, Pointer<Void> op1, Pointer<Void> op2, Int32 rnd);
typedef MpfrMulNative = Int32 Function(Pointer<Void> rop, Pointer<Void> op1, Pointer<Void> op2, Int32 rnd);
typedef MpfrSqrtNative = Int32 Function(Pointer<Void> rop, Pointer<Void> op, Int32 rnd);
typedef MpfrConstPiNative = Int32 Function(Pointer<Void> rop, Int32 rnd);
typedef MpfrSinNative = Int32 Function(Pointer<Void> rop, Pointer<Void> op, Int32 rnd);

typedef MpfrInit2Dart = void Function(Pointer<Void> x, int prec);
typedef MpfrClearDart = void Function(Pointer<Void> x);
typedef MpfrSetUiDart = int Function(Pointer<Void> rop, int op, int rnd);
typedef MpfrSetDDart = int Function(Pointer<Void> rop, double op, int rnd);
typedef MpfrGetStrDart = Pointer<Utf8> Function(Pointer<Utf8> str, Pointer<Int64> expptr, int base, int n, Pointer<Void> op, int rnd);
typedef MpfrGetDDart = double Function(Pointer<Void> op, int rnd);
typedef MpfrAddDart = int Function(Pointer<Void> rop, Pointer<Void> op1, Pointer<Void> op2, int rnd);
typedef MpfrMulDart = int Function(Pointer<Void> rop, Pointer<Void> op1, Pointer<Void> op2, int rnd);
typedef MpfrSqrtDart = int Function(Pointer<Void> rop, Pointer<Void> op, int rnd);
typedef MpfrConstPiDart = int Function(Pointer<Void> rop, int rnd);
typedef MpfrSinDart = int Function(Pointer<Void> rop, Pointer<Void> op, int rnd);

// MPC function signatures
typedef MpcInit2Native = Void Function(Pointer<Void> z, Int64 prec);
typedef MpcClearNative = Void Function(Pointer<Void> z);
typedef MpcSetUiUiNative = Int32 Function(Pointer<Void> rop, Uint64 op1, Uint64 op2, Int32 rnd);
typedef MpcGetStrNative = Pointer<Utf8> Function(Int32 base, Uint64 n, Pointer<Void> op, Int32 rnd);
typedef MpcAddNative = Int32 Function(Pointer<Void> rop, Pointer<Void> op1, Pointer<Void> op2, Int32 rnd);
typedef MpcMulNative = Int32 Function(Pointer<Void> rop, Pointer<Void> op1, Pointer<Void> op2, Int32 rnd);
typedef MpcSqrtNative = Int32 Function(Pointer<Void> rop, Pointer<Void> op, Int32 rnd);

typedef MpcInit2Dart = void Function(Pointer<Void> z, int prec);
typedef MpcClearDart = void Function(Pointer<Void> z);
typedef MpcSetUiUiDart = int Function(Pointer<Void> rop, int op1, int op2, int rnd);
typedef MpcGetStrDart = Pointer<Utf8> Function(int base, int n, Pointer<Void> op, int rnd);
typedef MpcAddDart = int Function(Pointer<Void> rop, Pointer<Void> op1, Pointer<Void> op2, int rnd);
typedef MpcMulDart = int Function(Pointer<Void> rop, Pointer<Void> op1, Pointer<Void> op2, int rnd);
typedef MpcSqrtDart = int Function(Pointer<Void> rop, Pointer<Void> op, int rnd);

// FLINT function signatures
typedef FmpzInitNative = Void Function(Pointer<Void> f);
typedef FmpzClearNative = Void Function(Pointer<Void> f);
typedef FmpzSetUiNative = Void Function(Pointer<Void> f, Uint64 val);
typedef FmpzGetStrNative = Pointer<Utf8> Function(Pointer<Utf8> str, Int32 b, Pointer<Void> f);
typedef FmpzAddNative = Void Function(Pointer<Void> f, Pointer<Void> g, Pointer<Void> h);
typedef FmpzMulNative = Void Function(Pointer<Void> f, Pointer<Void> g, Pointer<Void> h);
typedef FmpzPowUiNative = Void Function(Pointer<Void> f, Pointer<Void> g, Uint64 exp);
typedef FmpzCmpNative = Int32 Function(Pointer<Void> f, Pointer<Void> g);
typedef FmpzAbsNative = Void Function(Pointer<Void> f1, Pointer<Void> f2);
typedef FmpzFacUiNative = Void Function(Pointer<Void> f, Uint64 n);

typedef FmpzInitDart = void Function(Pointer<Void> f);
typedef FmpzClearDart = void Function(Pointer<Void> f);
typedef FmpzSetUiDart = void Function(Pointer<Void> f, int val);
typedef FmpzGetStrDart = Pointer<Utf8> Function(Pointer<Utf8> str, int b, Pointer<Void> f);
typedef FmpzAddDart = void Function(Pointer<Void> f, Pointer<Void> g, Pointer<Void> h);
typedef FmpzMulDart = void Function(Pointer<Void> f, Pointer<Void> g, Pointer<Void> h);
typedef FmpzPowUiDart = void Function(Pointer<Void> f, Pointer<Void> g, int exp);
typedef FmpzCmpDart = int Function(Pointer<Void> f, Pointer<Void> g);
typedef FmpzAbsDart = void Function(Pointer<Void> f1, Pointer<Void> f2);
typedef FmpzFacUiDart = void Function(Pointer<Void> f, int n);

/// Extended CAS Bridge with direct access to all math libraries
class CasBridge {
  late final DynamicLibrary _dylib;
  
  // SymEngine wrapper functions
  late final SymEngineEvaluateDart _evaluate;
  late final SymEngineSolveDart _solve;
  late final SymEngineFreeStringDart _freeString;
  late final SymEngineFactorDart _factor;
  late final SymEngineExpandDart _expand;
  
  // Direct GMP functions (your existing working ones)
  late final MpzInitSetStrDart _mpzInitSetStr;
  late final MpzGetStrDart _mpzGetStr;
  late final MpzClearDart _mpzClear;
  late final MpzPowUiDart _mpzPowUi;
  late final FreeDart _free;
  
  // Direct MPFR functions
  late final MpfrInit2Dart _mpfrInit2;
  late final MpfrClearDart _mpfrClear;
  late final MpfrSetUiDart _mpfrSetUi;
  late final MpfrSetDDart _mpfrSetD;
  late final MpfrGetStrDart _mpfrGetStr;
  late final MpfrGetDDart _mpfrGetD;
  late final MpfrAddDart _mpfrAdd;
  late final MpfrMulDart _mpfrMul;
  late final MpfrSqrtDart _mpfrSqrt;
  late final MpfrConstPiDart _mpfrConstPi;
  late final MpfrSinDart _mpfrSin;
  
  // Direct MPC functions
  late final MpcInit2Dart _mpcInit2;
  late final MpcClearDart _mpcClear;
  late final MpcSetUiUiDart _mpcSetUiUi;
  late final MpcGetStrDart _mpcGetStr;
  late final MpcAddDart _mpcAdd;
  late final MpcMulDart _mpcMul;
  late final MpcSqrtDart _mpcSqrt;
  
  // Direct FLINT functions
  late final FmpzInitDart _fmpzInit;
  late final FmpzClearDart _fmpzClear;
  late final FmpzSetUiDart _fmpzSetUi;
  late final FmpzGetStrDart _fmpzGetStr;
  late final FmpzAddDart _fmpzAdd;
  late final FmpzMulDart _fmpzMul;
  late final FmpzPowUiDart _fmpzPowUi;
  late final FmpzCmpDart _fmpzCmp;
  late final FmpzAbsDart _fmpzAbs;
  late final FmpzFacUiDart _fmpzFacUi;
  
  bool _symengineAvailable = false;
  bool _gmpDirectAvailable = false;
  bool _mpfrDirectAvailable = false;
  bool _mpcDirectAvailable = false;
  bool _flintDirectAvailable = false;

  CasBridge() {
    if (Platform.isIOS) {
      _dylib = DynamicLibrary.executable();
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('libgmp_bridge.so');
    } else {
      throw UnsupportedError('This platform is not supported.');
    }

    _initializeLibraries();
  }

  void _initializeLibraries() {
    // Initialize SymEngine
    try {
      _evaluate = _dylib.lookup<NativeFunction<SymEngineEvaluateC>>('symengine_evaluate').asFunction();
      _solve = _dylib.lookup<NativeFunction<SymEngineSolveC>>('symengine_solve').asFunction();
      _freeString = _dylib.lookup<NativeFunction<SymEngineFreeStringC>>('symengine_free_string').asFunction();
      _factor = _dylib.lookup<NativeFunction<SymEngineFactorC>>('symengine_factor').asFunction();
      _expand = _dylib.lookup<NativeFunction<SymEngineExpandC>>('symengine_expand').asFunction();
      _symengineAvailable = true;
      print('✅ SymEngine loaded');
    } catch (e) {
      print('❌ SymEngine not available: $e');
    }

    // Initialize direct GMP (your existing working version)
    try {
      _mpzInitSetStr = _dylib.lookup<NativeFunction<MpzInitSetStrNative>>('__gmpz_init_set_str').asFunction();
      _mpzGetStr = _dylib.lookup<NativeFunction<MpzGetStrNative>>('__gmpz_get_str').asFunction();
      _mpzClear = _dylib.lookup<NativeFunction<MpzClearNative>>('__gmpz_clear').asFunction();
      _mpzPowUi = _dylib.lookup<NativeFunction<MpzPowUiNative>>('__gmpz_pow_ui').asFunction();
      _free = _dylib.lookup<NativeFunction<FreeNative>>('free').asFunction();
      _gmpDirectAvailable = true;
      print('✅ GMP Direct loaded');
    } catch (e) {
      print('❌ GMP Direct not available: $e');
    }
    
    // Initialize direct MPFR
    try {
      _mpfrInit2 = _dylib.lookup<NativeFunction<MpfrInit2Native>>('mpfr_init2').asFunction();
      _mpfrClear = _dylib.lookup<NativeFunction<MpfrClearNative>>('mpfr_clear').asFunction();
      _mpfrSetUi = _dylib.lookup<NativeFunction<MpfrSetUiNative>>('mpfr_set_ui').asFunction();
      _mpfrSetD = _dylib.lookup<NativeFunction<MpfrSetDNative>>('mpfr_set_d').asFunction();
      _mpfrGetStr = _dylib.lookup<NativeFunction<MpfrGetStrNative>>('mpfr_get_str').asFunction();
      _mpfrGetD = _dylib.lookup<NativeFunction<MpfrGetDNative>>('mpfr_get_d').asFunction();
      _mpfrAdd = _dylib.lookup<NativeFunction<MpfrAddNative>>('mpfr_add').asFunction();
      _mpfrMul = _dylib.lookup<NativeFunction<MpfrMulNative>>('mpfr_mul').asFunction();
      _mpfrSqrt = _dylib.lookup<NativeFunction<MpfrSqrtNative>>('mpfr_sqrt').asFunction();
      _mpfrConstPi = _dylib.lookup<NativeFunction<MpfrConstPiNative>>('mpfr_const_pi').asFunction();
      _mpfrSin = _dylib.lookup<NativeFunction<MpfrSinNative>>('mpfr_sin').asFunction();
      _mpfrDirectAvailable = true;
      print('✅ MPFR Direct loaded');
    } catch (e) {
      print('❌ MPFR Direct not available: $e');
    }
    
    // Initialize direct MPC
    try {
      _mpcInit2 = _dylib.lookup<NativeFunction<MpcInit2Native>>('mpc_init2').asFunction();
      _mpcClear = _dylib.lookup<NativeFunction<MpcClearNative>>('mpc_clear').asFunction();
      _mpcSetUiUi = _dylib.lookup<NativeFunction<MpcSetUiUiNative>>('mpc_set_ui_ui').asFunction();
      _mpcGetStr = _dylib.lookup<NativeFunction<MpcGetStrNative>>('mpc_get_str').asFunction();
      _mpcAdd = _dylib.lookup<NativeFunction<MpcAddNative>>('mpc_add').asFunction();
      _mpcMul = _dylib.lookup<NativeFunction<MpcMulNative>>('mpc_mul').asFunction();
      _mpcSqrt = _dylib.lookup<NativeFunction<MpcSqrtNative>>('mpc_sqrt').asFunction();
      _mpcDirectAvailable = true;
      print('✅ MPC Direct loaded');
    } catch (e) {
      print('❌ MPC Direct not available: $e');
    }
    
    // Initialize direct FLINT
    try {
      _fmpzInit = _dylib.lookup<NativeFunction<FmpzInitNative>>('fmpz_init').asFunction();
      _fmpzClear = _dylib.lookup<NativeFunction<FmpzClearNative>>('fmpz_clear').asFunction();
      _fmpzSetUi = _dylib.lookup<NativeFunction<FmpzSetUiNative>>('fmpz_set_ui').asFunction();
      _fmpzGetStr = _dylib.lookup<NativeFunction<FmpzGetStrNative>>('fmpz_get_str').asFunction();
      _fmpzAdd = _dylib.lookup<NativeFunction<FmpzAddNative>>('fmpz_add').asFunction();
      _fmpzMul = _dylib.lookup<NativeFunction<FmpzMulNative>>('fmpz_mul').asFunction();
      _fmpzPowUi = _dylib.lookup<NativeFunction<FmpzPowUiNative>>('fmpz_pow_ui').asFunction();
      _fmpzCmp = _dylib.lookup<NativeFunction<FmpzCmpNative>>('fmpz_cmp').asFunction();
      _fmpzAbs = _dylib.lookup<NativeFunction<FmpzAbsNative>>('fmpz_abs').asFunction();
      _fmpzFacUi = _dylib.lookup<NativeFunction<FmpzFacUiNative>>('fmpz_fac_ui').asFunction();
      _flintDirectAvailable = true;
      print('✅ FLINT Direct loaded');
    } catch (e) {
      print('❌ FLINT Direct not available: $e');
    }
  }

  // SymEngine wrapper functions (unchanged)
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

  // GMP Direct functions (your existing working version - unchanged)
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

  // MPFR Direct functions
  String testMPFRDirect() {
    if (!_mpfrDirectAvailable) return 'MPFR Direct not available';
    
    const int precision = 256;
    const int rnd = 0; // MPFR_RNDN
    
    final Pointer<Void> pi = calloc<Uint8>(64).cast();
    final Pointer<Void> sinPi = calloc<Uint8>(64).cast();
    final Pointer<Void> sqrtPi = calloc<Uint8>(64).cast();
    
    try {
      // Initialize with 256-bit precision
      _mpfrInit2(pi, precision);
      _mpfrInit2(sinPi, precision);
      _mpfrInit2(sqrtPi, precision);
      
      // Get π with high precision
      _mpfrConstPi(pi, rnd);
      
      // Calculate sin(π) (should be ~0)
      _mpfrSin(sinPi, pi, rnd);
      
      // Calculate sqrt(π)
      _mpfrSqrt(sqrtPi, pi, rnd);
      
      // Convert to strings
      final expPtr = calloc<Int64>();
      
      final piStrPtr = _mpfrGetStr(nullptr, expPtr, 10, 50, pi, rnd);
      final piStr = piStrPtr.toDartString();
      _free(piStrPtr.cast());
      
      final sinStrPtr = _mpfrGetStr(nullptr, expPtr, 10, 20, sinPi, rnd);
      final sinStr = sinStrPtr.toDartString();
      _free(sinStrPtr.cast());
      
      final sqrtStrPtr = _mpfrGetStr(nullptr, expPtr, 10, 30, sqrtPi, rnd);
      final sqrtStr = sqrtStrPtr.toDartString();
      _free(sqrtStrPtr.cast());
      
      calloc.free(expPtr);
      
      return 'π≈$piStr, sin(π)≈$sinStr, √π≈$sqrtStr';
    } catch (e) {
      return 'MPFR Error: $e';
    } finally {
      _mpfrClear(pi);
      _mpfrClear(sinPi);
      _mpfrClear(sqrtPi);
      calloc.free(pi);
      calloc.free(sinPi);
      calloc.free(sqrtPi);
    }
  }

  // MPC Direct functions  
  String testMPCDirect() {
    if (!_mpcDirectAvailable) return 'MPC Direct not available';
    
    const int precision = 128;
    const int rnd = 0; // MPC_RNDNN
    
    final Pointer<Void> z1 = calloc<Uint8>(128).cast();
    final Pointer<Void> z2 = calloc<Uint8>(128).cast();
    final Pointer<Void> result = calloc<Uint8>(128).cast();
    
    try {
      // Initialize complex numbers with 128-bit precision
      _mpcInit2(z1, precision);
      _mpcInit2(z2, precision);
      _mpcInit2(result, precision);
      
      // Set z1 = 3 + 4i
      _mpcSetUiUi(z1, 3, 4, rnd);
      
      // Set z2 = 1 + 2i  
      _mpcSetUiUi(z2, 1, 2, rnd);
      
      // Calculate z1 * z2
      _mpcMul(result, z1, z2, rnd);
      
      // Convert to string
      final resultStrPtr = _mpcGetStr(10, 15, result, rnd);
      final resultStr = resultStrPtr.toDartString();
      _free(resultStrPtr.cast());
      
      return '(3+4i)×(1+2i)=$resultStr';
    } catch (e) {
      return 'MPC Error: $e';
    } finally {
      _mpcClear(z1);
      _mpcClear(z2);
      _mpcClear(result);
      calloc.free(z1);
      calloc.free(z2);
      calloc.free(result);
    }
  }

  // FLINT Direct functions
  String testFLINTDirect() {
    if (!_flintDirectAvailable) return 'FLINT Direct not available';
    
    final Pointer<Void> n = calloc<Uint8>(32).cast();
    final Pointer<Void> factorial = calloc<Uint8>(64).cast();
    
    try {
      // Initialize FLINT integers
      _fmpzInit(n);
      _fmpzInit(factorial);
      
      // Set n = 20
      _fmpzSetUi(n, 20);
      
      // Calculate 20!
      _fmpzFacUi(factorial, 20);
      
      // Convert to string
      final factStrPtr = _fmpzGetStr(nullptr, 10, factorial);
      final factStr = factStrPtr.toDartString();
      _free(factStrPtr.cast());
      
      return '20! = $factStr';
    } catch (e) {
      return 'FLINT Error: $e';
    } finally {
      _fmpzClear(n);
      _fmpzClear(factorial);
      calloc.free(n);
      calloc.free(factorial);
    }
  }

  String testGMPViaSymEngine(int exponent) {
    return evaluate('2^$exponent');
  }

  /// Get comprehensive test results showing actual computations
  Map<String, List<String>> getTestResults() {
    final results = <String, List<String>>{};
    
    if (_symengineAvailable) {
      results['SymEngine (High-level)'] = [
        'Basic: ${evaluate('2+3*4')}',
        'Expand: ${expand('(x+1)^2')}', 
        'Factor: ${factor('x^2-1')}',
        'Solve: ${solve('x^2-4', 'x')}',
        'Power: ${testGMPViaSymEngine(64)}',
      ];
    } else {
      results['SymEngine (High-level)'] = ['Not available'];
    }
    
    if (_gmpDirectAvailable) {
      results['GMP (Direct)'] = [
        '2^64: ${testGMPDirect(64)}',
        '2^128: ${testGMPDirect(128)}',
        '2^256: ${testGMPDirect(256)}',
      ];
    } else {
      results['GMP (Direct)'] = ['Not available'];
    }

    if (_mpfrDirectAvailable) {
      results['MPFR (Direct)'] = [
        'High-precision: ${testMPFRDirect()}',
      ];
    } else {
      results['MPFR (Direct)'] = ['Not available'];
    }

    if (_mpcDirectAvailable) {
      results['MPC (Direct)'] = [
        'Complex: ${testMPCDirect()}',
      ];
    } else {
      results['MPC (Direct)'] = ['Not available'];
    }
    
    if (_flintDirectAvailable) {
      results['FLINT (Direct)'] = [
        'Factorial: ${testFLINTDirect()}',
      ];
    } else {
      results['FLINT (Direct)'] = ['Not available'];
    }
    
    return results;
  }

  /// Get library availability status
  Map<String, bool> getLibraryStatus() {
    return {
      'SymEngine Wrapper': _symengineAvailable,
      'GMP Direct': _gmpDirectAvailable,
      'MPFR Direct': _mpfrDirectAvailable,
      'MPC Direct': _mpcDirectAvailable,
      'FLINT Direct': _flintDirectAvailable,
    };
  }
}