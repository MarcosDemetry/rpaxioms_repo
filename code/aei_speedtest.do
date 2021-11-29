***************************
*** Speed tests for AEI ***
***************************

clear

* Create matrix to store results
local max_iteration = 100		/* Set as any value */
local max_tolerance = 15		/* Set as value between 1–15 */
local max_row_nr = `max_iteration'*`max_tolerance'
display `max_row_nr'

matrix outcome = J(`max_row_nr', 3, .)
matrix colnames outcome  = "Iteration" "Tolerance" "Time"

local row_nr = 1
forvalues iteration = 1/`max_iteration' {
	forvalues tol = 1/`max_tolerance' {
		
		timer clear `tol'
		timer on `tol'
		quietly aei, price(P) quantity(X) tol(`tol')
		timer off `tol'
		
		timer list `tol'
				
		matrix outcome[`row_nr', 1] = `iteration'
		matrix outcome[`row_nr', 2] = `tol'
		matrix outcome[`row_nr', 3] = `r(t`tol')'
		
		local row_nr = `row_nr' + 1

	}

}

* Creating dataset out of matrix "outcome"
svmat outcome, names(col)

* Graph: Average runtime by tolerance level
binscatter Time Tolerance, line(qfit) xq(Tol) ytitle("Time (seconds)") ///
	note("Average time per tolerance level for 100 iterations of AEI")
	
* Summary statistics
tabstat Time, stat(mean sd min max n) by(Tolerance)

* Detailed graph:
bysort Tolerance: egen max = max(Time)
bysort Tolerance: egen min = min(Time)

collapse (mean) Time (firstnm) min max, by(Tolerance)

twoway (scatter Time Tolerance) ///
	   (rarea min max Tolerance, color(gs15))
