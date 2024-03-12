
   .global _thing
   .balign 4
_thing:
   .incbin "pixel-64x64.png"
_thing_end:
   .global _thing_size
   .balign 4
_thing_size:
   .int _thing_end - _thing

   .global _ship_png
   .balign 4
_ship_png:
   .incbin "ship.png"
_ship_png_end:
   .global _ship_png_size
   .balign 4
_ship_png_size:
   .int _ship_png_end - _ship_png

   .global _optical_aberration_fs
   .balign 4
_optical_aberration_fs:
   .incbin "optical_aberration.fs"
   .int 0 /* Add c_null_char to the end */
_optical_aberration_fs_end:
   .global _optical_aberration_fs_size
   .balign 4
_optical_aberration_fs_size:
   .int _optical_aberration_fs_end - _optical_aberration_fs
