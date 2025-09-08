<p align="center">
  <img src="./Images/Moveek_logo.png" alt="Logo" width="200">
</p>

# 📦 Analyse des retards de livraison des commandes Moveek



## 🔵 Contexte

Moveek est une entreprise spécialisée dans la vente de vêtements et d'équipements sportifs. 

Suite à une recrudescence ces derniers mois des réclamations liées aux commandes retardées, l'entreprise souhaite réaliser une analyse pour identifier les principales causes.

Cette analyse permettra de définir des actions correctives pour améliorer la chaîne de traitement des commandes et la relation client.



## 🟢 Objectifs

Les principaux objectifs de cette analyse sont :

- Identifier les catégories les plus affectées par les retards (produit, types de clients, pays, méthodes de paiement, etc.)
- Analyser l'impact de certaines variables (Types de livraison, volume de commande, distance) sur les délais de livraison
- Fournir des recommandations pour optimiser le traitement des commandes et améliorer la satisfaction client



## 🟡 Données utilisées

**Période analysée** : Janvier 2015 au 31 janvier 2018  
**Nombre de commandes** : 65 257

Données utilisées concernent :

- Les clients : identifiant, type, ville
- Les commandes : identifiant, date, ventes, bénéfices, délais de préparation
- Les expéditions : pays, option d'envoi, date et statut de livraison
- Le paiement : type de paiement 



## 🔵 Sources de données

Les données utilisées dans ce projet proviennent du site : [Kaggle](https://www.kaggle.com/)  
Lien du dataset : https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis/data



## 🟣 Méthodologie

**1. Préparation des données** :

- La vérification des valeurs manquantes et dupliquées.
- L’harmonisation des noms de variables.
- Correction des incohérences dans les données (variable "benefit_per_order").
- La création de variables supplémentaires pertinentes pour l’analyse (délais de traitement, écart de livraison, etc.).

**2. **Analyse exploratoire**

- Répartition des commandes par statut de livraison.
- Impact des différentes variables (type de produit, client..).
- Analyse des volumes et corrélations.



## 🟠 Quelques Résultats illustrés

![Évolution des commandes et des retards](./Images/Évolution%20des%20commandes%20totales%20et%20retardées.png)

Le nombre de commandes est assez stable avec un léger pic à partir de fin 2017. L'évolution des retards est proportionnelle au nombre de commandes reçues.

![Répartition des commandes par statut de livraison](./Images/commandes%20par%20statut%20de%20livraison.png)

Plus de 55 % des commandes sont livrées en retard, représentant une problématique majeure que Moveek doit solutionner.

![Proportion des commandes selon le nombre d'articles commandés](./Images/Nombre%20d'articles%20commandés.png)

Les commandes unitaires sont majoritairement impactées par les retards, représentant plus de 20 % des commandes retardées.  
Les commandes supérieures à 1 article, moins nombreuses, sont beaucoup moins affectées. Cela suggère que la taille des commandes n'est pas un facteur déterminant des retards, tandis que la fréquence des commandes d'une certaine quantité semble représenter une des principales causes des retards

![Top 5 des destination des commandes](./Images/Top%205%20des%20pays%20de%20livraison.png)

Les États-unis sont la principale destination des commandes totales et retardées, suivi par la France, le Mexique, l'Australie et l'Allemagne.  
La distance ne semble pas représenter un facteur de retard (Points de vente situés aux US), cela suggère de nouveau une possible relation entre le volume de commande et la fréquence des retards.

![Proportion des commandes par type de client](./Images/Commandes%20selon%20type%20client.png)

Les Consumer (Particuliers) représentent la clientèle majoritaire de Moveek (+ 50 % des commandes réalisées).  
Cette clientèle est également la plus touchée par les retards de livraison (+ 50 % de commandes retardées). Ce qui suggère également une relation existante entre le volume de commande et les retards de livraison.

Pour conclure, les retards semblent davantage liés au volume de commandes passées qu'à la taille, la distance ou le type de client.



## 🔴 Limites de l'analyse

- Absence de données sur la satisfaction client : difficile de mesurer l’impact réel des retards sur la satisfaction client.
- Peu d’information sur les causes internes des retards : Les données sont insuffisantes et ne permettent pas d’identifier la ou les causes réelles du problème (réception des commandes, traitement des commandes, préparation des commandes, problèmes logistiques).



## 🟡 Recommendations

- Analyser plus finement la chaîne opérationelle des commandes permettant d'identifier la ou les causes réelles de retard.

### Actions à envisager : 

- Renforcer l’organisation des équipes afin d’assurer un traitement plus efficace.
- Réviser les délais de livraison en fonction de l’historique et des performances passées pour garantir plus de fiabilité.
- Optimiser la gestion des commandes, en priorisant notamment les catégories les plus populaires pour améliorer la disponibilité et la réactivité.
- Mettre en place une application prédictive capable d’anticiper les retards de livraison, afin de mieux planifier et informer les clients.
- Envisager un système de compensation (ex. remise sur une prochaine commande) en cas de retard, pour renforcer la fidélisation client.




## ⚪ Technologies utilisées

- **Python** : Jupyter Notebook, Pandas, Numpy, Matplotlib, Seaborn
- **VSCode** : environnement de développement local
- **Git / Github** : gestion de version et partage du projet en ligne



## 🟣 Compétences développées

### Compétences techniques :

- Nettoyage et préparation des données
- Analyse exploratoire et descriptives
- Python (Jupyter Notebook)
- Gestion de projet via VSCode et Github

### Compétences transversales : 

- Esprit critique et de synthèse
- Interprétation des résultats via les graphiques générés
- Communication des résultats à un public non technique
- Formulation de recommandations à partir de données actionnables
