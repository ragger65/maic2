!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!                  Specification file maic2_specs_runname.h
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#define LMAX 180
!                       LMAX+1: number of grid points in latitudinal (phi)
!                               direction (l=0...LMAX)

!                       So far only equidistant grid points implemented.
!                       The grid spacing is therefore dphi = 180 deg / LMAX.

!  ------------------

#define PARAM_RHO_I 9.1e+02_dp
!       Density of ice (in kg/m3)

#define PARAM_RHO_W 1.0e+03_dp
!       Density of pure water (in kg/m3)

#define PARAM_G 3.72_dp
!       Acceleration due to gravity (in m/s2)

#define PARAM_R 3.396e+06_dp
!       Radius of Mars (m)

!  ------------------

#define YEAR_SEC  31556926.0_dp
!                       Conversion from earth years to seconds

#define MARS_YEAR 59512320.0_dp
!                       Length of Martian year in seconds (PlaSim calendar)

#define MARS_DAY  (MARS_YEAR/672.0_dp)
!                       Length of Martian day in seconds (PlaSim calendar)

#define TIME_INIT0 (-(MARS_YEAR/YEAR_SEC)*5.303e+06_dp)
!                       Initial time of simulation (in a)

#define TIME_END0  ((MARS_YEAR/YEAR_SEC)*5.303e+06_dp)
!                       Final time of simulation (in a)

#define DTIME0     ((MARS_YEAR/YEAR_SEC)/84.0_dp)
!                       Time step (in a)

#define NTIME 10000
!                       Number of subdivisions of the Martian year for the
!                       computation of the orbital position (true anomaly)

!  ------------------

#define INSOL_MA_90N_FILE 'mars_laskar_2004.dat'
!                       Name of the file containing the mean-annual north-polar
!                       insolation

#define ALBEDO 0.3_dp
!                       Planetary mean albedo.
!                       Standard value: 0.3 (planetary mean)

#define ALBEDO_CO2 0.3_dp
!                       Albedo of the seasonal CO2 ice caps.
!                       Suitable range from 0.3 to 0.7.

#define TEMP_SURF_AMP_EQ 30.0_dp
!                       Amplitude (maximum minus mean) of the daily cycle of the
!                       surface temperature at the equator (in K)

#define TEMP_SURF_AMP_EXP 4.0_dp
!                       Exponent of the latitude-dependent parameterisation
!                       for the daily cycle of the surface temperature

!  ------------------

#define H_INIT 1
!                       Initial conditions for the ice thickness:
!                         1 : Constant ice thickness THICK_INIT everywhere
!                         2 : Present-day conditions with polar ice caps between
!                             the poles and 80 deg lat, ground ice elsewhere

#define THICK_INIT 5.25_dp
!                       Initial ice thickness (m), for H_INIT=1

#define WATER_INIT 0.02_dp
!                       Initial, uniform atmospheric water content (in kg/m2)

!  ------------------

#define P_SURF 7.0e+02_dp
!                       Surface pressure (in Pa)

!  ------------------

#define EVAP_FACT 0.05_dp
!                       Evaporation factor

#define GAMMA_REG 1.0e-01_dp
!                       Regolith-insulation coefficient [in m]

!  ------------------

#define COND 1
!                       Condensation model:
!                         1 : Removal of water exceeding the saturation pressure
!                             at the surface
!                         2 : Continuous, quadratic dependence on humidity

#define TAU_COND 1.0e+00_dp
!                5.0e+03_dp
!                       Time-scale for condensation [in a], for COND=2

!  ------------------

#define SOLV_DIFF 3
!                       Solution of the water-diffusion equation:
!                         1 : Explicit scheme (Euler forward)
!                         2 : Implicit scheme (Euler backward)
!                         3 : Instantaneous mixing
!                             with optional north-south gradient

#define DIFF_WATER_MAIC 1.0e+02_dp
!                       Diffusion coefficient of atmospheric water (in m2/s)
!                       (irrelevant for SOLV_DIFF=3)

#define RATIO_WATER_NP_SP 2.0_dp
!                       Ratio of the atmospheric water content at the poles
!                       (north pole relative to south pole; for SOLV_DIFF=3)
!                       (default value is 1.0_dp, that is, no north-south gradient)

!  ------------------

#define OUTPUT 1
!                         1 : Data output with prescribed time step
!                         2 : Data output at arbitrarily specified times

#define DTIME_OUT0 ((MARS_YEAR/YEAR_SEC)*1000.0_dp)
!                             Time step (in a) for data output
!                             (only for OUTPUT==1)

#define N_OUTPUT 0
!                             Number of specified times for data output
!                             (only for OUTPUT==2, not more than 20)

#define TIME_OUT0_01 1.11e+11_dp
#define TIME_OUT0_02 1.11e+11_dp
#define TIME_OUT0_03 1.11e+11_dp
#define TIME_OUT0_04 1.11e+11_dp
#define TIME_OUT0_05 1.11e+11_dp
#define TIME_OUT0_06 1.11e+11_dp
#define TIME_OUT0_07 1.11e+11_dp
#define TIME_OUT0_08 1.11e+11_dp
#define TIME_OUT0_09 1.11e+11_dp
#define TIME_OUT0_10 1.11e+11_dp
#define TIME_OUT0_11 1.11e+11_dp
#define TIME_OUT0_12 1.11e+11_dp
#define TIME_OUT0_13 1.11e+11_dp
#define TIME_OUT0_14 1.11e+11_dp
#define TIME_OUT0_15 1.11e+11_dp
#define TIME_OUT0_16 1.11e+11_dp
#define TIME_OUT0_17 1.11e+11_dp
#define TIME_OUT0_18 1.11e+11_dp
#define TIME_OUT0_19 1.11e+11_dp
#define TIME_OUT0_20 1.11e+11_dp
!                             Times (in a) for writing of time-slice
!                             data (only for OUTPUT==2, in increasing
!                             order from #1 to #N_OUTPUT)

!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
