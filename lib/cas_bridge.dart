import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// Only include GMP signatures for now
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

/// A simplified bridge class that only initializes functions we know work
class CasBridge {
  late final DynamicLibrary _dylib;
  
  // Only GMP functions for now
  late final MpzInitSetStrDart _mpzInitSetStr;
  late final MpzGetStrDart _mpzGetStr;
  late final MpzClearDart _mpzClear;
  late final MpzPowUiDart _mpzPowUi;
  late final FreeDart _free;

  CasBridge() {
    if (Platform.isIOS) {
      _dylib = DynamicLibrary.executable();
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('libgmp_bridge.so');
    } else {
      throw UnsupportedError('This platform is not supported.');
    }

    // Only initialize GMP functions - we know these work
    _mpzInitSetStr = _dylib.lookup<NativeFunction<MpzInitSetStrNative>>('__gmpz_init_set_str').asFunction();
    _mpzGetStr = _dylib.lookup<NativeFunction<MpzGetStrNative>>('__gmpz_get_str').asFunction();
    _mpzClear = _dylib.lookup<NativeFunction<MpzClearNative>>('__gmpz_clear').asFunction();
    _mpzPowUi = _dylib.lookup<NativeFunction<MpzPowUiNative>>('__gmpz_pow_ui').asFunction();
    _free = _dylib.lookup<NativeFunction<FreeNative>>('free').asFunction();
  }

  /// Test GMP: Calculate 2^exponent
  String testGMP(int exponent) {
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
}