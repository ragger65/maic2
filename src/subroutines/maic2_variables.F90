!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

!  Module     :  m a i c 2 _ v a r i a b l e s

!  Purpose    :  Declarations of global variables.

!! Copyright 2010 Ralf Greve, Bjoern Grieger, Oliver J. Stenzel
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
!! along with MAIC-2.  If not, see <http://www.gnu.org/licenses/>.

!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

module maic2_variables

use maic2_types

!-------- Field quantities --------

real(dp), dimension(0:LMAX) :: phi_node, phi_cb1, phi_cb2, &
                               cos_phi_cb1, cos_phi_cb2, &
                               sin_phi_cb1, sin_phi_cb2
real(dp), dimension(LMAX)   :: dphi, dphi_inv
real(dp), dimension(0:LMAX) :: temp_surf, temp_surf_amp, temp_co2, &
                               p_surf, water, water_new, &
                               cond, evap, a_net
real(dp), dimension(0:LMAX) :: H, H_new

!-------- Physical parameters --------

real(dp) :: RHO, RHO_I, RHO_W, G, R
real(dp) :: rho_inv

!-------- Further quantities -------- 

integer(i4b) :: insol_time_min, insol_time_stp, insol_time_max, itercount
real(dp), dimension(0:100000) :: insol_ma_90, obl_data, ecc_data, &
                                 ave_data, cp_data

real(dp), dimension(0:NTIME) :: psi_tab

real(dp), dimension(0:LMAX) :: diff_aux

integer(i4b) :: n_output
real(dp)     :: dtime_out, time_output(100)
integer(i4b) :: iter_out, iter_output(100)

real(dp), parameter :: &
       pi = 3.141592653589793_dp, pi_inv = 1.0_dp/pi, &
       pi_180 = pi/180.0_dp, pi_180_inv = 180.0_dp/pi, &
       eps = 1.0e-05_dp

end module maic2_variables
