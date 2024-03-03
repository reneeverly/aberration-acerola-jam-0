program main
   use, intrinsic :: iso_c_binding, only: c_null_char
   use resources
   use raylib
   implicit none (type, external)

   integer, parameter :: screen_width = 1280
   integer, parameter :: screen_height = 768

   integer, parameter :: tile_size = 64
   integer, parameter :: screen_width_in_tiles = screen_width / tile_size
   integer, parameter :: screen_height_in_tiles = screen_height / tile_size

   type(image_type) :: slurm, slurm_copy
   type(texture2d_type) :: t_slurm

   ! This has to be done before texture loading or it segfaults.
   call init_window(screen_width, screen_height, 'Aberration Acerola Jam 0' // c_null_char)
   call set_target_fps(60)


   ! Load an affixed image (not from a file)
   slurm = load_image_from_memory('.png' // c_null_char, thing, thing_size)
   t_slurm = load_texture_from_image(slurm)

   do while (.not. window_should_close())
      call begin_drawing()
         call clear_background(darkgray)
         call draw_text('Hello, world!' // c_null_char, 10, 10, 16, white)
         call draw_texture(t_slurm, 64, 64, white)
      call end_drawing()
   end do

   call close_window()
end program
