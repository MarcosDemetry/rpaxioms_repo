# Stata Module 'rpaxioms' Repository


This repo contains the code, data and output for the Stata module <b>rpaxioms</b>. The module contains three user-written commands: <b>checkax</b>, <b>aei</b> and <b>powerps</b>.

## TL:DR
- <b>checkax</b> tests whether consumer demand data satisfy certain revealed preference axioms at a given efficiency level.
- <b>aei</b> calculates measures of goodness-of-fit when the data violates the axioms.
- <b>powerps</b> calculates the power against uniform random behaviour and predictive success for the axioms at any given efficiency level.

## To reproduce results
To reproduce the results: 
1. Open do-file master.do 
2. Change global stem with your path to the folder _rpaxioms_repo_ 
3. Run master.do

** Note: Some sections take several hours to run. Comment and uncomment as you please, and use the available data.

## Suggestions or bugs?
We appreciate all suggestions! Raise an issue describing the problem or request a certain feature to be added or modified.

# IFN Working Paper
You can read more about the theoretical background and technical descriptions of the commands in Demetry, Hjertstrand and Polisson (2020) "[Testing Axioms of Revealed Preference in Stata.](https://www.ifn.se/media/xf4bpowg/wp1342.pdf)" _IFN Working Paper No. 1342_.

## Cite
- To cite the WP:

Demetry, Marcos, Per Hjertstrand and Matthew Polisson (2020), "Testing Axioms of Revealed Preference in Stata". IFN Working Paper No. 1342. Stockholm: Research Institute of Industrial Economics (IFN).

- To cite the code:

Marcos Demetry & Per Hjertstrand & Matthew Polisson, 2020. "RPAXIOMS: Stata module to test and evaluate axioms of revealed preferences," Statistical Software Components S458800, Boston College Department of Economics, revised 26 Nov 2020.

