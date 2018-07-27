! *********************************COPYRIGHT************************************
! (C) Crown copyright Met Office. All rights reserved.
! For further details please refer to the file LICENCE.txt
! which you should have received as part of this distribution.
! *********************************COPYRIGHT************************************
!
! This file is part of the UM Shared Library project.
!
! The UM Shared Library is free software: you can redistribute it
! and/or modify it under the terms of the Modified BSD License, as
! published by the Open Source Initiative.
!
! The UM Shared Library is distributed in the hope that it will be
! useful, but WITHOUT ANY WARRANTY; without even the implied warranty
! of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! Modified BSD License for more details.
!
! You should have received a copy of the Modified BSD License
! along with the UM Shared Library.
! If not, see <http://opensource.org/licenses/BSD-3-Clause>.
!*******************************************************************************
MODULE fruit_test_shum_thread_utils_mod

USE fruit
USE, INTRINSIC :: ISO_C_BINDING, ONLY: C_INT64_T, C_INT32_T, C_FLOAT,          &
                                       C_DOUBLE, C_BOOL
!$ USE omp_lib

IMPLICIT NONE
PRIVATE

PUBLIC :: fruit_test_shum_thread_utils

!------------------------------------------------------------------------------!
! We're going to use the types from the ISO_C_BINDING module, since although   !
! the REALs aren't 100% guaranteed to correspond to the sizes we want to       !
! enforce, they should be good enough on the majority of systems.              !
!                                                                              !
! Additional protection for the case that FLOAT/DOUBLE do not conform to the   !
! sizes we expect is provided via the "precision_bomb" macro-file              !
!------------------------------------------------------------------------------!
  INTEGER, PARAMETER :: int64  = C_INT64_T
  INTEGER, PARAMETER :: int32  = C_INT32_T
  INTEGER, PARAMETER :: real64 = C_DOUBLE
  INTEGER, PARAMETER :: real32 = C_FLOAT
!------------------------------------------------------------------------------!

INTERFACE

!-------------!

  SUBROUTINE c_test_returns_valid_lock(test_ret)                               &
             BIND(c, name="c_test_returns_valid_lock")

    IMPORT :: C_BOOL

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret

  END SUBROUTINE c_test_returns_valid_lock

!-------------!

  SUBROUTINE c_test_invalid_lock_release(test_ret)                             &
             BIND(c, name="c_test_invalid_lock_release")

    IMPORT :: C_BOOL

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret

  END SUBROUTINE c_test_invalid_lock_release

!-------------!

  SUBROUTINE c_test_create_and_release_lock(test_ret)                          &
             BIND(c, name="c_test_create_and_release_lock")

    IMPORT :: C_BOOL

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret

  END SUBROUTINE c_test_create_and_release_lock

!-------------!

  SUBROUTINE c_test_create_many_locks(test_ret)                                &
             BIND(c, name="c_test_create_many_locks")

    IMPORT :: C_BOOL

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret

  END SUBROUTINE c_test_create_many_locks

!-------------!

  SUBROUTINE c_test_backfill_locks(test_ret)                                   &
             BIND(c, name="c_test_backfill_locks")

    IMPORT :: C_BOOL

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret

  END SUBROUTINE c_test_backfill_locks

!-------------!

  SUBROUTINE c_test_sweep_release_locks(test_ret)                              &
             BIND(c, name="c_test_sweep_release_locks")

    IMPORT :: C_BOOL

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret

  END SUBROUTINE c_test_sweep_release_locks

!-------------!

  SUBROUTINE c_test_inpar(test_ret,par)                                        &
             BIND(c, name="c_test_inpar")

    IMPORT :: C_BOOL, C_INT64_T

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret
    INTEGER(KIND=C_INT64_T) :: par

  END SUBROUTINE c_test_inpar

!-------------!

  SUBROUTINE c_test_threadid(test_ret,tid)                                     &
             BIND(c, name="c_test_threadid")

    IMPORT :: C_BOOL, C_INT64_T

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret
    INTEGER(KIND=C_INT64_T) :: tid

  END SUBROUTINE c_test_threadid

!-------------!

  SUBROUTINE c_test_numthreads(test_ret,numthreads)                            &
             BIND(c, name="c_test_numthreads")

    IMPORT :: C_BOOL, C_INT64_T

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret
    INTEGER(KIND=C_INT64_T) :: numthreads

  END SUBROUTINE c_test_numthreads

!-------------!

  SUBROUTINE c_test_threadflush(test_ret,shared1)                              &
             BIND(c, name="c_test_threadflush")

    IMPORT :: C_BOOL, C_INT64_T

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret
    INTEGER(KIND=C_INT64_T) :: shared1

  END SUBROUTINE c_test_threadflush

!-------------!

  SUBROUTINE c_test_startOMPparallel(test_ret, threads)                        &
             BIND(c, name="c_test_startOMPparallel")

    IMPORT :: C_BOOL, C_INT64_T

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret
    INTEGER(KIND=C_INT64_T), INTENT(IN) :: threads

  END SUBROUTINE c_test_startOMPparallel

!-------------!


  SUBROUTINE c_test_startOMPparallelfor(test_ret, istart, iend, incr, threads) &
             BIND(c, name="c_test_startOMPparallelfor")

    IMPORT :: C_BOOL, C_INT64_T

    IMPLICIT NONE

    LOGICAL(KIND=C_BOOL), INTENT(OUT) :: test_ret
    INTEGER(KIND=C_INT64_T), INTENT(IN) :: istart, iend, incr, threads

  END SUBROUTINE c_test_startOMPparallelfor

!-------------!

END INTERFACE

!------------------------------------------------------------------------------!

CONTAINS

!------------------------------------------------------------------------------!

SUBROUTINE fruit_test_shum_thread_utils

USE, INTRINSIC :: ISO_FORTRAN_ENV, ONLY: OUTPUT_UNIT
USE f_shum_thread_utils_version_mod, ONLY: get_shum_thread_utils_version

IMPLICIT NONE

INTEGER(KIND=int64) :: version

! Note: we don't have a test case for the version checking because we don't
! want the testing to include further hardcoded version numbers to test
! against.  Since the version module is simple and hardcoded anyway it's
! sufficient to make sure it is callable; but let's print the version for info.
version = get_shum_thread_utils_version()

WRITE(OUTPUT_UNIT, "()")
WRITE(OUTPUT_UNIT, "(A,I0)")                                                   &
    "Testing shum_thread_utils at Shumlib version: ", version

CALL run_test_case(test_returns_valid_lock, "returns_valid_lock")
CALL run_test_case(test_invalid_lock_release, "invlaid_lock_release")
CALL run_test_case(test_create_and_release_lock, "create_and_release_lock")
CALL run_test_case(test_create_many_locks, "create_many_locks")
CALL run_test_case(test_backfill_locks, "test_backfill_locks")
CALL run_test_case(test_inpar, "test_inpar")
CALL run_test_case(test_threadid, "test_threadid")
CALL run_test_case(test_flush, "test_flush")
CALL run_test_case(test_numthreads, "test_numthreads")
CALL run_test_case(test_startOMPparallel, "test_startOMPparallel")
CALL run_test_case(test_startOMPparallelfor, "test_startOMPparallelfor")

END SUBROUTINE fruit_test_shum_thread_utils

!------------------------------------------------------------------------------!

SUBROUTINE test_returns_valid_lock

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret

CALL set_case_name("test_returns_valid_lock")
CALL c_test_returns_valid_lock(test_ret)
CALL assert_true(test_ret, "Returned value is not a valid lock")

END SUBROUTINE test_returns_valid_lock

!------------------------------------------------------------------------------!

SUBROUTINE test_invalid_lock_release

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret

CALL set_case_name("test_invalid_lock_release")
CALL c_test_invalid_lock_release(test_ret)
CALL assert_true(test_ret, "Did not handle/detect invalid lock release request")

END SUBROUTINE test_invalid_lock_release

!------------------------------------------------------------------------------!

SUBROUTINE test_create_and_release_lock

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret

CALL set_case_name("test_create_and_release_lock")
CALL c_test_create_and_release_lock(test_ret)
CALL assert_true(test_ret, "Did not correctly create, then release a lock")

END SUBROUTINE test_create_and_release_lock

!------------------------------------------------------------------------------!

SUBROUTINE test_create_many_locks

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret

CALL set_case_name("test_create_many_locksk")
CALL c_test_create_many_locks(test_ret)
CALL assert_true(test_ret, "Did not successfully create a high number of locks")

END SUBROUTINE test_create_many_locks

!------------------------------------------------------------------------------!

SUBROUTINE test_backfill_locks

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret

CALL set_case_name("test_backfill_locks")
CALL c_test_backfill_locks(test_ret)
CALL assert_true(test_ret, "Did not backfill lock array")

END SUBROUTINE test_backfill_locks

!------------------------------------------------------------------------------!

SUBROUTINE test_sweep_release_locks

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret

CALL set_case_name("test_sweep_release_locks")
CALL c_test_sweep_release_locks(test_ret)
CALL assert_true(test_ret, "Did not successfully release all locks in a sweep")

END SUBROUTINE test_sweep_release_locks

!------------------------------------------------------------------------------!

SUBROUTINE test_inpar

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret
LOGICAL :: working
INTEGER(KIND=C_INT64_T) :: par

par = -1

CALL set_case_name("test_inpar")

CALL c_test_inpar(test_ret,par)
CALL assert_true(test_ret, "Did succesfully call c_shum_inPar()")
test_ret = (par == 0)
CALL assert_true(test_ret, "c_shum_inPar() detected a false parallel region")

!$ CALL omp_set_num_threads(3)
!$OMP PARALLEL DEFAULT(NONE) PRIVATE(par) REDUCTION(.AND.:test_ret)
!$ par = -1
!$ CALL c_test_inpar(test_ret,par)
!$OMP END PARALLEL
!$ CALL assert_true(test_ret, "Did not succesfully call c_shum_inPar()")

!$OMP PARALLEL DEFAULT(NONE) PRIVATE(par, working) REDUCTION(.AND.:test_ret)
!$ par = -1
!$ CALL c_test_inpar(test_ret,par)
!$ working = (par == 1)
!$ IF (working .NEQV. omp_in_parallel()) THEN
!$   working = .FALSE.
!$ END IF
!$ test_ret = working
!$OMP END PARALLEL
!$ CALL assert_true(test_ret, "c_shum_inPar() did not detect a parallel region")

END SUBROUTINE test_inpar

!------------------------------------------------------------------------------!

SUBROUTINE test_threadid

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret
INTEGER(KIND=C_INT64_T) :: tid

!$ INTEGER :: i

tid = -1

CALL set_case_name("test_threadid")

CALL c_test_threadid(test_ret,tid)
CALL assert_true(test_ret, "Thread IDs not calculated correctly")
test_ret = (tid == 0)
CALL assert_true(test_ret, "Thread ID not zero outside parallel region")

!$ CALL omp_set_num_threads(3)
!$OMP PARALLEL DO SCHEDULE(static, 1) DEFAULT(NONE) PRIVATE(tid, i)            &
!$OMP REDUCTION(.AND.:test_ret)
!$ DO i=0,2
!$ CALL c_test_threadid(test_ret,tid)
!$ IF (tid/=i) test_ret = .FALSE.
!$ IF (tid/=omp_get_thread_num()) test_ret = .FALSE.
!$ END DO
!$OMP END PARALLEL DO
!$ CALL assert_true(test_ret, "Thread IDs not calculated correctly" //         &
!$                            " in parallel region")

END SUBROUTINE test_threadid

!------------------------------------------------------------------------------!

SUBROUTINE test_flush

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret

INTEGER(KIND=C_INT64_T) :: shared1

CALL set_case_name("test_threadflush")

! These are dummy tests for now.

! TODO: work out how to correctly test a flush, and implement it here

shared1=0
CALL c_test_threadflush(test_ret,shared1)
CALL assert_true(test_ret, "Dummy flush test fails!")

END SUBROUTINE test_flush

!------------------------------------------------------------------------------!

SUBROUTINE test_numthreads

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret
INTEGER(KIND=C_INT64_T) :: numthreads

!$ INTEGER :: i

numthreads = -1

CALL set_case_name("test_numthreads")

CALL c_test_numthreads(test_ret,numthreads)
CALL assert_true(test_ret, "Thread count not calculated correctly")
test_ret = (numthreads == 1)
CALL assert_true(test_ret, "Thread count not one outside parallel region")

!$ CALL omp_set_num_threads(1)
!$OMP PARALLEL DEFAULT(NONE) SHARED(numthreads, test_ret)
!$ CALL c_test_numthreads(test_ret,numthreads)
!$OMP END PARALLEL
!$ CALL assert_true(test_ret, "Thread count not calculated correctly" //       &
!$                            " in parallel region")
!$ test_ret = (numthreads == 1)
!$ CALL assert_true(test_ret, "Thread count not one in single threaded region")


!$ CALL omp_set_num_threads(3)
!$OMP PARALLEL DO SCHEDULE(static, 1) DEFAULT(NONE) PRIVATE(numthreads, i)     &
!$OMP REDUCTION(.AND.:test_ret)
!$ DO i=0,2
!$ CALL c_test_numthreads(test_ret,numthreads)
!$ IF (numthreads/=3) test_ret = .FALSE.
!$ IF (numthreads/=omp_get_num_threads()) test_ret = .FALSE.
!$ END DO
!$OMP END PARALLEL DO
!$ CALL assert_true(test_ret, "Thread count not consistent across threads" //  &
!$                            " in parallel region")

END SUBROUTINE test_numthreads

!------------------------------------------------------------------------------!

SUBROUTINE test_startOMPparallel

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret

INTEGER(KIND=C_INT64_T) :: threads

threads = 1

CALL set_case_name("test_startOMPparallel")
!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallel(test_ret, threads)
CALL assert_true(test_ret, "f_shum_startOMPparallel() failed")

END SUBROUTINE test_startOMPparallel

!------------------------------------------------------------------------------!

SUBROUTINE test_startOMPparallelfor

IMPLICIT NONE

LOGICAL(KIND=C_BOOL) :: test_ret

INTEGER(KIND=C_INT64_T) :: istart, iend, incr, threads


threads = 1

! Single iteration tests
!!!!!!!!!!!!!!!!!!!!!!!!

CALL set_case_name("test_startOMPparallelfor single iteration")

istart = 1
iend = 1
incr = 1

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {1 ~> 1 (1)} failed")

istart = 1
iend = 1
incr = -1

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {1 ~> 1 (-1)} failed")

! Multiple iteration tests
!!!!!!!!!!!!!!!!!!!!!!!!!!

CALL set_case_name("test_startOMPparallelfor multiple iteration")

istart = 1
iend = 4
incr = 1

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {1 ~> 4 (1)} failed")

istart = 4
iend = 1
incr = -1

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {4 ~> 1 (-1)} failed")

! Multiple iteration tests (iterations > threads)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!$ CALL set_case_name("test_startOMPparallelfor multiple iteration" //         &
!$                    " (iterations > threads)")

!$ istart = 1
!$ iend = 8
!$ incr = 1

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() {1 ~> 8 (1)} failed")

!$ istart = 8
!$ iend = 1
!$ incr = -1

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() {8 ~> 1 (-1)} failed")

! non-unitary increments
!!!!!!!!!!!!!!!!!!!!!!!!

CALL set_case_name("test_startOMPparallelfor non-unitary increments")

istart = 1
iend = 8
incr = 2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {1 ~> 8 (2)} failed")

istart = 8
iend = 1
incr = -2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {8 ~> 1 (-2)} failed")

! non-unitary increments (iterations > threads)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!$ CALL set_case_name("test_startOMPparallelfor non-unitary increments" //     &
!$                    " (iterations > threads)")

!$ istart = 1
!$ iend = 16
!$ incr = 2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() {1 ~> 16 (2)} failed")

!$ istart = 16
!$ iend = 1
!$ incr = -2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() {16 ~> 1 (-2)} failed")

! negative iteration ranges
!!!!!!!!!!!!!!!!!!!!!!!!!!!

CALL set_case_name("test_startOMPparallelfor negative iteration ranges")

istart = -1
iend = -16
incr = -2


!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {-1 ~> -16 (-2)} failed")

istart = -16
iend = -1
incr = 2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {-16 ~> -2 (2)} failed")

! non-closure increments
!!!!!!!!!!!!!!!!!!!!!!!!

CALL set_case_name("test_startOMPparallelfor non-closure")

istart = 1
iend = 4
incr = -2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {1 ~> 4 (-2)} failed")

istart = 4
iend = 1
incr = 2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {4 ~> 1 (2)} failed")

istart = -1
iend = -4
incr = 2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {-1 ~> -4 (2)} failed")

istart = -4
iend = -1
incr = -2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {-4 ~> -1 (-2)} failed")

! Asymetric decomposition
!!!!!!!!!!!!!!!!!!!!!!!!!

!$ CALL set_case_name("test_startOMPparallelfor asymetric decomposition")

!$ istart = 1
!$ iend = 20
!$ incr = 2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() {1 ~> 20 (2)} failed")

!$ istart = 20
!$ iend = 1
!$ incr = -2

!$ threads = 4
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() {20 ~> 1 (-2)} failed")

! Vary Threads
!!!!!!!!!!!!!!

!$ CALL set_case_name("test_startOMPparallelfor thread varying")

!$ istart = 1
!$ iend = 20
!$ incr = 2


!$ threads = 1
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() 1-thread +ve failed")

!$ istart = 20
!$ iend = 1
!$ incr = -2

!$ threads = 1
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() 1-thread -ve failed")

!$ istart = 1
!$ iend = 20
!$ incr = 2

!$ threads = 2
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() 2-thread +ve failed")

!$ istart = 20
!$ iend = 1
!$ incr = -2

!$ threads = 2
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() 2-thread -ve failed")

!$ istart = 1
!$ iend = 20
!$ incr = 2

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() 3-thread +ve failed")

!$ istart = 20
!$ iend = 1
!$ incr = -2

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() 3-thread -ve failed")

!$ istart = 1
!$ iend = 20
!$ incr = 2

!$ threads = 5
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() 5-thread +ve failed")

!$ istart = 20
!$ iend = 1
!$ incr = -2

!$ threads = 5
!$ CALL omp_set_num_threads(INT(threads))
!$ CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
!$ CALL assert_true(test_ret,                                                  &
!$                  "f_shum_startOMPparallelfor() 5-thread -ve failed")

! Modify Offsets (Positive)
!!!!!!!!!!!!!!!!!!!!!!!!!!!

CALL set_case_name("test_startOMPparallelfor offset tests (Positive)")

istart = 1
iend = 200
incr = 3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {1 ~> 200 (3)} failed")

istart = 2
iend = 200
incr = 3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {2 ~> 200 (3)} failed")

istart = 3
iend = 200
incr = 3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {3 ~> 200 (3)} failed")

istart = 4
iend = 200
incr = 3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {4 ~> 200 (3)} failed")

istart = 4
iend = 200
incr = 3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {4 ~> 200 (3)} failed")

istart = 4
iend = 201
incr = 3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {4 ~> 201 (3)} failed")

istart = 4
iend = 202
incr = 3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {4 ~> 202 (3)} failed")

istart = 4
iend = 203
incr = 3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret, "f_shum_startOMPparallelfor() {4 ~> 203 (3)} failed")

! Modify Offsets (Negative)
!!!!!!!!!!!!!!!!!!!!!!!!!!!

CALL set_case_name("test_startOMPparallelfor offset tests (Negative)")

istart = 200
iend = 1
incr = -3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {200 ~> 1 (-3)} failed")

istart = 201
iend = 1
incr = -3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {201 ~> 1 (-3)} failed")


istart = 202
iend = 1
incr = -3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {202 ~> 1 (-3)} failed")


istart = 203
iend = 1
incr = -3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {203 ~> 1 (-3)} failed")

istart = 203
iend = 2
incr = -3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {203 ~> 2 (-3)} failed")

istart = 203
iend = 3
incr = -3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {203 ~> 3 (-3)} failed")

istart = 203
iend = 4
incr = -3

!$ threads = 3
!$ CALL omp_set_num_threads(INT(threads))
CALL c_test_startOMPparallelfor(test_ret,istart,iend,incr,threads)
CALL assert_true(test_ret,                                                     &
                 "f_shum_startOMPparallelfor() {203 ~> 4 (-3)} failed")

END SUBROUTINE test_startOMPparallelfor

!------------------------------------------------------------------------------!

END MODULE fruit_test_shum_thread_utils_mod
