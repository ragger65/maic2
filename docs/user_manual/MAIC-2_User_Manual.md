MAIC-2 User Manual
==================

**Ralf Greve** (1), **Björn Grieger** (2), **Oliver J. Stenzel** (3)

(1) Institute of Low Temperature Science, Hokkaido University, Kita-19, Nishi-8, Kita-ku, Sapporo 060-0819, Japan  

(2) European Space Astronomy Centre (ESAC), Camino Bajo del Castillo s/n, 28692 Villanueva de la Cañada, Madrid, Spain  

(3) Max Planck Institute for Solar System Research, Justus-von-Liebig-Weg 3, 37077 Göttingen, Germany  

2026-01-15

---

Introduction
------------

The Mars Atmosphere-Ice Coupler MAIC-2 is a simple, latitudinal (zonally averaged) model that consists of a set of parameterizations for the surface temperature, the atmospheric water transport and the surface mass balance (condensation minus evaporation) of water ice. It is driven directly by the orbital parameters obliquity, eccentricity and solar longitude of perihelion.

The underlying physics is explained in the paper by Greve et al. (2010) and the presentation by Greve et al. (2012).

### Resources

GitHub repository:
[https://github.com/ragger65/maic2/](https://github.com/ragger65/maic2/)

MAIC-2 community @ Zenodo:
[https://zenodo.org/communities/maic2/](https://zenodo.org/communities/maic2/)

### Legal notes

Copyright 2010-2026 Ralf Greve, Björn Grieger, Oliver J. Stenzel

MAIC-2 is free and open-source software. It can be redistributed and/or modified under the terms of the [GNU General Public License](https://www.gnu.org/licenses/) as published by the Free Software Foundation, either version 3 of the License, or (at the user's option) any later version.

MAIC-2 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

Requirements
------------

- Unix-like system (e.g., Linux).

- Fortran compiler.  
  So far, the GNU GCC (gfortran) and Intel Fortran (ifort, ifx) compilers are supported.

Download
--------

Cloning the latest revision from the GitHub repository:

`git clone https://github.com/ragger65/maic2.git`

You should then have a new folder `maic2` that contains the entire program package.

Change to `maic2` and execute the bash script `copy_templates.sh`:

`./copy_templates.sh`

It copies the run-specs header files from `headers/templates` to `headers`. This allows modifying the headers suitably if needed, while the original files are always stored in the templates subdirectory for reference.

Directory structure
-------------------

- Main directory:

  Shell script (bash) `maic2.sh` for running a single simulation.

  Shell script (bash) `multi_maic2.sh` for running multiple simulations by
  repeated calls of `maic2.sh`.

- `headers`:
  Run-specs header files `maic2_specs_<run_name>.h` (see below) for the simulations to be carried out with MAIC-2.

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

Run-specs header files
----------------------

Each simulation (run) must be specified by a run-specs header file (or "header" for short). If the name of the simulation is supposed to be `<run_name>`, then the name of the header must be `maic2_specs_<run_name>.h`. MAIC-2 actually extracts the name of the simulation from the name of the header according to this pattern.

A header consists of a number of preprocessor directives of the form

`#define PARAMETER value`

These allow specifying many aspects of a simulation and are documented in the headers themselves.

For a number of test simulations, the run-specs header files are contained in the MAIC-2 repository: 

  | Name of run | Description                                                                                  |
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

How to run a simulation
-----------------------

For example, to run simulation `run_t06`, use the script `maic2.sh`as follows:  

`(./maic2.sh -m run_t06) >tmp/out_job_t06.dat 2>&1 &`  

(bash required). Accordingly for the other simulations.

To list further options, execute `./maic2.sh -h`.

If you prefer to run all simulations consecutively, execute the script `multi_maic2.sh`:  

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

Each simulation produces an output file `<run_name>_out.asc` in ASCII format, written by default to the directory `maic2_out/<run_name>`. (This can be changed by executing `maic2.sh` with the option `-d /path/to/output/directory`.) The file contains the following data:

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
