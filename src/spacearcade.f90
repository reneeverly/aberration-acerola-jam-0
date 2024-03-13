module spacearcade_class
   use raylib
   implicit none
   type :: spacearcade
      integer :: width = 34
      integer :: height = 19
      real :: player(3) ! x, y, rot
      integer :: player_actual(2)
      integer :: level_map(34, 19) ! magic numbers: screen_width/tile_size (1360/40), screen_height/tile_size (760/40)
      real :: optical_aberration(2) ! index 1 = lens_strength, index 2 = lens_tightness
      integer :: current_level_num
      real :: timer_player_move, timer_player_fire
      real :: blackhole(2)
   contains
      procedure :: change_level => sa_change_level
      !procedure :: update_player_tex
      procedure :: update_gamestate, draw_gamestate
   end type
   interface spacearcade
      procedure constructor
   end interface

contains

   function constructor(level_num)
      type(spacearcade) :: constructor
      integer, intent(in) :: level_num
      !type(texture2d_type), intent(in) :: player_tex

      ! Default to no aberration of the lens
      constructor%optical_aberration = (0.00, 2.75)

      ! set all timers to now
      constructor%timer_player_move = get_time()
      constructor%timer_player_fire = get_time()

      ! set the map
      call constructor%change_level(level_num)
   end function

   subroutine sa_change_level(this, level_num)
      class(spacearcade) :: this
      integer, intent(in) :: level_num

      if (level_num == 1) then
         ! -3 = point
         ! -2 = warp location
         ! -1 = weapons charge
         !  0 = open space
         !  1 = fixed asteroid
         !  2 = black hole
         this%level_map = reshape( (/1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, &
                                    &1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0,  0, 0, 0,-2, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1,-3,-3,-3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1,-3, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1,-1,-3, 1, 0,-3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 1,-3, 1,-3, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1,-3,-3,-3,-3, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1,-3, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1,-3,-3,-3,-3,-3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1/),&
                                    &shape(this%level_map))
         this%player = (/2.0, 18.0, 90.0/)
         this%player_actual = (/2, 18/)
         this%blackhole = (/9, 8/)
      end if
      this%current_level_num = level_num
   end subroutine

   !subroutine update_player_tex(this, player_tex)
   !   class(spacearcade) :: this
   !   type(texture2d_type), intent(in) :: player_tex
   !end subroutine

   subroutine update_gamestate(this)
      class(spacearcade) :: this
      real :: timer_now, slew_dist, speed_modifier, optical_dist

      timer_now = get_time()

      speed_modifier = 0.5

      ! only allow reorientation when not up against a block facing that direction
      if (is_key_down(key_right) .and. this%level_map(this%player_actual(1) + 1, this%player_actual(2)) < 1) then
         ! fix for seemingly teleporting ship
         if (this%player(3) /= 90.0) then
            this%player(2) = this%player_actual(2)
            if (this%player(3) == 270.0) then
               this%timer_player_move = timer_now - (speed_modifier - (timer_now - this%timer_player_move))
            end if
         end if
         this%player(3) = 90.0
      else if (is_key_down(key_left) .and. this%level_map(this%player_actual(1) - 1, this%player_actual(2)) < 1) then
         ! fix for seemingly teleporting ship
         if (this%player(3) /= 270.0) then
            this%player(2) = this%player_actual(2)
            if (this%player(3) == 90.0) then
               this%timer_player_move = timer_now - (speed_modifier - (timer_now - this%timer_player_move))
            end if
         end if
         this%player(3) = 270.0
      else if (is_key_down(key_down) .and. this%level_map(this%player_actual(1), this%player_actual(2) + 1) < 1) then
         ! fix for seemingly teleporting ship
         if (this%player(3) /= 180.0) then
            this%player(1) = this%player_actual(1)
            if (this%player(3) == 0.0) then
               this%timer_player_move = timer_now - (speed_modifier - (timer_now - this%timer_player_move))
            end if
         end if
         this%player(3) = 180.0
      else if (is_key_down(key_up) .and. this%level_map(this%player_actual(1), this%player_actual(2) - 1) < 1) then
         ! fix for seemingly teleporting ship
         if (this%player(3) /= 0.0) then
            this%player(1) = this%player_actual(1)
            if (this%player(3) == 180.0) then
               this%timer_player_move = timer_now - (speed_modifier - (timer_now - this%timer_player_move))
            end if
         end if
         this%player(3) = 0.0
      end if

      ! perform visual movement via slew
      ! rather than dealing with the mess of floor and ciel, we'll just move
      ! the ship around its canonical location
      ! be sure to normalize the slew around the time shifts
      slew_dist = ((timer_now - this%timer_player_move) - (speed_modifier / 2)) * (1 / speed_modifier)
      if (this%player(3) == 90.0) then
         if (slew_dist < 0 .and. (this%player_actual(1) + slew_dist > this%player(1)) .or. this%level_map(this%player_actual(1) + 1, this%player_actual(2)) < 1) then
            this%player(1) = this%player_actual(1) + slew_dist
            if (slew_dist > 0.5) this%player_actual(1) = this%player_actual(1) + 1
         end if
      else if (this%player(3) == 270.0) then
         if (slew_dist < 0 .and. (this%player_actual(1) - slew_dist < this%player(1)) .or. this%level_map(this%player_actual(1) - 1, this%player_actual(2)) < 1) then
            this%player(1) = this%player_actual(1) - slew_dist
            if (slew_dist > 0.5) this%player_actual(1) = this%player_actual(1) - 1
         end if
      else if (this%player(3) == 180.0) then
         if (slew_dist < 0 .and. (this%player_actual(2) + slew_dist > this%player(2)) .or. this%level_map(this%player_actual(1), this%player_actual(2) + 1) < 1) then
            this%player(2) = this%player_actual(2) + slew_dist
            if (slew_dist > 0.5) this%player_actual(2) = this%player_actual(2) + 1
         end if
      else if (this%player(3) == 0.0) then
         if (slew_dist < 0 .and. (this%player_actual(2) - slew_dist < this%player(2)) .or. this%level_map(this%player_actual(1), this%player_actual(2) - 1) < 1) then
            this%player(2) = this%player_actual(2) - slew_dist
            if (slew_dist > 0.5) this%player_actual(2) = this%player_actual(2) - 1
         end if
      end if

      if (slew_dist > 0.5) then
         this%timer_player_move = timer_now
      end if 

      ! calculate optical aberration around black hole
      optical_dist = sqrt((this%player(1)-this%blackhole(1))**2 + (this%player(2)-this%blackhole(2))**2)
      if (optical_dist < 8) then
         this%optical_aberration = (/0.00 + 0.04 * (8 - optical_dist)**2, 2.75 - 0.02 * (8 - optical_dist)**2/)
      else
         this%optical_aberration = (0.00, 2.75)
      end if

   end subroutine

   subroutine draw_gamestate(this)
      class(spacearcade) :: this
   end subroutine 
      
end module
