# aberration-acerola-jam-0
My submission for the Acerola Jam 0 game jam.

Licenses:
* Code is MPL 2.0
  * This includes all fortran, assembly, and shader files.
* Resources are CC BY-NC-ND
  * This includes my font, sound effects, music, and textures

## Build Instructions
MacOS & Windows are supported platforms.

### MacOS (Primary Development Environment)

Install [Homebrew](https://brew.sh/)

Install required development dependencies:
```bash
brew install raylib gfortran
```

Fetch [Interkosmos's Fortran Interface Bindings for Raylib](https://github.com/interkosmos/fortran-raylib) and build them.  My build script assumes you clone that repository into the folder that contains this repository (ex paths: `~/repos/fortran-raylib` and `~/repos/aberration-acerola-jam-0`).

Run the build script:
```bash
./build_macos.sh
```

### Windows

Install Raylib normally.

Install [MinGW GFortran MSVCRT](https://winlibs.com/)

Fetch [Interkosmos's Fortran Interface Bindings for Raylib](https://github.com/interkosmos/fortran-raylib) and build them.  My build script assumes you clone that repository into the folder that contains this repository (ex paths: `~/repos/fortran-raylib` and `~/repos/aberration-acerola-jam-0`).  The `make` provided in the downloadable zip is `mingw32-make`.

Build with the following command:
```cmd
buildwin64.bat
```
