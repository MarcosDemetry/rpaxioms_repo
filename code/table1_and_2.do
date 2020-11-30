capture log close
log using "${outputdir}/logs/table1_and_2_`c(current_date)'.log", replace

set rmsg on

*** Programs ***

* Fix headers
capture program drop fixingHeaders
program fixingHeaders

local k = 1
ds
foreach c of varlist `r(varlist)' {
	rename `c' A_`k'
	local k=`k'+1
}

ds 
describe `r(varlist)'
local m=`=`r(k)''
forvalues c = 1/`m' {
	replace A_`c'=A_`c'+"_"+A_`c'[_n-1] if regexm(A_`c',A_`c'[_n-1])!=1 & _n==2
}

drop if _n == 1

quietly describe
quietly return list
display "`r(k)'"

forval j = 1/`r(k)' {
     local try = strtoname(A_`j'[1]) 
     capture rename A_`j'  `try' 
}

drop if _n == 1

destring *, replace

end 


* Creating Excel-file for outputing results
putexcel set "${outputdir}/tables/table1_and_2_data.xlsx", sheet("checkaxiom") replace 

* List of axioms to be tested
local axioms eWGARP eWARP eGARP eSARP eHARP eCM eSGARP

* Value of starting column (1 = A)
local excel_column_local = 1

foreach axiom of local axioms {
	* Column names matrix
	matrix column_names_matrix_`axiom' = J(1,3,.)
	matrix colname column_names_matrix_`axiom' = "`axiom'" "`axiom'" "`axiom'" 
	
	* Results matrix
	matrix resultsmatrix_`axiom' = J(142,3,.)
	matrix colname resultsmatrix_`axiom' = Pass Violations Violations_frac

	forvalues subject = 1(1)142 {

		* Calculating Pass, Number and Frequency of Violations
		quietly checkax, price(P) quantity(Q`subject') axiom(`axiom')
		quietly return list
		
		* Pass indicator
		local pass = r(PASS_`axiom')
		* Number of violations per axiom and subject *
		local violations_number = r(NUM_VIO_`axiom')
		* Fraction of violations per axiom and subject *
		local violations_fraction = r(FRAC_VIO_`axiom')
		
		matrix resultsmatrix_`axiom'[`subject',1] = `pass'
		matrix resultsmatrix_`axiom'[`subject',2] = `violations_number'
		matrix resultsmatrix_`axiom'[`subject',3] = `violations_fraction'

	}

	local col: word `excel_column_local' of `c(ALPHA)'
	putexcel `col'1 = matrix(column_names_matrix_`axiom'), colnames
	putexcel `col'2 = matrix(resultsmatrix_`axiom'), colnames
	
	local excel_column_local = `excel_column_local' + 3

}

* Modifying the excel file with an additional sheet
putexcel set "${outputdir}/tables/table1_and_2_data.xlsx", sheet("aei") modify 

* Value of starting column (1 = A)
local excel_column_local = 1

foreach axiom of local axioms {
	
	* Column names matrix
	matrix column_names_matrix_`axiom' = J(1,1,.)
	matrix colname column_names_matrix_`axiom' = "`axiom'" 
		
	* Results matrix
	matrix resultsmatrix_`axiom' = J(142,1,.)
	matrix colname resultsmatrix_`axiom' = AEI
	
	forvalues subject = 1(1)142 {
		
		* Calculating Affriat Efficiency Index
		quietly aei, price(P) quantity(Q`subject') axiom(`axiom')
		quietly return list
		
		local aei = r(AEI_`axiom')
		
		matrix resultsmatrix_`axiom'[`subject',1] = `aei'
	
	}	
				
	local col: word `excel_column_local' of `c(ALPHA)'
	putexcel `col'1 = matrix(column_names_matrix_`axiom'), colnames
	putexcel `col'2 = matrix(resultsmatrix_`axiom'), colnames
	local excel_column_local = `excel_column_local' + 1

}

*******************
*** Table 1 & 2 ***
*******************

* Table 1 *
putdocx clear
putdocx begin
putdocx paragraph, style(Title) 
putdocx text ("Table 1")

import excel using "${outputdir}/tables/table1_and_2_data.xlsx", sheet("checkaxiom") clear

* Calling program that fixes headers
fixingHeaders

* Creating table
gen subject = _n
order subject

gen andreoniMillerSubjects = (subject == 3 |  subject == 38 | subject == 40 | ///
	subject == 41 | subject == 47 | subject == 61 | subject == 72 | subject == 87 |  ///
	subject == 90 | subject == 90 | subject == 104 | subject == 126 | subject == 137 | ///
	subject == 139)

order subject andreoniMillerSubjects

list subject Violations_eGARP Violations_frac_eGARP ///
	Violations_eWGARP Violations_frac_eWGARP ///
	Violations_eSARP Violations_frac_eSARP ///
	Violations_eWARP Violations_frac_eWARP ///
	Violations_eSGARP Violations_frac_eSGARP if andreoniMillerSubjects == 1

putdocx table Table1 = data(Violations_eGARP Violations_frac_eGARP ///
	Violations_eWGARP Violations_frac_eWGARP ///
	Violations_eSARP Violations_frac_eSARP ///
	Violations_eWARP Violations_frac_eWARP ///
	Violations_eSGARP Violations_frac_eSGARP) if andreoniMillerSubjects == 1, varnames obsno 
	
putdocx table Table1(2/14,2/8), nformat(%12.2f)

putdocx save "${outputdir}/tables/Table1", replace

* Table 2 *
putdocx clear
putdocx begin
putdocx paragraph, style(Title) 
putdocx text ("Table 2")

tabstat Violations_eGARP Violations_frac_eGARP ///
		Violations_eHARP Violations_frac_eHARP ///
		Violations_eCM Violations_frac_eCM ///
		Violations_eSGARP Violations_frac_eSGARP, ///
		stat(mean sd min p25 p50 p75 max) save
	
return list

matrix results = r(StatTotal)

putdocx table Table2 = matrix(results), rownames colnames

putdocx table Table2(.,2/5), nformat(%12.2f)

putdocx save "${outputdir}/tables/Table2", replace


* Table 1 Last Column *
putdocx begin
import excel using "${outputdir}/tables/table1_and_2_data.xlsx", sheet("aei") clear

* Calling program that fixes headers
fixingHeaders

gen subject = _n

gen andreoniMillerSubjects = (subject == 3 |  subject == 38 | subject == 40 | ///
	subject == 41 | subject == 47 | subject == 61 | subject == 72 | subject == 87 |  ///
	subject == 90 | subject == 90 | subject == 104 | subject == 126 | subject == 137 | ///
	subject == 139)

order subject andreoniMillerSubjects

putdocx table Table1 = data(AEI_eGARP) if andreoniMillerSubjects == 1, varnames obsno

putdocx table Table1(.,2), nformat(%12.3f)

putdocx save "${outputdir}/tables/Table1", append

* Table 2 Last Column *
putdocx begin

tabstat AEI_eGARP AEI_eHARP AEI_eCM AEI_eSGARP, stat(mean sd min p25 p50 p75 max) save

matrix results = r(StatTotal)

putdocx table Table2 = matrix(results), rownames colnames nformat(%12.3f) 

*putdocx table Table2(.,2/3), nformat(%10.5g)

putdocx save "${outputdir}/tables/Table2", append




log close
