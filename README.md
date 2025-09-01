# Flutter to Native GMP FFI Demo

This Flutter application serves as a working demonstration of how to call native C code from the [GNU Multiple Precision Arithmetic Library (GMP)](https://gmplib.org/) on iOS using Dart's FFI (Foreign Function Interface).

The primary goal of this project is to provide a clear, robust, and reproducible example of linking a pre-compiled static C library (`.a`) to a Flutter app for high-performance computing tasks.

## Key Features

-   **Native C Integration**: Shows how to call GMP functions directly from Dart to perform arbitrary-precision arithmetic (calculating 2^128 as a test case).
-   **Local Plugin Architecture**: Uses a local Flutter plugin (`gmp_bridge`) to correctly link and bundle the native GMP library via CocoaPods. This is the modern, recommended approach for native code integration on iOS.
-   **Clean Separation**: The native bridge logic is cleanly separated in `lib/cas_bridge.dart`, making it easy to understand and adapt for other native libraries.

## Project Structure

This project is part of a three-repository solution:

1.  **`gmp-ios-builder`**: A build system that compiles the GMP library from source into a universal static library (`.a`) for iOS simulators.
2.  **`gmp_bridge`**: A local Flutter plugin that takes the static library and correctly links it into a `.framework` using a CocoaPods configuration (`.podspec`).
3.  **`gmp_test_app`** (This Repository): The main Flutter application that depends on the `gmp_bridge` plugin and uses it to perform a GMP calculation.

## How It Works

1.  **Dependency**: The `pubspec.yaml` file includes a `path:` dependency on the local `gmp_bridge` plugin.
2.  **FFI Bridge**: The `lib/cas_bridge.dart` file uses `dart:ffi` to load the `gmp_bridge.framework` at runtime.
3.  **Function Lookup**: It looks up the necessary C function pointers (e.g., `__gmpz_pow_ui`, `__gmpz_get_str`) within the loaded framework.
4.  **Execution**: The UI in `lib/main.dart` calls the bridge methods, which execute the native GMP code and return the result to be displayed on screen.

## How to Run This Project

1.  **Build the Native Library**: First, run the scripts in the `gmp-ios-builder` repository to produce the `libgmp-simulator.a` file.
2.  **Set Up the Plugin**: Place the `libgmp-simulator.a` file into the `gmp_bridge/ios/` directory and ensure its `.podspec` is configured.
3.  **Run the App**: Make sure the relative path to `gmp_bridge` in `pubspec.yaml` is correct. Then, run the app:

    ```bash
    # Open the iOS Simulator
    open -a Simulator

    # Run the Flutter app
    flutter run
    ```