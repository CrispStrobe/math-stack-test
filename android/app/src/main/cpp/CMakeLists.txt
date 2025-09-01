# Minimum CMake version required
cmake_minimum_required(VERSION 3.10)

# Import the ExternalProject module
include(ExternalProject)

# --- Project Definition ---
project(gmp_bridge)


# --- Map Android ABI to the correct GNU host triplet ---
if(${ANDROID_ABI} STREQUAL "arm64-v8a")
    set(GMP_HOST "aarch64-linux-android")
elseif(${ANDROID_ABI} STREQUAL "armeabi-v7a")
    set(GMP_HOST "armv7a-linux-androideabi")
elseif(${ANDROID_ABI} STREQUAL "x86_64")
    set(GMP_HOST "x86_64-linux-android")
elseif(${ANDROID_ABI} STREQUAL "x86")
    set(GMP_HOST "i686-linux-android")
else()
    message(FATAL_ERROR "Unsupported Android ABI: ${ANDROID_ABI}")
endif()


# --- Configure the External GMP Build ---
ExternalProject_Add(
    gmp_external
    
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/gmp-6.3.0
    BINARY_DIR gmp-build-${ANDROID_ABI}

    CONFIGURE_COMMAND
        env
        "CC=${CMAKE_C_COMPILER}"
        "AR=${CMAKE_AR}"
        "LD=${CMAKE_LINKER}"
        "RANLIB=${CMAKE_RANLIB}"
        "STRIP=${CMAKE_STRIP}"
        # --- THIS IS THE FIX ---
        # Add -fPIC to generate Position-Independent Code, required for shared libraries.
        "CFLAGS=-fPIC ${CMAKE_C_FLAGS} --sysroot=${CMAKE_SYSROOT} --target=${CMAKE_C_COMPILER_TARGET}"
        "LDFLAGS=${CMAKE_LINKER_FLAGS}"
        <SOURCE_DIR>/configure
        --build=x86_64-apple-darwin
        --host=${GMP_HOST}
        --disable-assembly
        --disable-shared

    BUILD_COMMAND make -j
    INSTALL_COMMAND ""
    BUILD_BYPRODUCTS <BINARY_DIR>/.libs/libgmp.a
)

# --- Build Our Final Shared Library ---
add_library(gmp_bridge SHARED gmp-bridge.cpp)

add_dependencies(gmp_bridge gmp_external)

target_link_directories(gmp_bridge PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/gmp-build-${ANDROID_ABI}/.libs)

# Use -Wl,--whole-archive to force the linker to include all symbols
# from the static gmp library in our final shared library.
target_link_libraries(gmp_bridge -Wl,--whole-archive gmp -Wl,--no-whole-archive)