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

  integer(i4b)      :: l
  real(dp)          :: H_NP, H_SP
  real(dp)          :: V_NPLD, V_SPLD
  character(len=64) :: ch_fmt

  H_NP = H(LMAX)   ! ice thickness at the north pole
  H_SP = H(0)      ! ice thickness at the south pole

  V_NPLD = 9.99999e+09_dp
           ! Volume of the north-polar layered deposits (>= 75 degN)
  V_SPLD = 9.99999e+09_dp
           ! Volume of the south-polar layered deposits (>= 75 degS)
           !!! DUMMIES, STILL TO BE COMPUTED !!!

  ch_fmt = '(es14.6,f9.3,4es14.5)'

  write(12, trim(ch_fmt)) &
            time/YEAR_SEC , &   ! in a
            ls*pi_180_inv , &   ! in deg
            H_NP          , &   ! in m
            H_SP          , &   ! in m
            V_NPLD        , &   ! in m3
            V_SPLD              ! in m3

  ch_fmt = '(es14.6,f7.1,f10.3,5es14.5)'

  do l=0, LMAX
     write(13, trim(ch_fmt)) &
               time/YEAR_SEC                , &   ! in a
               phi_node(l)*pi_180_inv       , &   ! in deg
               temp_surf(l)                 , &   ! in K
               evap(l)*YEAR_SEC             , &   ! in kg/(m^2*a)
               cond(l)*YEAR_SEC             , &   ! in kg/(m^2*a)
               water(l)                     , &   ! in kg/m^2
               a_net(l)*1.0e+03_dp*YEAR_SEC , &   ! in mm ice equiv./a
               H(l)                               ! in m
  end do

  end subroutine output

!-------------------------------------------------------------------------------

end module output_m
!
