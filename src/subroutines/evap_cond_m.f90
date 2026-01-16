!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Module :  e v a p _ c o n d _ m
!
!! Computation of the evaporation rate (buoyant-diffusion approach by Ingersoll)
!! and of the condensation rate.
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
!> Computation of the evaporation rate (buoyant-diffusion approach by Ingersoll)
!! and of the condensation rate.
!-------------------------------------------------------------------------------
module evap_cond_m

use maic2_types_m

implicit none
real(dp), private :: evap_fact, gamma_reg, &
                     R_univ, mol_w, mol_c, diff_w_c, visc_c, g, tau

contains

!-------------------------------------------------------------------------------
!> Setting of parameters for evapotation.
!-------------------------------------------------------------------------------
   subroutine setevappar_bd(evap_fact_para, gamma_reg_para, &
                            R_univ_para, mol_w_para, mol_c_para, &
                            diff_w_c_para, visc_c_para, g_para)

   implicit none

   real(dp), optional :: evap_fact_para, gamma_reg_para, &
                         R_univ_para, mol_w_para, mol_c_para, &
                         diff_w_c_para, visc_c_para, g_para

   if ( present(evap_fact_para) ) then
      evap_fact = evap_fact_para   ! evaporation factor
   else
      evap_fact = 1.0_dp
   end if

   if ( present(gamma_reg_para) ) then
      gamma_reg = gamma_reg_para   ! regolith-insolation coefficient [in m]
   else
      gamma_reg = 1.11e+11_dp
   end if

   if ( present(R_univ_para) ) then
      R_univ = R_univ_para   ! universal gas constant [J/(mol*K)]
   else
      R_univ = 8.314_dp
   end if

   if ( present(mol_w_para) ) then
      mol_w = mol_w_para   ! molar mass of water [kg/mol]
   else
      mol_w = 1.802e-02_dp
   end if

   if ( present(mol_c_para) ) then
      mol_c = mol_c_para   ! molar mass of CO2 [kg/mol]
   else
      mol_c = 4.401e-02_dp
   end if

   if ( present(diff_w_c_para) ) then
      diff_w_c = diff_w_c_para   ! diffusion coefficient of water in CO2 [m2/s]
   else
      diff_w_c = 1.4e-03_dp
   end if

   if ( present(visc_c_para) ) then
      visc_c = visc_c_para   ! kinematic viscosity of CO2 [m2/s]
   else
      visc_c = 6.93e-04_dp
   end if

   if ( present(g_para) ) then
      g = g_para   ! gravity acceleration [m/s2]
   else
      g = 3.7_dp
   end if

   end subroutine setevappar_bd

!-------------------------------------------------------------------------------
!> Computation of evaporation.
!-------------------------------------------------------------------------------
   subroutine getevap_bd(temp, temp_amp, p, H, evap)

   implicit none

   real(dp) :: temp(:), temp_amp(:), p(:), H(:), evap(:)

   integer(i4b) :: i, hr, n
   real(dp) :: inv_visc_c_2, one_third, one_eighth
   real(dp) :: delta_eta, rho, &
               delta_rho_rho_1, delta_rho_rho_2, delta_rho_rho, &
               inv_length, inv_gamma_reg, &
               temp_hr, evap_hr
   real(dp) :: sat_pressure
   real(dp), dimension(8) :: cos_factor
   real(dp), parameter :: pi = 3.141592653589793_dp

   n = size(temp)

   inv_visc_c_2  = 1.0_dp/visc_c**2
   inv_gamma_reg = 1.0_dp/gamma_reg
   one_third     = 1.0_dp/3.0_dp
   one_eighth    = 1.0_dp/8.0_dp
   cos_factor    = (/(cos(2.0_dp*pi*one_eighth*real(hr,dp)),hr=1,8)/)

   do i = 1, n

      evap(i) = 0.0_dp

      do hr=1, 8   ! counter for one Martian day (sampled in 3-hour intervals)

         temp_hr       = temp(i) - temp_amp(i)*cos_factor(hr)
         sat_pressure  = p_sat(temp_hr)
         delta_eta     = mol_w*sat_pressure/(mol_c*p(i))
         rho           = mol_c*p(i)/(R_univ*temp_hr)

         delta_rho_rho_1 = (mol_c-mol_w)*sat_pressure
         delta_rho_rho_2 = mol_c*p(i)-(mol_c-mol_w)*sat_pressure

         if (delta_rho_rho_1 <= delta_rho_rho_2) then
                ! physically reasonable case
            delta_rho_rho = delta_rho_rho_1/delta_rho_rho_2
         else   ! physically unreasonable case
            delta_rho_rho = 1.0_dp
         end if

         inv_length    = (delta_rho_rho*g*inv_visc_c_2)**one_third

         evap_hr       = evap_fact * 0.17_dp*delta_eta*rho*diff_w_c*inv_length

         evap(i)       = evap(i) + one_eighth*evap_hr

      end do

      if (H(i) < 0.0_dp) evap(i) = evap(i) * exp(inv_gamma_reg*H(i))

   end do

   end subroutine getevap_bd

!-------------------------------------------------------------------------------
!> Setting of parameters for condensation.
!-------------------------------------------------------------------------------
   subroutine setcondpar(gravity, timescale)

   implicit none

   real(dp), optional :: gravity, timescale

   if ( present(gravity) ) then
      g = gravity
   else
      g = 3.7_dp ! m/s**2
   end if

   if ( present(timescale) ) then
      tau = timescale
   else
      tau = 24.622962_dp*3600.0_dp ! length of Martian day (sol) in seconds
   end if

   end subroutine setcondpar
   
!-------------------------------------------------------------------------------
!> Computation of condensation
!! (removal of water exceeding the saturation pressure at the surface).
!-------------------------------------------------------------------------------
   subroutine getcond_1(temp, water, cond, dtime)

   implicit none

   real(dp) :: temp(:), water(:), cond(:)
   real(dp) :: dtime

   integer(i4b) :: i, n
   real(dp) :: g_inv, dtime_inv
   real(dp) :: water_excess

   g_inv     = 1.0_dp/g
   dtime_inv = 1.0_dp/dtime

   n = size(cond)

   do i = 1, n
      water_excess = water(i) - p_sat(temp(i))*g_inv
      if (water_excess > 0.0_dp) then
         cond(i) = water_excess*dtime_inv
      else
         cond(i) = 0.0_dp
      end if
   end do

   end subroutine getcond_1
   
!-------------------------------------------------------------------------------
!> Computation of condensation (continuous, quadratic dependence on humidity).
!-------------------------------------------------------------------------------
   subroutine getcond_2(temp, water, cond)

   implicit none

   real(dp) :: temp(:), water(:), cond(:)

   integer(i4b) :: i, n

   n = size(cond)

   do i = 1, n
      cond(i) = (g/tau) * water(i)**2 / p_sat(temp(i))
   end do

   end subroutine getcond_2

!-------------------------------------------------------------------------------
!> Computation of the water-vapour saturation pressure.
!-------------------------------------------------------------------------------
   elemental function p_sat(temp_surf) result(psat)

   implicit none

   real(dp), intent(in) :: temp_surf

   real(dp) :: psat

   ! psat = exp( -5504.4088_dp * temp_surf**(-1) &
   !             - 3.5704628_dp &
   !             - 1.7337458e-2_dp * temp_surf &
   !             + 6.5204209e-6_dp * temp_surf**2 &
   !             + 6.1295027_dp * log(temp_surf) )

   psat = 610.66_dp * exp( 21.875_dp*(temp_surf-273.16_dp)/ &
                                     (temp_surf-  7.65_dp) )

   end function p_sat

end module evap_cond_m
!
