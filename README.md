# shared-makefile

A shared collection of constants, functions and build rules to help facilitate makefile compilation across windows and unix machines. Each \*.mk file has documentation at the top describing what it performs and possibly more regarding inputs and outputs.

A good example of this project in use is the [threadily-sample](https://github.com/k2snowman69/threadily-sample) repository.

# Depenencies

In general for this entire package to work there are several dependencies which are required to be fufilled. Each makefile is prefixed with the build tool of which is required for functionality to be successful. We have summarized what files require what and where to retrieve that dependency below.

## `All files` - Windows only - Mingw64

Mingw64 allows for make to be run on windows.
http://mingw-w64.org/

## `emcc-\*` - Emscripten

Emscripten is a C++ to JavaScript compiler which converts C++ code into JavaScript.
http://kripken.github.io/emscripten-site/
You'll need the SDK at minimum

## `npm-\*` - NPM and Node

npm is a package manager for node that allows software to be bundled for re-use
https://nodejs.org/en/download/

# Building

On Windows

1. Open a prompt window
1. Setup the emscripten sdk by running `emsdk_env.bat` from wherever you installed
1. Set the path to include your MinGW location (e.g. `PATH = %PATH%;D:/MinGW/mingw64/bin`)
1. Run `mingw32-make`

On Unix (or Unix based system)

1. Open a terminal window
1. Setup the emscripten sdk by running `source ./emsdk_env.sh` from wherever you installed
1. Run `make`

Other notes:

- You can also run make from the root directory, and it will recurse into all the sub directories.
- Use the -jN feature to run multiple processors for faster builds

# Last checked versions

This example code was last verified on Windows on October 1st, 2018
| Tool | Version |
| ------------- | -------- |
| Windows | 10 Version 1803 |
| EMCC | 1.38.12 (commit 0d8576c0e8f5ee09a36120b9d44184b5da2f2e7a) |
| Node | 8.9.1 |
| mingw32-make | v5.0.0 |

This example code was last verified on OSX on October 1st, 2018
| Tool | Version |
| ------------- | -------- |
| macOS | Version 10.13.6 |
| EMCC | 1.38.12 (commit 0d8576c0e8f5ee09a36120b9d44184b5da2f2e7a) |
| Node | 8.12.0 |
| make | GNU Make 3.81 |
