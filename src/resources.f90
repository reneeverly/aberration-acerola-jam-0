module resources
   use raylib
   use iso_c_binding
   implicit none
   integer(c_int), bind(c, name="thing_size") :: thing_size
   !character(kind=c_char), target, bind(c, name="_thing") :: f_thing
   !type(c_ptr), bind(c, name="_thing") :: thing
   integer(kind=c_unsigned_char), bind(c, name="thing") :: thing
end module
