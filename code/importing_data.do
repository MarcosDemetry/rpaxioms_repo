* This do-file imports data

local data_panel_test		0
local data_mat_test			1
local data_mat_food			0
local data_mat_andreoni		0

if `data_panel_test' {
clear all

cd "${datadir}"

tempfile pricedata

* Importing prices
import excel using "prices.xls", clear

* Renaming price vars
capture {
	local i = 1
	foreach j in `c(ALPHA)' {
		rename `j' P`i'	
		local i = `i' + 1
	}
}

* Creating time identifier
gen T = _n

save `pricedata'

* Importing quantities
import excel using "quantities.xls", clear

* Renaming quantity vars
capture {
	local i = 1
	foreach j in `c(ALPHA)' {
		rename `j' Q`i'	
		local i = `i' + 1
	}
}

* Creating ime identifier
gen T = _n

* Merging quantity data with price data
merge 1:1 T using `pricedata', nogen

* Reshaping data as panel
reshape long Q P , i(T) j(K)

* Renaming variables for compatibility
rename (T K Q P) (period good quantity price)

* Structuring & saving
order good period quantity price

save panel_data, replace

}


if `data_mat_test' {

clear all

cd "${datadir}"

import excel using "prices.xls", clear

mkmat A B C D E, matrix(P)

import excel using "quantities.xls", clear

mkmat A B C D E, matrix(X)

** Creating matrices for exception-handling examples

	* Dimensions different in either matrix
matrix P_DIM = P[1..10,1..5]

	* Price matrix with negative prices
matrix P_NEG = P
matrix P_NEG[1,1] = -2
matrix P_NEG[1,2] = -5

	* Quantity matrix: 1 time-period with 1 positive and 4 null-quantity
matrix X_OK = X
matrix X_OK[1,1] = 0
matrix X_OK[1,2] = 0
matrix X_OK[1,3] = 0
matrix X_OK[1,4] = 0

	* Quantity matrix: 1 time-period with 0 positive and 5 null-quantity
matrix X_NOTOK = X
matrix X_NOTOK[1,1] = 0
matrix X_NOTOK[1,2] = 0
matrix X_NOTOK[1,3] = 0
matrix X_NOTOK[1,4] = 0
matrix X_NOTOK[1,5] = 0



*matrix P = P[1..4,1..5]
*matrix X = X[1..4,1..5]

}


if `data_mat_food' {

clear all

use "${datadir}/food", clear

mkmat p1 p2 p3 p4, matrix(P)

mkmat w1 w2 w3 w4, matrix(X)

}


if `data_mat_andreoni' {
clear all

import delimited using "${datadir}/qHOLD_E1.txt", clear delim(" ")

mkmat v1 v2 v3 v4 v5 v6 v7 v8, matrix(qHOLD)

import delimited using "${datadir}/qPASS_E1.txt", clear delim(" ")

mkmat v1 v2 v3 v4 v5 v6 v7 v8, matrix(qPASS)

gen v9 = _n

mkmat v9, matrix(SUB_NUM)

mata:
	
	//Loading data to mata
	qHOLD = st_matrix("qHOLD")
	qPASS = st_matrix("qPASS")
	
	//Number of time periods
	T = cols(qHOLD)

	//Empty price matrix
	P = J(T, 2, .)
	
	//Filling in price matrix...
		// for the first good
	P[1,1] = 1/3
	P[2,1] = 1
	P[3,1] = 1/2
	P[4,1] = 1
	P[5,1] = 1/2
	P[6,1] = 1
	P[7,1] = 1
	P[8,1] = 1
		// for the second good
	P[1,2] = 1
	P[2,2] = 1/3
	P[3,2] = 1
	P[4,2] = 1/2
	P[5,2] = 1
	P[6,2] = 1/2
	P[7,2] = 1
	P[8,2] = 1
		//Exporting price matrix
	st_matrix("P", P)

	//Setting expenditure
	TE = J(T, 1, .)
	
	TE[1] = 40
	TE[2] = 40
	TE[3] = 60
	TE[4] = 60
	TE[5] = 75
	TE[6] = 75
	TE[7] = 60
	TE[8] = 100
		//Exporting TE matrix
	st_matrix("TE", TE)
	
	//Subjects
	SUB = rows(qHOLD)
	SUB_NUM = st_matrix("SUB_NUM")

	disptext = "Subject: "
	Q = J(T,2,.)
	
	for (sub = 1; sub<=SUB; sub++) {
		display(disptext)
		sub
		
		//Creating quantity matrix per subject
		Q`sub'[.,1] = qHOLD[sub,.]'
		Q`sub'[.,2] = qPASS[sub,.]'
		Q`sub'
		
		//Exporting matrices to Stata
		st_matrix("Q"+strofreal(sub), Q`sub')

	}
	
	
end




}




