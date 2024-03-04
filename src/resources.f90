module resources
   use raylib
   use iso_c_binding
   implicit none
   integer(c_int), bind(c, name="thing_size") :: thing_size
   integer(kind=c_unsigned_char), bind(c, name="thing") :: thing
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

end interface

end module
