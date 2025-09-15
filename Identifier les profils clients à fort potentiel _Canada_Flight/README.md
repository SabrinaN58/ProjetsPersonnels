<p align="center">
  <img src="./Images/Logo_canada_flight.png" alt="Logo" width="200">
</p>

# 💎 Identifier les profils clients à fort potentiel : analyse statistique du programme de fidélité de Canada Flight



## 🔵 Contexte

Canada Flight est une compagnie aérienne spécialisée dans les vols nationaux et internationaux, à destination et en provenance du Canada.
Elle a mis en place un programme de fidélité permettant aux clients d'accumuler des points à chaque vol et de bénéficier d'avantages variés.

Aujourd'hui, la compagnie souhaite renforcer et développer ce programme. Mais avant tout, elle cherche à mieux comprendre les différences de comportement entre les profils des adhérents selon leur niveau d'activité.

Pour cette étude la base client a été segmentée en deux catégories d’activité :

- **Clients engagés** : ayant effectués plus de 20 vols,
- **Désengagés** : inscrits mais ayant effectués moins de 20 vols

Cette analyse permettra à la compagnie d'idenfier les facteurs qui différencient ces deux groupes, afin de repérer les clients à fort potentiel et d'orienter plus efficacement les actions de développement et de fidélisation



## 🟢 Objectifs

Les principaux objectifs de cette analyse sont :

- Comprendre le profil des adhérents en fonction du nombre de vols réalisés.
- Identifier les facteurs clés qui distinguent les clients engagés des désengagés.
- Proposer des recommandations pour améliorer l'engagement client.



## 🟡 Données utilisées

**Période analysée** : années 2017 et 2018

Pour cette étude, nous avons utilisé les données collectées par Canada Flight en provenance de deux sources.

La première table contient les informations sociodémographique des clients :
 - Le sexe, 
 - lieu de résidence, 
 - le niveau d’études, 
 - le statut marital, 
 - le salaire. 

La deuxième table contient des informations sur l’activité des clients regroupant des variables comme :
 - le nombre de vols, 
 - la distance total parcourue, 
 - les points cumulés ou échangés.
 


## 🔵 Sources de données

Les données utilisées dans ce projet proviennent du site : [Mayven Analytics](https://mavenanalytics.io/)  
Lien du dataset : https://mavenanalytics.io/data-playground/airline-loyalty-program



## 🟣 Méthodologie

**1. Nettoyage et préparation des données** 

- Vérification des types de données et des doublons 
- Imputation des valeurs manquantes (salaires)
- Création de nouvelles variables : ancienneté, date (mois + années)

**2. Analyse exploratoire**

- **Visualisation des distributions** : comparer la distibution des variables numériques (salaire, ancienneté, CLV, nombre de vols) par statut d'engagement
- **Répartition par statut d'engagement** : visualiser la répartition des statuts d'engagement par facteur sociodémographique (genre, statut marital, niveau d'études, province)

**3. Tests statistiques**

- **Chi²** : pour analyser le lien entre les  variables catégorielles (genre, niveau d'étude, statut marital, province) et le statut d'engagement.
- **Mann-Whitney U** : pour comparer la distribution des variables numériques (salaire, ancienneté, valeur vie client, nombre de vols) entre deux groupes (engagés vs désengagés).
- **Spearman** : pour des analyses complentaires et visualiser les corrélations entre les variables numériques.



## 🟠 Résultats 

**1. Répartition des statuts d'engagement**

![Répartition des statuts d'engagement](./Images/Analyse%20exploratoire/Répartition%20des%20clients%20par%20statut.png)

La majorité des clients (82 %) ont effectué plus de 20 vols sur la période étudiée, tandis qu'une minorité est désengagés avec moins de 20 vols

**2. Analyse des facteurs sociodémographiques**

![Répartition des statuts par genre](./Images/Analyse_ciblée/Répartition%20des%20statuts%20par%20genre.png)

Les variables genre, niveau d'étude, statut marital et province n'ont pas d'influence significative sur le statut d'engagement des clients. *(Tests Chi² : p-valeur > 0.05)*.

**3. Comparaison de la ditribution des salaires et la valeur vie (CLV)**

![Distribution des salaires](./Images/Analyse_ciblée/Distribution%20des%20salaires%20par%20statut%20(boxplot).png)
![Distribution de la CLV](./Images/Analyse_ciblée/Distribution%20de%20la%20CLV%20(boxplots).png)

Le salaire et la CLV ne montre pas de différence significative entre les deux groupe. (Test Mann-Whitney U : p-valeur > 0.05)*.

**4. Comparaison de la ditribution du nombre de vols et de l'ancienneté**

![Distribution du nombre de vols](./Images/Analyse_ciblée/Distribution%20du%20nombre%20de%20vols%20(boxplot).png)
![Distribution de l'ancienneté](./Images/Analyse_ciblée/Distribution%20de%20l'ancienneté%20(boxplots).png)

À l'inverse, on observe une différence significative entre les deux groupes *(Test Mann-Whitney U : p-valeur < 0.05)* sur : 

- Le nombre de vols réalisés, les clients engagés réalisent plus de vols que les désengagés
- L'anciennété dans le programme, les clients engagés sont généralement plus anciens dans le programme

**5. Analyses complémentaires**

![Heatmap corrélation](./Images/Analyse_ciblée/Heatmap%20de%20corrélation.png)

Les corrélations montrent (Test de Spearman : p-valeur < 0.05 )  : 

- une corrélation très faible mais significative entre nombre de vols et CLV. *(Coefficient de Spearman : 0.01)*
- une corrélation faible mais significative entre le nombre de vols et l'ancienneté. *(Coefficient de Spearman : 0.37)*
- une corrélation très faible mais significative entre le salaire et CLV (Coefficient de Spearman : 0.02)



## 🔴 Limites de l'analyse

- Imputation des salaires (via la médiane) peut introduire des biais dans les résultats
- Absence de variables clés (âge, montant total dépensé) pour une segmentation plus fine des profils clients et enrichir l'analyse comportementale
- La majorité des tests utilisés sont non paramétriques, ils sont adapatés aux données dont la distribution ne suit pas une loi normale, mais sont moins puissants que les tests paramétriques



## 🟡 Recommendations

- **Identifier les clients à fort potentiel** : inciter les clients non adhérents à rejoindre ou rester dans le programme (+ de 20 vols et une ancienneté > 2 ans).
- **Acccompagner les nouveaux clients** : créer du contenu (email, campagne d'onboarding, offre d'activation) pour orienter et accompagner les nouveaux adhérents afin de se familiariser avec le programme.
- **Retenir et relancer les adhérents** : réaliser des rappels, tenir informer les adhérents des nouveautés, réaliser des promotions ciblées pour un maintien du programme dans les esprits.
- **Comprendre le comportement des désengagés (les désabonnés) : analyser le comportement des clients qui quittent le programme pour détecter les signaux de désengagement
- **Personnaliser les offres** : s'informer sur les préférences des adhérents (budgets, destinations préférées, services attendus) afin de personnaliser les offres 

![Rapport d'analyse](./Rapport/Rapport_d'analyse.pdf)

## ⚪ Technologies utilisées

- **Python** : Jupyter Notebook, Pandas, Numpy, Matplotlib, Seaborn, Scipy
- **VSCode** : environnement de développement local
- **Git / Github** : gestion de version et mise en ligne du projet



## 🟣 Compétences développées

### Compétences techniques :

- Nettoyage et préparation des données
- Visualisation des données (barplots, pie charts, scatterplots, boxplots)
- Automatisation des tests statistiques via la création de fonctions
- Application de tests statistiques (Chi², Mann-Whitney U, Spearman)
- Gestion de projet via VSCode et Github

### Compétences transversales : 

- Esprit critique et capacité de synthèse
- Interprétation des résultats
- Vulagarisation des analyses pour un public non technique
- Formulation de recommandations claires et actionnables





