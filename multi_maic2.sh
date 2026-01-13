#!/bin/bash
# (Selection of shell)

# Simulation #2 by Greve et al. (2010),
# only over 1 Martian year with more detailed output:
(./maic2.sh run_c01a) >tmp/out_mjob_01.dat 2>&1

# Simulation #2 by Greve et al. (2010):
(./maic2.sh run_c01) >tmp/out_mjob_02.dat 2>&1

# Simulation #1 by Greve et al. (2010):
(./maic2.sh run_c02) >tmp/out_mjob_03.dat 2>&1

# Simulation #3 by Greve et al. (2010):
(./maic2.sh run_c03) >tmp/out_mjob_04.dat 2>&1

# Simulation #4 by Greve et al. (2010):
(./maic2.sh run_c04) >tmp/out_mjob_05.dat 2>&1

# Simulation #6 by Greve et al. (2010):
(./maic2.sh run_t06) >tmp/out_mjob_06.dat 2>&1

# Simulation #7 by Greve et al. (2010):
(./maic2.sh run_t07) >tmp/out_mjob_07.dat 2>&1

# Simulation #8 by Greve et al. (2010):
(./maic2.sh run_t08) >tmp/out_mjob_08.dat 2>&1

# Simulation #5 by Greve et al. (2010):
(./maic2.sh run_t12) >tmp/out_mjob_09.dat 2>&1

# Simulation #6 by Greve et al. (2010),
# but from 20 million years ago until 10 million years into the future:
(./maic2.sh run_t14) >tmp/out_mjob_10.dat 2>&1

# Simulation run_t39 by Greve et al. (2012), pp. 14-15:
(./maic2.sh run_t39) >tmp/out_mjob_11.dat 2>&1

# Simulation run_t40 by Greve et al. (2012), pp. 14-15:
(./maic2.sh run_t40) >tmp/out_mjob_12.dat 2>&1

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
# 24 May 2012, doi: 10.5281/zenodo.3698542.
