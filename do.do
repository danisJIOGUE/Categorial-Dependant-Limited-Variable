                                              ***************************************************************************************
				    					   **                             ENSAE-Dakar                                             **
                						 **                                                                                     **
									   **            Travaux pratiques- Expos� Analyse Multiniveau                            **
									 **                                                                                     **
								   **                          Travaux r�alis�s par                                       **
								 **                    AWONON  A. Josu� & DANSOU N. Romuald                             **
							   **                                                                                     **
							 **                                                                                     **
						   **                                 Classe: ITS 4                                       **
						 **                                                                                     **
					   **-------------------------------------2014-2015---------------------------------------**
                              


cd "F:\My ITS4\var-qual\AWONON\Expos�_analyse_multi_niveaux\Bases"
clear
**Lin�aire
use continuous.dta
desc
*log using linear1, replace

*****analyse d'un mod�le de r�gression lin�aire simple "r�gression na�ve"

regress tc age

*****analyse multiniveaux d'un mod�le de r�gression lin�aire avec constante al�atoire
gllamm tc age, i(med) nip(12) adapt 

******analyse multiniveaux de r�gression lin�aire avec constante et pente al�atoires
generate con=1
eq int: con 
eq slope: age 
gllamm tc age, i(med) nrf(2) eqs(int slope) nip(24) adapt

*****analyse multiniveaux de r�gression lin�aire � deux niveaux
gllamm tc age, i(med institution) nip(12) adapt

*log close

** Logistique
******R�gression logistique d'analyse multiniveaux avec constante et pente al�atoires
clear
use dichotomous.dta
desc
generate con=1
eq int: con
eq slope: age
gllamm hyp age, i(med) fam(binom) link(logit) nrf(2) eqs(int slope) nip(24) adapt

******R�gression logistique d'analyse multiniveaux avec constante al�atoire
eq int: con
eq slope: age
gllamm hyp age, i(med) fam(binom) link(logit) nip(12) adapt

**logit multinomial
clear
use multinomial.dta
desc
gllamm groupe age, i(med) fam(binom) link(mlogit) nip(12) adapt
est store m1
** L'optioon star nous permet d'avoir les statistiques des deux mod�les
est table m1 star 


*poisson
clear
use poisson.dta
desc
sum nombre age
poisson nombre age
poisgof
*ou  estat gof
gllamm nombre age, i(med) fam (poisson) link(log) nip(12) adapt

** La commande suivante est plus adapt�e aux donn�es en panel
xtmepoisson nombre age || med:, mle cov(unstr)

/*
|| : constitue la s�paration entre la partie fixe et celle entrainant l�effet al�atoire 
mle : (Maximum Likelihood Estimation) estimation par la m�thode du maximum de vraisemblance 
cov(unstr) : cette pr�cision permet d�avoir une matrice de variance-covariance dont tous les �l�ments sont distincts.
*/
