!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Program :  m a i c 2
!
#define DATE '2026-01-23'
!
!! Main program of MAIC-2.
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

!-------- Inclusion of run-specification header --------

#include RUN_SPECS_HEADER

!-------- Inclusion of modules --------

#include "subroutines/maic2_types_m.f90"
#include "subroutines/maic2_variables_m.F90"
#include "subroutines/maic2_maths_m.f90"

#include "subroutines/instemp_m.f90"
#include "subroutines/evap_cond_m.f90"

#include "subroutines/boundary_maic2_m.F90"
#include "subroutines/calc_top_maic2_m.F90"
#include "subroutines/output_m.F90"

!-------------------------------------------------------------------------------
!> Main program of MAIC-2.
!-------------------------------------------------------------------------------
program maic2

!-------- Modules, variables --------

use maic2_types_m
use maic2_variables_m

use boundary_maic2_m
use calc_top_maic2_m
use output_m

implicit none
integer(i4b) :: l, n
integer(i4b) :: n1, n2
integer(i4b) :: ios, istat
integer(i4b) :: itercount_max
integer(i4b) :: ndata_orb_par
real(dp) :: time, time_init, time_end, dtime
real(dp) :: ls, psi
real(dp) :: dphi_equi
real(dp) :: d_dummy
character(len=256) :: run_name, file_name
character(len=256) :: shell_command
character(len=256) :: ch_revision
character(len=256) :: ch_line, ch_text
character :: ch_dummy
logical :: output_flag

character(len=64), parameter :: fmt1 = '(a)', &
                                fmt2 = '(a,i0)', &
                                fmt3 = '(a,es13.5)'

!-------- Setting of physical parameters --------

year2sec = real(YEAR_SEC,dp)
sec2year = 1.0_dp/year2sec

#if (defined(PARAM_RHO_I))
RHO_I = real(PARAM_RHO_I,dp)
#else
ch_text = ' >>> PARAM_RHO_I not defined in run-specs header'
write(6, fmt=trim(fmt1)) trim(ch_text)
ch_text = '      -> default value for RHO_I used!'
write(6, fmt=trim(fmt1)) trim(ch_text)
RHO_I = 9.1e+02_dp   ! Density of ice = 910 kg/m3
#endif

#if (defined(PARAM_RHO_W))
RHO_W = real(PARAM_RHO_W,dp)
#else
ch_text = ' >>> PARAM_RHO_W not defined in run-specs header'
write(6, fmt=trim(fmt1)) trim(ch_text)
ch_text = '      -> default value for RHO_W used!'
write(6, fmt=trim(fmt1)) trim(ch_text)
RHO_W = 1.0e+03_dp   ! Density of pure water = 1000 kg/m3
#endif

#if (defined(PARAM_G))
G = real(PARAM_G,dp)
#else
ch_text = ' >>> PARAM_G not defined in run-specs header'
write(6, fmt=trim(fmt1)) trim(ch_text)
ch_text = '      -> default value for G used!'
write(6, fmt=trim(fmt1)) trim(ch_text)
G = 3.72_dp   ! Acceleration due to gravity = 3.72 m/s2
#endif

#if (defined(PARAM_R))
R = real(PARAM_R,dp)
#else
ch_text = ' >>> PARAM_R not defined in run-specs header'
write(6, fmt=trim(fmt1)) trim(ch_text)
ch_text = '      -> default value for R used!'
write(6, fmt=trim(fmt1)) trim(ch_text)
R = 3.396e+06_dp   ! Radius of Mars = 3396000 m
#endif

RHO = RHO_I   ! Density of ice-dust mixture
              ! (so far, no dust considered)

rho_inv = 1.0_dp/RHO

!-------- Name of current simulation --------

n1 = len('maic2_specs_')+1
n2 = len(trim(RUN_SPECS_HEADER))-len('.h')
run_name = trim(RUN_SPECS_HEADER)
run_name = run_name(n1:n2)

!-------- Write log file --------

shell_command = 'if [ ! -d'
shell_command = trim(shell_command)//' '//OUT_PATH
shell_command = trim(shell_command)//' '//'] ; then mkdir'
shell_command = trim(shell_command)//' '//OUT_PATH
shell_command = trim(shell_command)//' '//'; fi'
call execute_command_line(trim(shell_command))
     ! Check whether directory OUT_PATH exists. If not, it is created.

file_name = trim(run_name)//'.log'

open(10, iostat=ios, &
     file=trim(OUT_PATH)//'/'//trim(file_name), &
     status='new')

if (ios /= 0) stop ' Error when opening the log file!'

write(10, fmt=trim(fmt3)) 'RHO_I =', RHO_I
write(10, fmt=trim(fmt3)) 'RHO_W =', RHO_W
write(10, fmt=trim(fmt3)) 'G     =', G
write(10, fmt=trim(fmt3)) 'R     =', R
write(10, fmt=trim(fmt3)) 'RHO   =', RHO

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt2)) 'LMAX = ', LMAX

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt3)) 'YEAR_SEC  =', YEAR_SEC
write(10, fmt=trim(fmt3)) 'MARS_YEAR =', MARS_YEAR
write(10, fmt=trim(fmt3)) 'MARS_DAY  =', MARS_DAY

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt3)) 'TIME_INIT0 =', TIME_INIT0
write(10, fmt=trim(fmt3)) 'TIME_END0  =', TIME_END0

write(10, fmt=trim(fmt1)) ' '
write(10, fmt=trim(fmt3)) 'DTIME0 =', DTIME0

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt2)) 'NTIME = ', NTIME

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt1)) 'ORBITAL_PARAMETER_FILE = ' &
                          // trim(ORBITAL_PARAMETER_FILE)

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt3)) 'ALBEDO     =', ALBEDO
write(10, fmt=trim(fmt3)) 'ALBEDO_CO2 =', ALBEDO_CO2

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt3)) 'TEMP_SURF_AMP_EQ  =', TEMP_SURF_AMP_EQ
write(10, fmt=trim(fmt3)) 'TEMP_SURF_AMP_EXP =', TEMP_SURF_AMP_EXP

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt2)) 'H_INIT = ', H_INIT
#if (H_INIT==1)
write(10, fmt=trim(fmt3)) 'THICK_INIT =', THICK_INIT
#endif
write(10, fmt=trim(fmt3)) 'WATER_INIT =', WATER_INIT

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt3)) 'P_SURF =', P_SURF

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt3)) 'EVAP_FACT =', EVAP_FACT
write(10, fmt=trim(fmt3)) 'GAMMA_REG =', GAMMA_REG

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt2)) 'COND = ', COND
#if (COND==2)
write(10, fmt=trim(fmt3)) 'TAU_COND =', TAU_COND
#endif

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt2)) 'SOLV_DIFF = ', SOLV_DIFF
#if (SOLV_DIFF<3)
write(10, fmt=trim(fmt3)) 'DIFF_WATER_MAIC =', DIFF_WATER_MAIC
#elif (SOLV_DIFF==3)
#if (defined(RATIO_WATER_NP_SP))
write(10, fmt=trim(fmt3)) 'RATIO_WATER_NP_SP =', RATIO_WATER_NP_SP
#endif
#endif

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt2)) 'OUTPUT = ', OUTPUT

#if (OUTPUT==1)

write(10, fmt=trim(fmt3)) 'DTIME_OUT0 =', DTIME_OUT0

#elif (OUTPUT==2)

write(10, fmt=trim(fmt2)) 'N_OUTPUT = ', N_OUTPUT

n_output = N_OUTPUT

time_output( 1) = TIME_OUT0_01
time_output( 2) = TIME_OUT0_02
time_output( 3) = TIME_OUT0_03
time_output( 4) = TIME_OUT0_04
time_output( 5) = TIME_OUT0_05
time_output( 6) = TIME_OUT0_06
time_output( 7) = TIME_OUT0_07
time_output( 8) = TIME_OUT0_08
time_output( 9) = TIME_OUT0_09
time_output(10) = TIME_OUT0_10
time_output(11) = TIME_OUT0_11
time_output(12) = TIME_OUT0_12
time_output(13) = TIME_OUT0_13
time_output(14) = TIME_OUT0_14
time_output(15) = TIME_OUT0_15
time_output(16) = TIME_OUT0_16
time_output(17) = TIME_OUT0_17
time_output(18) = TIME_OUT0_18
time_output(19) = TIME_OUT0_19
time_output(20) = TIME_OUT0_20

do n=1, n_output
   if (n==1) then
      write(10, fmt=trim(fmt3)) 'TIME_OUTPUT =' , time_output(n)
   else
      write(10, fmt=trim(fmt3)) '             ' , time_output(n)
   end if
end do

#endif

write(10, fmt=trim(fmt1)) ' '

write(10, fmt=trim(fmt1)) 'Program date: ' // trim(DATE)
call get_environment_variable(name='REPO_REVISION', value=ch_revision, &
                              status=istat, trim_name=.true.)
write(10, fmt=trim(fmt1)) 'Git revision identifier : ' // trim(ch_revision)

close(10, status='keep')

!-------- Conversion of time quantities --------

time_init = TIME_INIT0 * year2sec   ! a -> s
time_end  = TIME_END0  * year2sec   ! a -> s
dtime     = DTIME0     * year2sec   ! a -> s

#if (OUTPUT==1)

dtime_out = DTIME_OUT0 * year2sec    ! a -> s

#elif (OUTPUT==2)
do n=1, n_output
   time_output(n) = time_output(n) * year2sec    ! a -> s
end do

#endif

!-------- Reading of data for orbital parameters --------

insol_ma_90 = 0.0_dp   ! Assignment of dummy values
obl_data    = 0.0_dp
ecc_data    = 0.0_dp
ave_data    = 0.0_dp
cp_data     = 0.0_dp

open(21, iostat=ios, &
     file=trim(IN_PATH)//'/'//trim(ORBITAL_PARAMETER_FILE), &
     status='old')
if (ios /= 0) stop ' Error when opening the data file for orbital parameters!'

read(21,*) ch_dummy, orb_par_time_min, orb_par_time_stp, orb_par_time_max

if (ch_dummy /= '#') then
   ch_text = ' >>> orb_par_time_min, orb_par_time_stp, orb_par_time_max'
   write(6, fmt=trim(fmt1)) trim(ch_text)
   ch_text = '     not defined in data file!'
   write(6, fmt=trim(fmt1)) trim(ch_text)
end if

ndata_orb_par = (orb_par_time_max-orb_par_time_min)/orb_par_time_stp

if (ndata_orb_par > 100000) &
   stop 'Too many data in orbital-parameter-data file!'

do n=0, ndata_orb_par
   read(21,*) d_dummy, ecc_data(n), obl_data(n), &
              cp_data(n), ave_data(n), insol_ma_90(n)
   obl_data(n) = obl_data(n) *deg2rad   ! deg -> rad
   ave_data(n) = ave_data(n) *deg2rad   ! deg -> rad
end do

close(21, status='keep')

!-------- Numerical grid --------

!  ------ Nodes (grid points)

dphi_equi = (180.0_dp/LMAX) *deg2rad   ! deg -> rad

do l=0, LMAX
   phi_node(l) = -90.0_dp*deg2rad + dble(l)*dphi_equi
                 ! Grid points laid out between -90 deg (90S, south pole)
                 ! and +90 deg (90N, north pole).
                 ! So far only equidistant grid points implemented.
end do

!  ------ Spacing

do l=1, LMAX
   dphi(l)     = phi_node(l) - phi_node(l-1)
   dphi_inv(l) = 1.0_dp/dphi(l)
end do

!  ------ Lower cell boundaries

phi_cb1(0) = phi_node(0)
do l=1, LMAX
   phi_cb1(l) = 0.5_dp*(phi_node(l-1)+phi_node(l))
end do

cos_phi_cb1 = cos(phi_cb1)
sin_phi_cb1 = sin(phi_cb1)

!  ------ Upper cell boundaries

do l=0, LMAX-1
   phi_cb2(l) = 0.5_dp*(phi_node(l)+phi_node(l+1))
end do
phi_cb2(LMAX) = phi_node(LMAX)

cos_phi_cb2 = cos(phi_cb2)
sin_phi_cb2 = sin(phi_cb2)

!  ------ Auxiliary quantity needed for the diffusional transport

do l=0, LMAX
   diff_aux(l) = DIFF_WATER_MAIC/(R**2*(sin_phi_cb2(l)-sin_phi_cb1(l)))
end do

!-------- Definition of initial values --------

#if (H_INIT==1)

H = THICK_INIT

#elif (H_INIT==2)

do l=0, LMAX
   H(l) = 3000.0_dp &
          * ( 1.0_dp-(90.0_dp*deg2rad-abs(phi_node(l)))**2/(10.0_dp*deg2rad)**2 )
   H(l) = max(H(l), -0.1_dp)
end do

#endif

water = WATER_INIT

!-------- Output files --------

#if (OUTPUT==1)
iter_out  = nint(dtime_out/dtime)
#elif (OUTPUT==2)
do n=1, n_output
   iter_output(n) = nint((time_output(n)-time_init)/dtime)
end do
#endif

!  ------ File #1 (only time-dependent variables)

file_name = trim(run_name)//'_out1.asc'

open(12, iostat=ios, &
     file=trim(OUT_PATH)//'/'//trim(file_name), status='new')
if (ios /= 0) stop ' Error when opening the output file '//trim(file_name)

ch_line = '--------------------------------------' &
       // '-----------------------------------------'

write(12, fmt=trim(fmt1)) trim(ch_line)

ch_text = 'Column 1: Time t [a]'
write(12, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 2: Solar longitude L_s [deg]'
write(12, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 3: Ice thickness at the north pole H_NP [m]'
write(12, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 4: Ice thickness at the south pole H_SP [m]'
write(12, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 5: Volume of the north-polar layered deposits (>= 75 degN)'
write(12, fmt=trim(fmt1)) trim(ch_text)
ch_text = '          V_NPLD [m3]'
write(12, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 6: Volume of the south-polar layered deposits (>= 75 degS)'
write(12, fmt=trim(fmt1)) trim(ch_text)
ch_text = '          V_SPLD [m3]'
write(12, fmt=trim(fmt1)) trim(ch_text)

write(12, fmt=trim(fmt1)) trim(ch_line)

ch_text = '  t               L_s' &
       // '      H_NP          H_SP          V_NPLD        V_SPLD'
write(12, fmt=trim(fmt1)) trim(ch_text)

write(12, fmt=trim(fmt1)) trim(ch_line)

!  ------ File #2 (time- and latitude-dependent variables)

file_name = trim(run_name)//'_out2.asc'

open(13, iostat=ios, &
     file=trim(OUT_PATH)//'/'//trim(file_name), status='new')
if (ios /= 0) stop ' Error when opening the output file '//trim(file_name)

ch_line = '-------------------------------------------------' &
       // '----------------------------------------------------'

write(13, fmt=trim(fmt1)) trim(ch_line)

ch_text = 'Column 1: Time t [a]'
write(13, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 2: Latitude phi [deg]'
write(13, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 3: Surface temperature T(phi, t) [K]'
write(13, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 4: Evaporation rate E(phi, t) [kg m-2 a-1]'
write(13, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 5: Condensation rate C(phi, t) [kg m-2 a-1]'
write(13, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 6: Water content omega(phi, t) [kg m-2]'
write(13, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 7: Net mass balance a_net(phi, t) [mm a-1 ice equivalent]'
write(13, fmt=trim(fmt1)) trim(ch_text)

ch_text = 'Column 8: Ice thickness H(phi, t) [m]'
write(13, fmt=trim(fmt1)) trim(ch_text)

write(13, fmt=trim(fmt1)) trim(ch_line)

ch_text = '  t              phi     T       ' &
       // '  E             C             omega         a_net         H'
write(13, fmt=trim(fmt1)) trim(ch_text)

write(13, fmt=trim(fmt1)) trim(ch_line)

!-------- Main loop --------

!  ------ Begin of main loop

write(6, fmt=trim(fmt1)) ' '

itercount=1; write(6,'(i10)') itercount

itercount_max = nint((time_end-time_init)/dtime)

main_loop : do itercount=1, itercount_max

   if ( mod(itercount, 1000) == 0 ) &
      write(6,'(i10)') itercount

!  ------ Update of time

   time = time_init + real(itercount,dp)*dtime

!  ------ Boundary conditions

   call boundary_maic2(time, ls, psi, dtime)

!  ------ Topography

   call calc_top_maic2(time, dtime)

   H = H_new   ! new values -> old values

!  ------ Data output

output_flag = .false.

#if (OUTPUT==1)

if ( mod(itercount, iter_out) == 0 ) output_flag = .true.

#elif (OUTPUT==2)

do n=1, n_output
   if (itercount == iter_output(n)) output_flag = .true.
end do

#endif

if ( output_flag ) call output(time, ls)

end do main_loop   ! End of main loop

!-------- End of main program --------

close(12, status='keep')
close(13, status='keep')

write(6, fmt=trim(fmt1)) ' '
write(6, fmt=trim(fmt1)) ' '
ch_text = '             * * * maic2.F90  r e a d y * * *'
write(6, fmt=trim(fmt1)) trim(ch_text)
write(6, fmt=trim(fmt1)) ' '
write(6, fmt=trim(fmt1)) ' '

end program maic2

!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!                          End of maic2.F90
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
