**********************
*** Code for batch ***
**********************
clear
capture log close

cls

log using "${outputdir}/logs/data_for_figure_2_and_3_`c(current_date)'.log", replace


gen axiom = ""
gen subject = .
gen efficiency = .
gen p = .
gen ps = .

* Number of rows in Stata file
local nr_sub = 142
local nr_ax  = 7
local nr_eff = 60
local nr_obs = `nr_sub'*`nr_ax'*`nr_eff'
di `nr_obs'

set obs `nr_obs'

gen id = _n

display "Approximate running time: " as res ((`nr_obs'*6.5)/60)/60 " hours"


* Using POI food data
local axioms eGARP eWGARP eSARP eWARP eHARP eCM eSGARP

local id = 1
foreach axiom of local axioms  {
	
	forvalues eff = 1(-0.01)0.4 {
	
		forvalues subject = 1(1)142 {
			
			display "Now subject nr `subject'; efficiency: " %4.3f `eff' "; axiom `axiom'" as res " (" %5.2f (`id'/`nr_obs')*100 "% )"		
			
			quietly powerps, price(P) quantity(Q`subject') sim(1000) axiom(`axiom') eff(`eff')
			quietly return list
			
			* filling in variables
			replace subject = `subject'			if id == `id'
			replace efficiency = `eff'			if id == `id'
			replace axiom = "`axiom'"			if id == `id'
			replace p = `r(POWER_`axiom')'		if id == `id'
			replace ps = `r(PS_`axiom')'		if id == `id'
			
			local id = `id' + 1

		}
	}

	save "${outputdir}/tables/data_for_figure_2_and_3.dta", replace

}

log close
