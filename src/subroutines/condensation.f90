!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Module :  c o n d e n s a t i o n
!
!! Computation of the condensation rate.
!!
!!##### Authors
!!
!! Ralf Greve, Bjoern Grieger, Oliver J. Stenzel
!!
!!##### License
!!
!! This file is part of MAIC-2.
!!
!! MAIC-2 is free software: you can redistribute it and/or modify
!! it under the terms of the GNU General Public License as published by
!! the Free Software Foundation, either version 3 of the License, or
!! (at your option) any later version.
!!
!! MAIC-2 is distributed in the hope that it will be useful,
!! but WITHOUT ANY WARRANTY; without even the implied warranty of
!! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
!! GNU General Public License for more details.
!!
!! You should have received a copy of the GNU General Public License
!! along with MAIC-2. If not, see <https://www.gnu.org/licenses/>.
!
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

!-------------------------------------------------------------------------------
!> Computation of the condensation rate.
!-------------------------------------------------------------------------------
module condensation

   use maic2_types

   implicit none
   real(dp), private :: g
   real(dp), private :: tau

contains

!-------------------------------------------------------------------------------
!> Setting of parameters.
!-------------------------------------------------------------------------------
   subroutine setcondpar(gravity, timescale)

   implicit none

   real(dp), optional :: gravity, timescale

   if ( present(gravity) ) then
      g = gravity
   else
      g = 3.7_dp ! m/s**2
   end if

   if ( present(timescale) ) then
      tau = timescale
   else
      tau = 24.622962_dp*3600.0_dp ! length of Martian day (sol) in seconds
   end if

   end subroutine setcondpar
   
!-------------------------------------------------------------------------------
!> Computation of condensation
!! (removal of water exceeding the saturation pressure at the surface).
!-------------------------------------------------------------------------------
   subroutine getcond_1(temp, water, cond, dtime)

   implicit none

   real(dp) :: temp(:), water(:), cond(:)
   real(dp) :: dtime

   integer(i4b) :: i, n
   real(dp) :: g_inv, dtime_inv
   real(dp) :: p_sat, water_excess

   g_inv     = 1.0_dp/g
   dtime_inv = 1.0_dp/dtime

   n = size(cond)

   do i = 1, n
      water_excess = water(i) - p_sat(temp(i))*g_inv
      if (water_excess > 0.0_dp) then
         cond(i) = water_excess*dtime_inv
      else
         cond(i) = 0.0_dp
      end if
   end do

   end subroutine getcond_1
   
!-------------------------------------------------------------------------------
!> Computation of condensation (continuous, quadratic dependence on humidity).
!-------------------------------------------------------------------------------
   subroutine getcond_2(temp, water, cond)

   implicit none

   real(dp) :: temp(:), water(:), cond(:)
   real(dp) :: p_sat

   integer(i4b) :: i, n

   n = size(cond)

   do i = 1, n
      cond(i) = (g/tau) * water(i)**2 / p_sat(temp(i))
   end do

   end subroutine getcond_2

end module condensation
!
