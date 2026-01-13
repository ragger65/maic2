!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Module :  m a i c 2 _ v a r i a b l e s
!
!> @file
!!
!! Declarations of global variables for MAIC-2.
!!
!! @section Copyright
!!
!! Copyright 2010-2013 Ralf Greve, Bjoern Grieger, Oliver J. Stenzel
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
!> Declarations of global variables for MAIC-2.
!<------------------------------------------------------------------------------
module maic2_variables

use maic2_types

!-------- Field quantities --------

!> phi_node(l): Latitude of grid point
real(dp), dimension(0:LMAX) :: phi_node
!> phi_cb1(l): Latitude of lower cell boundary
real(dp), dimension(0:LMAX) :: phi_cb1
!> phi_cb2(l): Latitude of upper cell boundary
real(dp), dimension(0:LMAX) :: phi_cb2
!> cos_phi_cb1(l): Cosine of phi_cb1(l)
real(dp), dimension(0:LMAX) :: cos_phi_cb1
!> cos_phi_cb2(l): Cosine of phi_cb2(l)
real(dp), dimension(0:LMAX) :: cos_phi_cb2
!> sin_phi_cb1(l): Sine of phi_cb1(l)
real(dp), dimension(0:LMAX) :: sin_phi_cb1
!> sin_phi_cb2(l): Sine of phi_cb2(l)
real(dp), dimension(0:LMAX) :: sin_phi_cb2
!> dphi(l): Grid spacing
real(dp), dimension(LMAX)   :: dphi
!> dphi_inv(l): Inverse of the grid spacing
real(dp), dimension(LMAX)   :: dphi_inv
!> temp_surf(l): Daily mean surface temperature
real(dp), dimension(0:LMAX) :: temp_surf
!> temp_surf_amp(l): Amplitude of the daily cycle of the surface temperature
real(dp), dimension(0:LMAX) :: temp_surf_amp
!> temp_co2(l): CO2 condensation temperature
real(dp), dimension(0:LMAX) :: temp_co2
!> p_surf(l): Surface pressure
real(dp), dimension(0:LMAX) :: p_surf
!> water(l): Water content in the atmosphere
real(dp), dimension(0:LMAX) :: water
!> (.)_new: New value of quantity (.) computed during an integration step
real(dp), dimension(0:LMAX) :: water_new
!> cond(l): Condensation rate
real(dp), dimension(0:LMAX) :: cond
!> evap(l): Evaporation rate
real(dp), dimension(0:LMAX) :: evap
!> a_net(l): Net surface mass balance of water ice
real(dp), dimension(0:LMAX) :: a_net
!> H(l): Ice thickness
real(dp), dimension(0:LMAX) :: H
!> (.)_new: New value of quantity (.) computed during an integration step
real(dp), dimension(0:LMAX) :: H_new

!-------- Physical parameters --------

!> RHO: Density of ice-dust mixture
real(dp) :: RHO
!> RHO_I: Density of ice
real(dp) :: RHO_I
!> RHO_W: Density of pure water
real(dp) :: RHO_W
!> G: Acceleration due to gravity
real(dp) :: G
!> R: Radius of Mars
real(dp) :: R
!> rho_inv: Inverse of the density of ice-dust mixture
real(dp) :: rho_inv

!-------- Further quantities -------- 

!> insol_time_min: Minimum time of the data values for the insolation etc.
integer(i4b) :: insol_time_min
!> insol_time_stp: Time step of the data values for the insolation etc.
integer(i4b) :: insol_time_stp
!> insol_time_max: Maximum time of the data values for the insolation etc.
integer(i4b) :: insol_time_max
!> itercount: Counter for the number of time integration steps
integer(i4b) :: itercount

!> insol_ma_90(n): Data for the mean-annual north- or south-polar insolation
real(dp), dimension(0:100000) :: insol_ma_90
!> obl_data(n): Data for the obliquity
real(dp), dimension(0:100000) :: obl_data
!> ecc_data(n): Data for the eccentricity
real(dp), dimension(0:100000) :: ecc_data
!> ave_data(n): Data for the anomaly of vernal equinox
!>              (= 360 deg - Ls of perihelion )
real(dp), dimension(0:100000) :: ave_data
!> cp_data(n): Data for Laskar's climate parameter
!>             = eccentricity
!>               *sin(Laskar's longitude of perihelion from moving equinox),
!>               ( where Laskar's longitude of perihelion from moving equinox
!>                       = Ls of perihelion - 180 deg )
real(dp), dimension(0:100000) :: cp_data

!> ls_tab(n): Solar longitudes (orbital positions with respect to vernal equinox)
!>            over a Martian year
real(dp), dimension(0:NTIME) :: ls_tab
!> psi_tab(n): True anomalies (orbital positions with respect to perihelion)
!>             over a Martian year
real(dp), dimension(0:NTIME) :: psi_tab

!> diff_aux(l): Auxiliary quantity needed for the diffusional transport
real(dp), dimension(0:LMAX) :: diff_aux

!> n_output: Number of specified times for data output
integer(i4b)                 :: n_output
!> dtime_out: Time step for data output
real(dp)                     :: dtime_out
!> time_output(n): Specified times for data output
real(dp), dimension(100)     :: time_output
!> iter_out: Intervall of integration steps for data output
integer(i4b)                 :: iter_out
!> iter_output(n): Specified integration steps for data output
integer(i4b), dimension(100) :: iter_output

!> pi: Mathematical constant
real(dp), parameter :: pi = 3.141592653589793_dp
!> pi_inv: Inverse of pi
real(dp), parameter :: pi_inv = 1.0_dp/pi
!> pi_180: pi divided by 180 (-> deg to rad)
real(dp), parameter :: pi_180 = pi/180.0_dp
!> pi_180_inv: 180 divided by pi (-> rad to deg)
real(dp), parameter :: pi_180_inv = 180.0_dp/pi
!> eps: Small number
real(dp), parameter :: eps = 1.0e-05_dp

end module maic2_variables
!
