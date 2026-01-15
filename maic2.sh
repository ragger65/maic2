#!/bin/bash
LANG=C

################################################################################
#
#  m a i c 2 . s h
#
#  bash script for
#  compilation, linking and execution of the program MAIC-2.
#
#  Author: Ralf Greve
#
#  Date: 2026-01-15
#
################################################################################

function error()
{
   echo -e "\n******************************************************************************">&2
   echo -e   "** ERROR:                                                                   **">&2
   echo -e   "$1" | awk '{printf("** %-73s**\n",$0)}'>&2
   echo -e "******************************************************************************\n">&2
   exit 1
}

################################################################################

function info()
{
   echo -e "$1" >&2
}

################################################################################

function usage()
{
   echo -e "\n  Usage: `basename $0` -m <run_name> [further options...]\n"\
   "     use -m? to get a list of available simulations\n"\
   "     [-m <run_name>] => name of the simulation\n"\
   "     [-i <dir>] => individual input directory, default is maic2_in\n"\
   "     [-d <dir>] => individual output directory, default is maic2_out/<run_name>\n"\
   "     [-f] => force overwriting the output directory\n"\
   "     [-n] => skip make clean\n"\
   "     [-b] => skip execution, build only\n"\
   "     [-c <FILE>] => configuration file FILE instead of maic2_configs.sh\n"\

      if [ "$1" ]; then error "$1"; fi
}

################################################################################

function check_args()
{
   while getopts bc:d:fhi:m:n? OPT ; do
     case $OPT in
       b) BUILD_ONLY="TRUE";;
       c) CONFIG=$OPTARG ;;
       d) local OUTDIR=$OPTARG ;;
       f) local FORCE="TRUE";;
       i) local INDIRIN=$OPTARG ;;
       m) RUN=$OPTARG ;;
       n) SKIP_MAKECLEAN="TRUE";;
     h|?) usage; exit 1;;
     
     esac            
   done

   PROGNAME="maic2"

   # Check if RUN is set correctly
   if [ ! "$RUN" ]; then error "No simulation set. Try option -h."; fi
   if [ $RUN == "?" ]; then
      info "--------------------------" 
      info "Available simulations are:"
      info "--------------------------"
      ls headers/ | sed 's/maic2_specs_\(.*\)\.h/\1/'
      exit 1
   fi
   
   HEADER=`pwd`"/headers/maic2_specs_$RUN.h"
   if [ ! -e $HEADER ]; then 
      error "Simulation header $HEADER does not exist."
   fi

   RUN_SPECS_HEADER="maic2_specs_$RUN.h"

   # Output directory, absolute paths
   if [ ! "$OUTDIR" ]; then
      RESDIR=${PWD}"/maic2_out/$RUN"
   else
      lastch=`echo $OUTDIR | sed -e 's/\(^.*\)\(.$\)/\2/'`
      if [ ${lastch} == "/" ]; then OUTDIR=`echo $OUTDIR | sed '$s/.$//'`; fi
      if [ ! -e $OUTDIR ]; then error "$OUTDIR does not exist."; fi
      RESDIR=${OUTDIR}"/$RUN"
   fi
   
   # Input directory, absolute paths
      if [ ! "$INDIRIN" ]; then
      INDIR=${PWD}"/maic2_in"
   else
      lastch=`echo $INDIRIN | sed -e 's/\(^.*\)\(.$\)/\2/'`
      if [ ${lastch} == "/" ]; then INDIRIN=`echo $INDIRIN  | sed '$s/.$//'`; fi
      if [ ! -e $INDIRIN  ]; then error "$INDIRIN does not exist."; fi
      INDIR=${INDIRIN}
   fi

   # Checking for existing output
   if [ "$FORCE" ]; then $RM -rf $RESDIR 2> /dev/null ; fi
   if [ -e $RESDIR ]; then error "$RESDIR exists. Use -f to overwrite."; fi

   # Configuration file
   if [ ! "$CONFIG" ]; then
      CONFIG="./maic2_configs.sh"
   else
      if [ ! -e $CONFIG ]; then error "$CONFIG does not exist."; fi
      CONFIG=`dirname $CONFIG`/`basename $CONFIG`
   fi
}

################################################################################

function compile()
{
   info "\nConfiguration file ${CONFIG}."
   source $CONFIG

   source ./rev_id.sh >/dev/null 2>&1

   cd ./src/

   EXE_FILE='maic2_'${RUN}'.x'

   $RM -f ${EXE_FILE}
   $RM -f *.mod
   
   $CP $HEADER $RUN_SPECS_HEADER

   FCFLAGS="${FCFLAGS} -DRUN_SPECS_HEADER=\"${RUN_SPECS_HEADER}\""

   FCFLAGS="${FCFLAGS} -DIN_PATH=\"${INDIR}\""
   FCFLAGS="${FCFLAGS} -DOUT_PATH=\"${RESDIR}\""

   FCFLAGS="${FCFLAGS} -o ${EXE_FILE}"

   ${FC} ./${PROGNAME}.F90 ${FCFLAGS}

   mkdir $RESDIR
   
   $MV $RUN_SPECS_HEADER $RESDIR
   
   # Writing a log file with some information about the host
   HOSTINFOFILE=$RESDIR/host_info.log
   echo "Host infos:" > $HOSTINFOFILE
   echo "-----------" >> $HOSTINFOFILE
   echo -n "Host name: " >> $HOSTINFOFILE
   hostname >> $HOSTINFOFILE
   echo -n "OS: " >> $HOSTINFOFILE
   uname >> $HOSTINFOFILE
   echo -n "User: " >> $HOSTINFOFILE
   id >> $HOSTINFOFILE

   cd $OLDPWD
}

################################################################################

function run()
{
   if [ $BUILD_ONLY ]; then
      info "Skip execution."
      return 0
   fi

   cd ./src/

   # Needed for openmp on LINUX 
   UNAME=`uname`
   if [ "$UNAME" == "Linux" ]; then
      echo "Setting ulimit to unlimited."
      ulimit -s unlimited
      export STACKSIZE=8192
   fi

   local OUT=../out_$RUN.dat
   info "Starting ./$EXE_FILE"
   info "         (log-output in out_$RUN.dat) ..."

   (time $NICE -n 19 ./${EXE_FILE}) >$OUT
   # (time $NICE -n 19 ./${EXE_FILE}) >$OUT 2>&1

   $MV $OUT $RESDIR

   if [ ! $SKIP_MAKECLEAN ]; then
      $RM -f ./${EXE_FILE}
      $RM -f *.mod
   fi

   info "\n... finished"
   info   "    (output in $RESDIR).\n"

   cd $OLDPWD
}

################################################################################

RM=/bin/rm
CP=/bin/cp
MV=/bin/mv

if [ -x /usr/bin/nice ]; then
   NICE=/usr/bin/nice
elif [ -x /bin/nice ]; then
   NICE=/bin/nice
else
   NICE=nice
fi

check_args $*
compile 
run

############################ End of maic2.sh ###################################
