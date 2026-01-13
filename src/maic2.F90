!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

!  Program   :  m a i c 2

!  Purpose   :  Mars Atmosphere-Ice Coupler MAIC-2;
!               application to a static, zonally averaged
!               (only latitude-dependent) ice cap.

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

!-------- Inclusion of specification header --------

#include "maic2_specs.h"

!-------- Inclusion of kind-type and global-variable modules --------

#include "subroutines/maic2_types.F90"
#include "subroutines/maic2_variables.F90"

!-------- Inclusion of further modules --------

#include "subroutines/instemp.f90"
#include "subroutines/evaporation.f90"
#include "subroutines/condensation.f90"

!-------- Begin of main program --------

program maic2

!-------- Modules, variables --------

use maic2_types
use maic2_variables

implicit none
integer(i4b) :: l, n
integer(i4b) :: ios
integer(i4b) :: itercount_max
integer(i4b) :: ndata_insol
real(dp) :: time, time_init, time_end, dtime
real(dp) :: dphi_equi
real(dp) :: d_dummy
character (len=100) :: runname
character :: ch_dummy
logical :: output_flag

!-------- Initializations --------

!  ------ Setting of physical parameters

  RHO_I       = 9.1e+02_dp
!       Density of ice = 910 kg/m3 
!
  RHO_W       = 1.0e+03_dp
!       Density of pure water = 1000 kg/m3
!
  G           = 3.72_dp
!       Gravity acceleration = 3.72 m/s2 
!
  R           = 3.396e+06_dp
!       Radius of Mars = 3396 km

!  ------ Density of ice-dust mixture

RHO = RHO_I   ! so far no dust considered

rho_inv = 1.0_dp/RHO

!  ------ Specification of current simulation

runname = RUNNAME

!  ------ Conversion of time quantities

time_init  = TIME_INIT0*YEAR_SEC    ! a --> s
time_end   = TIME_END0*YEAR_SEC     ! a --> s
dtime      = DTIME0*YEAR_SEC        ! a --> s

#if OUTPUT==1
dtime_out = DTIME_OUT0 * YEAR_SEC    ! a --> s
#elif OUTPUT==2
n_output         = N_OUTPUT
time_output( 1) = TIME_OUT0_01 * YEAR_SEC    ! a --> s
time_output( 2) = TIME_OUT0_02 * YEAR_SEC    ! a --> s
time_output( 3) = TIME_OUT0_03 * YEAR_SEC    ! a --> s
time_output( 4) = TIME_OUT0_04 * YEAR_SEC    ! a --> s
time_output( 5) = TIME_OUT0_05 * YEAR_SEC    ! a --> s
time_output( 6) = TIME_OUT0_06 * YEAR_SEC    ! a --> s
time_output( 7) = TIME_OUT0_07 * YEAR_SEC    ! a --> s
time_output( 8) = TIME_OUT0_08 * YEAR_SEC    ! a --> s
time_output( 9) = TIME_OUT0_09 * YEAR_SEC    ! a --> s
time_output(10) = TIME_OUT0_10 * YEAR_SEC    ! a --> s
time_output(11) = TIME_OUT0_11 * YEAR_SEC    ! a --> s
time_output(12) = TIME_OUT0_12 * YEAR_SEC    ! a --> s
time_output(13) = TIME_OUT0_13 * YEAR_SEC    ! a --> s
time_output(14) = TIME_OUT0_14 * YEAR_SEC    ! a --> s
time_output(15) = TIME_OUT0_15 * YEAR_SEC    ! a --> s
time_output(16) = TIME_OUT0_16 * YEAR_SEC    ! a --> s
time_output(17) = TIME_OUT0_17 * YEAR_SEC    ! a --> s
time_output(18) = TIME_OUT0_18 * YEAR_SEC    ! a --> s
time_output(19) = TIME_OUT0_19 * YEAR_SEC    ! a --> s
time_output(20) = TIME_OUT0_20 * YEAR_SEC    ! a --> s
#endif

!  ------ Reading of data for orbital parameters

insol_ma_90 = 0.0_dp   ! Assignment of dummy values
obl_data    = 0.0_dp
ecc_data    = 0.0_dp
ave_data    = 0.0_dp
cp_data     = 0.0_dp

open(21, iostat=ios, &
     file=INPATH//'/'//INSOL_MA_90N_FILE, &
     status='old')
if (ios /= 0) stop ' Error when opening the data file for orbital parameters!'

read(21,*) ch_dummy, insol_time_min, insol_time_stp, insol_time_max

if (ch_dummy /= '#') then
   write(6,*) 'insol_time_min, insol_time_stp, insol_time_max not defined in'
   write(6,*) 'data file!'
end if

ndata_insol = (insol_time_max-insol_time_min)/insol_time_stp

if (ndata_insol > 100000) &
   stop 'Too many data in orbital-parameter-data file!'

do n=0, ndata_insol
   read(21,*) d_dummy, ecc_data(n), obl_data(n), cp_data(n), ave_data(n), insol_ma_90(n)
   obl_data(n) = obl_data(n) *pi_180   ! deg -> rad
   ave_data(n) = ave_data(n) *pi_180   ! deg -> rad
end do

close(21, status='keep')

!  ------ Numerical grid

!    ---- Nodes (grid points)

dphi_equi = 180.0_dp/LMAX *pi_180   ! deg -> rad

do l=0, LMAX
   phi_node(l) = -90.0_dp*pi_180 + dble(l)*dphi_equi
                 ! Grid points laid out between -90 deg (90S, south pole)
                 ! and +90 deg (90N, north pole).
                 ! So far only equidistant grid points implemented.
end do

!    ---- Spacing

do l=1, LMAX
   dphi(l)     = phi_node(l) - phi_node(l-1)
   dphi_inv(l) = 1.0_dp/dphi(l)
end do

!    ---- Lower cell boundaries

phi_cb1(0) = phi_node(0)
do l=1, LMAX
   phi_cb1(l) = 0.5_dp*(phi_node(l-1)+phi_node(l))
end do

cos_phi_cb1 = cos(phi_cb1)
sin_phi_cb1 = sin(phi_cb1)

!    ---- Upper cell boundaries

do l=0, LMAX-1
   phi_cb2(l) = 0.5_dp*(phi_node(l)+phi_node(l+1))
end do
phi_cb2(LMAX) = phi_node(LMAX)

cos_phi_cb2 = cos(phi_cb2)
sin_phi_cb2 = sin(phi_cb2)

!    ---- Auxiliary quantity needed for the diffusional transport

do l=0, LMAX
   diff_aux(l) = DIFF_WATER_MAIC/(R**2*(sin_phi_cb2(l)-sin_phi_cb1(l)))
end do

!  ------ Definition of initial values

#if H_INIT==1

H = THICK_INIT

#elif H_INIT==2

do l=0, LMAX
   H(l) = 3000.0_dp &
          * ( 1.0_dp-(90.0_dp*pi_180-abs(phi_node(l)))**2/(10.0_dp*pi_180)**2 )
   H(l) = max(H(l), -0.1_dp)
end do

#endif

water = WATER_INIT

!  ------ Output file

#if OUTPUT==1
iter_out  = nint(dtime_out/dtime)
#elif OUTPUT==2
do n=1, n_output
   iter_output(n) = nint((time_output(n)-time_init)/dtime)
end do
#endif

open(12, iostat=ios, &
     file=OUTPATH//'/'//trim(runname)//'.out', &
     status='replace')
if (ios /= 0) stop ' Error when opening the output file runname.out!'

!-------- Main loop --------

!  ------ Begin of main loop

write(6,*) ' '

itercount=1; write(6,'(i10)') itercount

itercount_max = nint((time_end-time_init)/dtime)

main_loop : do itercount=1, itercount_max

   if ( mod(itercount, 1000) == 0 ) &
      write(6,'(i10)') itercount

!  ------ Update of time

   time = time_init + real(itercount,dp)*dtime

!  ------ Boundary conditions

   call boundary_maic2(time, dtime)

!  ------ Topography

   call calc_top_maic2(time, dtime)

   H = H_new   ! new values -> old values

!  ------ Data output

output_flag = .false.

#if OUTPUT == 1

if ( mod(itercount, iter_out) == 0 ) output_flag = .true.

#elif OUTPUT == 2

do n=1, n_output
   if (itercount == iter_output(n)) output_flag = .true.
end do

#endif

if ( output_flag ) call output(time)

end do main_loop   ! End of main loop

!-------- End of main program --------

close(12, status='keep')

write(6,'(a)') ' '
write(6,'(a)') ' '
write(6,'(a)') &
'             * * * maic2.F90  r e a d y * * *'
write(6,'(a)') ' '
write(6,'(a)') ' '

end program maic2

!-------- Inclusion of subroutines --------

#include "subroutines/boundary_maic2.F90"
#include "subroutines/get_orb_par.F90"
#include "subroutines/get_psi_tab.F90"
#include "subroutines/p_sat.f90"
#include "subroutines/diff_trans.F90"
#include "subroutines/tri_sle.F90"
#include "subroutines/calc_top_maic2.F90"
#include "subroutines/output.F90"

!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!                       End of maic2.F90
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
