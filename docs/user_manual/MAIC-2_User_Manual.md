MAIC-2 User Manual
==================

**Ralf Greve** (1,2), **Björn Grieger** (3), **Oliver J. Stenzel** (4)

(1) Institute of Low Temperature Science, Hokkaido University, Sapporo, Japan  
(2) Arctic Research Center, Hokkaido University, Sapporo, Japan  
(3) European Space Astronomy Centre (ESAC), Villanueva de la Cañada, Madrid, Spain  
(4) Max Planck Institute for Solar System Research, Göttingen, Germany

2026-01-18

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

Cloning the latest revision from the GitHub repository with either HTTPS or SSH:

HTTPS: `git clone https://github.com/ragger65/maic2.git`  
SSH: `git clone git@github.com:ragger65/maic2.git`

You should then have a new folder `maic2` that contains the entire program package.

Change to `maic2` and execute the bash script `copy_templates.sh`:

`./copy_templates.sh`

It copies several scripts from `templates` to `.` (the main directory), and the run-specs header files from `headers/templates` to `headers`. This allows modifying the scripts and headers suitably if needed, while the original files are always stored in the respective templates subdirectories for reference.

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

The approximate computing times for the simulations, run with the gfortran compiler v13.3.1 for Linux (optimization options `-O3 -ffast-math -ffree-line-length-none`) on a single core of a 2 × 14-Core Intel Xeon E5-2690 v4 (2.6 GHz) PC under openSUSE Leap 15.6, are as follows:

  | Run      | Time    |   | Run     | Time     |   | Run     | Time     |
  |:-------- |:------- |:- |:------- |:-------- |:- |:------- |:-------- |
  | run_c01a | 0.1 sec |   | run_t06 |  8.5 hrs |   | run_t39 |  8.5 hrs |
  | run_c01  | 8.5 hrs |   | run_t07 |  8.5 hrs |   | run_t40 | 17.0 hrs |
  | run_c02  | 8.5 hrs |   | run_t08 |  8.5 hrs |   |         |          |
  | run_c03  | 8.5 hrs |   | run_t12 |  8.5 hrs |   |         |          |
  | run_c04  | 8.5 hrs |   | run_t14 | 25.5 hrs |   |         |          |

Output files
------------

Each simulation produces two output files `<run_name>_out{1,2}.asc` in ASCII format, written by default to the directory `maic2_out/<run_name>`. (This can be changed by executing `maic2.sh` with the option `-d /path/to/output/directory`.) The files contain the following data:

`<run_name>_out1.asc`: time-dependent variables

Column 1: Time *t* \[a\]   
Column 2: Solar longitude *L*<sub>s</sub>(*t*) \[deg\]  
Column 3: Ice thickness at the north pole *H*<sub>NP</sub>(*t*) \[m\]  
Column 4: Ice thickness at the south pole *H*<sub>SP</sub>(*t*) \[m\]  
Column 5: Volume of the north-polar layered deposits (≥ 75°N) *V*<sub>NPLD</sub>(*t*) \[m<sup>3</sup>\]  
Column 6: Volume of the south-polar layered deposits (≥ 75°S) *V*<sub>SPLD</sub>(*t*) \[m<sup>3</sup>\]

`<run_name>_out2.asc`: latitude- and time-dependent variables

Column 1: Time *t* \[a\]   
Column 2: Latitude *φ* \[deg\]  
Column 3: Surface temperature *T*(*φ*, *t*) \[K\]  
Column 4: Evaporation rate *E*(*φ*, *t*) \[kg m<sup>−2</sup> a<sup>−1</sup>\]  
Column 5: Condensation rate *C*(*φ*, *t*) \[kg m<sup>−2</sup> a<sup>−1</sup>\]  
Column 6: Water content *ω*(*φ*, *t*) \[kg m<sup>−2</sup>\]  
Column 7: Net mass balance *a*<sub>net</sub>(*φ*, *t*) \[mm a<sup>−1</sup> ice equivalent\]  
Column 8: Ice thickness *H*(*φ*, *t*) \[m\]

Building the developer manual
-----------------------------

The MAIC-2 developer manual can be built locally with the tool [FORD (FORtran Documenter)](https://github.com/Fortran-FOSS-Programmers/ford) as follows:

- Installing FORD with pip: `pip install ford`.

- Creating/updating the manual: `ford ford.md` (in the main directory of the MAIC-2 installation).

- Output is in HTML -> `docs/ford/index.html`.

If required, see the [FORD documentation](https://forddocs.readthedocs.io) for further information.

References
----------

Greve, R., B. Grieger and O. J. Stenzel. 2010. MAIC-2, a latitudinal model for the Martian surface temperature, atmospheric water transport and surface glaciation. *Planetary and Space Science*, **58** (6), 931-940, [doi: 10.1016/j.pss.2010.03.002](https://doi.org/10.1016/j.pss.2010.03.002).

Greve, R., B. Grieger and O. J. Stenzel. 2012. Glaciation of Mars from 10 million years ago until 10 million years into the future simulated with the model MAIC-2. Presentation No. PPS03-06, JpGU Meeting, Makuhari Messe, Chiba, Japan, 24 May 2012, [doi: 10.5281/zenodo.3698541](https://doi.org/10.5281/zenodo.3698541).

Laskar, J., A. C. M. Correia, M. Gastineau, F. Joutel, B. Levrard and P. Robutel. 2004. Long term evolution and chaotic diffusion of the insolation quantities of Mars. *Icarus*, **170** (2), 343-364, [doi: 10.1016/j.icarus.2004.04.005](https://doi.org/10.1016/j.icarus.2004.04.005).
