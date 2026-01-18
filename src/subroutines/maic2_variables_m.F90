!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Module :  m a i c 2 _ v a r i a b l e s _ m
!
!! Declarations of global variables for MAIC-2.
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
!> Declarations of global variables for MAIC-2.
!-------------------------------------------------------------------------------
module maic2_variables_m

use maic2_types_m

!-------- Field quantities --------

real(dp), dimension(0:LMAX) :: phi_node
   !! Latitude of grid point

real(dp), dimension(0:LMAX) :: phi_cb1
   !! Latitude of lower cell boundary

real(dp), dimension(0:LMAX) :: phi_cb2
   !! Latitude of upper cell boundary

real(dp), dimension(0:LMAX) :: cos_phi_cb1
   !! Cosine of phi_cb1(l)

real(dp), dimension(0:LMAX) :: cos_phi_cb2
   !! Cosine of phi_cb2(l)

real(dp), dimension(0:LMAX) :: sin_phi_cb1
   !! Sine of phi_cb1(l)

real(dp), dimension(0:LMAX) :: sin_phi_cb2
   !! Sine of phi_cb2(l)

real(dp), dimension(LMAX) :: dphi
   !! Grid spacing

real(dp), dimension(LMAX) :: dphi_inv
   !! Inverse of the grid spacing

real(dp), dimension(0:LMAX) :: temp_surf
   !! Daily mean surface temperature

real(dp), dimension(0:LMAX) :: temp_surf_amp
   !! Amplitude of the daily cycle of the surface temperature

real(dp), dimension(0:LMAX) :: temp_co2
   !! CO2 condensation temperature

real(dp), dimension(0:LMAX) :: p_surf
   !! Surface pressure

real(dp), dimension(0:LMAX) :: water
   !! Water content in the atmosphere

real(dp), dimension(0:LMAX) :: water_new
   !! New value of quantity computed during an integration step

real(dp), dimension(0:LMAX) :: cond
   !! Condensation rate

real(dp), dimension(0:LMAX) :: evap
   !! Evaporation rate

real(dp), dimension(0:LMAX) :: a_net
   !! Net surface mass balance of water ice

real(dp), dimension(0:LMAX) :: H
   !! Ice thickness

real(dp), dimension(0:LMAX) :: H_new
   !! New value of quantity computed during an integration step

!-------- Physical parameters --------

real(dp) :: RHO
   !! Density of ice-dust mixture

real(dp) :: RHO_I
   !! Density of ice

real(dp) :: RHO_W
   !! Density of pure water

real(dp) :: G
   !! Acceleration due to gravity

real(dp) :: R
   !! Radius of Mars

real(dp) :: rho_inv
   !! Inverse of the density of ice-dust mixture

!-------- Further quantities -------- 

integer(i4b) :: insol_time_min
   !! Minimum time of the data values for the insolation etc.

integer(i4b) :: insol_time_stp
   !! Time step of the data values for the insolation etc.

integer(i4b) :: insol_time_max
   !! Maximum time of the data values for the insolation etc.

integer(i4b) :: itercount
   !! Counter for the number of time integration steps

real(dp), dimension(0:100000) :: insol_ma_90
   !! Data for the mean-annual north- or south-polar insolation

real(dp), dimension(0:100000) :: obl_data
   !! Data for the obliquity

real(dp), dimension(0:100000) :: ecc_data
   !! Data for the eccentricity

real(dp), dimension(0:100000) :: ave_data
   !! Data for the anomaly of vernal equinox
   !! (= 360 deg - Ls of perihelion )

real(dp), dimension(0:100000) :: cp_data
   !! Data for Laskar's climate parameter
   !!  = eccentricity
   !!     *sin(Laskar's longitude of perihelion from moving equinox)
   !!       ( where Laskar's longitude of perihelion from moving equinox
   !!         = Ls of perihelion - 180 deg )

real(dp), dimension(0:NTIME) :: ls_tab
   !! Solar longitudes (orbital positions with respect to vernal equinox)
   !! over a Martian year

real(dp), dimension(0:NTIME) :: psi_tab
   !! True anomalies (orbital positions with respect to perihelion)
   !! over a Martian year

real(dp), dimension(0:LMAX) :: diff_aux
   !! Auxiliary quantity needed for the diffusional transport

integer(i4b) :: n_output
   !! Number of specified times for data output

real(dp) :: dtime_out
   !! Time step for data output

real(dp), dimension(100) :: time_output
   !! Specified times for data output

integer(i4b) :: iter_out
   !! Intervall of integration steps for data output

integer(i4b), dimension(100) :: iter_output
   !! Specified integration steps for data output

real(dp), parameter :: pi = 3.141592653589793_dp
   !! Mathematical constant

real(dp), parameter :: pi_inv = 1.0_dp/pi
   !! Inverse of pi

real(dp), parameter :: deg2rad = pi/180.0_dp
   !! pi divided by 180 (-> deg to rad)

real(dp), parameter :: rad2deg = 180.0_dp/pi
   !! 180 divided by pi (-> rad to deg)

real(dp), parameter :: epsil = 1.0e-05_dp
   !! Small number

end module maic2_variables_m
!
