*********************************************************
*** Speed tests for AEI 1 (Changing tolerance levels) ***
*********************************************************
clear all
drop _all

cd "${datadir}"

import excel using "example_Data.xlsx", clear firstrow

mkmat p1-p5, matrix(P1)		/* p{1, ..., 5} vars contain prices */
mkmat x1-x5, matrix(X1)		/* x{1, ..., 5} vars contain quantities */

tempfile repeated_data
quietly save `repeated_data', emptyok
forvalues i = 1/2 {
    import excel using "example_Data.xlsx", clear firstrow
    append using `repeated_data'
    quietly save `repeated_data', replace
}

mkmat p1-p5, matrix(P2)		/* p{1, ..., 5} vars contain prices */
mkmat x1-x5, matrix(X2)		/* x{1, ..., 5} vars contain quantities */

* Create matrix to store results
local axioms "eGARP"
local total_axioms = wordcount("`axioms'")
local max_iteration = 100		/* Set as any value */
local max_tolerance = 15		/* Set as value between 1–15 */
local max_row_nr = `max_iteration'*`max_tolerance'*`total_axioms'*2
display `max_row_nr'

matrix outcome = J(`max_row_nr', 5, .)
matrix colnames outcome  = "Iteration" "Tolerance" "Time" "AEI" "Axiom"

local row_nr = 1
local axiom_nr = 1
foreach ax of local axioms {
	forvalues dataset_nr = 1/2 {
		forvalues iteration = 1/`max_iteration' {
			forvalues tol = 1/`max_tolerance' {
				
				timer clear `tol'
				timer on `tol'
				quietly aei, price(P`dataset_nr') quantity(X`dataset_nr') ax(`ax') tol(`tol')
				timer off `tol'
				
				timer list `tol'
						
				matrix outcome[`row_nr', 1] = `iteration'
				matrix outcome[`row_nr', 2] = `tol'
				matrix outcome[`row_nr', 3] = `r(t`tol')'
				matrix outcome[`row_nr', 4] = `r(AEI_`ax')'
				matrix outcome[`row_nr', 5] = `axiom_nr'
				
				local row_nr = `row_nr' + 1

			}

		}
	}
	
	local axiom_nr = `axiom_nr' + 1
}

* Creating dataset out of matrix "outcome"
svmat outcome, names(col)

label def ax_label 1 "eGARP"
label val Axiom ax_label 

save "${datadir}/aei_speedtest_1", replace

* Graph: Average runtime by tolerance level
binscatter Time Tolerance, by(Dataset) line(qfit) xq(Tol) ///
	ytitle("Time (seconds)") legend(order(1 "20 Observations" 2 "60 Observations"))

graph export "${outputdir}/figures/aei_speed_test_1.eps", replace
graph export "${outputdir}/figures/aei_speed_test_1.pdf", replace

* Summary statistics
bysort Axiom: tabstat Time, stat(mean sd min max n) by(Tolerance)

* Detailed graph:
bysort Tolerance: egen max = max(Time)
bysort Tolerance: egen min = min(Time)

collapse (mean) Time (firstnm) min max, by(Tolerance)

twoway (scatter Time Tolerance) ///
	   (rarea min max Tolerance, color(gs15))

****************************************************
*** Speed tests for AEI 2 (Changing matrix size) ***
****************************************************

cd "${datadir}"

clear all

tempfile repeated_data
quietly save `repeated_data', emptyok
forvalues i = 1/25 {
    import excel using "example_Data.xlsx", clear firstrow
    append using `repeated_data'
    quietly save `repeated_data', replace
}

* Create matrix to store results
local axioms "eGARP"
local total_axioms = wordcount("`axioms'")
local max_iteration = 1			/* Set as any value */
local tolerance_levels = 2		/* Set as value between 1–15 */
local matsizes = c(N)			/* Number of observations in data set */
local max_row_nr = `max_iteration'*`tolerance_levels'*`matsizes'*`total_axioms'
display `max_row_nr'

matrix outcome = J(`max_row_nr', 5, .)
matrix colnames outcome  = "Iteration" "Tolerance" "Time" "Size" "Axiom"

local row_nr = 1
local axiom_nr = 1

foreach ax of local axioms {
	
	forvalues iteration = 1/`max_iteration' {
	
		forvalues tol = 6(6)12 {
			
			forvalues matsize = 20/`matsizes' {
	
				mkmat p1-p5 if _n <= `matsize', matrix(P)		/* p{1, ..., 5} vars contain prices */
				mkmat x1-x5 if _n <= `matsize', matrix(X)		/* x{1, ..., 5} vars contain quantities */
				
				timer clear `tol'
				timer on `tol'
				quietly aei, price(P) quantity(X) axiom(`ax') tol(`tol')
				timer off `tol'
				
				timer list `tol'
						
				matrix outcome[`row_nr', 1] = `iteration'
				matrix outcome[`row_nr', 2] = `tol'
				matrix outcome[`row_nr', 3] = `r(t`tol')'
				matrix outcome[`row_nr', 4] = `matsize'
				matrix outcome[`row_nr', 5] = `axiom_nr'
				
				local row_nr = `row_nr' + 1
			}

		}

	}
	
	local axiom_nr = `axiom_nr' + 1
}

/* Loop total runtime per 1 iteration apprx 50 minutes */

* Creating dataset out of matrix "outcome"
svmat outcome, names(col)

save "${datadir}/aei_speedtest_2", replace

* Graph: Average runtime by matrix size (number of observations) and tolerance level
binscatter Time Size, by(Tolerance) line(qfit)  ///
	ytitle("Time (seconds)") xtitle("Number of observations") ///
	xscale(range(20 500)) ///
	legend(order(1 "Tolerance = 10^-6" 2 "Tolerance = 10^-12"))

graph export "${outputdir}/figures/aei_speed_test_2.eps", replace
graph export "${outputdir}/figures/aei_speed_test_2.pdf", replace

twoway (scatter Time Size if Tolerance == 6) ///
	   (scatter Time Size if Tolerance == 12)
