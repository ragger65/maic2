!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Subroutine :  b o u n d a r y _ m a i c 2
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
subroutine boundary_maic2(time, ls, psi, dtime)

use maic2_types
use maic2_variables
use instemp
use evaporation
use condensation

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
     .or. time - time_of_last_temp_update > (1.0e+03_dp*YEAR_SEC) ) then

   print*, 'Surface temperature update ...'
   first_iteration = .false.
   time_of_last_temp_update = time

   call get_orb_par(time, ecc, obl, cp, ave, insol_ma_90NS)

   call get_psi_tab(ecc, ave)

   call setinstemp(temp, ecc = ecc, ave = ave*pi_180_inv, &
                         obl = obl*pi_180_inv, &
                         sa = ALBEDO, sac = ALBEDO_CO2, op = MARS_YEAR, &
                         ct = temp_co2_mean)

end if

!-------- Solar longitude (orbital position with respect to vernal equinox)
!         and true anomaly (orbital position with respect to perihelion) --------

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
   temp_surf(l) = inst(temp, psi*pi_180_inv, phi_node(l)*pi_180_inv)   ! in K
end do

!  ------ Amplitude of daily cycle

if (TEMP_SURF_AMP_EQ < eps) then

   temp_surf_amp = 0.0_dp   ! no daily cycle

else

   do l=0, LMAX
      temp_surf_amp(l) &
         = TEMP_SURF_AMP_EQ &
           * (1.0_dp-(abs(phi_node(l))*2.0_dp*pi_inv)**TEMP_SURF_AMP_EXP)
                                                                   ! in K
!           * max((cos(phi_node(l))),0.0_dp)**TEMP_SURF_AMP_EXP  ! in K
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

   if (water_new(l) >= -eps) then
      water(l) = max(water_new(l),0.0_dp)   ! new values -> old values
   else   ! physically meaningless
      stop ' Negative water content!'
   end if

end do

!-------- Condensation --------

#if (COND==1)   /* Removal of water exceeding the surface saturation pressure */

call setcondpar(gravity=G)
call getcond_1(temp_surf, water, cond, dtime)

#elif (COND==2)   /* Continuous, quadratic dependence on humidity */

tau_cond = TAU_COND*YEAR_SEC   ! a -> s
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
!
