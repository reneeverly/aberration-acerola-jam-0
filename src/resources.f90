module resources
   use raylib
   use iso_c_binding
   implicit none
   integer(c_int), bind(c, name="thing_size") :: thing_size
   integer(kind=c_unsigned_char), bind(c, name="thing") :: thing

   integer(c_int), bind(c, name="ship_png_size") :: ship_png_size
   integer(kind=c_unsigned_char), bind(c, name="ship_png") :: ship_png

   integer(c_int), bind(c, name="blackhole_png_size") :: blackhole_png_size
   integer(kind=c_unsigned_char), bind(c, name="blackhole_png") :: blackhole_png

!   integer(c_int), bind(c, name="ds_ttf_size") :: ds_ttf_size
!   integer(kind=c_unsigned_char), bind(c, name="ds_ttf") :: ds_ttf

   integer(c_int), bind(c, name="optical_aberration_fs_size") :: optical_aberration_fs_size
   character(kind=c_char), bind(c, name="optical_aberration_fs") :: optical_aberration_fs

interface

! the existing binding for load_shader_from_memory wasn't working with null_ptr, so here's a workaround!
function load_partial_shader_from_memory(vs_code, fs_code) bind(c, name='LoadShaderFromMemory')
   import c_char, shader_type, c_ptr
   implicit none
   type(c_ptr), intent(in), value :: vs_code
   character(kind=c_char), intent(in) :: fs_code
   type(shader_type) :: load_partial_shader_from_memory
end function

function load_font_from_memory_null(file_type, file_data, data_size, font_size, codepoints, codepoints_count) &
      bind(c, name='LoadFontFromMemory')
   import :: c_char, c_int, c_unsigned_char, font_type, c_ptr
   implicit none
   character(kind=c_char),        intent(in)        :: file_type
   integer(kind=c_unsigned_char), intent(in)        :: file_data
   integer(kind=c_int),           intent(in), value :: data_size
   integer(kind=c_int),           intent(in), value :: font_size
   type(c_ptr), intent(in)     :: codepoints
   integer(kind=c_int),           intent(in), value :: codepoints_count
   type(font_type)                                  :: load_font_from_memory_null
end function

! Font LoadFontEx(const char *fileName, int fontSize, int *codepoints, int codepointsCount)
function load_font_ex_null(file_name, font_size, codepoints, codepoints_count) bind(c, name='LoadFontEx')
   import :: c_char, c_int, font_type, c_ptr
   implicit none
   character(kind=c_char), intent(in)        :: file_name
   integer(kind=c_int),    intent(in), value :: font_size
   type(c_ptr),    intent(in)     :: codepoints
   integer(kind=c_int),    intent(in), value :: codepoints_count
   type(font_type)                           :: load_font_ex_null
end function

end interface

end module
