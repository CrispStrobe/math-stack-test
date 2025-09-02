import 'dart:ffi';
import 'dart:io';

/// Test which symbols are actually available in the linked libraries
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
    
    // Test GMP symbols (we know these work)
    final gmpCandidates = [
      '__gmpz_init', '__gmpz_init_set_str', '__gmpz_get_str', '__gmpz_clear', '__gmpz_pow_ui',
      '__gmpz_add', '__gmpz_mul', '__gmpz_set_str', 'free'
    ];
    results['GMP'] = gmpCandidates.where(symbolExists).toList();
    
    // Test MPFR symbols 
    final mpfrCandidates = [
      'mpfr_init2', 'mpfr_init', 'mpfr_const_pi', 'mpfr_get_str', 'mpfr_clear',
      'mpfr_set_prec', 'mpfr_get_version', 'mpfr_set', 'mpfr_add', 'mpfr_mul'
    ];
    results['MPFR'] = mpfrCandidates.where(symbolExists).toList();
    
    // Test MPC symbols  
    final mpcCandidates = [
      'mpc_init2', 'mpc_init3', 'mpc_set_ui_ui', 'mpc_mul', 'mpc_get_str', 'mpc_clear',
      'mpc_add', 'mpc_set', 'mpc_get_version', 'mpc_abs'
    ];
    results['MPC'] = mpcCandidates.where(symbolExists).toList();
    
    // Test FLINT symbols
    final flintCandidates = [
      'fmpz_init', 'fmpz_set_ui', 'fmpz_fac_ui', 'fmpz_get_str', 'fmpz_clear',
      'fmpz_set', 'fmpz_pow_ui', 'fmpz_add', 'fmpz_mul'
    ];
    results['FLINT'] = flintCandidates.where(symbolExists).toList();
    
    // Test SymEngine symbols (C wrapper API)
    final symengineCandidate = [
      'basic_new_heap', 'basic_const_pi', 'basic_pow', 'basic_str', 'basic_free_stack',
      'basic_new', 'basic_assign', 'basic_free', 'symengine_get_version'
    ];
    results['SymEngine'] = symengineCandidate.where(symbolExists).toList();
    
    return results;
  }
  
  String getReport() {
    final symbols = findAvailableSymbols();
    final buffer = StringBuffer();
    
    buffer.writeln('Available Library Symbols:\n');
    
    for (final entry in symbols.entries) {
      buffer.writeln('${entry.key}:');
      if (entry.value.isEmpty) {
        buffer.writeln('  ❌ No symbols found');
      } else {
        for (final symbol in entry.value) {
          buffer.writeln('  ✅ $symbol');
        }
      }
      buffer.writeln();
    }
    
    return buffer.toString();
  }
}