*_____________________MODELE PROBIT BIANAIRE___________________________*
*
*Application 
*		Warrissat Geraldo
*				Khariratou DIALLO
*						Danis JIOGUE	
*
*_________________________Janvier 2020_________________________________*

*Définition du chemin
cd "D:\Danis_ITS4\Econometrics of Qualitative Dependent Variable\2019-2020\Expose"

*log pour stocker les résultats
log using "source.log", replace

*Importation de la base
import delimited "D:\Danis_ITS4\Econometrics of Qualitative Dependent Variable\2019-2020\Expose\Expose_2019\base\base.csv",clear


*------Recodification des variables

*niveau d'étude
generate niv_etd = "primaire" if  niv_edu == 1
replace niv_etd = "moyen" if  niv_edu == 2
replace niv_etd = "secondaire" if  niv_edu == 3
replace niv_etd = "superieur" if  niv_edu == 4
replace niv_etd = "aucun" if  niv_edu == 5

*Pratique de l'agriculture
generate pratiq_agri = "oui" if membre_pratique_agri == 1
replace pratiq_agri = "non" if membre_pratique_agri == 0

*apprehnesion du changement pluviométrique
gen app_chan_clim = "constante" if chang_pluv == 1
replace app_chan_clim = "tendance baisse" if chang_pluv == 2
replace app_chan_clim = "tendance haute" if chang_pluv == 3
replace app_chan_clim = "eratique" if chang_pluv == 4

*source d'information de la pluie
gen srce_inf_pluie = "tele" if srce_infos_pluie == 1
replace srce_inf_pluie = "radio" if srce_infos_pluie == 2
replace srce_inf_pluie = "association_agri" if srce_infos_pluie == 5
replace srce_inf_pluie = "offic_gouver" if srce_infos_pluie == 7
replace srce_inf_pluie = "proche" if srce_infos_pluie == 8
replace srce_inf_pluie = "aucun" if srce_infos_pluie == 10
replace srce_inf_pluie = "autre" if srce_infos_pluie == 9

*Connaissance de l'assurance
gen connaiss_assur = "oui" if connaissance_assurance == 1
replace connaiss_assur = "non" if connaissance_assurance == 0

*Souscription à une assurance
gen souscri_assu = "oui" if souscrip_assu == "1"
replace souscri_assu = "non" if souscrip_assu == "0"



*------Analyse préliminaire
*____Obtenir prêt : capter l'aversion au risque de responsale du bétail dans le ménage
*____niv_edu
*____Nombre de personne dans le mng : proxy du niveau de revenu (bien être dans le menage)
*____Membre d'association d'éléveur :

*Analyse univariée
tab(obtenir_pret)
tab(niv_etd)
tab(membre_association_elev)
summarize(nb_pers)
tab(betail_classique)
tab(betail_indicielle)

*Analyse bi-variée
tab betail_classique betail_indicielle



*test de corrélation entre les 2 variables dépendantes
tabulate betail_indicielle betail_classique, chi2

*H0 : indépendance des deux variables
*H1 : dépendance des deux variables

*Application du modèle

biprobit (betail_classique = obtenir_pret niv_edu nb_pers membre_association_elev ) (betail_indicielle = obtenir_pret niv_edu nb_pers membre_association_elev)

// ***********CALCUL DES CRITERES D'INFORMATION AIC et BIC

estat ic


************effets marginaux
mfx
****************************
