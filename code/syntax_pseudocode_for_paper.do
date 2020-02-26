*** Section 3 ***
capture log close

set rmsg off
set more off

*rmdir "${outputdir}/syntax_pseudocode"
*mkdir"${outputdir}/syntax_pseudocode"

**********************
*** Syntax CHECKAX ***
**********************

sjlog using "${outputdir}/syntax_pseudocode/syntax_checkax", replace 

import excel using "${datadir}/prices.xls", clear

mkmat A B C D E, matrix(P)

import excel using "${datadir}/quantities.xls", clear

mkmat A B C D E, matrix(X)

checkax, price(P) quantity(X)

checkax, price(P) quantity(X) axiom(eHARP) efficiency(0.95)

return list

sjlog close, replace

******************
*** Syntax AEI ***
******************

sjlog using "${outputdir}/syntax_pseudocode/syntax_aei", replace 

aei, price(P) quantity(X)

aei, price(P) quantity(X) axiom(eGARP) tolerance(6) suppress

return list

sjlog close, replace

**********************
*** Syntax POWERPS ***
**********************

sjlog using "${outputdir}/syntax_pseudocode/syntax_powerps", replace 

powerps, price(P) quantity(X) axiom(eGARP eHARP)

powerps, price(P) quantity(X) axiom(eGARP eHARP) aei

return list

sjlog close, replace


**************************
*** Pseudocode Powerps ***
**************************

* Importing data not included in log because it's too long
do "${codedir}/importing_andreoni_data.do"

sjlog using "${outputdir}/syntax_pseudocode/pseudocode_powerps", replace 

powerps, price(P) quantity(Q1) axiom(eGARP) efficiency(1)

sjlog close, replace

**************************
*** Pseudocode Table 1 ***
**************************

** Note: code does not show how values are stored and
**		or how the table is made, rather how the results 
**		were calculated.

sjlog using "${outputdir}/syntax_pseudocode/pseudocode_table1", replace 
local axioms eGARP eWGARP eSARP eWARP

forvalues subject = 1/142 {
	
	foreach axiom of local axioms {
	
		checkax, price(P) quantity(Q`subject') axiom(`axiom')
		
	}

	aei, price(P) quantity(Q`subject') axiom(eGARP)

}
sjlog close, replace

***************************
*** Pseudocode figure 1 ***
***************************

sjlog using "${outputdir}/syntax_pseudocode/pseudocode_figure1", replace 

local axioms ewgarp ewarp egarp esarp eharp ecm

foreach axiom of local axioms {
	
	forvalues eff = 700(5)995 {
		
		local nr_pass = 0
		local share_pass = 0
		
			forvalues subject = 1(1)142 {
				
				checkax, price(P) quantity(Q`subject') axiom(`axiom') efficiency(0.`eff') suppress
				
				local nr_pass = `nr_pass' + `r(PASS)'
				local share_pass = `nr_pass'/142

			}
	
	}

}


sjlog close, replace


**************************
*** Pseudocode Table 2 ***
**************************

** Note: Similar to Table 1, except calculated over all subjects.

sjlog using "${outputdir}/syntax_pseudocode/pseudocode_table2", replace 

local axioms eGARP eWGARP eSARP eWARP

forvalues subject = 1/142 {
	
	foreach axiom of local axioms {
	
		checkax, price(P) quantity(Q`subject') axiom(`axiom')
	
	}

	aei, price(P) quantity(Q`subject') axiom(eGARP)

}

sjlog close, replace


******************************************
*** Pseudocode AEI for eWGARP and GARP ***
******************************************

** Note: Showing how real data is loaded,
** but running example on fake data for time.

sjlog using "${outputdir}/syntax_pseudocode/pseudocode_aei_ewgarp_egarp", replace 

use http://www.stata-press.com/data/r16/food.dta, clear

mkmat p1 p2 p3 p4, matrix(P)

forvalues i = 1(1)4 {
	
	gen x`i' = w`i'* expfd/p`i'

}

mkmat x1 x2 x3 x4, matrix(X)

aei, price(P) quantity(X) tolerance(6)

aei, price(P) quantity(X) axiom(eWGARP) tolerance(6)

sjlog close, replace

sjlog using "${outputdir}/syntax_pseudocode/pseudocode_powerps_aei_ewgarp_egarp", replace 

aei, price(P) quantity(X) axiom(eWGARP) tolerance(6)
quietly return list

powerps, price(P) quantity(X) axiom(eWGARP) efficiency(`r(AEI)')

sjlog close, replace

