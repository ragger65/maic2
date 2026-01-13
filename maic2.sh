#!/bin/bash
# (Selection of shell)

#######################################################################
#
#  M A I C 2 . S H
#
#  bash script for
#  compilation, linking and execution of the program MAIC2.
#
#  System: PC, openSUSE Linux
#
#  Author: Ralf Greve
#
#    Execute script from a bash with
#       '(./maic2.sh runname) >tmp/out_job.dat 2>&1 &'
#    where runname is the name of the simulation.
#
#    Specification header must be called 'maic2_specs_runname.h'
#    and must be placed in subdirectory 'headers'!
#
#######################################################################

#-------- Start directory for MAIC2 run --------

RUN_DIR=/uchi/greve/models_tools/maic2

#-------- Source code directory ----

SRC_DIR=/uchi/greve/models_tools/maic2/src

#-------- System commands used by this script --------

RM=/bin/rm
CP=/bin/cp
MV=/bin/mv

#-------- Name of header, executable and output files --------

HEADER_FILE='headers/maic2_specs_'$1'.h'
#   Header file of current simulation
HEADER_FILE_MAIC2='maic2_specs.h'
#   Name of header file in MAIC2

EXE_FILE='maic2_'$1'.x'
OUT_FILE='out_'$1'.dat'

#-------- Compiler --------

# Intel Fortran Compiler for Linux
F90=ifort
F90FLAGS='-O3 -no-prec-div'
### F90FLAGS='-xHOST -O3 -no-prec-div'
### # This is '-fast' without '-static' and '-ipo'
### F90FLAGS='-fast'

# GFortran Compiler
# F90=gfortran
# F90FLAGS='-O2'

# G95 Compiler for Linux
# F90=g95
# F90FLAGS='-O2'

F90FLAGS="${F90FLAGS} -I${RUN_DIR} -o ${EXE_FILE}"

#-------- Compilation and linking of the source code --------

cd ${RUN_DIR}

if [ -f ${HEADER_FILE_MAIC2} ] ; then
   $RM -f ${HEADER_FILE_MAIC2}
fi

$CP ${HEADER_FILE} ${HEADER_FILE_MAIC2}

if [ -f ${EXE_FILE} ] ; then
   $RM -f ${EXE_FILE}
fi

${F90} ${SRC_DIR}/maic2.F90 ${F90FLAGS}

$RM -f ${HEADER_FILE_MAIC2}

#-------- Execution of the program --------

(time /usr/bin/nice -n 19 ./${EXE_FILE}) >${OUT_FILE} 2>&1

$RM -f ${EXE_FILE}

#-------- End of maic2.sh --------
