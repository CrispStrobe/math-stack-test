import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// --- C function signatures ---
typedef MpzInitSetStrNative = Int32 Function(
    Pointer<Void> rop, Pointer<Utf8> str, Int32 base);
typedef MpzGetStrNative = Pointer<Utf8> Function(
    Pointer<Utf8> str, Int32 base, Pointer<Void> op);
typedef MpzClearNative = Void Function(Pointer<Void> x);
typedef MpzPowUiNative = Void Function(
    Pointer<Void> rop, Pointer<Void> base, Uint64 exp);
typedef FreeNative = Void Function(Pointer<Void> ptr);

// --- Dart function types ---
typedef MpzInitSetStrDart = int Function(
    Pointer<Void> rop, Pointer<Utf8> str, int base);
typedef MpzGetStrDart = Pointer<Utf8> Function(
    Pointer<Utf8> str, int base, Pointer<Void> op);
typedef MpzClearDart = void Function(Pointer<Void> x);
typedef MpzPowUiDart = void Function(
    Pointer<Void> rop, Pointer<Void> base, int exp);
typedef FreeDart = void Function(Pointer<Void> ptr);

/// A bridge class to interact with the native GMP library on iOS and Android.
class CasBridge {
  late final DynamicLibrary _dylib;
  late final MpzInitSetStrDart _mpzInitSetStr;
  late final MpzGetStrDart _mpzGetStr;
  late final MpzClearDart _mpzClear;
  late final MpzPowUiDart _mpzPowUi;
  late final FreeDart _free;

  CasBridge() {
    // --- Platform-specific library loading ---
    if (Platform.isIOS) {
      // Load the framework built by your plugin
      _dylib = DynamicLibrary.open('gmp_bridge.framework/gmp_bridge');
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('libgmp_bridge.so');
    } else {
      throw UnsupportedError('This platform is not supported.');
    }

    // --- Look up the functions in the loaded library ---
    // Note the '__gmpz' prefix for C symbols on Apple platforms.
    _mpzInitSetStr = _dylib
        .lookup<NativeFunction<MpzInitSetStrNative>>('__gmpz_init_set_str')
        .asFunction();
    _mpzGetStr = _dylib
        .lookup<NativeFunction<MpzGetStrNative>>('__gmpz_get_str')
        .asFunction();
    _mpzClear =
        _dylib.lookup<NativeFunction<MpzClearNative>>('__gmpz_clear').asFunction();
    _mpzPowUi =
        _dylib.lookup<NativeFunction<MpzPowUiNative>>('__gmpz_pow_ui').asFunction();

    // 'free' is a standard C function and doesn't need a prefix
    _free = _dylib.lookup<NativeFunction<FreeNative>>('free').asFunction();
  }

  /// Calculates 2 to the power of `exponent` using the native GMP library.
  String powerOfTwo(int exponent) {
    final Pointer<Void> base = calloc<Uint8>(32).cast();
    final Pointer<Void> result = calloc<Uint8>(32).cast();

    try {
      final baseStr = '2'.toNativeUtf8();
      _mpzInitSetStr(base, baseStr, 10);
      calloc.free(baseStr);

      _mpzPowUi(result, base, exponent);

      final Pointer<Utf8> resultStrPtr = _mpzGetStr(nullptr, 10, result);
      final String resultString = resultStrPtr.toDartString();

      // The GMP documentation specifies that the string returned by mpz_get_str
      // must be freed with the system's standard 'free' function.
      _free(resultStrPtr.cast());

      return resultString;
    } finally {
      _mpzClear(base);
      _mpzClear(result);
      calloc.free(base);
      calloc.free(result);
    }
  }
}
