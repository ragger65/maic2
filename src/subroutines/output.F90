!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Subroutine :  o u t p u t
!
!> @file
!!
!! Data output.
!!
!! @section Copyright
!!
!! Copyright 2010, 2011 Ralf Greve, Bjoern Grieger, Oliver J. Stenzel
!!
!! @section License
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
!! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!! GNU General Public License for more details.
!!
!! You should have received a copy of the GNU General Public License
!! along with MAIC-2.  If not, see <http://www.gnu.org/licenses/>.
!<
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

!-------------------------------------------------------------------------------
!> Data output.
!<------------------------------------------------------------------------------
subroutine output(time)

use maic2_types
use maic2_variables

implicit none

real(dp), intent(in) :: time

integer(i4b) :: l, n

do l=0, LMAX
   write(12, '(es14.6,f7.1,f10.3,5es12.3)') &
        time/YEAR_SEC, &                  ! in a
        phi_node(l)*pi_180_inv, &         ! in deg
        temp_surf(l), &                   ! in K
        evap(l)*YEAR_SEC, &               ! in kg/(m^2*a)
        cond(l)*YEAR_SEC, &               ! in kg/(m^2*a)
        water(l), &                       ! in kg/m^2
        a_net(l)*1.0e+03_dp*YEAR_SEC, &   ! in mm ice equiv./a
        H(l)                              ! in m
end do

end subroutine output
!
