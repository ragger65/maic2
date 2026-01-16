!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Module :  c a l c _ t o p _ m a i c 2 _ m
!
!! Computation of the ice-cap topography.
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
!> Computation of the ice-cap topography.
!-------------------------------------------------------------------------------
module calc_top_maic2_m

use maic2_types_m
use maic2_variables_m

implicit none

contains

!-------------------------------------------------------------------------------
!> Main subroutine: Computation of the ice-cap topography.
!-------------------------------------------------------------------------------
  subroutine calc_top_maic2(time, dtime)

  implicit none

  real(dp), intent(in) :: time, dtime

  integer(i4b) :: l, n

!-------- Numerical integration --------

  do l=0, LMAX
     H_new(l) = H(l) + dtime*a_net(l)
  end do

  end subroutine calc_top_maic2

!-------------------------------------------------------------------------------

end module calc_top_maic2_m
!
