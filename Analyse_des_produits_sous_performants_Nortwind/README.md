<p align="center">
  <img src="./Images/Logo_Northwind.png" alt="Logo" width="200">
</p>

# 📈 Analyse de la performance des produits Northwind 🛒



## 🔵 Contexte

Northwind est une entreprise B2B spécialisée dans la vente de produits alimentaires à l’échelle internationale. Elle est organisée en deux équipes, l'une située aux États-Unis et l'autre à Londres. Son catalogue comprend 77 produits dont 8 ne sont plus commercialisés.

À la suite d'une hausse des prix fournisseurs, la direction souhaite identifier et analyser les produits à faible rotation et chiffre d'affaire afin d'identifier ceux susceptible d'être impactés par cette hausse.

Plutôt que de supprimer de nouvelles références, cette analyse permettra de proposer des ajustements stratégiques afin de mieux valoriser ces produits et accroître leurs ventes .



## 🟢 Objectifs

Les principaux objectifs de cette analyse sont :

- Identifier les produits à faible rotation et chiffre d'afaires.
- Analyser les raisons possibles de cette sous-performance (prix, remise, saisonnalité, etc.).
- Évaluer l'impact de la hausse tarifaire sur les différentes catégories de produits.
- Fournir des recommandations concrètes sur les actions à envisager pour valoriser les produits à faible rotation.



## 🟡 Données utilisées

**Période analysée** : juillet 2013 à mai 2015  
**Nombre de produits** : 77 dont 8 inactifs  
**Nombre de commandes** : 830  

Les données utilisées concernent :

- **Les clients (customers)** : nom de l'entreprise, nom du représentant et sa profession, ville et pays de résidence.
- **Les salariés (employees)** : identité des salariés (nom + prénom), profession, ville et pays d'activité, responsable rattaché.
- **Les commandes (orders)** : date de commande et l'employé ayant effectué la transaction.
- **Les commandes détaillées** : prix unitaire, quantité et remise appliquée par produit et par commande.
- **Les produits** : nom et description du produit, conditionnement, nouveau prix appliqué et sa catégorie.
 


## 🔵 Sources de données
Les données utilisées dans ce projet proviennent du site : [Mayven Analytics](https://mavenanalytics.io/)    
Lien du dataset : https://mavenanalytics.io/data-playground/northwind-traders



## 🟣 Méthodologie

**1. Préparation et modélisation des données** 

- Création d'un diagramme ERD (Entity Relationship Diagram) pour représenter les relations entre les tables clés (Product, Customers, Employees, etc.).
- Génération automatique de la base dans PostgreSQL à partir de ce modèle conceptuel.
- Dénormalisation de la table *Category* dans la table Product :
 - La table contenait peu d'informations pertinentes.
 - Simplifacation des requêtes et réduction des jointures inutiles.
- Vérification des doublons et des produits actifs/inactifs.

**2. Analyse exploratoire**

- **Construction de KPIs** : Nombre total de clients / produits / commandes / employés, remise moyenne.
- **Agrégations** : commandes par pays / client / employé, produits par catégorie.
- **Répartition** : prix, quantités vendues et chiffre d'affaires par produit.
- **Évolution commandes** : Nombre de commandes par mois et par an.

**3. Analyse avancée**

- Identification des produits à faible rotation et chiffre d'affaires (10 % des produits les plus faibles).
- Segmentation des produits selon leur performance: 
 - Low_quantity (faible volume), dont les ventes sont inférieures à 296 unités,
 - Low_revenue (faible chiffre d'affaires), dont le chiffre d'affaires est inférieur à 3200 dollars
 - Low_quantity_revenue (faible volume et CA), 
 - Good_performance (Volume et CA élevés).
- Analyse des performances grâce au croisement de différents indicateurs (quantité, chiffre d'affaires, remises, nombre de ventes, etc.).



## 🟠 Résultats 

- Un total de 10 produits distincts sous-performants identifiés, représentant seulement 2,4 % du chiffre d'affaires.
- Ces produits se répartissent en deux grandes catégories : 
  - **des produits saisonniers** (saumon mariné, caviar, bière artisanale), consommés lors d'événements spéciaux.
  - **des produits culturels** (sauce soja, tofu, chocolat finnois), fortement liés à une culture culinaire spécifique.
- Leur positionnement est globalement dans le bas voire milieu de gamme, avec des prix unitaires compris entre 2 et 23 dollars.
- La plupart de ces produits n'ont été achetés qu'une seule fois par client, ce qui suggère un manque de visibilité ou un usage ponctuel.
- La récente hausse des prix pourrait accentuer la faiblesse de ces produits.



## 🟡 Recommendations

- Cibler des clients/prospects spécialisés ou plus opportuns selon le type de produit.
- Réaliser des campagnes promotionnelles et des offres groupées pour une meilleure visibilité et accroissement des ventes, notamment lors d'événements spéciaux
- Adapter les prix et les remises sur certains produits pour plus d'attractivité
- Réaliser des enquêtes clients ayant achetés ces produits pour comprendre le manque d'intérêt
- Améliorer l'argumentaire de vente des représentants commerciaux pour mieux valoriser les produits.

![Rapport d'analyse (PDF)](./Rapport/Rapport_analyse.pdf)


## ⚪ Technologies utilisées

- **PostgreSQL** : modélisation avec diagramme ERD, génération de la base de données, requêtes SQL
- **VSCode** : environnement de développement local
- **Git / Github** : gestion de version et mise en ligne du projet



## 🟣 Compétences développées

### Compétences techniques :

- Modélisation de données : schéma conceptuel, ERD.
- Requêtes SQL exploratoires : agrégations, filtres, KPIs.
- Requêtes SQL avancées : CTE, fonctions de fenêtrage
- Gestion de projet via VSCode et Github

### Compétences transversales : 

- Esprit critique et capacité de synthèse
- Interprétation des résultats
- Vulagarisation des analyses pour un public non technique
- Formulation de recommandations claires et actionnables



## 🟢 Annexes : quelques exemples de requêtes SQL 

**1. Segmentation des produits par catégorie de performance**

```sql 
WITH all_product AS (
	SELECT 
		p.product_id,
		p.product_name,
		p.category_name,
		p.unit_price,
		ROUND(AVG(od.unit_price)::decimal,2) AS mean_price,
		SUM(od.quantity) AS total_quantity,
		ROUND(SUM(od.unit_price * od.quantity * (1-od.discount))::numeric,2) AS total_revenue -- ventes nettes (avec remise)
	FROM products AS p
	JOIN order_details AS od
		ON p.product_id = od.product_id
	WHERE p.discontinued=FALSE
	GROUP BY p.product_id, p.product_name, p.category_name, p.unit_price
),
-- Seuil de 10 % des quantités vendues et du chiffre d'affaires
threshold_q1 AS (
	SELECT 
		PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY total_quantity) AS qty_q1, 
		PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY total_revenue) AS revenue_q1
	FROM all_product
)

SELECT 
	ap.product_id,
	ap.product_name,
	ap.category_name,
	ap.unit_price,
	ap.mean_price,
	ap.total_quantity,
	ap.total_revenue,
	-- segmentation selon la performance produit
	CASE 
		WHEN ap.total_revenue < revenue_q1 AND ap.total_quantity < qty_q1 THEN'low_quantity_revenue'
		WHEN ap.total_revenue< revenue_q1 THEN 'low_revenue'
		WHEN ap.total_quantity < qty_q1 THEN 'low_quantity'
		ELSE 'good_performance'
	END AS performance_status
FROM all_product AS ap
CROSS JOIN threshold_q1 AS tq
```


**2. Impact du prix et remise moyenne par catégorie de performance**

```sql 
WITH mean_discount_product AS (
SELECT 
	pp.performance_status,
	ROUND(AVG(od.discount)::DECIMAL,2) AS mean_discount
FROM product_performance AS pp
JOIN order_details AS od
	ON pp.product_id = od.product_id
GROUP BY pp.performance_status
),
--Quantités et CA totaux par categorie de performance
total_per_performance AS ( 
SELECT 
	performance_status,
	SUM(total_quantity) AS total_quantity,
	SUM(total_revenue) AS total_revenue,
	ROUND(AVG(mean_price),2) AS mean_price
FROM product_performance
GROUP BY performance_status
)

SELECT 
mdp.performance_status,
mdp.mean_discount,
tpp.total_quantity,
tpp.total_revenue,
tpp.mean_price
FROM mean_discount_product AS mdp
JOIN total_per_performance AS tpp
	ON mdp.performance_status = tpp.performance_status;
```

**3. Fréquence des commandes contenant des produits sous-performants**

```sql
WITH low_product_month AS (
 SELECT 
		DATE(DATE_TRUNC('month', o.order_date)) AS year_month,
		pp.product_id,
		pp.product_name,
		pp.performance_status
	FROM orders AS o
	JOIN order_details AS od 
		ON o.order_id = od.order_id
	JOIN product_performance AS pp
		ON od.product_id = pp.product_id
	WHERE pp.performance_status !='good_performance'
	GROUP BY DATE_TRUNC('month', o.order_date), pp.product_id, pp.product_name, pp.performance_status
	ORDER BY pp.product_name, year_month
),
-- intervalle en jours entre chaque commande contenant des produits sous-performants 
order_interval AS (
	SELECT 
		year_month,
		product_id,
		product_name,
		LAG(year_month) OVER(PARTITION BY product_id ORDER BY year_month) AS prev_month,
		year_month - LAG(year_month) OVER(PARTITION BY product_id ORDER BY year_month) AS diff_days
	FROM low_product_month
)

SELECT 
	product_id,
	product_name,
	ROUND(AVG(diff_days),2) AS days_interval
FROM order_interval
GROUP BY product_id, product_name;
```
