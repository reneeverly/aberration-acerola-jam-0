gcc -c src/resources_windows.s

gfortran -L/usr/local/lib -LC:/raylib/raylib/src -I/usr/local/include -I../fortran-raylib src/resources_windows.f90 src/spacearcade.f90 src/main.f90 resources_windows.o ../fortran-raylib/libfortran-raylib.a -lraylib -lopengl32 -lgdi32 -lwinmm -fno-range-check -ffree-line-length-none
