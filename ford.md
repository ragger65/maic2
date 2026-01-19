project: MAIC-2
summary: MAIC-2 Developer Manual
author: Ralf Greve, Bjoern Grieger, Oliver J. Stenzel
src_dir: ./src
preprocess: false
docmark: !
docmark_alt: *
predocmark: >
predocmark_alt: |
display: public
         protected
         private
incl_src: true
lower: false
max_frontpage_items: 20
search: true
sort: src
source: false
version: v2
year: 2026
graph: true
output_dir: ./docs/ford
force: true

The Mars Atmosphere-Ice Coupler MAIC-2 is a simple, latitudinal (zonally averaged) model that consists of a set of parameterizations for the surface temperature, the atmospheric water transport and the surface mass balance (condensation minus evaporation) of water ice. It is driven directly by the orbital parameters obliquity, eccentricity and solar longitude of perihelion.

The underlying physics is explained in the paper by Greve et al. (2010) and the presentation by Greve et al. (2012).

##### Resources

- User manual: in the directory `docs/user_manual/`
- GitHub repository: <https://github.com/ragger65/maic2/>  
- MAIC-2 community @ Zenodo: <https://zenodo.org/communities/maic2/>

##### Copyright

Copyright 2010-2026 Ralf Greve, Bjoern Grieger, Oliver J. Stenzel

##### License

MAIC-2 is free and open-source software, licensed under the terms of the [GNU General Public License](https://www.gnu.org/licenses/).

##### References

Greve, R., B. Grieger and O. J. Stenzel. 2010. MAIC-2, a latitudinal model for the Martian surface temperature, atmospheric water transport and surface glaciation. Planet. Space Sci., 58 (6), 931–940. <https://doi.org/10.1016/j.pss.2010.03.002>.

Greve, R., B. Grieger and O. J. Stenzel. 2012. Glaciation of Mars from 10 million years ago until 10 million years into the future simulated with the model MAIC-2. Presentation No. PPS03-06, JpGU Meeting, Makuhari, Chiba, Japan, 24 May 2012. <https://doi.org/10.5281/zenodo.3698542>.

@note
This developer manual is generated automatically using [FORD](https://github.com/Fortran-FOSS-Programmers/ford).  
Installing FORD: `pip install ford`.  
Creating/updating the developer manual: `ford ford.md`.  
Output is in HTML -> `docs/ford/index.html`.
