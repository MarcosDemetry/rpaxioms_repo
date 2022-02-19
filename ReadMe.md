# Stata Module 'rpaxioms' Repository


This repo contains the code, data and output for the Stata module <b>rpaxioms</b>. The module contains three user-written commands: <b>checkax</b>, <b>aei</b> and <b>powerps</b>.

## TL:DR
- <b>checkax</b> tests whether consumer demand data satisfy certain revealed preference axioms at a given efficiency level.
- <b>aei</b> calculates measures of goodness-of-fit when the data violates the axioms.
- <b>powerps</b> calculates the power against uniform random behaviour and predictive success for the axioms at any given efficiency level.
- Available on SSC: <code>ssc install rpaxioms</code>

## Using package

### Install from SSC
```stata
 ssc install rpaxioms
```

### Running checkax
```
 * Checkax with default settings, i.e. axiom(eGARP) and efficiency(1)
 checkax, price(P) quantity(X)
 
 * Checkax with custom settings
 checkax, price(P) quantity(X) axiom(eGARP eWARP) efficiency(0.9)
```

### Running aei
```
 * aei with defualt settings, i.e. axiom(eGARP) and tolerance(6)
 aei, price(P) quantity(X)
 
 * aei with custom settings
 aei, price(P) quantity(X) axiom(eGARP eWGARP eHARP) tolerance(10)
 ```
 ### Running powerps
 ```
 * powerps with default settings, i.e. axiom(eGARP) seed(12345) simulations(1000)
 powerps, price(P) quantity(X)
 
 * powerps with custom settings
 powerps, price(P) quantity(X) axiom(eGARP eHARP) simulations(2000)
 
 powerps, price(P) quantity(X) axiom(eWARP) simulations(1000) aei tolerance(6)
```

### Consult help-files
```
help checkax
help aei
help powerps
```

## Version 2.0 updates coming soon!
- AEI defualt tolerance level set to <code>tolerance(6)</code>, i.e. tolerance of 10^-6
- AEI runs faster for tolerance levels up to <code>tolerance(15)</code>
- Help-files include examples and interpretation of results
- Example data included in package and accessed via <code>sysuse rpaxioms_example_data.dta</code>
- Miscellaneous aesthetic changes (e.g. report result of fraction of violations now in decimal)

## To reproduce results in the paper
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

