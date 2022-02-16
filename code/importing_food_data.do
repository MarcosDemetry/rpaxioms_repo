clear all

use http://www.stata-press.com/data/r16/food.dta, clear

mkmat p1 p2 p3 p4, matrix(P)

forvalues i = 1(1)4 {
	
	gen x`i' = w`i'* expfd/p`i'

}

mkmat x1 x2 x3 x4, matrix(X)
