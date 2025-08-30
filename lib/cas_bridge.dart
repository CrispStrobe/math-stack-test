import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// --- Define C function signatures ---

// Signature for: mpz_init_set_str(mpz_t rop, const char *str, int base)
// We treat mpz_t as an opaque pointer since we don't need its internal structure.
typedef MpzInitSetStrNative = Int32 Function(
    Pointer<Void> rop, Pointer<Utf8> str, Int32 base);
typedef MpzInitSetStrDart = int Function(
    Pointer<Void> rop, Pointer<Utf8> str, int base);

// Signature for: mpz_get_str(char *str, int base, const mpz_t op)
typedef MpzGetStrNative = Pointer<Utf8> Function(
    Pointer<Utf8> str, Int32 base, Pointer<Void> op);
typedef MpzGetStrDart = Pointer<Utf8> Function(
    Pointer<Utf8> str, int base, Pointer<Void> op);

// Signature for: mpz_clear(mpz_t x)
typedef MpzClearNative = Void Function(Pointer<Void> x);
typedef MpzClearDart = void Function(Pointer<Void> x);

// Signature for: mpz_pow_ui(mpz_t rop, const mpz_t base, unsigned long int exp);
typedef MpzPowUiNative = Void Function(
    Pointer<Void> rop, Pointer<Void> base, Uint64 exp);
typedef MpzPowUiDart = void Function(
    Pointer<Void> rop, Pointer<Void> base, int exp);

// This is a C function, not from GMP. It's needed for memory management.
typedef FreeNative = Void Function(Pointer<Void> ptr);
typedef FreeDart = void Function(Pointer<Void> ptr);

/// A bridge class to interact with the native GMP library.
class CasBridge {
  late final DynamicLibrary _dylib;

  // --- Define Dart wrappers for the C functions ---
  late final MpzInitSetStrDart _mpzInitSetStr;
  late final MpzGetStrDart _mpzGetStr;
  late final MpzClearDart _mpzClear;
  late final MpzPowUiDart _mpzPowUi;
  late final FreeDart _free;

  CasBridge() {
    if (Platform.isIOS) {
      // On iOS, static libraries are linked into the main process executable.
      _dylib = DynamicLibrary.process();
    } else if (Platform.isMacOS) {
      // On macOS, we'll load a dynamic library.
      // This path is for development. A real app would bundle it differently.
      _dylib = DynamicLibrary.open('libgmp.dylib');
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    // Look up the functions in the library
    _mpzInitSetStr = _dylib
        .lookup<NativeFunction<MpzInitSetStrNative>>('mpz_init_set_str')
        .asFunction();
    _mpzGetStr = _dylib
        .lookup<NativeFunction<MpzGetStrNative>>('mpz_get_str')
        .asFunction();
    _mpzClear =
        _dylib.lookup<NativeFunction<MpzClearNative>>('mpz_clear').asFunction();
    _mpzPowUi =
        _dylib.lookup<NativeFunction<MpzPowUiNative>>('mpz_pow_ui').asFunction();

    // Standard C 'free' function for memory allocated by mpz_get_str
    _free = _dylib.lookup<NativeFunction<FreeNative>>('free').asFunction();
  }

  /// Calculates 2 to the power of `exponent` using GMP.
  String powerOfTwo(int exponent) {
    // GMP requires a structure to hold the big integer.
    // We allocate 32 bytes which is enough for the mpz_t struct on arm64.
    final Pointer<Void> base = calloc<Uint8>(32).cast();
    final Pointer<Void> result = calloc<Uint8>(32).cast();

    try {
      // Initialize 'base' to the value 2
      _mpzInitSetStr(base, '2'.toNativeUtf8(), 10);

      // Calculate result = base ^ exponent
      _mpzPowUi(result, base, exponent);

      // Get the string representation of the result.
      // GMP allocates memory for the string, which we must free.
      final Pointer<Utf8> resultStrPtr = _mpzGetStr(nullptr, 10, result);
      final String resultString = resultStrPtr.toDartString();

      // IMPORTANT: Free the memory allocated by mpz_get_str
      _free(resultStrPtr.cast());

      return resultString;
    } finally {
      // IMPORTANT: Always clear the GMP numbers to prevent memory leaks
      _mpzClear(base);
      _mpzClear(result);
      // Free the memory we allocated for the structs
      calloc.free(base);
      calloc.free(result);
    }
  }
}
