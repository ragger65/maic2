!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Function :  p _ s a t
!
!> @file
!!
!! Computation of the water-vapour saturation pressure.
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
!> Computation of the water-vapour saturation pressure.
!<------------------------------------------------------------------------------
elemental function p_sat(temp_surf) result(psat)

use maic2_types

implicit none

real(dp), intent(in) :: temp_surf

real(dp) :: psat

!   psat = exp( -5504.4088_dp * temp_surf**(-1) &
!               - 3.5704628_dp &
!               - 1.7337458e-2_dp * temp_surf &
!               + 6.5204209e-6_dp * temp_surf**2 &
!               + 6.1295027_dp * log(temp_surf) )

   psat = 610.66_dp * exp( 21.875_dp*(temp_surf-273.16_dp)/ &
                                     (temp_surf-  7.65_dp) )

end function p_sat
!
