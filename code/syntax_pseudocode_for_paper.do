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

checkax, price(P) quantity(X) axiom(eGARP eHARP) efficiency(0.95)

return list

sjlog close, replace

******************
*** Syntax AEI ***
******************

sjlog using "${outputdir}/syntax_pseudocode/syntax_aei", replace 

aei, price(P) quantity(X)

quietly aei, price(P) quantity(X) axiom(eGARP eHARP) tolerance(6)

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
				
				quietly checkax, price(P) quantity(Q`subject') axiom(`axiom') efficiency(0.`eff')
				
				local nr_pass = `nr_pass' + `r(PASS_`axiom')'
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

