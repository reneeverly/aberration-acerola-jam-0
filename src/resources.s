/*   .section .rodata */

   .global _thing
/*   .type thing, @object */
   .balign 4
_thing:
   .incbin "pixel-64x64.png"
thing_end:
   .global _thing_size
/*   .type thing_size, @object */
   .balign 4
_thing_size:
   .int thing_end - _thing

   .global _optical_aberration_fs
   .balign 4
_optical_aberration_fs:
   .incbin "optical_aberration.fs"
   .int 0 /* Add c_null_char to the end */
optical_aberration_fs_end:
   .global _optical_aberration_fs_size
   .balign 4
_optical_aberration_fs_size:
   .int optical_aberration_fs_end - _optical_aberration_fs
