**Generate minimum school leaving age data

use "/Users/nattavudhpowdthavee/Dropbox/UKHLS/caring dementia/xwavedat.dta", clear
keep pidp birthy scend feend generation lmar1y paedqf racel_dv ukborn
sort pidp
save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling.dta", replace

use "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/c_indresp_protect.dta"
renpfix c_
keep hidp pidp big5* birth*
gen round = 3
sort pidp 
save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/big5.dta", replace

**Merge schooling with personality traits

merge 1:1 pidp using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling.dta" 
drop _merge
save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect.dta", replace

use "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/d_indresp_protect.dta"
renpfix d_
gen round=4 
keep hidp pno pidp sex env*  marstat jbstat   oprlg* nch* dvage  paj* maj* env* qfhigh_dv/*
*/  scghq* sclfsato bty* prfit* fim* disd* sf* hcond* aid* naid* gor_dv round  birth* scenv* carb* scopecl* vote*
sort hidp
save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/ind_round4.dta", replace


use "/Users/nattavudhpowdthavee/Dropbox/UKHLS/caring dementia/d_hhresp.dta"
renpfix d_
gen round=4
sort hidp  
save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/hh_round4.dta", replace

merge 1:m hidp using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/ind_round4.dta"
drop _m
sort pidp round
by pidp round: egen s= seq()
drop if s>1
sort pidp 
save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/merge_round4.dta", replace

**Merge
 
sort pidp
merge 1:1 pidp using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect.dta"
drop _m
drop if round==.
save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect.dta", replace


**Clean
replace scend = . if scend<0
replace intdatey = . if intdatey<0
** Gen year at 15 **
gen leftat14 = 0 if scend~=.
replace leftat14 = 1 if scend<=14
gen leftat15 = 0 if scend~=.
replace leftat15 = 1 if scend<=15
gen stayafter15 = 0 if scend~=.
replace stayafter15 = 1 if scend>15
gen leftat16 = 0 if scend~=.
replace leftat16 = 1 if scend<=16

**Gen quarter birth month

gen quarter = 1 if birthm >=1 & birthm<=3
replace quarter = 2 if birthm >=4 & birthm<=6
replace quarter = 3 if birthm >=7 & birthm<=9
replace quarter = 4 if birthm >=10 & birthm<=12

gen qb_year = birthy*10 +  quarter  if birthy>0

replace qb_year = qb_year/10
 
keep if round==4


gen mb_year = birthy*100 + birthm


gen cut_1972 = 0 if qb_year<=1957.3
replace cut_1972 = 1 if qb_year>1957.3

gen cut_1944 = 0 if qb_year<=1933.2
replace cut_1944 = 1 if qb_year>1933.2

**environment

gen envh1 = 0 if envhabit1 <=5 & envhabit1 >=4
replace envh1 = 1 if envhabit1 >=1 & envhabit1 <=3
lab var envh1 "Habit: Leave TV on standby overnight"

gen envh2 = 0 if envhabit2 <=5 & envhabit2 >=4
replace envh2 = 1 if envhabit2 >=1 & envhabit2 <=3
lab var envh2 "Habit: Switch off lights in rooms that aren't being used"

gen envh3 = 0 if envhabit3 <=5 & envhabit3 >=4
replace envh3 = 1 if envhabit3 >=1 & envhabit3 <=3
lab var envh3 "Habit: Keep the tap running while you brush your teeth"

gen envh4 = 0 if envhabit4 <=5 & envhabit4 >=4
replace envh4 = 1 if envhabit4 >=1 & envhabit4 <=3
lab var envh4 "Habit: Put more clothes on when you feel cold rather than putting the heating on"

gen envh5 = 0 if envhabit5 <=5 & envhabit5 >=4
replace envh5 = 1 if envhabit5 >=1 & envhabit5 <=3
lab var envh5 "Habit: Decide not to buy something because you feel it has too much packaging"

gen envh6 = 0 if envhabit6 <=5 & envhabit6 >=4
replace envh6 = 1 if envhabit6 >=1 & envhabit6 <=3
lab var envh6 "Habit: Buy recycled paper products such as toilet papers or tissues"

gen envh7 = 0 if envhabit7 <=5 & envhabit7 >=4
replace envh7 = 1 if envhabit7 >=1 & envhabit7 <=3
lab var envh7 "Habit: Take your own shopping bag when shopping"

gen envh8 = 0 if envhabit8 <=5 & envhabit8 >=4
replace envh8 = 1 if envhabit8 >=1 & envhabit8 <=3
lab var envh8 "Habit: Use public transport rather than travel by car"

gen envh9 = 0 if envhabit9 <=5 & envhabit9 >=4
replace envh9 = 1 if envhabit9 >=1 & envhabit9 <=3
lab var envh9 "Habit: Walk or cycle for short journeys less than 2 or 3 miles"

gen envh10 = 0 if envhabit10 <=5 & envhabit10 >=4
replace envh10 = 1 if envhabit10 >=1 & envhabit10 <=3
lab var envh9 "Habit: Car share with others who need to make a similar journey"

gen envh11 = 0 if envhabit11 <=5 & envhabit11 >=4
replace envh11 = 1 if envhabit11 >=1 & envhabit11 <=3
lab var envh11 "Habit: Take fewer flights when possible"

**Attitude towards environment

replace scenv_tlat = . if scenv_tlat<0
replace scenv_nowo = . if scenv_nowo <0
replace scenv_noot  = . if scenv_noot <0
replace scenv_canc = . if scenv_canc <0
replace scenv_ftst = . if scenv_ftst<0
replace scenv_fitl = . if scenv_fitl<0
replace scenv_crlf = . if scenv_crlf<0
replace scenv_grn  = . if scenv_grn <0
replace scenv_bccc  = . if scenv_bccc <0
replace scenv_pmep  = . if scenv_pmep <0
replace scenv_meds   = . if scenv_meds  <0
replace scenv_crex   = . if scenv_crex  <0
 
 
 revrs scenv_tlat, replace
 revrs scenv_nowo, replace
 revrs scenv_noot, replace
 revrs scenv_canc, replace
 revrs scenv_ftst, replace
 
 revrs scenv_grn, replace
 revrs scenv_bccc, replace
 revrs scenv_pmep, replace
 revrs scenv_meds, replace
 revrs scenv_crex, replace
 
 **Reverse environment habit
 
replace envhabit1 = . if envhabit1<0
replace envhabit1 = . if envhabit1==6
revrs envhabit1, replace 
 
replace envhabit2 = . if envhabit2<0
replace envhabit2 = . if envhabit2==6
revrs envhabit2, replace 
 
replace envhabit3 = . if envhabit3<0
replace envhabit3 = . if envhabit3==6
revrs envhabit3, replace 
  
replace envhabit4 = . if envhabit4<0
replace envhabit4 = . if envhabit4==6
revrs envhabit4, replace 
  
replace envhabit5 = . if envhabit5<0
replace envhabit5 = . if envhabit5==6
revrs envhabit5, replace 
  
replace envhabit6 = . if envhabit6<0
replace envhabit6 = . if envhabit6==6
revrs envhabit6, replace 

replace envhabit7 = . if envhabit7<0
replace envhabit7 = . if envhabit7==6
revrs envhabit7, replace 

replace envhabit8 = . if envhabit8<0
replace envhabit8 = . if envhabit8==6
revrs envhabit8, replace 
  
replace envhabit9 = . if envhabit9<0
replace envhabit9 = . if envhabit9==6
revrs envhabit9, replace 

replace envhabit10 = . if envhabit10<0
replace envhabit10 = . if envhabit10==6
revrs envhabit10, replace 

replace envhabit11 = . if envhabit11<0
replace envhabit11 = . if envhabit11==6
revrs envhabit11, replace 
  
**Standardise outcome variables 
 egen std_scenv_tlat = std(scenv_tlat)
 egen std_scenv_nowo = std(scenv_nowo)
 egen std_scenv_noot = std(scenv_noot)
 egen std_scenv_canc = std(scenv_canc)
 egen std_scenv_bccc = std(scenv_bccc)
 egen std_scenv_ftst = std(scenv_ftst)
 egen std_scenv_grn = std(scenv_grn) 
 egen std_scenv_pmep = std(scenv_pmep) 
 egen std_scenv_meds = std(scenv_meds) 
 egen std_scenv_crex = std(scenv_crex) 
 egen std_scenv_crlf  = std(scenv_crlf) 

 egen std_envhabit1 = std(envhabit1)
 egen std_envhabit2 = std(envhabit2)
 egen std_envhabit3 = std(envhabit3)
 egen std_envhabit4 = std(envhabit4)
 egen std_envhabit5 = std(envhabit5)
 egen std_envhabit6 = std(envhabit6)
 egen std_envhabit7 = std(envhabit7)
 egen std_envhabit8 = std(envhabit8)
 egen std_envhabit9 = std(envhabit9)
 egen std_envhabit10 = std(envhabit10)
 egen std_envhabit11 = std(envhabit11)
 
 **Gen university degree
 
 gen unidegree = 0 if qfhi~=.
 replace unidegree = 1 if qfhi>=1 & qfhi<=2
 
  gen alevel = 0 if qfhi~=.
 replace alevel = 1 if qfhi>=1 & qfhi<=7
 
   gen gcse = 0 if qfhi~=.
 replace gcse = 1 if qfhi>=1 & qfhi<=15
 
replace  scopecl30 = . if  scopecl30<0
replace  scopecl30 = 0 if  scopecl30==2

replace  scopecl200 = . if scopecl200<0
replace scopecl200 = 0 if scopecl200==2
 
  egen std_scopecl200 = std(scopecl200)
   egen std_scopecl30 = std(scopecl30)
 
  
  **Support the Green party
 
 gen green = 0 if vote4_a~=.
 replace green = 1 if vote4_a == 6
 egen std_green = std(green)
 
 replace qb_year = 1957.4 if birthm==9 & birthy==1957
 
 gen male = 0 if sex==2
 replace male = 1 if sex==1
 
 gen sla = 0
 replace sla = 1 if qb_year >= 1957.4
 
 replace big5a_dv=. if big5a_dv<0
 replace big5c_dv=. if big5c_dv<0
 replace big5e_dv=. if big5e_dv<0
 replace big5n_dv=. if big5n_dv<0
 replace big5o_dv=. if big5o_dv<0
 
replace mb_year = . if mb_year<0 

replace mb_year = mb_year/100

**North-South divide

gen south = 0
replace south = 1 if gor_dv>=6 & gor_dv<=9

**gen total household net income
gen high_income = 0 if hhnetinc1~=.
egen median_income = median(hhnetinc1)
replace high_income = 1 if hhnetinc1>median_income



**Principle component
*1) Climate literacy
pca scenv*, blanks(.3) com(3)
screeplot, yline(1)   
predict pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10, score  

*2) Proenvironmental behaviours
pca envhabit1 envhabit2 envhabit3 envhabit4 envhabit5 envhabit6 envhabit7 envhabit8 envhabit9 , blank (.3)  com(4)
screeplot, yline(1) 
predict pd1 pd2 pd3 pd4 pd5 pd6 pd7 pd8 pd9 pd10, score  

**Factor analysis 
*1) Climate literacy 
factor scenv*
screeplot, yline(1)   
predict ft1  
rotate
predict ft1_rotate

factor envhabit1 envhabit2 envhabit3 envhabit4 envhabit5 envhabit6 envhabit7 envhabit8 envhabit9 
predict ft2
rotate
predict ft2_rotate
 
**The 1972 ROSLA
gen stayafter15_100 = stayafter15*100
gen gcse_100 = gcse*100

**Gen personal income variable
gen lgpersonal_income = log(fimngrs_dv)
gen lglabour_income = log(fimnlabgrs_dv )
gen lghhincome = log(hhnetinc1)
gen lgnetpersonal_income = log(fimnnet_dv )


save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect.dta", replace

**Keep only certain individuals (for graphs)

keep if birthy >= 1930 & birthy <=1991

**Keep only people who were born in England & Wales
keep if ukborn == 1 | ukborn==4

**Keep only England and Wales residence

keep if gor<=10

save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect_England_Wales.dta", replace


**Analysis

use "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect.dta", clear

**Keep only certain individuals (for graphs)

keep if birthy >= 1930 & birthy <=1991


**Keep only people who were born in England & Wales
keep if ukborn == 2 | ukborn==4

**Keep only Scotland and Northern Ireland

keep if gor==11 | gor==12

save "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect_Scotland_NI.dta", replace


**Analysis
use "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect_England_Wales.dta", clear


**Density manipulation checks
rddensity qb_year, c(1957.4) plot  
graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Density.png", as(png) name("Graph") replace


rddensity mb_year, c(1957.09) plot  
graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Density2.png", as(png) name("Graph") replace


**Regression: Sharp RDD

**Figure 1: Sharp RDD on education outcomes

**Stay after 15
rdplot stayafter15_100 qb , c(1957.4)   bwselect(mserd) covs(birthm male)    ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Remained in school after 15 years of age (%)")  )   vce(hc0) masspoints(adjust)  

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1a.png", as(png) name("Graph") replace

rdrobust stayafter15_100 qb , c(1957.4)    bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
      addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust stayafter15_100 qb , c(1957.4)    bwselect(msetwo) covs(birthm male)   vce(hc0) masspoints(adjust)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
     addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
rdrobust stayafter15_100 qb , c(1957.4)    bwselect(cerrd) covs(birthm male)   vce(hc0) masspoints(adjust)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
      addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

	
**Years of schooling	
	
rdplot scend qb , c(1957.4)    bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel(1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Age left full-time education"))   vce(hc0) masspoints(adjust)  

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1b.png", as(png) name("Graph") replace

rdrobust scend qb , c(1957.4)    bwselect(mserd) covs(birthm male)    vce(hc0) masspoints(adjust)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
      addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust scend qb , c(1957.4)    bwselect(msetwo) covs(birthm male)    vce(hc0) masspoints(adjust)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
     addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
rdrobust scend qb , c(1957.4)    bwselect(cerrd) covs(birthm male)    vce(hc0) masspoints(adjust)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
     addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

**GCSE

rdplot gcse_100 qb , c(1957.4)   bwselect(mserd) covs(birthm male)     ci(95) shade  graph_options(xlabel(1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Completed at least a GCSE/CSE/O level qualification (%)"))  vce(hc0) masspoints(adjust)  

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1c.png", as(png) name("Graph") replace

rdrobust gcse_100 qb , c(1957.4)    bwselect(mserd) covs(birthm male)    vce(hc0) masspoints(adjust)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust gcse_100 qb , c(1957.4)    bwselect(msetwo) covs(birthm male)    vce(hc0) masspoints(adjust)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
rdrobust gcse_100 qb , c(1957.4)    bwselect(cerrd) covs(birthm male)    vce(hc0) masspoints(adjust)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig1.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

	

**Figure 2: Sharp RDD on PCA1-3
rdplot pc1 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Climate change literacy: PC1")  ) vce(hc0) masspoints(adjust)  stdvars(on)

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig2a.png", as(png) name("Graph") replace

rdrobust pc1 qb , c(1957.4)    bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig2.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p))

rdplot pc2 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Climate change literacy: PC2")  ) vce(hc0) masspoints(adjust) stdvars(on)

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig2b.png", as(png) name("Graph") replace

rdrobust pc2 qb , c(1957.4)    bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig2.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p))

rdplot pc3 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Climate change literacy: PC3")  ) vce(hc0) masspoints(adjust) stdvars(on)

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig2c.png", as(png) name("Graph") replace

rdrobust pc3 qb , c(1957.4)    bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on) 

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig2.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p))
	
	
**Figure 3: Sharp RDD on PCA4-7
rdplot pd1 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC1")  ) vce(hc0) masspoints(adjust) stdvars(on)

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig3a.png", as(png) name("Graph") replace

rdrobust pd1 qb , c(1957.4)    bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig3.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p))

rdplot pd2 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC2")  ) vce(hc0) masspoints(adjust) stdvars(on)

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig3b.png", as(png) name("Graph") replace

rdrobust pd2 qb , c(1957.4)    bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p))

rdplot pd3 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC3")  ) vce(hc0) masspoints(adjust) stdvars(on)

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig3c.png", as(png) name("Graph") replace

rdrobust pd3 qb , c(1957.4)    bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p))

rdplot pd4 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC4")  ) vce(hc0) masspoints(adjust) stdvars(on)

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig3d.png", as(png) name("Graph") replace

rdrobust pd4 qb , c(1957.4)    bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p))


*************************

*Table 1 regression: Sharp and Fuzzy

**Beliefs & Attitudes 

**Component 1
 **MSERD
  rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

 
 rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

 rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
 
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

 rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
 
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
**MSETWO
   rdrobust pc1  qb , c(1957.4)   bwselect(msetwo) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
   rdrobust pc1  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(stayafter15)  vce(hc0) masspoints(adjust) stdvars(on)
 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pc1  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(scend)  vce(hc0) masspoints(adjust) stdvars(on)
 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pc1  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(gcse) vce(hc0) masspoints(adjust) stdvars(on)
 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 **CERRD
 rdrobust pc1  qb , c(1957.4)   bwselect(cerrd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pc1  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pc1  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(scend) vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pc1  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(gcse)  vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 
**Component 2
 **MSERD
 rdrobust pc2  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
rdrobust pc2  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pc2  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pc2  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
**MSETWO 
 
 rdrobust pc2  qb , c(1957.4)   bwselect(msetwo) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
      outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pc2  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(stayafter15)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust pc2  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(scend)  vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust pc2  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(gcse) vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

	**CERRD
 rdrobust pc2  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc2  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc2  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(scend) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc2  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(gcse)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
**Component 3
**MSERD

 rdrobust pc3  qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
rdrobust pc3  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc3  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc3  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse) vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
**MSETWO	
 rdrobust pc3  qb , c(1957.4)   bwselect(msetwo) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc3  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(stayafter15)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc3  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(scend)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc3  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(gcse)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 

 **CERRD
  rdrobust pc3  qb , c(1957.4)   bwselect(cerrd) covs(birthm male)  vce(hc0) masspoints(adjust)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc3  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(stayafter15)  vce(hc0) masspoints(adjust)
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc3  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(scend)  vce(hc0) masspoints(adjust)
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pc3 qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(gcse)  vce(hc0) masspoints(adjust)
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 1c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
********* 
 
**Environmentally friendly behaviours
**Component 1
**MSERD
 rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
**MSETWO 
 rdrobust pd1  qb , c(1957.4)   bwselect(msetwo) covs(birthm male)    vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pd1  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(stayafter15)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd1 qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(scend)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd1  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(gcse) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

**CERRD	
 rdrobust pd1  qb , c(1957.4)   bwselect(cerrd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)	
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd1  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd1 qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(scend) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd1  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(gcse)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
**Component 2 
*MSERD
 
rdrobust pd2  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
rdrobust pd2  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)	
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd2  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd2  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
	
**MSETWO
 rdrobust pd2  qb , c(1957.4)   bwselect(msetwo) covs(birthm male)    vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd2  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(stayafter15)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd2 qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(scend)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd2  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(gcse) vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
**CERRD 
 rdrobust pd2  qb , c(1957.4)   bwselect(cerrd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
	rdrobust pd2  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd2  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(scend) vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
	rdrobust pd2  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(gcse)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2b.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
**Component 3
**MSERD		
 rdrobust pd3  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd3  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd3  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd3  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
**MSETWO 
 rdrobust pd3  qb , c(1957.4)   bwselect(msetwo) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd3  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(stayafter15)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd3  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(scend)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd3  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(gcse) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 **CERRD 
 rdrobust pd3  qb , c(1957.4)   bwselect(cerrd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd3  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd3  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(scend) vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd3  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(gcse)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2c.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

**Component 4
**MSERD	
 rdrobust pd4  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pd4  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd4  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd4  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
**MSETWO	
 rdrobust pd4  qb , c(1957.4)   bwselect(msetwo) covs(birthm male)    vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd4  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(stayafter15)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
rdrobust pd4  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(scend)  vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd4  qb , c(1957.4)   bwselect(msetwo) covs(birthm male) fuzzy(gcse) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
**CERRD	
 rdrobust pd4  qb , c(1957.4)   bwselect(cerrd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd4  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust pd4  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(scend) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust pd4  qb , c(1957.4)   bwselect(cerrd) covs(birthm male) fuzzy(gcse)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 2d.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

	
	
**Table 3: Factor analysis 
**Unrotated factor
*Component 1
rdrobust ft1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3a.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust ft1  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
  rdrobust ft1   qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust ft1   qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
*Component 2
 rdrobust ft2  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust ft2  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
  rdrobust ft2   qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
      outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 rdrobust ft2   qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3a.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 *Rotated
 *Component 1
 rdrobust ft1_rotate  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
      outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust ft1_rotate  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
      outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
  rdrobust ft1_rotate   qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
       outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust ft1_rotate   qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
      outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 *Component 2
 rdrobust ft2_rotate  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
      outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
 rdrobust ft2_rotate  qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(stayafter15) vce(hc0) masspoints(adjust) stdvars(on)
      outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
  rdrobust ft2_rotate   qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(scend)  vce(hc0)   masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
  rdrobust ft2_rotate   qb , c(1957.4)   bwselect(mserd) covs(birthm male) fuzzy(gcse)   vce(hc0) masspoints(adjust) stdvars(on)
      outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 3.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
 
 
**Placebo test
*Component 1
rdrobust pc1  qb , c(1956.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 4.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 4.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
rdrobust pc1  qb , c(1958.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 4.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

*Component 2
rdrobust pd1  qb , c(1956.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 4.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 4.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust pd1  qb , c(1958.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Table 4.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

****************************************************************************************************************************************************************	
**Robustness checks	
**Different polynomials

rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) p(2)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/polynomials.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) p(3)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/polynomials.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) p(4)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/polynomials.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))	

rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) p(2)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/polynomials.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) p(3)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/polynomials.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) p(4)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/polynomials.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))	

**************************
**Clustering on running variable
rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(cluster qb) masspoints(adjust) stdvars(on) 
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/clustering.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))


rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(cluster qb) masspoints(adjust) stdvars(on) 
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/clustering.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
	
	
***************************
*Sub-sample
**By gender
rdplot pc1 qb if male==1, c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC1")  )  vce(hc0) masspoints(adjust) stdvars(on)

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig_men.png", as(png) name("Graph") replace

rdrobust pc1 qb if male==1, c(1957.4)    bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Sub-sample.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p))

rdplot pc1 qb if male==0, c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC1")  )   vce(hc0) masspoints(adjust) stdvars(on)

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig_women.png", as(png) name("Graph") replace

rdrobust pc1 qb if male==0, c(1957.4)    bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Sub-sample.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
  
**By region
 rdplot pc1 qb if south==1, c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC1")  )  vce(hc0) masspoints(adjust) stdvars(on)
 
 graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig_south.png", as(png) name("Graph") replace

 rdrobust pc1 qb if south==1, c(1957.4)    bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Sub-sample.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
  
 rdplot pc1 qb if south==0, c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC1")  )  vce(hc0) masspoints(adjust) stdvars(on)
 
 graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig_north.png", as(png) name("Graph") replace

 rdrobust pc1 qb if south==0, c(1957.4)    bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Sub-sample.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
   
 
 **By income status
 
rdplot pc1 qb if high_income==0, c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC1")  )  vce(hc0) masspoints(adjust) stdvars(on)
 
graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig_lowincome.png", as(png) name("Graph") replace

rdrobust pc1 qb if high_income==0, c(1957.4)    bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Sub-sample.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
   
rdplot pc1 qb if high_income==1, c(1957.4)   bwselect(mserd) covs(birthm male)   ci(95) shade  graph_options(xlabel (1930 (5) 1990) legend(off) xtitle("Quarter of birth") ytitle("Pro-environmental behaviours: PC1")  )  vce(hc0) masspoints(adjust) stdvars(on)
 
graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Fig_lowincome.png", as(png) name("Graph") replace

rdrobust pc1 qb if high_income==1, c(1957.4)    bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/Sub-sample.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
 
*********

**Did the 1972 ROSLA have an effect on income?

 rdrobust lghhincome qb  , c(1957.4)    bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 
  outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/effect_on_hhincome.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 

 
	
**Separate regression for each variable

 rdrobust scenv_bccc  qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 

 rdrobust scenv_tlat  qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
    outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
	
 rdrobust scenv_nowo  qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
	
 rdrobust scenv_noot   qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
      outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
  
rdrobust scenv_canc     qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
     outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
	
 rdrobust scenv_crex    qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
 
rdrobust scenv_meds     qb , c(1957.4)   bwselect(mserd) covs(birthm male) vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
 
rdrobust scenv_grn      qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
 
rdrobust scenv_pmep      qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
	
rdrobust scenv_crlf      qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 

 rdrobust scenv_ftst      qb , c(1957.4)   bwselect(mserd) covs(birthm male) vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
	
  rdrobust envhabit1      qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
  
  rdrobust envhabit2     qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
 
 rdrobust envhabit3     qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
 
  rdrobust envhabit4      qb , c(1957.4)   bwselect(mserd) covs(birthm male) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
	
  rdrobust envhabit5     qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
  
 
  rdrobust envhabit6      qb , c(1957.4)   bwselect(mserd) covs(birthm male) vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
 
  rdrobust envhabit7      qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
 
  rdrobust envhabit8      qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 
 
  rdrobust envhabit9      qb , c(1957.4)   bwselect(mserd) covs(birthm male)  vce(hc0) masspoints(adjust) stdvars(on)
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/all_variables.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Bandwidth, e(h_l), Order polyn., e(p)) 

*******


**TED estimates

gen y1 = pc1
gen s1=qb // running variable
global s_star = 1957.4
gen w = (s1>=$s_star)
global L=6
global M=2
global kernel triangular

****
*Generate the optimal bandwidth
****

rdbwselect y1 s1, c($s_star) p($M) q(3) kernel($kernel) all
global bw_CCT=e(h_mserd) //bandwidth proposed by Calonico, Cattaneo, and Titiunik (2014)
 
**Choose one of the three optimal bandwidth
global band=$bw_CCT


log using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/TED_regression.log", replace
**Estimate TED using "ted"

ted y1 s1 w, model(sharp) h(11) c($s_star) m($M) l($L) k($kernel) graph vce(robust)

log close

graph export "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/TED.png", as(png) name("Graph") replace

*******

**Non-robust RDD

rd pc1 qb, z0(1957.4)    mbw(100)
	
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/nonrobust_rd.xls", replace ///
tex(fragment) nonote noobs  

rd pd1 qb, z0(1957.4)   mbw(100)
	
 outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/nonrobust_rd.xls", append ///
tex(fragment) nonote noobs  
   
	
*************

**Different kernels (for referee only)

  rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) kernel(uniform)

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/kernel.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
	  rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) kernel(epa)

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/kernel.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))


*************

**Use all England and Wales samples
use "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect.dta", clear

**Keep only people who were born in England & Wales
keep if ukborn == 1 | ukborn==4

**Keep only England and Wales residence

keep if gor<=10

**Regression: Sharp RDD

  rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/full_England_Wales_sample.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

  rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on)  

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/full_England_Wales_sample.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))


***Higher order pca

 rdrobust pc4 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/higher_order_rdd.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

	 rdrobust pc5 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/higher_order_rdd.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
	 rdrobust pc6 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/higher_order_rdd.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
		 rdrobust pc7 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/higher_order_rdd.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
***	
	
 rdrobust pd5 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/higher_order_rdd.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))

	 rdrobust pd6 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/higher_order_rdd.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
	 rdrobust pc7 qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) 
   outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/higher_order_rdd.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), Order polyn., e(p))
	
	
**Summary statistics 
 
use "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect_England_Wales.dta", clear

asdoc sum scenv_bccc  scenv_tlat scenv_nowo scenv_noot scenv_canc  scenv_crex scenv_meds   /*
*/ scenv_grn  /*
*/ scenv_pmep  scenv_crlf  scenv_ftst scenv_fitl  envhabit1 envhabit2 envhabit3 envhabit4 envhabit5/*
*/ envhabit6 envhabit7 envhabit8 envhabit9 envhabit10 envhabit11  /*
*/ , by(stayafter15) stat(N mean semean min max) save(/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/mydoc1.doc) replace

**Balance test

covbal stayafter15 scenv_bccc  scenv_tlat scenv_nowo scenv_noot scenv_canc  scenv_crex scenv_meds  /*
*/ scenv_grn  /*
*/ scenv_pmep  scenv_crlf  scenv_ftst scenv_fitl  envhabit1  envhabit2 envhabit3 envhabit4 envhabit5/*
*/ envhabit6 envhabit7 envhabit8 envhabit9 envhabit10 envhabit11 


balancetable   stayafter15 scenv_bccc  scenv_tlat scenv_nowo scenv_noot scenv_canc  scenv_crex scenv_meds   /*
*/ scenv_grn  /*
*/ scenv_pmep  scenv_crlf  scenv_ftst scenv_fitl envhabit1 envhabit2 envhabit3 envhabit4 envhabit5/*
*/ envhabit6 envhabit7 envhabit8 envhabit9 envhabit10 envhabit11 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/balancetable.xls", pvalue wide replace 
 

 
**Use weight 
use "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect_England_Wales.dta", clear

sort pidp

save  "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect_England_Wales.dta", replace

use "/Users/nattavudhpowdthavee/Dropbox/UKHLS/UKDA-6614-stata/stata/stata11_se/ukhls_wx/xwavedat.dta"

sort pidp

merge pidp using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/schooling_effect_England_Wales.dta"

**Regression using weight

  rdrobust pc1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) weights(psnenus_xd)

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/weights.xls", replace ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), ///
	Order polyn., e(p))
	
	  rdrobust pd1  qb , c(1957.4)   bwselect(mserd) covs(birthm male)   vce(hc0) masspoints(adjust) stdvars(on) weights(psnenus_xd)

outreg2 using "/Users/nattavudhpowdthavee/Dropbox/Education and sustainability/Ecological Econ/Revision/weights.xls", append ///
tex(fragment) nonote noobs ///
    addtext(Covariates, NO) ///
    addstat(Mean dep. var., r(mean), Observations, e(N), Effective N left of cut-off, e(N_h_l), Effective N right of cut-off, e(N_h_r), Left bandwidth, e(h_l), Right bandwidth, e(h_r), ///
	Order polyn., e(p))
