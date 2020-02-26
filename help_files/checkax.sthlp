{smcl}
{* *! version 1.00 21february2020}{...}
{viewerjumpto ”Syntax” ”checkax##syntax”}{...}
{viewerjumpto ”Description” ”checkax##description”}{...}
{viewerjumpto ”Options” ”checkax##options”}{...}
{viewerjumpto ”Examples” ”checkax##examples”}{...}
{viewerjumpto ”Saved results” ”checkax##saved_results”}{...}
{viewerjumpto ”Authors” ”checkax##authors”}{...}
{viewerjumpto ”Acknowledgements” ”checkax##acknowledgements”}{...}
{title:Title}

{p2colset 4 19 21 2}{...}
{p2col :{hi:checkax} {hline 2}} Testing Axioms of Revealed Preference{p_end}
{p2colreset}{...}

{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:checkax}
{it: price(mname) quantity(mname)} [{cmd:,} {it: options}]
{p_end}


{synoptset 26 tabbed}{...}
{synopthdr:options}
{synoptline}
		
{syntab : Efficiency}
{synopt :{opth eff:iciency(checkax##axiom:efficiency)}} specifies the efficiency 
level at which the user would like to test the data. The default efficiency level is 
default is {bf:efficiency(1)}.{p_end}

{syntab : Axiom}
{synopt :{opth ax:iom(checkax##axiom:axiom)}} specifies which axiom the user would like to use in testing the data for consistency. The default is {bf: axiom(eGARP)}. In total, there are six axioms that can be tested: eGARP, eWARP, eWGARP, eSARP, eHARP and eCM.{p_end}

{syntab : suppress}
{synopt :{opth suppress:(checkax##suppress:suppress)}} specifies that the user does not want the results displayed in a table. The default is that {bf: suppress} is {if: not} specified. Whether or not this option is specified, the command results are retrievable from {bf: return list}.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{opt checkax} tests whether consumer demand data satisfy certain revealed preference axioms at a given efficiency level. The command implements Varian's (1982) algorithm to test

{pstd}
Binned scatterplots provide a non-parametric way of visualizing the relationship between two variables.
With a large number of observations, a scatterplot that plots every data point would become too crowded
to interpret visually.  {cmd:binscatter} groups the x-axis variable into equal-sized bins, computes the
mean of the x-axis and y-axis variables within each bin, then creates a scatterplot of these data points.
The result is a non-parametric visualization of the conditional expectation function.

{marker axiom}{...}
{dlgtab: Axiom}

{marker axiom}{...}
{synopt: {phang}{opth ax:iom(binscatter##axiom:axiom)}}specifies the type of axiom that will be tested.{p_end}
The default is {bf:WGARPe}, which does X and Y.  Other options are {bf:WGARP}, {bf:WARP}, {bf:GARP}, {bf:SARP}, {bf:HARP}.{p_end}

{marker fit_line}{...}
{dlgtab:Fit Line}

{marker linetype}{...}
{phang}{opth line:type(binscatter##linetype:linetype)} specifies the type of line plotted on each series.
The default is {bf:lfit}, which plots a linear fit line.  Other options are {bf:qfit} for a quadratic fit line,
{bf:connect} for connected points, and {bf:none} for no line.
