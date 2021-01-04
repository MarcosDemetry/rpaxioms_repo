***********************************
*** Video Demonstrations Script ***
***********************************

set rmsg off
cls

***************
*** CHECKAX ***
***************

matlist P
matlist X

* Defaults
checkax, price(P) quantity(X) axiom(eGARP) efficiency(1)
checkax, price(P) quantity(X) axiom(eGARP)
checkax, price(P) quantity(X)

* Not default example
checkax, price(P) quantity(X) axiom(eGARP eWARP) efficiency(0.92)

* First error
checkax, price(P)
checkax, quantity(X)

* Abbreviations
checkax, p(P) q(X) ax(eGARP) eff(1)

* Case-insensitive axiom names
checkax, price(P) quantity(X) axiom(egarp)

* Exception handling
	* Axiom
checkax, price(P) quantity(X) axiom(Hello World)

	* Efficiency
checkax, price(P) quantity(X) axiom(eGARP) efficiency(20)
checkax, price(P) quantity(X) axiom(eGARP) efficiency(-2)
checkax, price(P) quantity(X) axiom(eGARP) efficiency(0)

	* Matrix Values & Dimensions
matlist P_NEG
checkax, price(P_NEG) quantity(X)

matlist P_DIM
matlist X
checkax, price(P_DIM) quantity(X)

matlist X_OK
matlist X_NOTOK
checkax, price(P) quantity(X_OK)
checkax, price(P) quantity(X_NOTOK)

* Return list
checkax, price(P) quantity(X) axiom(eGARP) efficiency(1) 
return list

* Example: Loop through efficiency and plot
clear
cls

local start_value 75

local nrObs = 101 - `start_value'

set obs `nrObs'

gen ID = _n + `start_value' - 1

foreach axiom in eGARP eHARP eWARP {
	
	gen eff_`axiom' = .
	gen num_vio_`axiom' = .
	gen frac_vio_`axiom' = .

	forvalues eff = `start_value'(1)99 {

		quietly checkax, price(P) quantity(X) efficiency(0.`eff') axiom(`axiom')

		replace eff_`axiom' = r(EFF)					if ID == `eff'
		replace num_vio_`axiom' = r(NUM_VIO_`axiom')	if ID == `eff'
		replace frac_vio_`axiom' = r(FRAC_VIO_`axiom')	if ID == `eff'

	}

	quietly checkax, price(P) quantity(X) efficiency(1) axiom(`axiom')
	quietly return list

	replace eff_`axiom' = r(EFF)						if ID == 100
	replace num_vio_`axiom' = r(NUM_VIO_`axiom')	    if ID == 100
	replace frac_vio_`axiom' = r(FRAC_VIO_`axiom')		if ID == 100
}

twoway (line frac_vio_eGARP eff_eGARP) ///
	   (line frac_vio_eWARP eff_eWARP) ///
	   (line frac_vio_eHARP eff_eHARP, title("Checkax results") 	///
	ytitle("Violations (%)") xtitle("Efficiency"))

***********
*** AEI ***
***********
cls

matlist P
matlist X

aei, price(P) quantity(X) axiom(eGARP) tolerance(12)
aei, price(P) quantity(X) axiom(eGARP) 
aei, price(P) quantity(X)

aei, p(P) q(X) ax(eGARP) tol(6)
return list


***************
*** POWERPS ***
***************
cls

matlist P
matlist X

powerps, price(P) quantity(X) axiom(eGARP) efficiency(1) simulations(100) seed(12345)
powerps, price(P) quantity(X) axiom(eGARP) efficiency(1) simulations(100) 
powerps, price(P) quantity(X) axiom(eGARP) simulations(100)
powerps, price(P) quantity(X) simulations(100)

powerps, p(P) q(X) ax(eGARP) eff(1) sim(100) seed(12345)

* Retrieving raw simulation results
powerps, price(P) quantity(X) sim(10)
return list
matlist r(SIMRESULTS_eGARP)

* None-default examples
powerps, price(P) quantity(X) simulations(10) aei

powerps, p(P) q(X) ax(eGARP) eff(0.84) sim(100) seed(101010)

* Testing several axioms at once
powerps, price(P) quantity(X) simulations(10) axiom(eGARP)

powerps, price(P) quantity(X) simulations(10) axiom(eGARP eHARP)
return list

powerps, price(P) quantity(X) simulations(10) axiom(eWARP eCM)

powerps, price(P) quantity(X) simulations(10) axiom(all)

* Progress bar
powerps, price(P) quantity(X) sim(200) progress
return list


***************
*** GENERAL ***
***************

* Common syntax allows for looping over commands

foreach command in checkax aei /* powerps */ {
	
	foreach axiom in eGARP eWGARP eHARP eSARP eSLD {
	
		`command', price(P) quantity(X) axiom(`axiom')
	
	}
}


* Example: Loop through PowerPS & plot
clear
cls
set obs 100

gen p = .
gen ps = .
gen eff = .

local start_value 50

gen ID = _n + `start_value' - 1

gen frac_vio = .
forvalues efficiency = `start_value'(1)99 {

	powerps, price(P) quantity(X) eff(0.`efficiency') sim(100) progress
	quietly return list
	
	replace eff = r(EFFICIENCY)		if ID == `eff'
	replace p = r(POWER)	if ID == `efficiency'
	replace ps = r(PS)		if ID == `efficiency'

}

replace eff = _n + 49

powerps, price(P) quantity(X) eff(1)
quietly return list
replace p = r(POWER)		if ID == 100 
replace ps = r(PS)			if ID == 100

twoway (line p eff) (line ps eff), title("eGARP") ytitle("Power &" "Predictive Success") xtitle("Efficiency")
*graph save using "${outputdir}/figures/power_ps_efficiency.gph", replace
*graph export using "${outputdir}/figures/power_ps_efficiency.png", replace








