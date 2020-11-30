capture log close
log using "${outputdir}/logs/table3`c(current_date)'.log", replace

foreach ax in eGARP eHARP eCM eSGARP {

	quietly powerps, price(P) quantity(Q1) ax(`ax') aei
	quietly return list
	
	matrix `ax' = r(SUMSTATS_`ax')
}

** Panel A: (Number of violations (fraction)
matselrc eGARP table3a, r(1/7) c(1/2)
matselrc eHARP table3b, r(1/7) c(1/2)
matselrc eCM table3c, r(1/7) c(1/2)
matselrc eSGARP table3d, r(1/7) c(1/2)

matrix table3A = table3a, table3b, table3c, table3d
matlist table3A

** Panel B: AEI
matselrc eGARP table3a, r(1/7) c(3)
matselrc eHARP table3b, r(1/7) c(3)
matselrc eCM table3c, r(1/7) c(3)
matselrc eSGARP table3d, r(1/7) c(3)

matrix table3B = table3a, table3b, table3c, table3d
matlist table3B

** Table 3
matrix table3 = table3A, table3B
matlist table3

matrix coln table3 = eGARP:#vio eGARP:%vio eHARP:#vio eHARP:%vio ///
					 eCM:#vio eCM:%vio eSGARP:#vio eSGARP:%vio ///
					 GARP:AEI HARP:AEI CM:AEI SGARP:AEI
matlist table3

* Exporting table
putdocx clear
putdocx begin
putdocx paragraph, style(Title) 
putdocx text ("Table 3")

putdocx table Table3 = matrix(table3), rownames colnames

putdocx save "${outputdir}/tables/Table3", replace


log close
