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

### Prepare example data
> **_NOTE:_**  ```net get rpaxioms``` downloads the ancillary file __rpaxioms_example_data.dta__ to the user's current working directory. The ancillary file will be uploaded with the coming update to the package on SSC. For now, you can manually access the example dataset in the [help_files folder](https://github.com/MarcosDemetry/rpaxioms_repo/tree/RR/help_files).
```
* Set current working directory where you would like example data to be saved
cwd "/PATH/TO/SOME/FOLDER"

* Download example data that comes with the package
net get rpaxioms

* Load data
use rpaxioms_example_data, clear

* Create price (P) and quantity (X) matrices
mkmat p1-p5, matrix(P)
mkmat x1-x5, matrix(X)
```

<details>
  <summary>Inspect data</summary>

```
 . sum

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
observatio~r |         20        10.5     5.91608          1         20
          p1 |         20         6.4    2.036509          2         10
          p2 |         20         4.1    2.751076          1          9
          p3 |         20        5.65    3.328901          1         10
          p4 |         20           6    2.339591          1         10
-------------+---------------------------------------------------------
          p5 |         20        4.45     2.21181          1          9
          x1 |         20        30.3    8.584564         20         49
          x2 |         20        35.2    9.660555         20         49
          x3 |         20       34.65    8.671035         21         48
          x4 |         20        33.8    8.757553         20         49
-------------+---------------------------------------------------------
          x5 |         20       33.85    8.731522         20         49
 
. matlist P

             |        p1         p2         p3         p4         p5 
-------------+-------------------------------------------------------
          r1 |         8          2          1          6          9 
          r2 |         4          4          5          6          5 
          r3 |         6          6          9          8          2 
          r4 |         6          5          7          1          5 
          r5 |         2          1          6          7          4 
          r6 |         6          3          9          6          5 
          r7 |         7          9          1          2          9 
          r8 |         5          1         10         10          5 
          r9 |         9          9          2          6          4 
         r10 |         8          1          6          5          4 
         r11 |         4          7          2         10          2 
         r12 |         5          6          6          7          3 
         r13 |         4          3          1          5          1 
         r14 |         8          6          8          9          5 
         r15 |         8          2          9          6          3 
         r16 |         5          7         10          6          3 
         r17 |         7          6         10          7          5 
         r18 |        10          1          6          4          2 
         r19 |         8          1          3          3          5 
         r20 |         8          2          2          6          8 
 
. matlist X

             |        x1         x2         x3         x4         x5 
-------------+-------------------------------------------------------
          r1 |        27         22         29         28         43 
          r2 |        44         33         38         27         37 
          r3 |        22         25         48         27         43 
          r4 |        32         20         48         24         40 
          r5 |        20         49         38         49         23 
          r6 |        26         33         30         49         35 
          r7 |        20         49         46         45         30 
          r8 |        25         43         33         42         22 
          r9 |        24         20         48         25         24 
         r10 |        28         41         21         31         26 
         r11 |        25         41         36         25         40 
         r12 |        24         39         42         20         33 
         r13 |        38         37         25         29         41 
         r14 |        47         26         30         41         27 
         r15 |        49         43         25         39         20 
         r16 |        26         27         29         36         36 
         r17 |        34         31         32         33         28 
         r18 |        31         47         37         28         49 
         r19 |        36         46         21         35         48 
         r20 |        28         32         37         43         32 

```

</details>

### Running checkax
```
 * Checkax with default settings, i.e. axiom(eGARP) and efficiency(1)
 checkax, price(P) quantity(X)
 
 * Checkax with custom settings
 checkax, price(P) quantity(X) axiom(eGARP eWARP) efficiency(0.96)
```

<details>
  <summary>See checkax output</summary>

```
. checkax, price(P) quantity(X)

              Number of obs           =      20 
              Number of goods         =       5 
              Efficiency level        =       1 

-----------------------------------------------
       Axiom |      Pass       #vio       %vio 
-------------+---------------------------------
       eGARP |         0        161      .4237 
-----------------------------------------------

. checkax, price(P) quantity(X) axiom(eGARP eWARP) efficiency(0.96)

              Number of obs           =      20 
              Number of goods         =       5 
              Efficiency level        =     .96 

-----------------------------------------------
       Axiom |      Pass       #vio       %vio 
-------------+---------------------------------
       eGARP |         0        112      .2947 
       eWARP |         0          6      .0316 
-----------------------------------------------

```

</details>



### Running aei
```
 * aei with defualt settings, i.e. axiom(eGARP) and tolerance(6)
 aei, price(P) quantity(X)
 
 * aei with custom settings
 aei, price(P) quantity(X) axiom(eGARP eWGARP eHARP) tolerance(10)
 ```

<details>
  <summary>See aei output</summary>

```
. aei, price(P) quantity(X)

    Number of obs           =         20 
    Number of goods         =          5 
    Tolerance level         =    1.0e-06 

-------------------------
       Axiom |       AEI 
-------------+-----------
       eGARP |  .9055848 
-------------------------

. aei, price(P) quantity(X) axiom(eGARP eWGARP eHARP) tolerance(10)

    Number of obs           =         20 
    Number of goods         =          5 
    Tolerance level         =    1.0e-10 

-------------------------
       Axiom |       AEI 
-------------+-----------
       eGARP |  .9055851 
      eWGARP |  .9055851 
       eHARP |  .8449687 
-------------------------

```

</details>

 ### Running powerps
 ```
 * powerps with default settings, i.e. axiom(eGARP) seed(12345) simulations(1000)
 powerps, price(P) quantity(X)
 
 * powerps with custom settings
 powerps, price(P) quantity(X) axiom(eGARP eHARP) simulations(2000)
 
 powerps, price(P) quantity(X) axiom(eWARP) simulations(1000) aei tolerance(6)
```

<details>
  <summary>See powerps output</summary>

```
. powerps, price(P) quantity(X)

                       Number of obs           =        20 
                       Number of goods         =         5 
                       Simulations             =      1000 
                       Efficiency level        =         1 

----------------------------------------------------------
      Axioms |     Power         PS       Pass        AEI 
-------------+--------------------------------------------
       eGARP |      .995      -.005          0   .9055848 
----------------------------------------------------------
 
Summary statistics for simulations:

------------------------------------
       eGARP |      #vio       %vio 
-------------+----------------------
        Mean |    47.339   .1245762 
   Std. Dev. |  29.45589   .0775135 
         Min |         0          0 
          Q1 |        24      .0632 
      Median |        45      .1184 
          Q3 |      68.5     .18025 
         Max |       143      .3763 
------------------------------------

. powerps, price(P) quantity(X) axiom(eGARP eHARP) simulations(2000)

                       Number of obs           =        20 
                       Number of goods         =         5 
                       Simulations             =      2000 
                       Efficiency level        =         1 

----------------------------------------------------------
      Axioms |     Power         PS       Pass        AEI 
-------------+--------------------------------------------
       eGARP |      .994      -.006          0   .9055848 
       eHARP |         1          0          0   .8449683 
----------------------------------------------------------
 
Summary statistics for simulations:

------------------------------------
       eGARP |      #vio       %vio 
-------------+----------------------
        Mean |   47.0755   .1238843 
   Std. Dev. |  29.81487   .0784596 
         Min |         0          0 
          Q1 |        23      .0605 
      Median |        44      .1158 
          Q3 |        68      .1789 
         Max |       151      .3974 
------------------------------------

------------------------------------
       eHARP |      #vio       %vio 
-------------+----------------------
        Mean |        20          1 
   Std. Dev. |         0          0 
         Min |        20          1 
          Q1 |        20          1 
      Median |        20          1 
          Q3 |        20          1 
         Max |        20          1 
------------------------------------

. powerps, price(P) quantity(X) axiom(eWARP) simulations(1000) aei tolerance(6)

                       Number of obs           =        20 
                       Number of goods         =         5 
                       Simulations             =      1000 
                       Efficiency level        =         1 

----------------------------------------------------------
      Axioms |     Power         PS       Pass        AEI 
-------------+--------------------------------------------
       eWARP |      .991      -.009          0   .9055848 
----------------------------------------------------------
 
Summary statistics for simulations:

-----------------------------------------------
       eWARP |      #vio       %vio        AEI 
-------------+---------------------------------
        Mean |     7.842    .041276   .8472549 
   Std. Dev. |  4.637731   .0244045   .0824086 
         Min |         0          0   .5616641 
          Q1 |         4      .0211   .7964668 
      Median |         7      .0368   .8573208 
          Q3 |        10      .0526   .9060616 
         Max |        27      .1421          1 
-----------------------------------------------

```

</details>

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

