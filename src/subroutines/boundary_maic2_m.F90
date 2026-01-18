!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Module :  b o u n d a r y _ m a i c 2 _ m
!
!! Determination of the surface temperature and of the net mass balance
!! (accumulation-ablation rate) for the polar caps of Mars.
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
!> Determination of the surface temperature and of the net mass balance
!! (accumulation-ablation rate) for the polar caps of Mars.
!-------------------------------------------------------------------------------
module boundary_maic2_m

use maic2_types_m
use maic2_variables_m
use instemp_m
use evap_cond_m
#if (SOLV_DIFF==2)
use maic2_maths_m
#endif

implicit none

contains

!-------------------------------------------------------------------------------
!> Main subroutine:
!! Determination of the surface temperature and of the net mass balance
!! (accumulation-ablation rate) for the polar caps of Mars.
!-------------------------------------------------------------------------------
  subroutine boundary_maic2(time, ls, psi, dtime)

  implicit none

  real(dp), intent(in) :: time, dtime
  real(dp), intent(inout) :: ls, psi

  integer(i4b) :: l, n, n1, n2
  real(dp) :: temp_co2_mean
  real(dp) :: ecc, obl, cp, ave, insol_ma_90NS, time_help
  real(dp) :: evap_coeff, tau_cond
  real(dp) :: dtime_inv
  type (ins), save :: temp

  logical :: first_iteration = .true.
  real(dp) :: time_of_last_temp_update = 0.0

  dtime_inv = 1.0_dp/dtime

!-------- Surface pressure, CO2 condensation temperature --------

  p_surf = P_SURF

  temp_co2      = 3182.48_dp/(23.3494_dp-log(0.01_dp*p_surf))
  temp_co2_mean = sum(temp_co2)/real(size(temp_co2),dp)

!-------- Orbital parameters, table of true anomalies
!         and seasonal cycle of surface temperatures --------

  if ( first_iteration &
       .or. time - time_of_last_temp_update > (1.0e+03_dp*year2sec) ) &
     then

     print*, 'Surface temperature update ...'
     first_iteration = .false.
     time_of_last_temp_update = time

     call get_orb_par(time, ecc, obl, cp, ave, insol_ma_90NS)

     call get_psi_tab(ecc, ave)

     call setinstemp(temp, ecc = ecc, ave = ave*rad2deg, &
                           obl = obl*rad2deg, &
                           sa = ALBEDO, sac = ALBEDO_CO2, op = MARS_YEAR, &
                           ct = temp_co2_mean)

  end if

!-------- Solar longitude (orbital position with respect to vernal equinox),
!         true anomaly (orbital position with respect to perihelion) --------

  time_help = real(NTIME,dp)*modulo(time/MARS_YEAR, 1.0_dp)

  n1 = floor(time_help)
  n2 = n1 + 1

  if ((n1 < 0).or.(n2 > NTIME)) &
     stop ' Subroutine boundary_maic2: n1 or n2 out of range!'

  ls = ls_tab(n1) + (time_help-real(n1,dp))*(ls_tab(n2)-ls_tab(n1))
  ls = modulo(ls, 2.0_dp*pi)

  psi = psi_tab(n1) + (time_help-real(n1,dp))*(psi_tab(n2)-psi_tab(n1))
  psi = modulo(psi, 2.0_dp*pi)

!-------- Instantaneous surface temperature --------

!  ------ Daily mean

  do l=0, LMAX
     temp_surf(l) = inst(temp, psi*rad2deg, phi_node(l)*rad2deg)   ! in K
  end do

!  ------ Amplitude of daily cycle

  if (TEMP_SURF_AMP_EQ < epsil) then

     temp_surf_amp = 0.0_dp   ! no daily cycle

  else

     do l=0, LMAX
        temp_surf_amp(l) &
           = TEMP_SURF_AMP_EQ &
             * (1.0_dp-(abs(phi_node(l))*2.0_dp*pi_inv)**TEMP_SURF_AMP_EXP)
                                                                     ! in K
!             * max((cos(phi_node(l))),0.0_dp)**TEMP_SURF_AMP_EXP  ! in K
     end do

  end if

!-------- Initializations of evaporation and condensation --------

  evap = 0.0_dp
  cond = 0.0_dp

!-------- Evaporation (Buoyant-diffusion approach by Ingersoll)--------

  call setevappar_bd(evap_fact_para=EVAP_FACT, gamma_reg_para=GAMMA_REG, &
                     g_para=G)
  call getevap_bd(temp_surf, temp_surf_amp, p_surf, H, evap)

!-------- Diffusive transport --------

  call diff_trans(dtime)   ! computed with cond = 0.0_dp;
                           ! condensation will be accounted for later

  do l=0, LMAX

     if (water_new(l) >= -epsil) then
        water(l) = max(water_new(l),0.0_dp)   ! new values -> old values
     else   ! physically meaningless
        stop ' Negative water content!'
     end if

  end do

!-------- Condensation --------

#if (COND==1) /* Removal of water exceeding the surface saturation pressure */

  call setcondpar(gravity=G)
  call getcond_1(temp_surf, water, cond, dtime)

#elif (COND==2) /* Continuous, quadratic dependence on humidity */

  tau_cond = TAU_COND * year2sec   ! a -> s
  call setcondpar(gravity=G, timescale=tau_cond)
  call getcond_2(temp_surf, water, cond)

#endif

  do l=0, LMAX

     water_new(l) = water(l) - dtime * cond(l)

     if (water_new(l) >= 0.0_dp) then
        water(l) = water_new(l)   ! new values -> old values
     else   ! physically meaningless, needs to be corrected
        cond(l)  = cond(l) + water_new(l)*dtime_inv
        water(l) = 0.0_dp
     end if

  end do

!-------- Net mass balance --------

  do l=0, LMAX
     a_net(l) = (cond(l)-evap(l))*rho_inv
  end do

  end subroutine boundary_maic2

!-------------------------------------------------------------------------------
!> Determination of the orbital parameters
!! (eccentricity, obliquity, climate parameter CP, anomaly of vernal equinox,
!! mean-annual north- or south-polar insolation).
!-------------------------------------------------------------------------------
  subroutine get_orb_par(time, ecc, obl, cp, ave, insol_ma_90NS)

  implicit none

  real(dp), intent(in)  :: time
  real(dp), intent(out) :: ecc, obl, cp, ave, insol_ma_90NS

  integer(i4b) :: ndata_insol
  integer(i4b) :: i_kl, i_gr
  real(dp) :: time_kl, time_gr, ave_data_i_kl, ave_data_i_gr

  ndata_insol = (insol_time_max-insol_time_min)/insol_time_stp

  if (time*sec2year < real(insol_time_min,dp)) then

     ecc           = ecc_data(0)
     obl           = obl_data(0)
     cp            = cp_data(0)
     ave           = ave_data(0)
     insol_ma_90NS = insol_ma_90(0)

  else if (time*sec2year < real(insol_time_max,dp)) then

     i_kl = floor( ((time*sec2year)-real(insol_time_min,dp)) &
                   /real(insol_time_stp,dp) )
     i_kl = max(i_kl, 0)

     i_gr = ceiling( ((time*sec2year)-real(insol_time_min,dp)) &
                     /real(insol_time_stp,dp) )
     i_gr = min(i_gr, ndata_insol)

     if (i_kl == i_gr) then

        ecc           = ecc_data(i_kl)
        obl           = obl_data(i_kl)
        cp            = cp_data(i_kl)
        ave           = ave_data(i_kl)
        insol_ma_90NS = insol_ma_90(i_kl)

     else

        time_kl = (insol_time_min + i_kl*insol_time_stp) * year2sec
        time_gr = (insol_time_min + i_gr*insol_time_stp) * year2sec

        ecc = ecc_data(i_kl) &
                  +(ecc_data(i_gr)-ecc_data(i_kl)) &
                  *(time-time_kl)/(time_gr-time_kl)
        obl = obl_data(i_kl) &
                  +(obl_data(i_gr)-obl_data(i_kl)) &
                  *(time-time_kl)/(time_gr-time_kl)
        insol_ma_90NS = insol_ma_90(i_kl) &
                  +(insol_ma_90(i_gr)-insol_ma_90(i_kl)) &
                  *(time-time_kl)/(time_gr-time_kl)

        if ( abs(ave_data(i_gr)-ave_data(i_kl)) < pi ) then   ! regular case
              ave_data_i_kl = ave_data(i_kl)
              ave_data_i_gr = ave_data(i_gr)
        else
           if ( ave_data(i_gr) > ave_data(i_kl) ) then
              ave_data_i_kl = ave_data(i_kl) + 2.0_dp*pi
              ave_data_i_gr = ave_data(i_gr)
           else
              ave_data_i_kl = ave_data(i_kl)
              ave_data_i_gr = ave_data(i_gr) + 2.0_dp*pi
           end if
        end if

        ave = ave_data_i_kl &
                  +(ave_data_i_gr-ave_data_i_kl) &
                  *(time-time_kl)/(time_gr-time_kl)

        cp  = cp_data(i_kl) &
                  +(cp_data(i_gr)-cp_data(i_kl)) &
                  *(time-time_kl)/(time_gr-time_kl)
                   ! linear interpolation of the data
     end if

  else

     ecc           = ecc_data(ndata_insol)
     obl           = obl_data(ndata_insol)
     cp            = cp_data(ndata_insol)
     ave           = ave_data(ndata_insol)
     insol_ma_90NS = insol_ma_90(ndata_insol)

  end if

  end subroutine get_orb_par

!-------------------------------------------------------------------------------
!> Computation of the table of true anomalies (orbital positions
!! with respect to perihelion) over a Martian year.
!-------------------------------------------------------------------------------
  subroutine get_psi_tab(ecc, ave)

  implicit none

  real(dp), intent(in) :: ecc, ave

  integer(i4b) :: iter, n
  real(dp) :: dtime_psi, factor, misfit

  dtime_psi = MARS_YEAR / real(NTIME,dp)
  factor    = 2.0_dp*pi  / MARS_YEAR

  ls_tab(0) = 0   ! corresponds to the vernal equinox

!-------- Iteration loop --------

  do iter=1, 5

!  ------ Integration over one Martian year

     do n=0, NTIME-1
        ls_tab(n+1) = ls_tab(n) &
                      + dtime_psi*factor*(1.0_dp+ecc*cos(ls_tab(n)+ave))**2
     end do

!  ------ Adjustment of the factor in order to get the orbit closed

     misfit = 2.0_dp*pi/ls_tab(NTIME)
     factor = factor*misfit

  end do

!-------- Final scaling --------

  if ((misfit > 0.99_dp).and.(misfit < 1.01_dp)) then
     ls_tab = ls_tab*misfit
  else
     stop ' Subroutine get_psi_tab: Bad convergence of ls_tab!'
  end if

  psi_tab = ls_tab + ave   ! not normalized to the interval [0, 2*pi)

  end subroutine get_psi_tab

!-------------------------------------------------------------------------------
!> Diffusive transport of water in the Martian atmosphere.
!-------------------------------------------------------------------------------
  subroutine diff_trans(dtime)

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
                             + 0.5_dp*water_new(l) &
                                     *(sin_phi_cb2(l)-sin_phi_cb1(l))
  end do

  water_new = water_new * (water_mean/water_mean_normalized)

#else   /* Wrong value of parameter SOLV_DIFF */

  stop ' Wrong value of parameter SOLV_DIFF (must be 1, 2 or 3)!'

#endif

  end subroutine diff_trans

!-------------------------------------------------------------------------------

end module boundary_maic2_m
!
