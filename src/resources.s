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
