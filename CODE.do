**********************************************************************************************************************************************************
*											Ecole Nationale de la Statistique et de l'Analyse Economique												 *
*						Training : Ingénieur des Travaux Statistiques 									Level : year 4th 						    	 *				
*																																						 *	
**************************************************************** Multilevel Analysis Models **************************************************************
*               																																		 *
*  Presented by : Miss Djeneba SINGARE & Mr Ortéga Wanignon DOVOEDO  |  Supervised by : Mr Souleymane DIAKITE	|   Date : Tuesday december, 17th 2013   *
**********************************************************************************************************************************************************

** To reference our workspace
cd "C:\ENSAE\ITS4bis\econometrie des variables qualitatives\Exposé\Donnees\base esps 2005\WORKSPACE\Nouveau dossier"

** Create a log file to contain our results
log using Result

** Call our first base, that is the base of people
use population_ESPS-2005-2006
** Take only variables that we need
keep a1 a2 a6 menb1 menb2 menb3 menb4 educ3 edud1 edud2 edud4 edud7 edud8 empe1 hhid poid_fin
** Generate the variable link with head of family
gen lienCM=menb1
replace lienCM=3 if (menb1==3 | menb1==6 | menb1==9 | menb1==10)
replace lienCM=4 if (menb1==4 | menb1==5 | menb1==7 | menb1==8)
replace lienCM=5 if (menb1==11 | menb1==12)
** Rename the variable of sexe
rename  menb2 sexe
** Define and assign the label of the variable link with head of family
label define lienCM 1 "chef de menage" 2 "conjoint/conjointe" 3 "enfants" 4 "parents" 5 "autres liens"
lab val lienCM lienCM
label var lienCM "lien avec le chef de ménage"
** Create the variable group of age
recode  menb3 (0/5=1) (5/15=2) (15/35=3) (35/65=4) (65/99=5), gen (ageclass)
label define ageclass 1 "enfant"  2 "adolescent"  3 "jeune"  4 "adulte"  5 "vieux"
lab val ageclass ageclass
label var ageclass "classe d'age"
** Generate the variable matrimonial situation
gen sitmat=menb4
replace sitmat=1 if menb4==6
replace sitmat=2 if (menb4==1 | menb4==2 | menb4==3 | menb4==4 | menb4==5)
replace sitmat=3 if menb4==7
replace sitmat=4 if menb4==8
replace sitmat=5 if menb4==9
label define sitmat 1 "célibataire"  2 "marié" 3 "veuf/veuve" 4 "divorcé" 5 "autres sitmat"
lab val sitmat sitmat
label var sitmat "situation matrimoniale"
** Generate the variable school level
gen niveau=1
replace niveau=0 if educ3==0
label define niveau 0 "aucun niveau" 1 "scolarisé"
lab val niveau niveau
label var niveau "niveau d'instruction"

** Prendre en compte, rien que ceux qui sont malades ou blessés pendant la période d'étude
drop if  edud4==2

** Définition de la variable d'étude
gen consultation=edud7
label var consultation "Accès aux consultations"
recode consultation (2=0)
** Save the new base of people 
save Base_Individus
clear


** Call our second base, that is the base of family
use menage_ESPS-2005-2006_BON
** Take only variables that we need
keep a1 a2 urban a7 menb1 male age menb4 menb7 educ3 edud7 edud8 edud9 edud111 edud112 edud113 edud114 edud115 empe8 habg76 oop_fee oop_drug oop_inp oop_trad oop_prot oop_matrait depsant hhsize pds hhw hhid oop oopexp
** Generate the variable level of the head of family
gen niveau_CM=1
replace niveau=0 if educ3==0
label define niveau 0 "aucun niveau" 1 "scolarisé"
lab val niveau niveau
label var niveau "niveau d'instruction du CM"
** Rename the variable sexe of the head of family
rename  male sexe_CM
recode sexe_CM (2=0)
** Rename the variable social environnement of family
rename  urban milieu
** Save the new base of family
save Base_Menages

** Make the fusion of the news two base
sort hhid
merge m:m hhid using Base_Individus
drop if  _merge ~= 3
save Base_Menag_Indiv

** Delete all doublons
sort hhid
quietly by hhid : gen doublon=cond(_N==1,0,_n)
drop if doublon==0

******************************************************************** ++++ Multilevel Estimation ++++ *************************************************************************

** Estimate the model 
** 1-) 1st estimation. Whenwe added "|| hhid:", we specified random effects at the level identified by group variable hhid. Because we wanted only a random intercept, that is all we had to type.
xtmelogit consultation lienCM sexe ageclass sitmat niveau || hhid:
** With this estimation, we remark that variables sexe and sitmat are not significative, so we remove them

** 2nd estimation, without variables sexe and sitmat
xtmelogit consultation lienCM ageclass niveau || hhid:
** All variables are significative. See the comment on our document

** We now store our estimates for later use
estimates store r_estim1

** Estimation. With this estimation, we have the variance estimates
xtmelogit consultation lienCM ageclass niveau || hhid: , variance

** We now store our estimates for later use
estimates store r_estim2

** 2-) Extending the model was as simple as adding sexe_CM to the random effects specification, so that the model now includes a random intercept and a random coefficient on sexe_CM
xtmelogit consultation lienCM ageclass niveau || hhid: sexe_CM 

** We now store our estimates for later use
estimates store r_estim3

** Compare the estimation 
lrtest r_estim1 r_estim3
*** We find the default covariance structure for (Uj, Vj), covariance(Independant), to be inadequate.
*** We see below that we can reject this model in favor of one that allows correlation between Uj and Vj

** 3-) Re-estimation of model with suppoz correlation between Uj and Vj
xtmelogit consultation lienCM ageclass niveau || hhid: sexe_CM , covariance(unstructured) variance  

** We now store our estimates for later use
estimates store r_estim3_corr

** Compare the estimation
lrtest r_estim3 r_estim3_corr


** 4-) 
*generate byte female = 1 - sexe_CM
*xtmelogit consultation female lienCM ageclass niveau || hhid: female sexe_CM , covariance(unstructured) variance   

** We now store our estimates for later use
*estimates store r_estim3_corr_female

** Compare the estimation
*lrtest r_estim3_corr r_estim3_corr_female


** 5-) 
xtmelogit consultation lienCM ageclass niveau || hhid: sexe_CM age milieu, covariance(exchangeable) variance

estimates store r_estim5

lrtest r_estim3_corr r_estim5

** 6-)
xtmelogit consultation lienCM ageclass niveau || hhid: sexe_CM age milieu niveau_CM, covariance(exchangeable) variance || milieu:







