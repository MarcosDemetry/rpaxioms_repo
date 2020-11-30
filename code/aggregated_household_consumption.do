
***********************************************
*** AEI for eWGARP and GARP (Poi Food Data) ***
***********************************************

** Note: This takes approx 4.2 hours to run

sjlog using "${outputdir}/syntax_pseudocode/pseudocode_aei_ewgarp_egarp", replace 

use http://www.stata-press.com/data/r16/food.dta, clear

mkmat p1 p2 p3 p4, matrix(P)

forvalues i = 1(1)4 {
	
	gen x`i' = w`i'* expfd/p`i'

}

mkmat x1 x2 x3 x4, matrix(X)

aei, price(P) quantity(X) tolerance(6)

*aei, price(P) quantity(X) axiom(eWGARP) tolerance(6)

sjlog close, replace

sjlog using "${outputdir}/syntax_pseudocode/pseudocode_powerps_aei_ewgarp_egarp_2", replace 

aei, price(P) quantity(X) axiom(eWGARP) tolerance(6)
return list

powerps, price(P) quantity(X) axiom(eWGARP) efficiency(`r(AEI_eWGARP)')

sjlog close, replace

