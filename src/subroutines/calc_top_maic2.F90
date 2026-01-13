!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Subroutine :  c a l c _ t o p _ m a i c 2
!
!> @file
!!
!! Computation of the ice-cap topography.
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
!> Computation of the ice-cap topography.
!<------------------------------------------------------------------------------
subroutine calc_top_maic2(time, dtime)

use maic2_types
use maic2_variables

implicit none

real(dp), intent(in) :: time, dtime

integer(i4b) :: l, n

!-------- Numerical integration --------

do l=0, LMAX
   H_new(l) = H(l) + dtime*a_net(l)
end do

end subroutine calc_top_maic2
!
