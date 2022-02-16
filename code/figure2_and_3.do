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


*use "${outputdir}/tables/figure2_and_3_data_combined.dta", clear
use "${outputdir}/tables/data_for_figure_2_and_3", clear

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

*replace efficiency = efficiency/100

****************
*** Figure 2 ***
****************

* Stata journal scheme (manual colors) with legend
twoway	(line p_avg efficiency if tag & axiom == "eGARP", lcolor(gray))		///
		(line p_avg efficiency if tag & axiom == "eSGARP", lcolor(sand))	///
		(line p_avg efficiency if tag & axiom == "eHARP", lcolor(edkblue))	///
		(line p_avg efficiency if tag & axiom == "eCM", lcolor(orange_red)	///
		ytitle("Power") xtitle("Efficiency (e)")		///
		ylabel(0(0.1)1, format(%3.1f) angle(horisontal)) ///
		xlabel(0.4(0.05)1, format(%3.2f) angle(vertical)) ///
		legend(order(1 "eGARP" 2 "eSGARP" 3 "eHARP" 4 "eCM") rows(2)) ///
		scheme(sj))
		
customSaveImage fig2

***************************
*** Figure 3: Panel (a) ***
***************************

 * Stata journal scheme (manual colors) with legend
twoway	(line ps_avg efficiency if tag & axiom == "eGARP", lcolor(gray))		///
		(line ps_avg efficiency if tag & axiom == "eSGARP", lcolor(sand))		///
		(line ps_avg efficiency if tag & axiom == "eHARP", lcolor(edkblue))		///
		(line ps_avg efficiency if tag & axiom == "eCM", lcolor(orange_red)		///
		title("(a)") ytitle("Mean Predictive Success") xtitle("Efficiency (e)")  ///
		ylabel(-0.3(0.1)1, format(%3.1f) angle(horisontal))						///
		xlabel(0.4(0.05)1, format(%3.2f) angle(vertical))						///
		legend(order(1 "eGARP" 2 "eSGARP" 3 "eHARP" 4 "eCM") rows(2)) ///
		scheme(sj) name(fig3_panel_a, replace))

***************************
*** Figure 3: panel (b) ***
***************************
preserve

gen ps_egarp = ps if axiom == "eGARP"
gen ps_eharp = ps if axiom == "eHARP"

collapse (firstnm) ps_egarp ps_eharp, by(subject efficiency)

label var ps_egarp "Predictive Success (eGARP)"
label var ps_eharp "Predictive Success (eHARP)"


 * fig3B: Specific efficiency levels, with marker labels and color coding
gen effStr = strofreal(efficiency)
gen effLab = effStr if effStr == "1" | effStr == ".95" | effStr == ".9"

gl mOptions "mlabel(effLab) mlabposition(4) msize(medium) msymbol(D)"

twoway	(scatter ps_egarp ps_eharp if effLab == "1", mcolor(red) $mOptions) ///
		(scatter ps_egarp ps_eharp if effLab == ".95", mcolor(blue) $mOptions) ///
		(scatter ps_egarp ps_eharp if effLab == ".9", mcolor(green) $mOptions ///
		ytitle("Predictive Success (eGARP)")	///
		xtitle("Predictive Success (eHARP)")	///
		title("(b)")					///		
		ylabel(-0.7(0.1)1, format(%3.1f) angle(horisontal)) ///
		xlabel(-0.7(0.1)1, format(%3.1f) angle(vertical)) ///
		scheme(sj) name(fig3_panel_b, replace)) ||	///
		(line ps_eharp ps_eharp, lpattern(dash) sort legend(off))

export excel using "${datadir}/figure3_panelb_data.xlsx", replace firstrow(variables)
		
restore

*************************
*** Figure 3 combined ***
*************************

grc1leg fig3_panel_a fig3_panel_b, commonscheme scheme(sj) legendfrom(fig3_panel_a)
customSaveImage fig3


log close
