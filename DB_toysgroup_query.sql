-- Task 4: Risolvere le query
USE ToysGroup;        -- Uso DB creato
-- Es.1: Verificare che i campi definiti come PK siano univoci. 
-- Scrivi una query per determinare l’univocità dei valori di ciascuna PK (una query per tabella implementata).
-- Posso verificare univocità in vari modi (ne scelgo uno per ogni tabella)

-- Tabella Category
-- Metodo 1: visualizzo le chiavi nella tabella (esempio entità forte)
SHOW KEYS FROM category;                             -- restituisce informazioni su indici tabella
-- Risulta solo una PK -> nella colonna 'Non_unique', 0 indica che l'indice non permette duplicati (unico)

-- Tabella Product 
-- Metodo 1: visualizzo le chiavi nella tabella (esempio entità debole)
SHOW KEYS FROM product;                              -- restituisce informazioni su indici tabella
-- Risulta una PK -> nella colonna 'Non_unique', 0 indica che l'indice non permette duplicati (unico)
-- Risulta una FK -> nella colonna 'Non_unique', 1 indica che l'indice permette duplicati (non unico)

-- Tabella Sales 
-- Metodo 2: seleziono valori ID unici con DISTINCT e confronto con numero record effettivo tabella
SELECT * FROM sales;                                 -- 20 record totali -> num.effettivo record tabella
SELECT DISTINCT sale_id 
FROM sales
ORDER BY sale_id;                                    -- 20 PK -> verificata univocità

-- Tabella Region 
-- Metodo 3: conto numero totale di chiavi e confronto con numero record effettivo tabella
SELECT * FROM region;                                -- 20 record totali -> num.effettivo record tabella
SELECT COUNT(region_id) AS PK FROM region;           -- 1 record = 20 PK -- COUNT, se c'è NULL, non lo conta 
SELECT COUNT(DISTINCT region_id) AS PK FROM region;  -- 1 record = 20 PK -- DISTINCT -> valori unici di chiave

-- Tabella State 
-- Metodo 4: raggruppo per ID e conto quante volte appare lo stesso valore ID
-- Vedo cosi se ci sono State duplicati -> nella colonna univocita devo esserci tutti 1
SELECT * FROM state;                                 -- 22 record
SELECT state_id, COUNT(*) AS Univocita			
FROM state
GROUP BY state_id;                                   -- non esistono valori duplicati -> 22 record univocita con valore 1

-- Tabella Customer
-- Metodo 5: raggruppo per ID e conto quante volte appare lo stesso valore ID (con HAVING)
-- Se il conteggio delle ID è > 1, significa che ci sono duplicati -> non è valore univoco
SELECT * FROM customer;                              -- 20 record
SELECT customer_id, COUNT(*) AS Univocita	
FROM customer
GROUP BY customer_id
HAVING COUNT(*) > 1;                                 -- non resituisce risultato -> quindi ogni valore è univoco

-- Es.2: Esporre l’elenco delle transazioni, indicando nel result set il codice documento, la data, il nome del prodotto, 
-- la categoria del prodotto, il nome dello stato, il nome della regione di vendita e un campo booleano
-- valorizzato in base alla condizione che siano passati più di 180 giorni dalla data vendita o meno 
-- (>180 -> True, <= 180 -> False)
SELECT s.document_code, 
	MAX(s.sale_date) as sale_date, 
	MAX(p.product_name) as product_name, 
	MAX(c.category_name) as category_name,
	MAX(st.state_name) as state_name, 
	MAX(r.region_name) as region_name,
	IF(DATEDIFF(CURDATE(), MAX(s.sale_date)) > 180,'true','false') AS '>180gg'
FROM category AS c
JOIN product AS p 
ON c.category_id = p.category_id
RIGHT JOIN sales AS s 
ON p.product_id = s.product_id
JOIN region AS r 
ON s.region_id =  r.region_id
JOIN state AS st 
ON r.region_id = st.region_id
GROUP BY s.document_code
ORDER BY s.document_code;                            -- 20 record
SELECT * FROM sales;                                 -- 20 record -> combaciano con il risultato della query 

-- Es.3: Esporre elenco prodotti con venduto totale = a una quantità > della media vendite realizzate nell’ultimo anno 
-- censito. (Ogni valore della condizione deve risultare da una query e non deve essere inserito a mano). 
-- Nel result set devono comparire solo il codice prodotto e il totale venduto.  
SELECT p.product_id, SUM(s.total_amount) AS total_sold
FROM product AS p
JOIN sales AS s
ON p.product_id = s.product_id
WHERE YEAR(s.sale_date) = (SELECT MAX(YEAR(s.sale_date)) FROM sales)
GROUP BY p.product_id 
HAVING SUM(s.total_amount) > (
    SELECT ROUND(AVG(s.total_amount),2) AS avg_totalprice
    FROM sales s
    WHERE YEAR(s.sale_date) = (
    SELECT MAX(YEAR(s.sale_date)) FROM sales))
ORDER BY product_id;                                 -- 7 record
-- Result set: ID1 = 249.95, ID4 = 149.95, ID5 = 199.98, ID14 = 159.96, ID22 = 251.93, ID23 = 227.97, ID25 = 119.98

-- Verifico che sia corretta la query
-- Calcolo la media del totale venduto per prodotto, nell'ultimo anno censito
SELECT ROUND(AVG(s.total_amount),2) AS avg_totalprice
FROM sales s
WHERE YEAR(s.sale_date) = 
(SELECT MAX(YEAR(s.sale_date)) FROM sales);          -- AVG 101.42
-- Verifico totali venduti per prodotti > AVG ottenuta
SELECT p.product_id, SUM(s.total_amount) AS total_sold
FROM product AS p
JOIN sales AS s
ON p.product_id = s.product_id
WHERE YEAR(s.sale_date) = (SELECT MAX(YEAR(s.sale_date)) FROM sales)
GROUP BY p.product_id
HAVING SUM(s.total_amount) > 101.42
ORDER BY product_id;                                 -- 7 record
-- Result set: ID1 = 249.95, ID4 = 149.95, ID5 = 199.98, ID14 = 159.96, ID22 = 251.93, ID23 = 227.97, ID25 = 119.98
-- Query corretta

-- Es.4: Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno.
SELECT p.product_name, YEAR(s.sale_date) AS year_sales, SUM(total_amount) AS year_amount
FROM product p
JOIN sales s
ON p.product_id = s.product_id
GROUP BY p.product_id, year_sales
ORDER BY p.product_name;                             -- 20 record

-- Es.5: Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.
SELECT st.state_name, YEAR(s.sale_date) AS year_sales, SUM(s.total_amount) AS year_amount
FROM state st
JOIN region r
ON st.region_id = r.region_id
JOIN sales s 
ON r.region_ID = s.region_id
GROUP BY st.state_name, year_sales
ORDER BY year_sales DESC, year_amount DESC;          -- 31 record

-- Es.6: Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?
SELECT c.category_name, SUM(s.quantity_sold) AS total_quantity_sold
FROM category AS c
JOIN product AS p 
ON c.category_id = p.category_id
JOIN sales AS s
ON p.product_id = s.product_id
GROUP BY c.category_name
ORDER BY total_quantity_sold DESC LIMIT 1;           -- 1 record -> Board Games = 13 volte venduta
-- Verifica
SELECT * FROM category;                              -- Board Games ID=3
SELECT * FROM product WHERE category_id IN (3);      -- ID 4,13,22
SELECT * FROM sales WHERE product_id IN (4,13,22);   -- 13 somma totale quantità venduta

-- Es.7: Rispondere alla seguente domanda: quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.
-- Metodo 1: con LEFT JOIN tra Product e Sales, seleziono prodotti che non hanno corrispondenza nella tabella vendite 
SELECT p.product_id, p.product_name 
FROM product AS p
LEFT JOIN sales AS s
ON p.product_id = s.product_id
WHERE s.product_id IS NULL;                          -- 5 record -- ID prodotti invenduti (3,8,10,12,16)
-- Metodo 2: con SUBQUERY con NOT IN, seleziono prodotti il cui ID non appare nella tabella delle vendite
SELECT p.product_id, p.product_name 
FROM product p
WHERE p.product_id NOT IN
	(SELECT s.product_id FROM sales s);              -- 5 record -- ID prodotti invenduti (3,8,10,12,16)

-- Es.8: Creare una vista sui prodotti in modo tale da esporre una “versione denormalizzata” delle informazioni utili 
-- (codice prodotto, nome prodotto, nome categoria)
CREATE VIEW  info_utili AS (
SELECT p.product_id, p.product_name, c.category_name
FROM category AS c 
RIGHT JOIN product AS p
ON c.category_id = p.category_id
);                                                   
SELECT * FROM info_utili;                            -- 25 record

-- Es.9: Creare una vista per le informazioni geografiche
CREATE VIEW info_geo AS
SELECT  s.state_id, s.state_name, s.city, r.region_name
FROM state s 
LEFT JOIN region r 
ON s.region_id = r.region_id;                        
SELECT * FROM info_geo;                              -- 22 record