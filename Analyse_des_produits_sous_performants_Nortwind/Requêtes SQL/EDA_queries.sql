-- lECTURE DES TABLES
SELECT * FROM employees;
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_details;
SELECT * FROM products;




                                                /* EXPLORATORY DATA ANALYSIS */

-- CUSTOMERS --

-- 1.Nombre total de clients :

SELECT 
	COUNT(DISTINCT company_name) AS no_customers
FROM customers;

/* 91 clients, la table ne contient pas de doublons */


-- 2.Répartition des clients par pays : 
SELECT 
	country,
	COUNT(customer_id) AS no_customers
FROM customers
GROUP BY country
ORDER BY no_customers DESC;

/* Top 3 pays :  USA, Allemagne et France plus de 10 clients */

-- 3.Nombre de clients selon leur titre professionnel : 
SELECT
	contact_title,
	COUNT(customer_id) AS no_customers
FROM customers
GROUP BY contact_title
ORDER BY no_customers DESC;

/* Top 3 des professions de nos clients Owner, Sales representative et Marketing manager*/

-- 4.Nombre de commandes par client :
SELECT
	c.company_name,
	COUNT(o.order_id) AS no_orders
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
GROUP BY c.company_name
ORDER BY no_orders DESC; 

/*  le nombre de commandes varie entre 0 et 31 commandes par client. Deux clients n'ont jamais passé commande (Paris spécialité et FISSA Fabrica inter...)
(Top 3 :  Save-a-lot Markets (31), Ernst Handel (30) et QUICK-Stop (28)) */


-- EMPLOYEES --

-- 1.Nombre total d’employés :
SELECT 
	COUNT(DISTINCT employee_name) AS no_employees
FROM employees

/*  9 employés au total, pas de doublon s*/

-- 2.Hiérarchie au sein de l'entreprise : 

SELECT 
e1.*,
e2.employee_name,
e2.title,
e2.country
FROM employees e1
CROSS JOIN employees e2 
WHERE e1.reports_to = e2.employee_id;

/* Un vice président aux USA supervise deux managers. Chaque manager supervise 3 sales representative (USA et UK)  */


-- 3.Total de commandes par employés : 
SELECT
	e.employee_id,
	e.employee_name,
	COUNT(o.order_id) AS no_orders
FROM employees e
LEFT JOIN orders o
	ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.employee_name
ORDER BY no_orders DESC;

/* employés (1,3,4 et 8) plus de 100 commandes à leur actif. Il n'y pas d'employés sans commande */

-- 4. Ancienneté des employés (par rapport à la date de la 1ère commande) : 
SELECT
	e.employee_name,
	MIN(o.order_date) AS first_order
FROM employees e
JOIN orders o 
	ON o.employee_id = e.employee_id
GROUP BY e.employee_name
ORDER BY first_order;

/* Tous les employés ont réalisé leur 1ère commande en juillet 2013 avec quelques jours d'intervalle */
	

-- PRODUCTS --

--1.Nombre total de produits :
SELECT 
	COUNT(DISTINCT product_name) AS no_products
FROM products;

/*  le catalogue contient 77 produits, il n'y pas de doublons dans la table */


--2.Produits actifs vs non actifs : 
SELECT
	discontinued,
	COUNT(product_id) AS no_products
FROM products
GROUP BY discontinued;

/* 8 produits arrêtés et 69 produits actifs */


-- 4. Nombre de produits par catégorie : 
SELECT
	category_name,
	COUNT(product_id) AS no_products
FROM products
GROUP BY category_name
ORDER BY no_products DESC;

/* 8 catégories de produits possédant entre 5 à 13 produits */


-- 5.Répartition des prix (min, max, moyenne): 
SELECT 
	MIN(unit_price) AS min_price,
	MAX(unit_price) AS max_price,
	AVG(unit_price) AS mean_price
FROM order_details;

/* Prix min 2$, Prix max 263.5$ et moyenne des prix 26.21 $ */


-- ORDERS --

-- 1.Nombre total de commandes : 
SELECT 
	COUNT(DISTINCT order_id) AS no_orders
FROM orders;

/* 830 commandes au total, pas de doublons */


-- 2.Nombre de commandes par mois pour chaque année : 

SELECT
	TO_CHAR(order_date,'YYYY-MM') AS year_month,
	COUNT(order_id) AS no_orders
FROM orders
GROUP BY TO_CHAR(order_date,'YYYY-MM')
ORDER BY year_month;

/* 2013 (20+ cdes), 2014 (30+ cdes), 2015 (50+ cdes) */


-- 3. Moyenne de commandes par an : 
WITH orders_per_month AS
(SELECT
	EXTRACT(YEAR FROM order_date) AS year,
	EXTRACT(MONTH FROM order_date) AS month,
	COUNT(order_id) AS no_orders
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY year, month)

SELECT 
	year,
	ROUND(AVG(no_orders),2) AS mean_orders
FROM orders_per_month
GROUP BY year;

/* Évolution croissante du nombre de commandes par an 2013: 25 cdes, 2014 : 34 cdes, 2015 : 54 cdes */


-- 4. Répartiton des commandes par pays : 
SELECT 
	c.country,
	COUNT(o.order_id) AS no_orders
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY no_orders DESC;

/* Top 3 des pays où nous avons le plus de commandes (Germany (122), USA (122) et Brazil (83)) */


-- ORDER_DETAILS --

SELECT * FROM order_details;

-- 1.Chiffre d'affaires total : 
SELECT
	ROUND(SUM(od.unit_price * od.quantity * (1-od.discount))::numeric,2) AS total_revenue
FROM order_details AS od
JOIN products AS p
	ON od.product_id = p.product_id AND p.discontinued = FALSE;

/* 1 080 802 dollars de chiffre d'affaires entre juillet 2013 et mai 2015 pour l'ensemble des produits actifs */


-- 2. Chiffre d'affaires par produit :
SELECT 
	p.product_id,
	p.product_name,
	ROUND(SUM(od.unit_price * od.quantity * (1-discount))::numeric,2) AS product_revenue
FROM products p
JOIN order_details od
	ON p.product_id = od.product_id AND p.discontinued = FALSE
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC;

/*  Top 3 des produits qui génèrent plus de 70 000 dollars de CA (Côte de Blaye, Thüringer et raclette) */


-- 3. Nombre d'unités vendues par produit : 
SELECT 
	p.product_id,
	p.product_name,
	SUM(od.quantity) AS total_quantity
FROM products p
JOIN order_details od
	ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity DESC;

/* Les produits les plus vendus sont des fromages : Camembert, Raclette et Gorgonzola avec plus de 1300 unités vendues */

-- 4. Remise moyenne appliquée pour les commandes concernées : 
SELECT
	AVG(discount) AS mean_discount
FROM order_details
WHERE discount > 0;

/* Une moyenne de 15% de remise */


-- 5.Vérifier que tous les produits ont bien été vendus au moins une fois
SELECT 
	p.product_id,
	p.product_name,
	COUNT(od.product_id) AS no_products
FROM products p
LEFT JOIN order_details od
	ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY no_products;

/* Quantités vendues par produit : minimum 5 unités, maximum 54 unités vendues par produit */
