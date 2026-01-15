MAIC-2 User Manual
==================

**Ralf Greve** (1), **Björn Grieger** (2), **Oliver J. Stenzel** (3)

(1) Institute of Low Temperature Science, Hokkaido University, Kita-19, Nishi-8, Kita-ku, Sapporo 060-0819, Japan  

(2) European Space Astronomy Centre (ESAC), Camino Bajo del Castillo s/n, 28692 Villanueva de la Cañada, Madrid, Spain  

(3) Max Planck Institute for Solar System Research, Justus-von-Liebig-Weg 3, 37077 Göttingen, Germany  

2026-01-15

---

Copyright 2010-2026 Ralf Greve, Björn Grieger, Oliver J. Stenzel

This file is part of MAIC-2.

MAIC-2 is free software. It can be redistributed and/or modified under the terms of the [GNU General Public License](https://www.gnu.org/licenses/) as published by the Free Software Foundation, either version 3 of the License, or (at the user's option) any later version.

MAIC-2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

---

Requirements
------------

- Unix-like system (e.g., Linux).

- Fortran compiler.

Installation
------------

1.  Clone the latest revision from the GitHub repository:

    `git clone https://github.com/ragger65/maic2.git`

2.  You should then have a new folder `maic2` that contains the entire
    program package.

Files and directories in `maic2`
--------------------------------

- Main directory:

  Shell script (bash) `maic2.sh` for running a single simulation under
  UNIX/LINUX.

  Shell script (bash) `multi_maic2.sh` for running multiple simulations by
  repeated calls of `maic2.sh`.

  Subdirectory `headers/templates`:
  specification files `maic2_specs_run_name.h` ("run_name": name of run).

  | Name of Run | Description                                                                                  |
  |:----------- |:-------------------------------------------------------------------------------------------- |
  | run_c01a    | Simulation #2 by Greve et al. (2010), <br>only over 1 Martian year with more detailed output |
  | run_c01     | Simulation #2 by Greve et al. (2010)                                                         |
  | run_c02     | Simulation #1 by Greve et al. (2010)                                                         |
  | run_c03     | Simulation #3 by Greve et al. (2010)                                                         |
  | run_c04     | Simulation #4 by Greve et al. (2010)                                                         |
  | run_t06     | Simulation #6 by Greve et al. (2010)                                                         |
  | run_t07     | Simulation #7 by Greve et al. (2010)                                                         |
  | run_t08     | Simulation #8 by Greve et al. (2010)                                                         |
  | run_t12     | Simulation #5 by Greve et al. (2010)                                                         |
  | run_t14     | Simulation #6 by Greve et al. (2010), <br>but from 20 Ma ago until 10 Ma into the future     |
  | run_t39     | Simulation by Greve et al. (2012) (pp. 14-15)                                                |
  | run_t40     | Simulation by Greve et al. (2012) (pp. 14-15)                                                |

  Copy these header files into the subdirectory `headers` by executing

  `cp headers/templates/maic2_specs_*.h headers/`

- `src`:

  Main program file `maic2.F90`.

  Subdirectory `subroutines`: subroutines for MAIC-2.

- `maic2_in`:

  Input data files (orbital forcing by Laskar et al. 2004) for MAIC-2.

- `maic2_out`:

  Default directory for output files produced by MAIC-2; initially
  empty.

- `docs`:

  Documentation for MAIC-2 (this user manual, FORD developer manual).  
  The latter can be built by executing `ford ford.md` in the
  main directory.

How to run a simulation
-----------------------

1.  In the script `maic2.sh`, search for "greve", and replace the path
    names for RUN_DIR and SRC_DIR with your own ones.

    Also, search for "Compiler", and replace the variables F90 and
    F90FLAGS according to the syntax of your own Fortran compiler
    (F90FLAGS should do).

2.  In the specification files (subdirectory `headers/`), search for
    "greve", and replace the path names for INPATH and OUTPATH with your
    own ones.

3.  The rest is quite simple:

    - In order to run simulation run_t06, use the script `maic2.sh`. The
      command is  
      `(./maic2.sh run_t06) >tmp/out_job.dat 2>&1 &`  
      (bash required). Accordingly for the other simulations.

    - Alternatively, if you prefer to run all simulations consecutively,
      you may use the script `multi_maic2.sh`:  
      `(./multi_maic2.sh) >tmp/out_mjob.dat 2>&1 &`

The computing times for the simulations, run with the Intel Fortran Compiler for Linux 11.1 (optimization option `–fast`) on an Intel Xeon X5570 (2.93 GHz) PC under openSUSE 11.0 (64 bit), are as follows:

  | Run      | Time    |   | Run     | Time     |   | Run     | Time     |
  |:-------- |:------- |:- |:------- |:-------- |:- |:------- |:-------- |
  | run_c01a | 0.1 sec |   | run_t06 |  7.0 hrs |   | run_t39 |  7.0 hrs |
  | run_c01  | 7.0 hrs |   | run_t07 |  7.0 hrs |   | run_t40 | 14.0 hrs |
  | run_c02  | 7.0 hrs |   | run_t08 |  7.0 hrs |   |         |          | 
  | run_c03  | 7.0 hrs |   | run_t12 |  7.0 hrs |   |         |          |
  | run_c04  | 7.0 hrs |   | run_t14 | 21.0 hrs |   |         |          |

Output files
------------

Output files of simulations are written to a directory specified by the user (OUTPATH in specification files, see above). Each simulation produces an output file `run_name.out` in ASCII format that contains the following data:

Column 1: Time *t* \[a\]   
Column 2: Solar longitude *L*<sub>s</sub> \[deg\]  
Column 3: Latitude *φ* \[deg\]  
Column 4: Surface temperature *T*(*φ*, *t*) \[K\]  
Column 5: Evaporation rate *E*(*φ*, *t*) \[kg m<sup>−2</sup> a<sup>−1</sup>\]  
Column 6: Condensation rate *C*(*φ*, *t*) \[kg m<sup>−2</sup> a<sup>−1</sup>\]  
Column 7: Water content *ω*(*φ*, *t*) \[kg m<sup>−2</sup>\]  
Column 8: Net mass balance *a*<sub>net</sub>(*φ*, *t*) \[mm a<sup>−1</sup> ice equivalent\]  
Column 9: Ice thickness *H*(*φ*, *t*) \[m\]  

References
----------

Greve, R., B. Grieger and O. J. Stenzel. 2010. MAIC-2, a latitudinal model for the Martian surface temperature, atmospheric water transport and surface glaciation. *Planetary and Space Science*, **58** (6), 931–940, [doi: 10.1016/j.pss.2010.03.002](https://doi.org/10.1016/j.pss.2010.03.002).

Greve, R., B. Grieger and O. J. Stenzel. 2012. Glaciation of Mars from 10 million years ago until 10 million years into the future simulated with the model MAIC-2. Presentation No. PPS03-06, JpGU Meeting, Makuhari Messe, Chiba, Japan, 24 May 2012, [doi: 10.5281/zenodo.3698541](https://doi.org/10.5281/zenodo.3698541).

Laskar, J., A. C. M. Correia, M. Gastineau, F. Joutel, B. Levrard and P. Robutel. 2004. Long term evolution and chaotic diffusion of the insolation quantities of Mars. *Icarus*, **170** (2), 343-364, [doi: 10.1016/j.icarus.2004.04.005](https://doi.org/10.1016/j.icarus.2004.04.005).
