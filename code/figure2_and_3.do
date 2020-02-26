capture log close
log using "${outputdir}/logs/figure2_and_3_`c(current_date)'.log", replace

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


use "${outputdir}/tables/figure2_and_3_data_combined.dta", clear

drop if axiom == ""

************
*** Prep ***
************

* Calculating avg power and ps per axiom and efficiency level
foreach var of varlist p ps {
	
	bysort axiom efficiency: egen `var'_avg = mean(`var')

}

* Tag for figures
egen tag = tag(axiom efficiency)

replace efficiency = efficiency/100

****************
*** Figure 2 ***
****************

* Stata journal scheme (manual colors) with legend
twoway	(line p_avg efficiency if tag & axiom == "eHARP", lcolor(edkblue))		///
		(line p_avg efficiency if tag & axiom == "eCM", lcolor(orange_red))	///
		(line p_avg efficiency if tag & axiom == "eGARP", lcolor(gray))			///
		(line p_avg efficiency if tag & axiom == "eWGARP", lcolor(sand))		///
		(line p_avg efficiency if tag & axiom == "eSARP", lcolor(blue))			///
		(line p_avg efficiency if tag & axiom == "eWARP", lcolor(forest_green) 	///
		ytitle("Power") xtitle("Efficiency (e)")		///
		ylabel(0(0.1)1, format(%3.1f) angle(horisontal)) ///
		xlabel(0.4(0.05)1, format(%3.2f) angle(vertical)) ///
		legend(order(1 "eHARP" 2 "eCM" 3 "eGARP" 4 "eWGARP" 5 "eSARP" 6 "eWARP") rows(2)) ///
		scheme(sj))
		
customSaveImage fig2

***************************
*** Figure 3: Panel (a) ***
***************************

 * Stata journal scheme (manual colors) with legend
twoway	(line ps_avg efficiency if tag & axiom == "eHARP", lcolor(edkblue))		///
		(line ps_avg efficiency if tag & axiom == "eCM", lcolor(orange_red))	///
		(line ps_avg efficiency if tag & axiom == "eGARP", lcolor(gray))		///
		(line ps_avg efficiency if tag & axiom == "eWGARP", lcolor(sand))		///
		(line ps_avg efficiency if tag & axiom == "eSARP", lcolor(blue))		///
		(line ps_avg efficiency if tag & axiom == "eWARP", lcolor(forest_green) ///
		title("(a)") ytitle("Mean Predictive Success") xtitle("Efficiency (e)")  ///
		ylabel(0(0.1)1, format(%3.1f) angle(horisontal))						///
		xlabel(0.4(0.05)1, format(%3.2f) angle(vertical))						///
		legend(order(1 "eHARP" 2 "eCM" 3 "eGARP" 4 "eWGARP" 5 "eSARP" 6 "eWARP") rows(2)) ///
		scheme(sj) name(fig3_panel_a, replace))

************************************
*** Figure 3a, 3b, 3c: panel (b) ***
************************************
preserve

gen ps_egarp = ps if axiom == "eGARP"
gen ps_eharp = ps if axiom == "eHARP"

collapse (firstnm) ps_egarp ps_eharp, by(subject efficiency)

label var ps_egarp "Predictive Success (eGARP)"
label var ps_eharp "Predictive Success (eHARP)"

 * fig3a: At efficiency level == 1
twoway (scatter ps_egarp ps_eharp if efficiency == 1, msize(small) ///
		ytitle("Predictive Success (eGARP)")	///
		xtitle("Predictive Success (eHARP)")	///
		title("(b)")					///		
		ylabel(-0.65(0.1)1, format(%3.1f) angle(horisontal)) ///
		xlabel(-0.65(0.1)1, format(%3.1f) angle(vertical)) ///
		scheme(sj) name(fig3a_panel_b, replace)) ||	///
		(line ps_eharp ps_eharp, sort legend(off))


 * fig3b: All efficiency levels
twoway (scatter ps_egarp ps_eharp, ///
		ytitle("Predictive Success (eGARP)")	///
		xtitle("Predictive Success (eHARP)")	///
		title("(b)")					///		
		ylabel(-0.65(0.1)1, format(%3.1f) angle(horisontal)) ///
		xlabel(-0.65(0.1)1, format(%3.1f) angle(vertical)) ///
		scheme(sj) name(fig3b_panel_b, replace)) ||	///
		(line ps_eharp ps_eharp, sort legend(off))


 * fig3c: All efficiency levels; with marker labels att certain levels
gen efficiency_mlabel = efficiency if efficiency == 0.7 |efficiency == 0.8 | efficiency == 0.9 | efficiency == 1
tostring efficiency_mlabel, replace
replace efficiency_mlabel = "" if efficiency_mlabel == "."

twoway (scatter ps_egarp ps_eharp, mlabel(efficiency_mlabel) mlabposition(4) msize(vsmall) ///
		ytitle("Predictive Success (eGARP)")	///
		xtitle("Predictive Success (eHARP)")	///
		title("(b)")					///		
		ylabel(-0.7(0.1)1, format(%3.1f) angle(horisontal)) ///
		xlabel(-0.7(0.1)1, format(%3.1f) angle(vertical)) ///
		scheme(sj) name(fig3c_panel_b, replace)) ||	///
		(line ps_eharp ps_eharp, sort legend(off))

export excel using "${datadir}/figure3_panelb_data.xlsx", replace firstrow(variables)
		
restore

*************************
*** Figure 3 combined ***
*************************
foreach letter in a b c {
	
	grc1leg fig3_panel_a fig3`letter'_panel_b, commonscheme scheme(sj) legendfrom(fig3_panel_a)
	customSaveImage fig3`letter'

}

log close
