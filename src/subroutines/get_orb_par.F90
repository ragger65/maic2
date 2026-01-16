!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Subroutine :  g e t _ o r b _ p a r
!
!! Determination of the orbital parameters
!! (eccentricity, obliquity, climate parameter CP, anomaly of vernal equinox,
!! mean-annual north- or south-polar insolation).
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
!> Determination of the orbital parameters
!! (eccentricity, obliquity, climate parameter CP, anomaly of vernal equinox,
!! mean-annual north- or south-polar insolation).
!-------------------------------------------------------------------------------
subroutine get_orb_par(time, ecc, obl, cp, ave, insol_ma_90NS)

use maic2_types_m
use maic2_variables_m

implicit none

real(dp), intent(in)  :: time
real(dp), intent(out) :: ecc, obl, cp, ave, insol_ma_90NS

integer(i4b) :: ndata_insol
integer(i4b) :: i_kl, i_gr
real(dp) :: time_kl, time_gr, ave_data_i_kl, ave_data_i_gr

ndata_insol = (insol_time_max-insol_time_min)/insol_time_stp

if (time/YEAR_SEC < real(insol_time_min,dp)) then

   ecc           = ecc_data(0)
   obl           = obl_data(0)
   cp            = cp_data(0)
   ave           = ave_data(0)
   insol_ma_90NS = insol_ma_90(0)

else if (time/YEAR_SEC < real(insol_time_max,dp)) then

   i_kl = floor( ((time/YEAR_SEC)-real(insol_time_min,dp)) &
                 /real(insol_time_stp,dp) )
   i_kl = max(i_kl, 0)

   i_gr = ceiling( ((time/YEAR_SEC)-real(insol_time_min,dp)) &
                   /real(insol_time_stp,dp) )
   i_gr = min(i_gr, ndata_insol)

   if (i_kl == i_gr) then

      ecc           = ecc_data(i_kl)
      obl           = obl_data(i_kl)
      cp            = cp_data(i_kl)
      ave           = ave_data(i_kl)
      insol_ma_90NS = insol_ma_90(i_kl)

   else

      time_kl = (insol_time_min + i_kl*insol_time_stp) *YEAR_SEC
      time_gr = (insol_time_min + i_gr*insol_time_stp) *YEAR_SEC

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
!
