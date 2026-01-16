!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Module :  o u t p u t _ m
!
!! Data output.
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
!> Data output.
!-------------------------------------------------------------------------------
module output_m

use maic2_types_m
use maic2_variables_m

implicit none

contains

!-------------------------------------------------------------------------------
!> Main subroutine: Data output.
!-------------------------------------------------------------------------------
  subroutine output(time, ls)

  implicit none

  real(dp), intent(in) :: time, ls

  integer(i4b) :: l

  do l=0, LMAX
     write(12, '(es14.6,f9.3,f7.1,f10.3,5es12.3)') &
          time/YEAR_SEC, &                  ! in a
          ls*pi_180_inv, &                  ! in deg
          phi_node(l)*pi_180_inv, &         ! in deg
          temp_surf(l), &                   ! in K
          evap(l)*YEAR_SEC, &               ! in kg/(m^2*a)
          cond(l)*YEAR_SEC, &               ! in kg/(m^2*a)
          water(l), &                       ! in kg/m^2
          a_net(l)*1.0e+03_dp*YEAR_SEC, &   ! in mm ice equiv./a
          H(l)                              ! in m
  end do

  end subroutine output

!-------------------------------------------------------------------------------

end module output_m
!
