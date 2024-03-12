#!/bin/zsh

# This function assumes that fortran-raylib is in the folder containing this folder
build_fort() {
   gfortran -L/usr/local/lib -I/usr/local/include -I../fortran-raylib $@ ../fortran-raylib/libfortran-raylib.a -lraylib -framework OpenGL -framework Cocoa -framework IOKit -framework CoreAudio -framework CoreVideo -fno-range-check -ffree-line-length-none
}

build_fort src/resources.f90 src/spacearcade.f90 src/main.f90 -Ires/ src/resources.s
