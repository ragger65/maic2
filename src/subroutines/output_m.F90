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
  real(dp)          :: phi_PLD
  real(dp)          :: V_NPLD, V_SPLD

  character(len=64) :: ch_fmt

!-------- Compute ice thicknesses at the poles --------

  H_NP = H(LMAX)   ! north pole
  H_SP = H(0)      ! south pole

!-------- Compute volumes of the polar layered deposits --------

  phi_PLD = (75.0_dp-epsil) *deg2rad
                   ! equatorward extent of the PLDs, in rad

!  ------ SPLD

  l=0   ! 90 degS

  V_SPLD = max(H(l), 0.0_dp) &
              * ( 1.0_dp + sin( 0.5_dp*(phi_node(l)+phi_node(l+1)) ) )

  do l=1, LMAX-1
     if (abs(phi_node(l)) >= phi_PLD) then
        V_SPLD = V_SPLD + max(H(l), 0.0_dp) &
                    * (   sin( 0.5_dp*(phi_node(l)+phi_node(l+1)) ) &
                        - sin( 0.5_dp*(phi_node(l)+phi_node(l-1)) ) )
     end if
  end do

  V_SPLD = V_SPLD * (2.0_dp*pi*R**2)

!  ------ NPLD

  l=LMAX   ! 90 degN

  V_NPLD = max(H(l), 0.0_dp) &
              * ( 1.0_dp - sin( 0.5_dp*(phi_node(l)+phi_node(l-1)) ) )

  do l=LMAX-1, 1, -1
     if (abs(phi_node(l)) >= phi_PLD) then
        V_NPLD = V_NPLD + max(H(l), 0.0_dp) &
                    * (   sin( 0.5_dp*(phi_node(l)+phi_node(l+1)) ) &
                        - sin( 0.5_dp*(phi_node(l)+phi_node(l-1)) ) )
     end if
  end do

  V_NPLD = V_NPLD * (2.0_dp*pi*R**2)

!-------- Write data on file --------

  ch_fmt = '(es14.6,f9.3,4es14.5)'

  write(12, trim(ch_fmt)) &
            time*sec2year , &   ! in a
            ls*rad2deg    , &   ! in deg
            H_NP          , &   ! in m
            H_SP          , &   ! in m
            V_NPLD        , &   ! in m3
            V_SPLD              ! in m3

  ch_fmt = '(es14.6,f7.1,f10.3,5es14.5)'

  do l=0, LMAX
     write(13, trim(ch_fmt)) &
               time*sec2year                  , &   ! in a
               phi_node(l)*rad2deg            , &   ! in deg
               temp_surf(l)                   , &   ! in K
               evap(l)*year2sec               , &   ! in kg/(m^2*a)
               cond(l)*year2sec               , &   ! in kg/(m^2*a)
               water(l)                       , &   ! in kg/m^2
               (a_net(l)*1.0e+03_dp)*year2sec , &   ! in mm ice equiv./a
               H(l)                                 ! in m
  end do

  end subroutine output

!-------------------------------------------------------------------------------

end module output_m
!
