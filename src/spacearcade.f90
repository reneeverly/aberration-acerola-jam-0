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

      real :: timer_player_move, timer_player_fire
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

      ! TEMPORARY TODO player start location
      constructor%player = (/2.0, 18.0, 90.0/)
      constructor%player_actual = (/2, 18/)

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
         this%level_map = reshape( (/1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &&
                                    &1, 0, 0, 0, 0,  0, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 1, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 1, 1, 1, 1,  1, 1, 1, 1, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &&
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &&
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 0, 0,  0, 0, 0, 1, &
                                    &1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1, 1,  1, 1, 1, 1/), &
                                    &shape(this%level_map))
      end if
   end subroutine

   !subroutine update_player_tex(this, player_tex)
   !   class(spacearcade) :: this
   !   type(texture2d_type), intent(in) :: player_tex
   !end subroutine

   subroutine update_gamestate(this)
      class(spacearcade) :: this
      real :: timer_now, slew_dist, speed_modifier

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

   end subroutine

   subroutine draw_gamestate(this)
      class(spacearcade) :: this
   end subroutine 
      
end module
