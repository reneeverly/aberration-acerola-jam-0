# aberration-acerola-jam-0
My submission for the Acerola Jam 0 game jam.

## Build Instructions
MacOS & Windows are supported platforms.

### MacOS (Primary Development Environment)

Install [Homebrew](https://brew.sh/)

Install required development dependencies:
```bash
brew install raylib gfortran
```

Fetch [Interkosmos's Fortran Interface Bindings for Raylib](https://github.com/interkosmos/fortran-raylib) and build them.  My build script assumes you clone that repository into the folder that contains this repository (ex paths: `~/repos/fortran-raylib` and `~/repos/aberration-acerola-jame-0`).

Run the build script:
```bash
./build_macos.sh
```

### Windows


