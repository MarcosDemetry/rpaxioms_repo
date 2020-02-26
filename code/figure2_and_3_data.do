**********************
*** Code for batch ***
**********************
clear
capture log close

cls

log using "${outputdir}/logs/figure2_3_4_data_stationary3c_`c(current_date)'.log", replace


gen axiom = ""
gen subject = .
gen efficiency = .
gen p = .
gen ps = .

* Number of rows in Stata file
local nr_sub = 142
local nr_ax  = 6
local nr_eff = 1
local nr_obs = `nr_sub'*`nr_ax'*`nr_eff'
di `nr_obs'

set obs `nr_obs'

gen id = _n

* Using POI food data
local axioms eGARP eWGARP eSARP eWARP eHARP eSLD

local id = 1
forvalues subject = 1(1)142 {
		foreach axiom of local axioms {
			
			
			display "Now subject nr `subject'; efficiency: `eff'; axiom `axiom'"		
			di `eff'

			powerps, price(P) quantity(Q`subject') sim(1000) axiom(`axiom') eff(1) suppress
			quietly return list
			
			* filling in variables
			replace subject = `subject'	if id == `id'
			replace efficiency = 1		if id == `id'
			replace axiom = "`axiom'"	if id == `id'
			replace p = `r(POWER)'		if id == `id'
			replace ps = `r(PS)'		if id == `id'
			
			local id = `id' + 1
}
	
	
	save "${outputdir}/tables/figure2_3_4_data_stationary3a.dta", replace

}

log close

exit



************

local tempaxs eHARP eSLD

foreach axiom of local tempaxs {
	forvalues eff = 70(-1)50 {
		
		powerps, price(P) quantity(Q1) sim(100) axiom(`axiom') eff(0.`eff') suppress
		
		di "Axiom: `axiom'; Efficiency: `eff'; Power: `r(POWER)'"
		
		if `r(POWER)' == 0 {
			exit
		}
		
	}
}
