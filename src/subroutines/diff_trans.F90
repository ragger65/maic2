!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Subroutine :  d i f f _ t r a n s
!
!! Diffusive transport of water in the Martian atmosphere.
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
!> Diffusive transport of water in the Martian atmosphere.
!-------------------------------------------------------------------------------
subroutine diff_trans(dtime)

use maic2_types_m
use maic2_variables_m
#if (SOLV_DIFF==2)
use maic2_maths_m
#endif

implicit none

real(dp), intent(in) :: dtime

integer(i4b) :: l
real(dp), dimension(0:LMAX) :: sle_a0, sle_a1, sle_a2, sle_b
real(dp) :: ratio_water_np_sp
real(dp) :: water_mean, water_mean_normalized

#if (SOLV_DIFF==0)

stop ' diff_trans: Option SOLV_DIFF==0 not available any more!'

#elif (SOLV_DIFF==1)   /* Explicit scheme (Euler forward) */

!-------- Direct solution of the Euler forward scheme --------

l=0
water_new(l) = water(l) + dtime &
                 * ( evap(l) - cond(l) &
                     + diff_aux(l) &
                       * ( cos_phi_cb2(l)*(water(l+1)-water(l)) &
                                         *dphi_inv(l+1) ) &
                   )

do l=1, LMAX-1
   water_new(l) = water(l) + dtime &
                    * ( evap(l) - cond(l) &
                        + diff_aux(l) &
                          * (  cos_phi_cb2(l)*(water(l+1)-water(l)) &
                                             *dphi_inv(l+1) &
                              -cos_phi_cb1(l)*(water(l)-water(l-1)) &
                                             *dphi_inv(l)   ) &
                      )
end do

l=LMAX
water_new(l) = water(l) + dtime &
                 * ( evap(l) - cond(l) &
                     + diff_aux(l) &
                       * ( -cos_phi_cb1(l)*(water(l)-water(l-1)) &
                                          *dphi_inv(l) ) &
                   )

#elif (SOLV_DIFF==2)   /* Implicit scheme (Euler backward) */

!-------- Setting of matrix and vector components --------

l=0
sle_a1(l) = 1.0_dp   + dtime * diff_aux(l)*cos_phi_cb2(l)*dphi_inv(l+1)
sle_a2(l) =          - dtime * diff_aux(l)*cos_phi_cb2(l)*dphi_inv(l+1)
sle_b(l)  = water(l) + dtime * (evap(l)-cond(l))

do l=1, LMAX-1
   sle_a0(l) =          - dtime * diff_aux(l)*cos_phi_cb1(l)*dphi_inv(l)
   sle_a1(l) = 1.0_dp   + dtime * diff_aux(l) &
                                  * (  cos_phi_cb1(l)*dphi_inv(l)   &
                                      +cos_phi_cb2(l)*dphi_inv(l+1) )
   sle_a2(l) =          - dtime * diff_aux(l)*cos_phi_cb2(l)*dphi_inv(l+1)
   sle_b(l)  = water(l) + dtime * (evap(l)-cond(l))
end do

l=LMAX
sle_a0(l) =          - dtime * diff_aux(l)*cos_phi_cb1(l)*dphi_inv(l)
sle_a1(l) = 1.0_dp   + dtime * diff_aux(l)*cos_phi_cb1(l)*dphi_inv(l)
sle_b(l)  = water(l) + dtime * (evap(l)-cond(l))

!-------- Solution of the system of linear equations --------

call tri_sle(sle_a0, sle_a1, sle_a2, water_new, sle_b, LMAX)

#elif (SOLV_DIFF==3)   /* Instantaneous mixing (optional north-south gradient) */

!-------- Ratio of the atmospheric water content at the poles
!                         (north pole relative to south pole) --------

#if (defined(RATIO_WATER_NP_SP))
ratio_water_np_sp = RATIO_WATER_NP_SP   ! prescribed north-south gradient
#else
ratio_water_np_sp = 1.0_dp   ! no north-south gradient,
                             ! constant water content everywhere on the planet
#endif

!-------- Predictor step without transport --------

do l=0, LMAX
   water_new(l) = water(l) + dtime * ( evap(l) - cond(l) )
end do

!-------- Mixing --------

!  ------ Mean water content from predictor

water_mean = 0.0_dp

do l=0, LMAX
   water_mean = water_mean &
                + 0.5_dp*water_new(l)*(sin_phi_cb2(l)-sin_phi_cb1(l))
end do

!  ------ Water content from linear distribution
!         with normalized value 1 at the south pole

do l=0, LMAX
   water_new(l) =   0.5_dp * (ratio_water_np_sp + 1.0_dp) &
                  + pi_inv * (ratio_water_np_sp - 1.0_dp) * phi_node(l)
end do

!  ------ Correction such that the correct mean water content results

water_mean_normalized = 0.0_dp

do l=0, LMAX
   water_mean_normalized = water_mean_normalized &
                           + 0.5_dp*water_new(l)*(sin_phi_cb2(l)-sin_phi_cb1(l))
end do

water_new = water_new * (water_mean/water_mean_normalized)

#else   /* Wrong value of parameter SOLV_DIFF */

stop ' Wrong value of parameter SOLV_DIFF (must be 1, 2 or 3)!'

#endif

end subroutine diff_trans
!
