-- Task 1: Creazione DB ToysGroup
CREATE DATABASE ToysGroup;
USE ToysGroup;

-- Task 2: Creazione tabelle
-- Creo tabella Category
CREATE TABLE category (                                     -- entità forte
    category_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,    -- ID categoria
    category_name VARCHAR(50) NOT NULL,                     -- nome categoria
    theme VARCHAR(50),                                      -- tema categoria
    functionality VARCHAR(80)                               -- funzionalità categoria
);
-- Creo tabella Product    
CREATE TABLE product (                                      -- entità debole di Category
    product_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,     -- ID prodotto
    product_name VARCHAR(40) NOT NULL,                      -- nome giocattolo
    age_range VARCHAR(5),                                   -- fascia età consigliata
    unit_quantity VARCHAR(10),                              -- quantità per unità
    unit_price DECIMAL(10,2) CHECK (unit_price >= 0),       -- prezzo unitario effettivo
    standard_cost DECIMAL(10,2) CHECK (standard_cost >= 0), -- costo di produzione
    list_price DECIMAL(10,2) CHECK (list_price >= 0),       -- prezzo di listino consigliato
    category_id INT,                                        -- chiave esterna
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);
-- Creo tabella Region 
CREATE TABLE region (                                       -- entità forte
    region_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,      -- ID regione
    region_name VARCHAR(20) NOT NULL UNIQUE                 -- nome regione
);
-- Creo tabella State
CREATE TABLE state (                                        -- entità debole di Region
    state_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,       -- ID stato
    state_name VARCHAR(20) NOT NULL,                        -- nome stato
    city VARCHAR(20),                                       -- nome città
    region_id INT,                                          -- chiave esterna per la regione
    FOREIGN KEY (region_id) REFERENCES region(region_id),
    UNIQUE (state_name, city)                               -- vincolo univocià: combinazione unica di stato e città
);
-- Creo tabella Customer -- anche se non serve per le query richieste, vorrei creare un DB completo
CREATE TABLE customer (                                     -- entità debole di State
    customer_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,    -- ID cliente
    first_name VARCHAR(20) NOT NULL,                        -- nome
    last_name VARCHAR(20) NOT NULL,                         -- cognome
    address VARCHAR(50),                                    -- indirizzo
    postal_code VARCHAR(10),                                -- cap
    email VARCHAR(30) NOT NULL UNIQUE,                      -- email
    phone_number VARCHAR(20),                               -- numero di telefono
    state_id INT,                                           -- chiave esterna per lo stato -- da qui si prende città e stato
    FOREIGN KEY (state_id) REFERENCES state(state_id),
    CHECK (email LIKE '%__@__%.__%')                        -- vincolo validità: verifica @ sia in un formato valido    
);
-- Creo tabella Sales
CREATE TABLE sales (                                        -- entità debole di Product, Region e Customer 
    sale_id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,        -- ID vendita
    order_date DATE,                                        -- data ordine (per mancanza pezzo in negozio/online)
    sale_date DATE,                                         -- data vendita
    quantity_sold INT CHECK (quantity_sold >= 0),           -- quantità venduta (maggiore o uguale a 0)
    unit_price DECIMAL(10,2) CHECK (unit_price >= 0),       -- prezzo unitario vendita (maggiore o uguale a 0)
    total_amount DECIMAL(10,2) CHECK (total_amount >= 0),   -- importo totale vendita al dì (maggiore o uguale a 0)
    discount DECIMAL(10,2) CHECK (discount >= 0),           -- sconto applicato (maggiore o uguale a 0)
    product_id INT,                                         -- chiave esterna per i prodotti   
    customer_id INT,                                        -- chiave esterna per i clienti
    region_id INT,                                          -- chiave esterna per la regione
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (region_id) REFERENCES region(region_id)
);

-- Task 3: Inserire valori nelle tabelle
-- Inserisco valori tabella Category
INSERT INTO category (category_name, theme, functionality) VALUES
('Educational Toys','Learning','Stimulate cognitive and motor skills'),
('Interactive Toys','Electronics','Interactive experiences'),
('Board Games','Social','Promote social skills and collaboration'),
('Creative and Craft Toys','Creativity','Encourage imagination and manual skills'),
('Outdoor Toys','Physical Activity','Promote active play'),
('Action Figures and Characters','Adventure','Represent movie and comic characters'),
('Musical Toys','Music','Explore the world of music'),
('Stuffed Animals and Dolls','Affection','Bedtime companions and role play'),
('Toy Vehicles','Mobility','Play with miniature vehicles'),
('STEM Toys','Learning','Promote learning in Science, Technology, Engineering, and Mathematics');
SELECT * FROM category;                          -- 10 record

-- Inserisco valori tabella Product
INSERT INTO product (product_name, age_range, unit_quantity, unit_price, standard_cost, list_price, category_id) VALUES
('Interactive Robot','6+',1,49.99,30.00,59.99,2),('Educational Puzzle','3+',1,15.99,8.00,18.99,1),
('Clay Set','5+',1,18.99,9.00,21.99,4),('Monopoly','8+',1,29.99,15.00,34.99,3),
('Kids Bicycle','5+',1,99.99,60.00,109.99,5),('Superhero Action Figure','5+',1,12.99,5.00,14.99,6),
('Painting Kit','4+',1,20.99,10.00,24.99,4),('Teddy Bear','0+',1,19.99,10.00,22.99,8),
('Race Car','3+',1,7.99,3.00,8.99,9),('Chemistry Set','10+',1,25.99,15.00,29.99,10),
('Talking Plush','2+',1,24.99,12.00,28.99,2),('Math Game','5+',1,14.99,7.00,17.99,10),
('Playing Cards','6+',1,9.99,4.00,11.99,3),('Musical Keyboard','3+',1,39.99,25.00,44.99,7),
('Soccer Ball','6+',1,19.99,8.00,22.99,5),('Doll','3+',1,15.99,7.00,18.99,8),('Train Set','3+',1,29.99,15.00,34.99,9),
('Robotics Kit','12+',1,49.99,30.00,59.99,1),('Logic Game','7+',1,12.99,6.00,15.99,7),
('Remote Control Car','6+',1,24.99,12.00,28.99,9),('Construction Castle','5+',1,45.99,25.00,49.99,1),
('Adventure Board Game','8+',1,35.99,20.00,39.99,3),('Toy Drone','10+',1,75.99,50.00,89.99,2),
('STEM Toy','7+',1,29.99,15.00,34.99,10),('Off-road Remote Control Car','6+',1,59.99,35.00,69.99,9);
SELECT * FROM product;                           -- 25 record

-- Inserisco valori tabella Region
INSERT INTO region (region_name) VALUES
('North Africa'),('South Africa'),('East Africa'),('West Africa'),
('North America'),('South America'),('East America'),('West America'),
('North Asia'),('South Asia'),('East Asia'),('West Asia'),
('North Europe'),('South Europe'),('East Europe'),('West Europe'),
('North Oceania'),('South Oceania'),('East Oceania'),('West Oceania');
SELECT * FROM region;                            -- 20 record

-- Inserisco valori tabella State
INSERT INTO state (state_name, city, region_id) VALUES
-- Europa
('Italy','Rome',14),('France','Paris',14),('Germany','Berlin',14),
('Spain','Madrid',15),('Sweden','Stockholm',13),('Netherlands','Amsterdam',15),
('Belgium','Brussels',15),('Switzerland','Zurich',13),('United Kingdom','London',15),
-- America
('United States','New York',5),('Canada','Toronto',5),('Mexico','Mexico City',6),
('Brazil','São Paulo',6),('Argentina','Buenos Aires',6),('Colombia','Bogotá',6),
('Chile','Santiago',6),('Peru','Lima',6),
-- Asia
('China','Beijing',9),('India','New Delhi',10),('Japan','Tokyo',10),
-- Africa
('South Africa','Cape Town',2),
-- Oceania
('Australia','Sydney',18);
SELECT * FROM state;                             -- 22 record

-- Inserisco valori tabella Customer
INSERT INTO customer (first_name, last_name, address, postal_code, email, phone_number, state_id) VALUES
('Pedro','Lopez','Carrera 7','110111','pedro.lopez@example.com','7890789078',6),             -- Colombia (Bogotá)
('Carlos','Garcia','Gran Vía','28013','carlos.garcia@example.com','4321432143',15),          -- Spagna (Madrid)
('Santiago','Perez','Avenida Libertador','8320000','p.santiago@example.com','8901890189',6), -- Cile (Santiago)
('Emily','Brown','Oxford Street','W1D 1BS','emily.brown@example.com','9012901290',15),       -- Regno Unito (Londra)
('Li','Wang','Wangfujing Street','100006','li.wang@example.com','0123012301',9),             -- Cina (Pechino)
('Juan','Martinez','Avenida 9 de Julio','C1043AAR','m.juan@example.com','6789678967',6),     -- Argentina (Buenos Aires)
('Akira','Tanaka','Shibuya Crossing','150-0002','t.akira@example.com','0987654321',10),      -- Giappone (Tokyo)
('Luis','Gomez','Avenida Larco','15074','luis.gomez@example.com','9012901290',6),            -- Perù (Lima)
('Erik','Svensson','Kungsgatan','111 22','erik.svensson@example.com','5678567856',13),       -- Svezia (Stoccolma)
('Hans','Müller','Unter den Linden','10117','hans.muller@example.com',NULL,14),              -- Germania (Berlino)
('Giuseppe','Rossi','Via Roma','00184','giuseppe.rossi@example.com','0123012301',14),        -- Italia (Roma)
('Jan','Jansen','Damrak','1012','jan.jansen@example.com',NULL,15),                           -- Paesi Bassi (Amsterdam)
('Robert','Wilson','Queen Street','M5H 2M5','robert.wilson@example.com',NULL,5),             -- Canada (Toronto)
('John','Smith','5th Avenue','10001','john.smith@example.com','1234567890',5),               -- Stati Uniti (New York)
('Liam','Johnson','Rue Neuve','1000','liam.johnson@example.com','7890789078',15),            -- Belgio (Bruxelles)
('Ravi','Kumar','Rajpath','110001','ravi.kumar@example.com','1234567890',10),                -- India (Nuova Delhi)
('Marie','Dubois','Champs-Élysées','75008','marie.dubois@example.com','0987654321',14),      -- Francia (Parigi)
('João','Silva','Avenida Paulista','01311-200','joao.silva@example.com','5678567856',6),     -- Brasile (San Paolo)
('Maria','Hernandez','Paseo de la Reforma','06500','maria.h@example.com','4567456745',6),    -- Messico (Città del Messico)
('Sophie','Meier','Bahnhofstrasse','8001','sophie.meier@example.com','8901890189',13);       -- Svizzera (Zurigo)
SELECT * FROM customer;                          -- 20 record

-- Inserisco valori tabella Sales
INSERT INTO sales (order_date, sale_date, quantity_sold, unit_price, total_amount, discount, 
product_id, customer_id, region_id) VALUES 
('2025-01-01','2025-01-01',4,24.99,99.96,NULL,11,1,14),    -- Italia (Puzzle Educativo)
('2024-01-01','2024-01-01',2,15.99,31.98,NULL,2,10,5),     -- Stati Uniti (Robot Interattivo)
('2025-07-05','2025-07-07',1,7.99,7.99,1.50,9,8,13),       -- Svizzera (Orso di Peluche)
('2024-01-15','2024-01-17',1,29.99,29.99,NULL,17,17,6),    -- Perù (Castello di Costruzione)
('2024-06-30','2024-06-30',4,39.99,159.96,NULL,14,7,15),   -- Belgio (Kit di Pittura)
('2025-01-20','2025-01-22',2,49.99,99.98,NULL,18,18,9),    -- Cina (Drone Giocattolo)
('2024-05-25','2024-05-25',1,12.99,12.99,1.00,6,6,15),     -- Paesi Bassi (Action Figure Supereroe)
('2024-08-10','2024-08-10',5,29.99,149.95,0.50,4,9,15),    -- Regno Unito (Auto da Corsa)
('2024-01-25','2024-01-25',4,20.99,83.96,1.00,7,19,10),    -- India (Giocattolo STEM)
('2024-12-30','2024-12-30',1,19.99,19.99,0.50,15,13,6),    -- Brasile (Carte da Gioco)
('2024-11-25','2024-11-25',2,99.99,199.98,1.50,5,12,6),    -- Messico (Gioco di Matematica)
('2024-01-05','2024-01-05',5,49.99,249.95,1.00,1,2,14),    -- Francia (Robot Interattivo)
('2024-03-15','2024-03-15',1,9.99,9.99,NULL,13,4,15),      -- Spagna (Monopoli)
('2025-01-05','2025-01-07',7,12.99,90.93,1.00,19,15,6),    -- Colombia (Pallone da Calcio)
('2025-02-10','2025-02-12',3,24.99,74.97,2.00,20,3,14),    -- Germania (Set di Argilla)
('2025-10-20','2025-10-22',1,45.99,45.99,NULL,21,11,5),    -- Canada (Peluche Parlante)
('2025-04-20','2025-04-23',7,35.99,251.93,NULL,22,5,13),   -- Svezia (Bicicletta Bambini)
('2024-01-10','2024-01-10',3,75.99,227.97,NULL,23,16,6),   -- Cile (Trenino)
('2025-01-01','2025-01-03',2,29.99,59.98,NULL,24,14,6),    -- Argentina (Tastiera Musicale)
('2024-01-30','2024-01-30',2,59.99,119.98,2.50,25,20,10),  -- Giappone (Macchina Telecomandata Fuoristrada)
('2025-03-01','2025-03-02',3,18.99,56.97,2.00,3,1,4),      -- Italia (Gioco da Tavolo)
('2025-06-01','2025-06-03',5,19.99,99.95,1.00,8,10,5);     -- Stati Uniti (Puzzle 3D)
SELECT * FROM sales;                             -- 22 record

-- INSERIMENTI, MODIFICHE ED ELIMANZIONI: 
-- per effettuare queste query, ho inserito, sbagliato ed omesso apposta alcune info, durante la creazione DB

-- Nel result set, task 4 (es.2), deve risultare 'codice documento'-> inserisco 'document_code', nella tabella Sales  
ALTER TABLE sales
ADD COLUMN document_code VARCHAR(10) AFTER sale_id;
SELECT * FROM sales;

-- Inserisco i valori dentro la colonna creata
START TRANSACTION;                               -- inizio transazione esplicita
UPDATE sales SET document_code = 'DOC001' WHERE sale_id = 1;
UPDATE sales SET document_code = 'DOC002' WHERE sale_id = 2;
UPDATE sales SET document_code = 'DOC003' WHERE sale_id = 3;
UPDATE sales SET document_code = 'DOC004' WHERE sale_id = 4;
UPDATE sales SET document_code = 'DOC005' WHERE sale_id = 5;
UPDATE sales SET document_code = 'DOC006' WHERE sale_id = 6;
UPDATE sales SET document_code = 'DOC007' WHERE sale_id = 7;
UPDATE sales SET document_code = 'DOC008' WHERE sale_id = 8;
UPDATE sales SET document_code = 'DOC009' WHERE sale_id = 9;
UPDATE sales SET document_code = 'DOC010' WHERE sale_id = 10;
UPDATE sales SET document_code = 'DOC011' WHERE sale_id = 11;
UPDATE sales SET document_code = 'DOC012' WHERE sale_id = 12;
UPDATE sales SET document_code = 'DOC013' WHERE sale_id = 13;
UPDATE sales SET document_code = 'DOC014' WHERE sale_id = 14;
UPDATE sales SET document_code = 'DOC015' WHERE sale_id = 15;
UPDATE sales SET document_code = 'DOC016' WHERE sale_id = 16;
UPDATE sales SET document_code = 'DOC017' WHERE sale_id = 17;
UPDATE sales SET document_code = 'DOC018' WHERE sale_id = 18;
UPDATE sales SET document_code = 'DOC019' WHERE sale_id = 19;
UPDATE sales SET document_code = 'DOC020' WHERE sale_id = 20;
UPDATE sales SET document_code = 'DOC021' WHERE sale_id = 21;
UPDATE sales SET document_code = 'DOC022' WHERE sale_id = 22;
SELECT * FROM sales;                             -- verifico se il risultato va bene 
COMMIT;                                          -- confermo la modifica (con ROLLBACK cancello le modifiche)

-- Modifico colonna 'order_date' (tabella Sales), inserendo qualche valore NULL; 
-- Così ottengo che, i valore NULL, fanno riferimento ad una vendita diretta in negozio,
-- mentre i valori NOT NULL, fanno riferimento alla data ordine effettuato, per mancanza pezzo in negozio o online
START TRANSACTION;                               -- inizio transazione esplicita
UPDATE sales
SET order_date = NULL
WHERE region_id IN (1,2,3,4,5,6,7,8,9);          -- ID delle regioni europee (vendite sicure in negozio solo in europa)
SELECT * FROM sales;                             -- verifico se il risultato va bene 
COMMIT;                                          -- confermo la modifica (con ROLLBACK cancello le modifiche)

-- Elimino colonna 'list_price' (tabella Product) e colonna 'discount' (tabella Sales)
ALTER TABLE product
DROP COLUMN list_price;
SELECT * FROM product;                           -- decido di lasciare campo unit_price come prezzo prodotto

ALTER TABLE sales
DROP COLUMN discount;
SELECT * FROM sales;                             -- tolgo campo (eventuale) sconto applicato, perchè info non primaria

-- Elimino ultimi due record dalla tabella Sales
BEGIN;                                           -- inizio transazione esplicita
DELETE FROM sales
WHERE product_id IN (3,8)
AND sale_date IN ('2025-03-02','2025-06-03');
SELECT * FROM sales;                             -- verifico se il risultato va bene -- 20 record invece di 22
COMMIT;                                          -- confermo la modifica (con ROLLBACK cancello le modifiche)

-- Verifica rislutato finale tabelle create:
SELECT * FROM category;                          -- 10 record
SELECT * FROM product;                           -- 25 record
SELECT * FROM region;                            -- 20 record
SELECT * FROM state;                             -- 22 record
SELECT * FROM customer;                          -- 20 record
SELECT * FROM sales;                             -- 22 record

-- Se volessi eliminare l'intera tabella Customer
DROP TABLE customer;                                -- elimina intera struttura
-- Se volessi eliminare solo i valori inseriti
DELETE FROM customer;                               -- non elimina la struttura