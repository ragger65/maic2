!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Module :  m a i c 2 _ t y p e s
!
!> @file
!!
!! Declarations of kind types for MAIC-2.
!!
!! @section Copyright
!!
!! Copyright 2010, 2011 Ralf Greve, Bjoern Grieger, Oliver J. Stenzel
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
!> Declarations of kind types for MAIC-2.
!<------------------------------------------------------------------------------
module maic2_types

integer, parameter :: i2b = selected_int_kind(4)   !< 2-byte integers
integer, parameter :: i4b = selected_int_kind(9)   !< 4-byte integers
integer, parameter :: sp  = kind(1.0)              !< single-precision reals
integer, parameter :: dp  = kind(1.0d0)            !< double-precision reals

end module maic2_types
!
