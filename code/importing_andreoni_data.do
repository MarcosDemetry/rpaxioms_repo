** Importing andreoni data **

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

