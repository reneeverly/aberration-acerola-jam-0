program main
   use, intrinsic :: iso_c_binding, only: c_null_char
   use raylib
   implicit none

   integer, parameter :: screen_width = 1280
   integer, parameter :: screen_height = 768

   integer, parameter :: tile_size = 64
   integer, parameter :: screen_width_in_tiles = screen_width / tile_size
   integer, parameter :: screen_height_in_tiles = screen_height / tile_size

   call init_window(screen_width, screen_height, 'Aberration Acerola Jam 0' // c_null_char)
   call set_target_fps(60)

   do while (.not. window_should_close())
      call begin_drawing()
         call clear_background(darkgray)
         call draw_text('Hello, world!' // c_null_char, 10, 10, 16, white)
      call end_drawing()
   end do

   call close_window()
end program
