!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Module :  m a i c 2 _ m a t h s _ m
!
!! Several mathematical tools used by MAIC-2.
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
!> Several mathematical tools used by MAIC-2.
!-------------------------------------------------------------------------------
module maic2_maths_m

  use maic2_types_m

  implicit none

contains

!-------------------------------------------------------------------------------
!> Solution of a system of linear equations Ax=b with tridiagonal matrix A.
!-------------------------------------------------------------------------------
  subroutine tri_sle(a0, a1, a2, x, b, nrows)

  implicit none

  integer(i4b),                 intent(in)  :: nrows
  real(dp), dimension(0:nrows), intent(in)  :: a0, a1, a2, b
  real(dp), dimension(0:nrows), intent(out) :: x

     ! a0: a0(j) is element A_(j,j-1) of matrix A
     ! a1: a1(j) is element A_(j,j)   of matrix A
     ! a2: a2(j) is element A_(j,j+1) of matrix A
     ! b: inhomogeneity vector
     ! nrows: size of matrix A (indices run from 0 (!) to nrows)
     ! x: solution vector

  integer(i4b) :: n
  real(dp), dimension(0:nrows) :: a0_aux, a1_aux, a2_aux, b_aux, x_aux

!--------  Define local variables --------

  a0_aux = a0
  a1_aux = a1
  a2_aux = a2
  b_aux  = b
  x_aux  = 0.0_dp   ! initialization

!--------  Generate an upper triangular matrix --------

  do n=1, nrows
     a1_aux(n) = a1_aux(n) - a0_aux(n)/a1_aux(n-1)*a2_aux(n-1)
  end do

  do n=1, nrows
     b_aux(n) = b_aux(n) - a0_aux(n)/a1_aux(n-1)*b_aux(n-1)
     ! a0_aux(n) = 0.0_dp , not needed in the following, therefore not set
  end do

!-------- Iterative solution of the new system --------

  x_aux(0) = b_aux(nrows)/a1_aux(nrows)

  do n=1, nrows
     x_aux(n) = b_aux(nrows-n)/a1_aux(nrows-n) &
                -a2_aux(nrows-n)/a1_aux(nrows-n)*x_aux(n-1)
  end do

  do n=0, nrows
     x(n) = x_aux(nrows-n)
  end do

  !  WARNING: Subroutine does not check for elements of the main
  !           diagonal becoming zero. In this case it crashes even
  !           though the system may be solvable. Otherwise ok.

  end subroutine tri_sle

!-------------------------------------------------------------------------------

end module maic2_maths_m
!
