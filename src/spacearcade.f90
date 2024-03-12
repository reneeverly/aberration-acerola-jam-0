module spacearcade_class
   use raylib
   implicit none
   type :: spacearcade
      integer :: width = 34
      integer :: height = 19
      real :: player(3) ! x, y, rot
      !type(texture2d_type) :: ship_tex
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
      real :: timer_now
      integer :: x_n, x_f, x_c
      integer :: y_n, y_f, y_c
      integer :: rot

      timer_now = get_time()

      ! Nearest Tile
      x_n = nint(this%player(1))
      y_n = nint(this%player(2))
      rot = nint(this%player(3))

      ! Tile movement is happening from 90deg or 180deg
      x_f = floor(this%player(1))
      y_f = floor(this%player(2))

      ! Tile movement is happening from 270deg or 0deg
      x_c = ceiling(this%player(1))
      y_c = ceiling(this%player(2))

      ! check for able to rotate, and in what directions, then do it
      !if (abs(x_n - this%player(1)) < 0.25 .and. abs(y_n - this%player(2)) < 0.25) then
         if (is_key_down(key_right)) then
            if (this%level_map(x_n + 1, y_n) < 1) then
               rot = 90
               this%player(3) = 90.0
               ! bugfix visually align to col/row
               this%player(2) = y_n
            end if
         else if (is_key_down(key_left)) then
            if (this%level_map(x_n - 1, y_n) < 1) then
               rot = 270
               this%player(3) = 270.0
               ! bugfix visually align to col/row
               this%player(2) = y_n
            end if
         else if (is_key_down(key_down)) then
            if (this%level_map(x_n, y_n + 1) < 1) then
               rot = 180
               this%player(3) = 180.0
               ! bugfix visually align to col/row
               this%player(1) = x_n
            end if
         else if (is_key_down(key_up)) then
            if (this%level_map(x_n, y_n - 1) < 1) then
               rot = 0
               this%player(3) = 0.0
               ! bugfix visually align to col/row
               this%player(1) = x_n
            end if
         end if
      !end if
      

      ! perform movement
      if (rot == 90) then
         this%player(1) = x_f + (timer_now - this%timer_player_move) * 2
      else if (rot == 270) then
         this%player(1) = x_c - (timer_now - this%timer_player_move) * 2
      else if (rot == 180) then
         this%player(2) = y_f + (timer_now - this%timer_player_move) * 2
      else if (rot == 0) then
         this%player(2) = y_c - (timer_now - this%timer_player_move) * 2
      end if
      

      ! reset timer if move duration elapsed
      if (timer_now - this%timer_player_move > 0.5) then
         this%timer_player_move = timer_now
      end if

      ! constrain to world bounds
      if (this%player(1) >= this%width) this%player(1) = this%width
      if (this%player(2) >= this%height) this%player(2) = this%height
      if (this%player(1) < 1) this%player(1) = 1
      if (this%player(2) < 1) this%player(2) = 1

      ! constrain to map
      if (this%level_map(x_n + 1, y_n) >= 1) then
         if (this%player(1) > x_n) then
            this%player(1) = x_n
         end if
      else if (this%level_map(x_n - 1, y_n) >= 1) then
         if (this%player(1) < x_n) then
            this%player(1) = x_n
         end if
      end if
      ! break the else chain due to edge case where ship will have both x and y collisions
      if (this%level_map(x_n, y_n + 1) >= 1) then
         if (this%player(2) > y_n) then
            this%player(2) = y_n
         end if
      else if (this%level_map(x_n, y_n - 1) >= 1) then
         if (this%player(2) < y_n) then
            this%player(2) = y_n
         end if
      end if
      
   end subroutine

   subroutine draw_gamestate(this)
      class(spacearcade) :: this
   end subroutine 
      
end module
