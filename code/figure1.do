capture log close
log using "${outputdir}/logs/figure1_data_`c(current_date)'.log", replace

set rmsg on

****************
*** Programs ***
****************

capture program drop customSaveImage
program customSaveImage

	local name `1'
	
	foreach extension in eps png pdf {
		graph export "${outputdir}/figures/`name'.`extension'", replace
	}
		
end


******************************
*** Creating Figure 1 data ***
******************************

* Creating Excel-file for outputing results
putexcel set "${outputdir}/tables/figure1_data.xlsx", sheet("checkaxiom") replace 

* Column names matrix
matrix resultsmatrix = J(366,4,.)
matrix colname resultsmatrix = axiom efficiency number_pass share_pass

local axioms eHARP eCM eGARP eSGARP

local axiomnumber = 1
local rownumber = 1
foreach axiom of local axioms {

		*display "`axiom'"
	forvalues eff = 850(5)995 {

		local nr_pass = 0
		local share_pass = 0
		
		forvalues subject = 1(1)142 {
			*display "`subject'"
			
			quietly checkax, price(P) quantity(Q`subject') axiom(`axiom') efficiency(0.`eff')
			quietly return list
			
			local nr_pass = `nr_pass' + `r(PASS_`axiom')'
			local share_pass = `nr_pass'/142

		}

		
		display "Axiom: `axiom'; Efficiency: 0.`eff'; Number Passed: `nr_pass'; Share Passed: `share_pass'"
		matrix resultsmatrix[`rownumber',1] = `axiomnumber'
		matrix resultsmatrix[`rownumber',2] = `eff'
		matrix resultsmatrix[`rownumber',3] = `nr_pass'
		matrix resultsmatrix[`rownumber',4] = `share_pass'
		
				
		local rownumber = `rownumber' + 1

		* Special case for efficiency == 1
		if `eff' == 995 {
			
			local nr_pass = 0
			local share_pass = 0
			
			forvalues subject = 1(1)142 {
				*display "`subject'"
				
				quietly checkax, price(P) quantity(Q`subject') axiom(`axiom') efficiency(1)
				quietly return list
				
				local nr_pass = `nr_pass' + `r(PASS_`axiom')'
				local share_pass = `nr_pass'/142

			}
			
			display "Axiom: `axiom'; Efficiency: 1 ; Number Passed: `nr_pass'; Share Passed: `share_pass'"
			matrix resultsmatrix[`rownumber',1] = `axiomnumber'
			matrix resultsmatrix[`rownumber',2] = 1
			matrix resultsmatrix[`rownumber',3] = `nr_pass'
			matrix resultsmatrix[`rownumber',4] = `share_pass'
			
					
			local rownumber = `rownumber' + 1
			
		}

	}

	local axiomnumber = `axiomnumber' + 1

}

putexcel A1 = matrix(resultsmatrix), colnames

****************
*** Figure 1 ***
****************

import excel "${outputdir}/tables/figure1_data.xlsx", clear firstrow

label define axiomLabels 1 "eHARP" 2 "eCM" 3 "eGARP" 4 "eSGARP"
label value axiom axiomLabels

decode axiom, gen(axiom_str)
drop axiom
rename axiom_str axiom

rename share_pass share_pass_

replace efficiency = 1000 if efficiency == 1
replace efficiency = efficiency/1000

drop if axiom == ""

reshape wide number_pass share_pass_, i(efficiency) j(axiom) string

* Stata journal scheme (manual colors) with legend
twoway	(line share_pass_eHARP e, lcolor(edkblue))	///
		(line share_pass_eCM e, lcolor(orange_red))	///
		(line share_pass_eGARP e, lcolor(gray))	///
		(line share_pass_eSGARP e, lcolor(sand) 	///
		ytitle("Fraction of subjects") xtitle("Efficiency (e)") ///
		ylabel(0(0.1)1, format(%3.1f) angle(horisontal)) ///
		xlabel(0.85(0.01)1, format(%3.2f) angle(vertical)) ///
		legend(order(1 "eHARP" 2 "eCM" 3 "eGARP" 4 "eSGARP")) ///
		scheme(sj))

customSaveImage fig1


log close
