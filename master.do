*** General housekeeping
clear all
set more off
capture log close

*** Paths ***

* Per
if `"`c(os)'"' == "MacOSX" & "`c(username)'" == "perhjertstrand" global stem `"/Users/perhjertstrand/Dropbox/[SET PATH HERE]/"'
if `"`c(os)'"' == "Windows" & "`c(username)'" == "per.hjertstrand" global stem `"C:/Users/per.hjertstrand/Dropbox/[SET PATH HERE]/"'

* Matthew
if `"`c(os)'"' == "MacOSX" & "`c(username)'" == "matthewpolisson" global stem `"/Users/matthewpolisson/Dropbox/[SET PATH HERE]/"'
if `"`c(os)'"' == "Windows" & "`c(username)'" == "matthew.olisson" global stem `"C:/Users/matthew.polisson/Dropbox/[SET PATH HERE]/"'

* Marcos
if `"`c(os)'"' == "MacOSX" & "`c(username)'" == "marcosdemetry" global stem `"/Users/marcosdemetry/Dropbox/IFN/Per Hjertstrand/STATA/"'
if `"`c(os)'"' == "Windows" & "`c(username)'" == "marcos.demetry" global stem `"C:/Users/marcos.demetry/Dropbox/IFN/Per Hjertstrand/STATA/"'

* Relative paths
cd "${stem}"

di "Current directory: `c(pwd)'"

gl codedir "${stem}/results_for_paper/code"
gl datadir "${stem}/results_for_paper/data"
gl outputdir "${stem}/results_for_paper/output"

gl paperdir	"../Paper"

adopath + "${codedir}"

set rmsg on

*******************
*** Replication ***
*******************

* Importing Andreoni and Miller (2001) data
do "${codedir}/importing_andreoni_data.do"

* Results; Table 1 & Table 2
do "${codedir}/table1_and_2.do"

* Results; Figure 1
do "${codedir}/figure1.do"

* Results; Figure 2 & 3
do "${codedir}/figure2_and_3.do"

* Syntax & Pseudocode for paper
do "${codedir}/syntax_pseudocode_for_paper.do"


* Note: data for figures 2 & 3 come from overnight simulations and therefore
*		not created in this do-file in the interest of time.
