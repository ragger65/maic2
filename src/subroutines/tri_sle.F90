!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
!  Subroutine :  t r i _ s l e
!
!> @file
!!
!! Solution of a system of linear equations Ax=b with tridiagonal matrix A.
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
!> Solution of a system of linear equations Ax=b with tridiagonal matrix A.
!! @param[in]  a0       a0(j) is element A_(j,j-1) of matrix A
!! @param[in]  a1       a1(j) is element A_(j,j)   of matrix A
!! @param[in]  a2       a2(j) is element A_(j,j+1) of matrix A
!! @param[in]  b        inhomogeneity vector
!! @param[in]  n_rows   size of matrix A (indices run from 0 (!!!) to n_rows)
!! @param[out] x        solution vector.
!<------------------------------------------------------------------------------
subroutine tri_sle(a0, a1, a2, x, b, n_rows)

use maic2_types

implicit none

integer(i4b), intent(in) :: n_rows
real(dp), dimension(0:*), intent(inout) :: a0, a1, a2, b
real(dp), dimension(0:*), intent(out)   :: x

integer(i4b) :: n
real(dp), allocatable, dimension(:) :: help_x

!--------  Generation of an upper triangular matrix --------

do n=1, n_rows
   a1(n)   = a1(n) - a0(n)/a1(n-1)*a2(n-1)
end do

do n=1, n_rows
   b(n)    = b(n) - a0(n)/a1(n-1)*b(n-1)
!         a0(n)  = 0.0_dp , not needed in the following, therefore
!                           not set
end do

!-------- Iterative solution of the new system --------

!      x(n_rows) = b(n_rows)/a1(n_rows)

!      do n=n_rows-1, 0, -1
!         x(n) = (b(n)-a2(n)*x(n+1))/a1(n)
!      end do

allocate(help_x(0:n_rows))

help_x(0) = b(n_rows)/a1(n_rows)

do n=1, n_rows
   help_x(n) = b(n_rows-n)/a1(n_rows-n) &
              -a2(n_rows-n)/a1(n_rows-n)*help_x(n-1)
end do

do n=0, n_rows
   x(n) = help_x(n_rows-n)
end do

!       (The trick with the help_x was introduced in order to avoid
!        the negative step in the original, blanked-out loop.)

deallocate(help_x)

!  WARNING: Subroutine does not check for elements of the main
!           diagonal becoming zero. In this case it crashes even
!           though the system may be solvable. Otherwise ok.

end subroutine tri_sle
!
