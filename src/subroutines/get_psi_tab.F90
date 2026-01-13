!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Subroutine :  g e t _ p s i _ t a b
!
!! Computation of the table of true anomalies (orbital positions
!! with respect to perihelion) over a Martian year.
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
!> Computation of the table of true anomalies (orbital positions
!! with respect to perihelion) over a Martian year.
!-------------------------------------------------------------------------------
subroutine get_psi_tab(ecc, ave)

use maic2_types
use maic2_variables

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
!
