#!/bin/bash
# (Selection of shell)

################################################################################
#
#  m u l t i _ m a i c 2 . s h
#
#  bash script for multiple execution of maic2.sh
#  (compilation, linking and execution of the program MAIC-2).
#
#  Author: Ralf Greve
#
#  Date: 2026-01-15
#
################################################################################

# Simulation #2 by Greve et al. (2010),
# only over 1 Martian year with more detailed output:
(./maic2.sh -m run_c01a -f) >tmp/out_mjob_c01a.dat 2>&1

# Simulation #2 by Greve et al. (2010):
(./maic2.sh -m run_c01 -f) >tmp/out_mjob_c01.dat 2>&1

# Simulation #1 by Greve et al. (2010):
(./maic2.sh -m run_c02 -f) >tmp/out_mjob_c02.dat 2>&1

# Simulation #3 by Greve et al. (2010):
(./maic2.sh -m run_c03 -f) >tmp/out_mjob_c03.dat 2>&1

# Simulation #4 by Greve et al. (2010):
(./maic2.sh -m run_c04 -f) >tmp/out_mjob_c04.dat 2>&1

# Simulation #6 by Greve et al. (2010):
(./maic2.sh -m run_t06 -f) >tmp/out_mjob_t06.dat 2>&1

# Simulation #7 by Greve et al. (2010):
(./maic2.sh -m run_t07 -f) >tmp/out_mjob_t07.dat 2>&1

# Simulation #8 by Greve et al. (2010):
(./maic2.sh -m run_t08 -f) >tmp/out_mjob_t08.dat 2>&1

# Simulation #5 by Greve et al. (2010):
(./maic2.sh -m run_t12 -f) >tmp/out_mjob_t12.dat 2>&1

# Simulation #6 by Greve et al. (2010),
# but from 20 million years ago until 10 million years into the future:
(./maic2.sh -m run_t14 -f) >tmp/out_mjob_t14.dat 2>&1

# Simulation run_t39 by Greve et al. (2012), pp. 14-15:
(./maic2.sh -m run_t39 -f) >tmp/out_mjob_t39.dat 2>&1

# Simulation run_t40 by Greve et al. (2012), pp. 14-15:
(./maic2.sh -m run_t40 -f) >tmp/out_mjob_t40.dat 2>&1

################################################################################

# References:
#
# Greve, R., B. Grieger and O. J. Stenzel. 2010.
# MAIC-2, a latitudinal model for the Martian surface temperature,
# atmospheric water transport and surface glaciation.
# Planetary and Space Science 58 (6), 931-940,
# doi: 10.1016/j.pss.2010.03.002.
#
# Greve, R., B. Grieger and O. J. Stenzel. 2012.
# Glaciation of Mars from 10 million years ago until 10 million years
# into the future simulated with the model MAIC-2.
# Presentation No. PPS03-06, JpGU Meeting, Makuhari, Chiba, Japan,
# 24 May 2012, doi: 10.5281/zenodo.3698541.

######################### End of multi_maic2.sh ################################
