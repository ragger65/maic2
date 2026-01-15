#-------------------------------------------------------------------------------
# Configuration file for MAIC-2
#-------------------------------------------------------------------------------

#-------- Compiler --------

export FC=gfortran
###    Can be set here if needed.
###    Currently, gfortran, ifort and ifx are supported.

if [ "$FC" != "" ] ; then
   echo "Fortran compiler >$FC< found."
else
   echo "No Fortran compiler found (environment variable FC not set)."
   echo "Trying gfortran..."
   FC=gfortran
fi

#-------- Compiler flags --------

if [ "$FC" = "ifx" ] ; then

   case $PROGNAME in
        "maic2")
           FCFLAGS='-xHOST -O3 -no-prec-div'
           # This is '-fast' without '-static' and '-ipo'
           ;;
        *)
           FCFLAGS='-O2'
           ;;
   esac            

elif [ "$FC" = "ifort" ] ; then

   case $PROGNAME in
        "maic2")
           FCFLAGS='-xHOST -O3 -no-prec-div'
           # This is '-fast' without '-static' and '-ipo'
           ;;
        *)
           FCFLAGS='-O2'
           ;;
   esac            

elif [ "$FC" = "gfortran" ] ; then

   case $PROGNAME in
        "maic2")
           FCFLAGS='-O3 -ffast-math -ffree-line-length-none'
           ;;
        *)
           FCFLAGS='-O2 -ffree-line-length-none'
           ;;
   esac            

else
   echo "Unknown compiler flags for >$FC<, must exit."
   echo "Add flags to >maic2_configs.sh< and try again."
   exit 1
fi

echo "Flags: $FCFLAGS"

#-------------------------------------------------------------------------------
