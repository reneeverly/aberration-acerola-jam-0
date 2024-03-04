program main
   use, intrinsic :: iso_c_binding, only: c_null_char, c_ptr, c_null_ptr
   use resources
   use raylib
   implicit none (type, external)

   ! --

   integer, parameter :: screen_width = 1280
   integer, parameter :: screen_height = 720

   integer, parameter :: tile_size = 40
   integer, parameter :: tile_half = tile_size / 2
   integer, parameter :: screen_width_in_tiles = screen_width / tile_size
   integer, parameter :: screen_height_in_tiles = screen_height / tile_size

   type(shader_type) :: fshader

   type(image_type) :: slurm, slurm_copy
   type(texture2d_type) :: t_slurm
   
   type(render_texture2d_type) :: canvas

   real :: time_previous, time_current
   real, target :: lens_strength, lens_tightness

   ! --

   ! This has to be done before texture loading or it segfaults.
   call set_config_flags(flag_msaa_4x_hint)
   call init_window(screen_width, screen_height, 'Aberration Acerola Jam 0' // c_null_char)
   call set_target_fps(60)

   ! load shaders
   ! This modified load function is stored in resources.f90
   ! The regular binding seems like it can't handle c_null_ptr, so I made my own binding.
   fshader = load_partial_shader_from_memory(c_null_ptr, optical_aberration_fs)

   ! Load an affixed image (not from a file)
   slurm = load_image_from_memory('.png' // c_null_char, thing, thing_size)
   t_slurm = load_texture_from_image(slurm)
   call set_texture_filter(t_slurm, texture_filter_bilinear)
   call unload_image(slurm)

   ! the canvas upon which the shader is written to
   canvas = load_render_texture(screen_width, screen_height)
   call set_texture_filter(canvas%texture, texture_filter_bilinear)

   time_previous = get_time()

   ! default values
   lens_strength = 0.00
   lens_tightness = 2.75

   do while (.not. window_should_close())
      ! Let's not use frames for anything - use time instead!
      time_current = get_time()

      ! Run the optical aberration shader
      if (time_current > time_previous + 0.05) then
         if (lens_strength < 14*4*0.01) then
            lens_strength = lens_strength + 0.01
         else
            lens_strength = 0.01
            lens_tightness = 2.75
         end if
         lens_tightness = lens_tightness - 0.01
         call set_shader_value(fshader, get_shader_location(fshader, "lens_strength" // c_null_char), c_loc(lens_strength), shader_uniform_float)
         call set_shader_value(fshader, get_shader_location(fshader, "lens_tightness" // c_null_char), c_loc(lens_tightness), shader_uniform_float)
         time_previous = time_current
      end if

      call begin_texture_mode(canvas) 
         call clear_background(black)
         call draw_text('Hello, world!' // c_null_char, 10, 10, 16, white)
         call draw_texture_pro(t_slurm, rectangle_type(0, 0, tile_size, tile_size), rectangle_type(40, 40, tile_size, tile_size), vector2_type(tile_half, tile_half), -15.0, white)
         call draw_text("I'm in the center!" // c_null_char, screen_width_in_tiles / 2 * tile_size, screen_height_in_tiles / 2 * tile_size, 20, white)
      call end_texture_mode()
      call begin_drawing()
         call clear_background(darkgray)
         call begin_shader_mode(fshader)
            call draw_texture_pro(canvas%texture, rectangle_type(0, 0, screen_width, -screen_height), rectangle_type(0, 0, screen_width, screen_height), vector2_type(0, 0), 0.0, white)
         call end_shader_mode()
      call end_drawing()
   end do

   call close_window()
end program
