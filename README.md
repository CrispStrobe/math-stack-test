# Flutter Mathematical Computing Stack Demo

[![Flutter](https://img.shields.io/badge/Flutter-Demo%20App-blue)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS-lightgrey)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-yellow)](https://opensource.org/licenses/MIT)

A comprehensive Flutter application demonstrating the complete mathematical computing stack integration on iOS. This app showcases both **high-level symbolic computation** and **direct low-level access** to multiple mathematical libraries through the `symbolic_math_bridge` plugin.

## What This Demonstrates

This application serves as a working proof-of-concept for integrating powerful mathematical libraries into Flutter applications, showing:

### 🔥 **High-Level Symbolic Computing (SymEngine)**
- Algebraic expression evaluation: `2 + 3*4 = 14`
- Symbolic expansion: `(x+1)² = 1 + 2*x + x²`
- Polynomial factoring: `x² - 1 = (-1 + x)*(1 + x)`
- Equation solving: `x² - 4 = 0 → x = 2, -2`
- Large number computation: `2^64 = 18446744073709551616`

### 🔢 **Direct Arbitrary Precision Integers (GMP)**
- Ultra-large computations: `2^256` (78-digit result)
- Unlimited precision arithmetic
- Performance-optimized native operations

### 🎯 **Direct High-Precision Floating Point (MPFR)**
- Multi-precision π calculation (50+ digits)
- Trigonometric functions: `sin(π) ≈ 0` with extreme precision
- Mathematical constants and functions

### 🔵 **Direct Complex Number Arithmetic (MPC)**
- Complex multiplication: `(3+4i) × (1+2i) = -5+10i`
- Arbitrary precision complex operations
- Real and imaginary component handling

### 🧮 **Direct Number Theory Functions (FLINT)**
- Factorial computation: `20! = 2432902008176640000`
- Optimized integer operations
- Number theory algorithms

## Key Features

- **Unified Access**: Single plugin providing access to 5 mathematical libraries
- **Symbol Availability Testing**: Real-time verification of native symbol accessibility  
- **Performance Comparison**: High-level vs. direct library access benchmarking
- **Interactive UI**: Touch interface for exploring mathematical capabilities
- **Error Handling**: Robust native code integration with proper error reporting

## Project Architecture

This demo is part of a three-repository solution demonstrating modern native library integration:

1. **[math-stack-ios-builder](https://github.com/CrispStrobe/math-stack-ios-builder)**: Build system creating XCFrameworks for GMP, MPFR, MPC, FLINT, and SymEngine
2. **[symbolic_math_bridge](https://github.com/CrispStrobe/symbolic_math_bridge)**: Flutter plugin providing unified access to all mathematical libraries
3. **[math-stack-test](https://github.com/CrispStrobe/math-stack-test)** (This Repository): Demo application showcasing the functionality

## How It Works

### Modern Plugin Architecture

Unlike requiring separate plugins for each library, this system uses a single unified plugin:

```dart
// Single import for all mathematical capabilities
import 'package:symbolic_math_bridge/symbolic_math_bridge.dart';

final casBridge = CasBridge();

// High-level symbolic operations
final symbolic = casBridge.evaluate('solve(x^2 + 2*x + 1, x)');

// Direct library access for maximum performance  
final gmpResult = casBridge.testGMPDirect(256);      // 2^256
final mpfrResult = casBridge.testMPFRDirect();       // High-precision π
final mpcResult = casBridge.testMPCDirect();         // Complex arithmetic
final flintResult = casBridge.testFLINTDirect();     // 20!
```

### Symbol Linking Solution

The app demonstrates a simple but robust solution to the "symbol stripping" problem that oftentimes prevents static C libraries from working in Flutter:

- **Force Symbol Loading**: Plugin references 40+ mathematical functions
- **Runtime Verification**: App checks symbol availability via `dlsym()`
- **XCFramework Integration**: Proper packaging prevents linker issues

### Real-Time Testing Interface

The app provides an interactive interface showing:

```
✅ SymEngine Wrapper: Available
✅ GMP Direct: Available  
✅ MPFR Direct: Available
✅ MPC Direct: Available
✅ FLINT Direct: Available

=== Test Results ===
SymEngine: solve(x^2-4, x) → 2, -2
GMP: 2^256 → 11579208923731619542357098500868...
MPFR: π → 3.141592653589793238462643383279...
MPC: (3+4i)×(1+2i) → (-5.00000e+00 1.00000e+01)
FLINT: 20! → 2432902008176640000
```

## Getting Started

### Prerequisites

1. **Flutter SDK**: Installed and configured for iOS development
2. **Xcode**: With iOS SDK and Command Line Tools
3. **Built Libraries**: XCFrameworks from `math-stack-ios-builder`
4. **Plugin Setup**: Properly configured `symbolic_math_bridge` plugin

### Installation

1. **Clone this repository**:
   ```bash
   git clone https://github.com/CrispStrobe/math-stack-test.git
   cd math-stack-test
   ```

2. **Ensure plugin dependency is correct** in `pubspec.yaml`:
   ```yaml
   dependencies:
     symbolic_math_bridge:
       path: ../symbolic_math_bridge  # Adjust path as needed
   ```

3. **Get dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   # Open iOS Simulator
   open -a Simulator
   
   # Run the Flutter app
   flutter run
   ```

## Technical Highlights

### FFI Integration

The app showcases advanced Dart FFI techniques:

```dart
// Direct symbol lookup without headers
final _mpzPowUi = DynamicLibrary.executable()
  .lookup<NativeFunction<MpzPowUiNative>>('__gmpz_pow_ui')
  .asFunction<MpzPowUiDart>();

// Memory management for C structures
final Pointer<Void> result = calloc<Uint8>(32).cast();
try {
  _mpzPowUi(result, base, exponent);
  // ... use result
} finally {
  _mpzClear(result);
  calloc.free(result);
}
```

### Performance Comparison

The app compares different approaches:

| Method | Library | Performance | Precision |
|--------|---------|-------------|-----------|
| SymEngine | High-level | Very Fast | Automatic |
| GMP Direct | Low-level | Fastest | Unlimited |
| MPFR Direct | Low-level | Fast | Configurable |
| Native Dart | Built-in | Fast | Limited (64-bit) |

### Error Handling

Robust error handling demonstrates production-ready integration:

```dart
try {
  final result = _mpzGetStr(nullptr, 10, bigint);
  return result.toDartString();
} catch (e) {
  return 'Computation failed: $e';
} finally {
  _mpzClear(bigint);
  calloc.free(bigint);
}
```

## Sample Outputs

When you run the app, you'll see real computations like:

```
=== SymEngine (High-level) ===
✓ Basic: 14
✓ Expand: 1 + 2*x + x**2
✓ Factor: -1 + x**2  
✓ Solve: 2, -2
✓ Power: 1.84467e+19

=== GMP (Direct) ===  
✓ 2^64: 18446744073709551616
✓ 2^128: 340282366920938463463374607431768211456
✓ 2^256: 11579208923731619542357098500868790785326998466564056...

=== MPFR (Direct) ===
✓ π≈3.14159265358979323846264338327950288419716939937510582, sin(π)≈-5.0165e-50, √π≈1.77245

=== MPC (Direct) ===
✓ (3+4i)×(1+2i)=(-5.0000e+00 1.0000e+01)

=== FLINT (Direct) ===  
✓ 20! = 2432902008176640000
```

## Use Cases

This demo validates the mathematical computing stack for applications requiring:

- **Scientific Computing**: High-precision numerical analysis
- **Cryptography**: Large integer operations for RSA, elliptic curves
- **Computer Algebra**: Symbolic manipulation for education/research
- **Financial Modeling**: Arbitrary precision decimal arithmetic
- **Engineering**: Complex number computations for signal processing

## Development Notes

### Performance Considerations

- **Direct library access** provides fast computational-heavy operations
- **SymEngine wrapper** provides for mixed symbolic/numeric operations  
- **Memory management** is critical - all C allocations must be properly freed
- **Symbol availability** should be checked before making FFI calls

### Testing Strategy

The app implements basic testing:

1. **Symbol Availability**: Verify all functions are accessible via `dlsym()`
2. **Functional Testing**: Execute representative operations from each library
3. **Error Handling**: Test failure modes and recovery
4. **Memory Management**: Ensure no leaks in native operations
5. **Performance Benchmarking**: Compare different access methods

## Troubleshooting

### "Symbol not found" errors
- Verify the `symbolic_math_bridge` plugin is properly configured
- Check that all XCFrameworks are included in the plugin
- Ensure (per `nm`) the `SymEngineBridge.m` file includes necessary symbol references

### Build failures
- Confirm Xcode and Command Line Tools are installed
- Verify the plugin path in `pubspec.yaml` is correct
- Clean and rebuild: `flutter clean && flutter pub get`

### Performance issues
- Check that you're using the appropriate library for your use case
- Profile memory usage to identify leaks
- Consider using direct library access for compute-intensive operations

## License

This demo application is released under the **MIT License**. The underlying mathematical libraries have their own licenses which you must comply with in your applications.

## Acknowledgments

This project demonstrates integrating complex mathematical computing capabilities into modern mobile applications, building upon decades of open-source mathematical software development.