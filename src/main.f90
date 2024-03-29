program main
   use, intrinsic :: iso_c_binding, only: c_null_char, c_ptr, c_null_ptr
   use resources
   use raylib
   use spacearcade_class
   implicit none (type, external)

   ! --

   integer, parameter :: screen_width = 1360
   integer, parameter :: screen_height = 760

   integer, parameter :: tile_size = 40
   integer, parameter :: tile_half = tile_size / 2
   integer, parameter :: tile_fourth = tile_half / 2
   integer, parameter :: tile_eighth = tile_fourth / 2
   integer, parameter :: tile_three_eighth = tile_fourth + tile_eighth
   integer, parameter :: screen_width_in_tiles = screen_width / tile_size
   integer, parameter :: screen_height_in_tiles = screen_height / tile_size

   type(shader_type) :: fshader

   type(image_type) :: ship_image, blackhole_image
   type(texture2d_type) :: ship_tex, blackhole_tex
   
   type(render_texture2d_type) :: canvas

   real :: timer_move, timer_now, timer_experiment
   real, target :: lens_strength, lens_tightness

   type(spacearcade) :: game

   integer :: x, y

   character(len=512) :: string_buffer

   type(font_type) :: ds_font_20, ds_font_60

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
   ship_image = load_image_from_memory('.png' // c_null_char, ship_png, ship_png_size)
   ship_tex = load_texture_from_image(ship_image)
   call set_texture_filter(ship_tex, texture_filter_bilinear)
   call unload_image(ship_image)

   blackhole_image = load_image_from_memory('.png' // c_null_char, blackhole_png, blackhole_png_size)
   blackhole_tex = load_texture_from_image(blackhole_image)
   call set_texture_filter(blackhole_tex, texture_filter_bilinear)
   call unload_image(blackhole_image)

   ! the canvas upon which the shader is written to
   canvas = load_render_texture(screen_width, screen_height)
   call set_texture_filter(canvas%texture, texture_filter_bilinear)

   ! load the font
   !ds_font_20 = load_font_ex_null('res/digital-scientifika.ttf', 20, c_null_ptr, 0)
   !ds_font_60 = load_font_ex_null('res/digital-scientifika.ttf', 20, c_null_ptr, 0)
   !ds_font_20 = load_font_from_memory_null('.ttf' // c_null_char, ds_ttf, ds_ttf_size, 20, c_null_ptr, 0)
   !ds_font_60 = load_font_from_memory_null('.ttf' // c_null_char, ds_ttf, ds_ttf_size, 60, c_null_ptr, 0)
   !call gen_texture_mipmaps(ds_font_20%texture)
   !call gen_texture_mipmaps(ds_font_60%texture)
   !call set_texture_filter(ds_font_20%texture, texture_filter_point)
   !call set_texture_filter(ds_font_60%texture, texture_filter_point)

   timer_move = get_time()

   call run_titlescreen()

   game = spacearcade(1)

   ! default values
   lens_strength = 0.00
   lens_tightness = 2.75

   do while (.not. window_should_close())
      ! Let's not use frames for anything - use time instead!
      timer_now = get_time()

      call game%update_gamestate()


      if (game%lives <= 0) then
         call run_deathscreen()
         game = spacearcade(1)
      end if

      ! Run the optical aberration shader
!      if (timer_now > timer_experiment + 0.05) then
!         if (lens_strength < 14*4*0.01) then
!            lens_strength = lens_strength + 0.01
!         else
!            lens_strength = 0.01
!            lens_tightness = 2.75
!         end if
!         lens_tightness = lens_tightness - 0.01
         lens_strength = game%optical_aberration(1)
         lens_tightness = game%optical_aberration(2)
         call set_shader_value(fshader, get_shader_location(fshader, "lens_strength" // c_null_char), c_loc(lens_strength), shader_uniform_float)
         call set_shader_value(fshader, get_shader_location(fshader, "lens_tightness" // c_null_char), c_loc(lens_tightness), shader_uniform_float)
!         timer_experiment = timer_now
!      end if

      call begin_texture_mode(canvas) 

         call clear_background(black)
         call draw_text('Hello, world!' // c_null_char, 10, 10, 16, white)

         ! draw map
         do x=1,34
            do y=1,19
               if (game%level_map(x, y) == 1) then
                  call draw_rectangle_v(vector2_type((x - 1)*tile_size, (y - 1)*tile_size), vector2_type(tile_size, tile_size), blue)
               else if (game%level_map(x, y) == 2) then
                  call draw_texture_pro(blackhole_tex, rectangle_type(0, 0, tile_size*3, tile_size*3), rectangle_type((x - 2)*tile_size, (y - 2)*tile_size, tile_size*3, tile_size*3), vector2_type(0, 0), 0.0, white)
               else if (game%level_map(x, y) == -1) then
                  call draw_rectangle_v(vector2_type((x - 1)*tile_size+tile_fourth, (y - 1)*tile_size+tile_fourth), vector2_type(tile_half, tile_half), green)
               else if (game%level_map(x, y) == -2) then
                  call draw_rectangle_v(vector2_type((x - 1)*tile_size, (y - 1)*tile_size), vector2_type(tile_size, tile_size), white)
               else if (game%level_map(x, y) == -3) then
                  call draw_rectangle_v(vector2_type((x - 1)*tile_size+tile_three_eighth, (y - 1)*tile_size+tile_three_eighth), vector2_type(tile_fourth, tile_fourth), green)
               end if
            end do
         end do

         ! Display the current number of points
         write (string_buffer, '(I8)') game%points
         call draw_text('Points: ' //trim(adjustl(string_buffer)) // c_null_char, 10, 10, 20, white)

         ! display the current charge count
         write (string_buffer, '(I8)') game%charge
         call draw_text('Charge: ' //trim(adjustl(string_buffer)) // c_null_char, 10, screen_height - 30, 20, white)

         ! display the current lives
         write (string_buffer, '(I8)') game%lives
         call draw_text('Lives: ' // trim(adjustl(string_buffer)) // c_null_char, 600, screen_height - 30, 20, white)
         

         ! draw bounding box and then ship
         !call draw_rectangle_v(vector2_type(nint(game%player(1) - 1)*tile_size, nint(game%player(2) - 1)*tile_size), vector2_type(tile_size, tile_size), red)
         call draw_texture_pro(ship_tex, rectangle_type(0, 0, tile_size, tile_size), rectangle_type((game%player(1) - 1)*tile_size + tile_half, (game%player(2) - 1)*tile_size + tile_half, tile_size, tile_size), vector2_type(tile_half, tile_half), game%player(3), white)
         !call draw_text("I'm in the center!" // c_null_char, screen_width_in_tiles / 2 * tile_size, screen_height_in_tiles / 2 * tile_size, 20, white)

         ! draw enemy ships
         do x=1,number_of_enemies
            if (game%enemies(x,1) == 1) then
               call draw_rectangle_v(vector2_type((game%enemies(x, 2) - 1)*tile_size, (game%enemies(x, 3) - 1)*tile_size), vector2_type(tile_size, tile_size), red)
            else
               !print *, "Enemy", x, " is disabled"
            end if
         end do

      call end_texture_mode()
      call begin_drawing()

         call clear_background(darkgray)
         call begin_shader_mode(fshader)
            call draw_texture_pro(canvas%texture, rectangle_type(0, 0, screen_width, -screen_height), rectangle_type(0, 0, screen_width, screen_height), vector2_type(0, 0), 0.0, white)
         call end_shader_mode()

      call end_drawing()
   end do

   call close_window()

contains

   subroutine run_titlescreen()
      do while(.not. window_should_close())
         call begin_drawing()
            call clear_background(darkgray)
            !call draw_text_ex(ds_font_20, 'Press [ENTER] to begin!' // c_null_char, vector2_type(screen_width / 2 - 60, screen_height / 2), 20.0, 0.0, white)
            call draw_text('Space Arcade' // c_null_char, 40, 40, 40, white)
            call draw_text('Press [ENTER] to begin!' // c_null_char, 40, screen_height / 2 - 20, 40, white)
            call draw_text('Use arrow keys to move, [SPACE] to fire.' // c_null_char, 40, screen_height / 2 + 20, 40, white)
            if (is_key_down(key_enter)) exit
         call end_drawing()
      end do
   end subroutine

   subroutine run_deathscreen()
      do while (.not. window_should_close())
         call begin_drawing()
            call clear_background(darkgray)
            write (string_buffer, '(I8)') game%points
            call draw_text('Final score: ' // string_buffer // c_null_char, 40, 40, 40, white)
            call draw_text('Press [ENTER] to reset back to the beginning of the game.' // c_null_char, 40, screen_height / 2 - 20, 40, white)
            if (is_key_down(key_enter)) exit
         call end_drawing()
      end do
   end subroutine
end program
