clear
capture log close
set more off

log using "${outputdir}/logs/powerps_speed_results.log", replace

* Importing Andreoni and Miller (2001) data
do "${codedir}/importing_andreoni_data.do"

set rmsg on

/// Running powerps with aei for 5 subjects; 10k & 50k simulations.
timer clear 1

local timer_nr = 1

foreach simulations in 1000 10000 50000 {
	
	timer on `timer_nr'
	
	forvalues subject = 1/5 {
		
		di "Simulations: `simulations'; Subject: `subject'"
		
		powerps, price(P) quantity(Q`subject') sim(`simulations') aei axiom(all) progress

	}
	
	timer off `timer_nr'
	
	local timer_nr = `timer_nr' + 1 
	
}

timer list

log close