clear

* setwd
cd "C:/Users/Amanda/OneDrive/Documents/Econ120BH"

* import data
import delimited using "new_cape.csv"

* drop first column
drop v1

* destring grade_exp and grade_rec
destring grade_exp, replace force
destring grade_rec, replace force

* response rate
gen response_rate = num_evals/num_enrolled*100
drop if response_rate > 100
hist response_rate, graphregion(color(white))
summ response_rate, detail

* summary
summ

* scatter plot 
scatter rec_instr experience

* regression with experience
reg rec_instr experience , r
outreg, se
*outreg using result.doc, replace se

* add number enrolled
reg rec_instr experience num_enrolled, r
outreg, merge se
*outreg using result.doc, merge se

* regression with indicators only
drop econ1
reg rec_instr experience econ*, r
outreg, merge se
*outreg using result.doc, merge se


*number enrolled and indicator variables
reg rec_instr experience num_enrolled econ*, r
outreg, merge se
*outreg using result.doc, merge se

* AVPLOT
avplot experience, graphregion(color(white)) msize(vsmall)



