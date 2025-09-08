--------------------------------------------------- ANALYSE DES PRODUITS SOUS-PERFORMANTS ---------------------------------------------------------------
SELECT * FROM employees;
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_details;
SELECT * FROM products
SELECT * FROM low_product_quantity;
SELECT * FROM low_product_revenue;
SELECT * FROM product_performance
WHERE performance_status ='good_performance';


													/* IDENTIFIER LES PRODUITS SOUS-PERFORMANTS */





-- 1. Identifier les 10% des produits les plus faibles en quantités vendues et les stocker dans une vue : 

CREATE VIEW low_product_quantity AS (
WITH product_quantity AS (
	SELECT 
		p.product_id,
		p.product_name,
		p.category_name,
		SUM(od.quantity) AS no_quantity,
		ROUND(SUM(od.unit_price * od.quantity * (1-od.discount))::numeric,2) AS product_revenue
	FROM products AS p
	JOIN order_details AS od
		ON p.product_id = od.product_id
	WHERE p.discontinued= FALSE
	GROUP BY p.product_id, p.product_name, p.category_name
),
-- Seuil de 10 % des quantités vendues
threshold_q1 AS (
	SELECT
		PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY no_quantity) AS quantity_q1
	FROM product_quantity
)
SELECT 
	pq.product_id,
	pq.product_name,
	pq.category_name,
	pq.no_quantity,
	pq.product_revenue
FROM product_quantity AS pq
CROSS JOIN threshold_q1 AS tq
WHERE pq.no_quantity <= tq.quantity_q1
ORDER BY pq.no_quantity
);

/* 7 produits sous-performants en termes de quantités vendues strictement inférieures à 296 unités totales */


-- 2. Identifier les 10% des produits les plus faibles en terme de chiffre d'affaires et les stocker dans une vue : 

CREATE VIEW low_product_revenue AS (	
WITH product_revenue AS (
	SELECT 
		p.product_id,
		p.product_name,
		p.category_name,
		SUM(od.quantity) AS no_quantity,
		ROUND(SUM(od.unit_price * od.quantity * (1-od.discount))::numeric,2) AS product_revenue
	FROM products p
	JOIN order_details od
		ON p.product_id = od.product_id
	WHERE p.discontinued=FALSE
	GROUP BY p.product_id, p.product_name, p.category_name
			
),
-- Seuil de 10 % du chiffre d'affaires 
threshold_q1 AS (
	SELECT
		PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY product_revenue) AS revenue_q1
	FROM product_revenue
)
SELECT 
	pr.product_id,
	pr.product_name,
	pr.category_name,
	pr.no_quantity,
	pr.product_revenue
FROM product_revenue AS pr
CROSS JOIN threshold_q1 AS tq
WHERE pr.product_revenue < tq.revenue_q1
ORDER BY pr.product_revenue

/* 7 produits sous-performants en terme de chiffre d'affaires inférieur à 3195,16 dollars */


-- 3.Visualiser les prix unitaires, moyenne des prix de ventes et la hausse de prix (%) des produits sous-performants : 

SELECT 
	p.product_id,
	p.product_name,
	p.category_name,
	p.unit_price,
	ROUND(AVG(od.unit_price)::numeric,2) AS mean_price,
	ROUND((AVG(od.unit_price) / p.unit_price) ::numeric,2) AS pct_growth
FROM products AS p
JOIN order_details AS od
	ON p.product_id = od.product_id
-- Jointure avec les tables de produits à faible volume et faible chiffre d'affaires combinées
JOIN (
	SELECT product_id FROM low_product_quantity
		UNION
	SELECT product_id FROM low_product_revenue) AS lp
	ON p.product_id = lp.product_id
GROUP BY p.product_id,p.product_name, p.category_name, p.unit_price
ORDER BY p.unit_price DESC;

/* 10 produits uniques au total, les prix unitaires varient entre 8,77 et 23,40 dollars, une moyenne compris entre 2 et 23.44 $
et une hausse moyenne de 9 % */


-- 4.Identifier les produits sous-performants en termes de quantités vendues et chiffre d'affaires :  
SELECT 
	product_id,
	product_name,
	category_name
FROM low_product_quantity
	INTERSECT
SELECT
	product_id,
	product_name,
	category_name
FROM low_product_revenue

/* 4 produits sous-performants à la fois en faible volume et chiffre d'affaires */


-- 5. Proportion des produits sous_performants par catégorie
WITH low_product AS (
	SELECT 
		product_id,
		product_name,
		category_name
	FROM low_product_quantity
		UNION
	SELECT
		product_id,
		product_name,
		category_name
	FROM low_product_revenue
),
product_category AS (
	SELECT 
		category_name,
		COUNT(*) AS total_product
	FROM products
	GROUP BY category_name
)
SELECT 
	lp.category_name,
	COUNT(*) AS no_low_product,
	pc.total_product,
	ROUND(COUNT(*)::decimal / pc.total_product *100,2) AS pct_low_product
FROM low_product AS lp
JOIN product_category AS pc
	ON lp.category_name = pc.category_name
GROUP BY lp.category_name, pc.total_product

/* Catégorie 'Condiments' est la plus affectée contenant 25 % de produits sous-performants */


-- 6.Classer l'ensemble des produits en 4 catégories (low_revenue, low_quantity,low_quantity_revenue (faible quantité et CA) et good_performance)
CREATE VIEW product_performance AS (
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
-- Seuil de 10 % du volume de vente et du chiffre d'affaires
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
);


--7.Proportion des ventes  et des quantités sur le CA total et les quantités totales pour chaque catégorie de performance
---7.1 Proportion des quantités des produits sous-performants en termes de quantités vendues : 

SELECT 
	performance_status,
	SUM(total_quantity) AS categ_quantity
FROM product_performance
GROUP BY performance_status
)
SELECT 
	performance_status,
	ROUND(categ_quantity / SUM(categ_quantity) OVER() * 100.0,2) AS pct_quantity -- quantités vendues par categ (%)
FROM quantity_pct
ORDER BY performance_status;

/* Produits performants : 94 % des quantités vendues,
   Produits à faible quantité vendue : 1.6 % des quantités vendues
   Produits à faible quantité vendue et chiffre d'affaires : 1.2 % des quantités vendues
   Produits à faibles chiffre d'affaires : 3 % des quantités vendues
*/



---7.2.Proportion des ventes des produits sous-performants en termes de chiffre d'affaires : 
WITH revenue_pct AS (
SELECT 
	performance_status,
	SUM(total_revenue) AS categ_revenue
FROM product_performance
GROUP BY performance_status
)
SELECT 
	performance_status,
	ROUND(categ_revenue / SUM(categ_revenue) OVER() * 100.0,2) as pct_revenue -- CA par categ (%)
FROM revenue_pct

/* Produits performants : 97 % du chiffres d'affaires,
   Produits à faible quantité vendue : 1 % du chiffre d'affaires
   Produits à faible quantité vendue et chiffre d'affaires : 0.76 % du chiffre d'affaires
   Produits à faibles chiffre d'affaires : 0.66 % du chiffre d'affaires
*/



-- 8. Analyse des remises applicables sur les produits sous-performants : 2 à 11% de remise en moyenne sur les produits sous-performants
SELECT 
	pp.product_id,
	pp.product_name,
	pp.category_name,
	ROUND(AVG(od.discount)::decimal,2) AS mean_discount
FROM order_details AS od
JOIN product_performance AS pp
	ON od.product_id = pp.product_id
WHERE performance_status !='good_performance'
GROUP BY pp.product_id, pp.product_name, pp.category_name
ORDER BY mean_discount;

/* En moyenne les remises sont comprises entre 2 et 11 % */


-- 9. Remise moyenne et prix moyen par catégorie de performance produit
WITH mean_discount_product AS (
SELECT 
	pp.performance_status,
	ROUND(AVG(od.discount)::DECIMAL,2) AS mean_discount
FROM product_performance AS pp
JOIN order_details AS od
	ON pp.product_id = od.product_id
GROUP BY pp.performance_status
),
--Quantités totales, CA total et prix moyen de vente par categorie de performance
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

/* Produits performants : remise moyenne de 6 %, prix moyen de 27 $
   Produits à faible quantité vendue : remise moyenne de 4 %, prix moyen de 14 $
   Produits à faible quantité vendue et chiffre d'affaires : remise moyenne de 6 %, prix moyen de 15 $
   Produits à faibles chiffre d'affaires : remise moyenne de 4 %, prix moyen de 6 $
*/

			
											
											
											/* PERFROMANCE DES PRODUITS SOUS-PERFORMANTS */


-- 1.Quantités vendues et chiffre d'affaires des produits sous-performants par mois 

SELECT 
	TO_CHAR(o.order_date, 'YYYY-MM') AS year_month,
	pp.product_id,
	pp.product_name,
	AVG(od.unit_price) AS mean_price,
	SUM(od.quantity) AS total_quantity,
	ROUND(SUM(od.unit_price * od.quantity * (1-od.discount))::numeric,2) AS total_revenue,
	pp.performance_status
FROM orders AS o
JOIN order_details AS od 
	ON o.order_id = od.order_id
JOIN product_performance AS pp
	ON od.product_id = pp.product_id
WHERE pp.performance_status !='good_performance'
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM'), pp.product_id, pp.product_name, pp.performance_status
ORDER BY pp.product_name, year_month;

/* On observe que les ventes ne présentent pas de tendance particulière. 
Le volume et le chiffre d'affaires varient d'un mois à l'autre à la hausse comme à la baisse */


-- 2.Analyse des ventes par mois des produits sous-performants :
WITH low_product_sales AS (
	SELECT 
		TO_CHAR(o.order_date, 'YYYY-MM') AS year_month,
		pp.product_id,
		pp.product_name,
		AVG(od.unit_price) AS mean_price,
		SUM(od.quantity) AS total_quantity,
		ROUND(SUM(od.unit_price * od.quantity * (1-od.discount))::numeric,2) AS total_revenue,
		pp.performance_status
	FROM orders AS o
	JOIN order_details AS od 
		ON o.order_id = od.order_id
	JOIN product_performance AS pp
		ON od.product_id = pp.product_id
	WHERE pp.performance_status !='good_performance'
	GROUP BY TO_CHAR(o.order_date, 'YYYY-MM'), pp.product_id, pp.product_name, pp.performance_status
	
)
SELECT 
	year_month,
	product_id,
	product_name,
	total_quantity,
	total_revenue,
	COALESCE(LAG(total_revenue) OVER(PARTITION BY product_id ORDER BY year_month),0 ) AS prev_sales,
	COALESCE(total_revenue - LAG(total_revenue) OVER(PARTITION BY product_id ORDER BY year_month),0) AS diff_sales,
	CASE 
		WHEN total_revenue - LAG(total_revenue) OVER(PARTITION BY product_id) < 0 THEN 'Decrease'
		WHEN total_revenue - LAG(total_revenue) OVER(PARTITION BY product_id) > 0 THEN 'Increase'
		ELSE 'No_change'
	END AS Growth_status
FROM low_product_sales
ORDER BY product_name, year_month;




								/* COMMANDES CONTENANT DES PRODUITS SOUS-PERFORMANTS*/

-- 1. Proportion des commandes contenant des produits sous-performants : 
WITH low_product_orders AS (
SELECT
	order_id,
	product_id
FROM order_details AS od
WHERE product_id IN ( 
					 SELECT DISTINCT product_id 
					 FROM product_performance
					 WHERE performance_status != 'good_performance')
)
SELECT 
	ROUND(
	COUNT(DISTINCT order_id)::DECIMAL
	/ (SELECT COUNT(order_id) FROM orders)*100,2)
FROM low_product_orders;

/* 13 % des commandes totales contiennent des produits sous-performants */

-- 2.Compter le nombre de ventes des produits sous-performants

WITH low_product_orders AS (
SELECT
	order_id,
	product_id
FROM order_details AS od
WHERE product_id IN ( 
					 SELECT DISTINCT product_id 
					 FROM product_performance
					 WHERE performance_status != 'good_performance')
)
SELECT 
 lpo.product_id,
 p.category_name,
 p.product_name,
 COUNT(lpo.product_id) AS product_count
 FROM low_product_orders AS lpo
 JOIN products AS p
 	ON lpo.product_id = p.product_id
 GROUP BY lpo.product_id, p.category_name, p.product_name
 ORDER BY product_count DESC;

/* Les produits sous-performant ont été commandés entre 6 et 32 fois */

 -- Durée moyenne entre les commandes contenant des produits sous-performants : Les produits sous-performants sont commandés en moyenne tous les 2-3 mois
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


/* Employés et clients des produits sous-performants */


-- 1.Profil des clients acheteurs des produits sous-performants
WITH low_product_customers AS (
SELECT 
	c.customer_id,
	c.company_name,
	c.contact_title,
	c.country,
	od.product_id
FROM customers AS c
JOIN orders AS o
	ON c.customer_id = o.customer_id
JOIN order_details AS od
	ON o.order_id = od.order_id
JOIN product_performance AS pp 
	ON od.product_id = pp.product_id AND pp.performance_status != 'good_performance'
)

SELECT 
	country,
	company_name,
	product_id,
	COUNT(*) AS total_product
FROM low_product_customers 
GROUP BY country, company_name, product_id
ORDER BY total_product DESC;

/* Top 3 des pays ayant achetés plusieurs fois les produits sous-performants :
USA, Germany et Venezuela entre 2 et 3 fois, une majorité des pays à achat unique 
*/


-- 2. Nombre de clients par équipe commerciale :  
SELECT 
	e.country,
	COUNT(*) AS no_customers
FROM customers AS c
LEFT JOIN orders AS o
	ON c.customer_id = o.customer_id
LEFT JOIN employees AS e
	ON o.employee_id = e.employee_id
GROUP BY e.country 

/* 606 client pour l'équipe US contre 202 pour l'équipe UK */


-- 3. Analyse la performance des équipes commerciales des produits sous-performants : 

WITH low_product_employee AS (
SELECT 
	e.employee_id,
	e.employee_name,
	e.title,
	e.country,
	od.product_id
FROM employees AS e
JOIN orders AS o
	ON e.employee_id = o.employee_id
JOIN order_details AS od 
	ON o.order_id = od.order_id
JOIN product_performance AS pp
	ON od.product_id = pp.product_id AND pp.performance_status !='good_performance'
)

SELECT 
	country,
	COUNT(*) AS total_product
FROM low_product_employee
GROUP BY  country
ORDER BY total_product DESC;

/* Majorité des produits sous-performants vendus par l'équipe US 89 produits contre 28 pour l'équipe UK */
	