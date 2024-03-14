.section rodata
   .global _thing
/*   .type thing, @object*/
   .balign 4
_thing:
   .incbin "res\\pixel-64x64.png"
_thing_end:
   .global _thing_size
/*   .type thing_size, @object*/
   .balign 4
_thing_size:
   .int _thing_end - _thing

   .global _ship_png
/*.type ship_png, @object*/
   .balign 4
_ship_png:
   .incbin "res\\ship.png"
_ship_png_end:
   .global _ship_png_size
/*.type ship_png_size, @object*/
   .balign 4
_ship_png_size:
   .int _ship_png_end - _ship_png


   .global _blackhole_png
   .balign 4
_blackhole_png:
   .incbin "res\\blackhole.png"
_blackhole_png_end:
   .global _blackhole_png_size
   .balign 4
_blackhole_png_size:
   .int _blackhole_png_end - _blackhole_png

/*   .global _ds_ttf
   .balign 4
_ds_ttf:
   .incbin "res\\digital-scientifika.ttf"
_ds_ttf_end:
   .global _ds_ttf_size
   .balign 4
_ds_ttf_size:
   .int _ds_ttf_end - _ds_ttf*/


   .global _optical_aberration_fs
   .balign 4
_optical_aberration_fs:
   .incbin "res\\optical_aberration.fs"
   .int 0 /* Add c_null_char to the end */
_optical_aberration_fs_end:
   .global _optical_aberration_fs_size
   .balign 4
_optical_aberration_fs_size:
   .int _optical_aberration_fs_end - _optical_aberration_fs
