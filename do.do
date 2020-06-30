                                              ***************************************************************************************
				    					   **                             ENSAE-Dakar                                             **
                						 **                                                                                     **
									   **            Travaux pratiques- Exposé Analyse Multiniveau                            **
									 **                                                                                     **
								   **                          Travaux réalisés par                                       **
								 **                    AWONON  A. Josué & DANSOU N. Romuald                             **
							   **                                                                                     **
							 **                                                                                     **
						   **                                 Classe: ITS 4                                       **
						 **                                                                                     **
					   **-------------------------------------2014-2015---------------------------------------**
                              


cd "F:\My ITS4\var-qual\AWONON\Exposé_analyse_multi_niveaux\Bases"
clear
**Linéaire
use continuous.dta
desc
*log using linear1, replace

*****analyse d'un modèle de régression linéaire simple "régression naïve"

regress tc age

*****analyse multiniveaux d'un modèle de régression linéaire avec constante aléatoire
gllamm tc age, i(med) nip(12) adapt 

******analyse multiniveaux de régression linéaire avec constante et pente aléatoires
generate con=1
eq int: con 
eq slope: age 
gllamm tc age, i(med) nrf(2) eqs(int slope) nip(24) adapt

*****analyse multiniveaux de régression linéaire à deux niveaux
gllamm tc age, i(med institution) nip(12) adapt

*log close

** Logistique
******Régression logistique d'analyse multiniveaux avec constante et pente aléatoires
clear
use dichotomous.dta
desc
generate con=1
eq int: con
eq slope: age
gllamm hyp age, i(med) fam(binom) link(logit) nrf(2) eqs(int slope) nip(24) adapt

******Régression logistique d'analyse multiniveaux avec constante aléatoire
eq int: con
eq slope: age
gllamm hyp age, i(med) fam(binom) link(logit) nip(12) adapt

**logit multinomial
clear
use multinomial.dta
desc
gllamm groupe age, i(med) fam(binom) link(mlogit) nip(12) adapt
est store m1
** L'optioon star nous permet d'avoir les statistiques des deux modèles
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

** La commande suivante est plus adaptée aux données en panel
xtmepoisson nombre age || med:, mle cov(unstr)

/*
|| : constitue la séparation entre la partie fixe et celle entrainant l’effet aléatoire 
mle : (Maximum Likelihood Estimation) estimation par la méthode du maximum de vraisemblance 
cov(unstr) : cette précision permet d’avoir une matrice de variance-covariance dont tous les éléments sont distincts.
*/
