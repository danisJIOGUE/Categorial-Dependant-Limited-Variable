cd:"D:\Anal_Multiniveau"
use multi_nivo

bysort school: egen y_mean=mean(y)
twoway scatter y school, msize(tiny) || connected y_mean school, connect(L) clwidth(thick) clcolor(black) mcolor(black) msymbol(none)||, ytitle(y)

statsby inter=_b[_cons] slope=_b[x1], by(school) saving(ols, replace): regress y x1
sort school
merge school using ols
drop _merge
gen yhat_ols=inter + slope*x1
sort school x1
separate y, by(school)
separate yhat_ols, by(school)
twoway connected yhat_ols1 - yhat_ols65 x1||lfit y x1, clwidth(thick) clcolor(black)
legend(off) ytitle(y)

xtmixed y || school:, mle nolog
xtmixed y x1 || school:,mle nolog
xtmixed y x1 || school: x1, mle nolog covariance(unstructure)
xtmixed y x1 || _all: R.x1, mle nolog

*** comparaison des modèles ****
lrtest ri rc

xtmixed y x1 || school: x1, mle nolog covariance(unstructure) variance
