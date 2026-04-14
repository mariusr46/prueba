DROP DATABASE sprint4;
CREATE DATABASE sprint4;
USE SPRINT4;

-- ####################
-- NIVEL 1 ############
-- ####################
-- Exercici 0 #########
-- ####################

-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema 
-- d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les 
-- següents consultes:


CREATE TABLE IF NOT EXISTS company(
	id INT NOT NULL PRIMARY KEY,
    company_name VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    country VARCHAR(255),
    website VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS user(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    surname VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    birth_date VARCHAR(255),
    country VARCHAR(255),
    city VARCHAR(255),
    postal_code VARCHAR(255),
    address VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS credit_card(
	id INT NOT NULL PRIMARY KEY,
    user_id VARCHAR(255),
    iban VARCHAR(255),
    pan VARCHAR(255),
    pin VARCHAR(4),
    cvv VARCHAR(3),
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date VARCHAR(255)
);


CREATE TABLE IF NOT EXISTS product(
	id VARCHAR(255) PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2),
    colour VARCHAR(255),
    weight VARCHAR(255),
    warehouse_id VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS `transaction` (
	id VARCHAR(255) NOT NULL PRIMARY KEY,
    card_id INT NOT NULL,
    company_id INT NOT NULL,
    timestamp DATE,
    amount DECIMAL(10,2),
    declined BOOLEAN,
    products_id VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    lat FLOAT,
    longitude FLOAT
);

CREATE TABLE IF NOT EXISTS product_transaction (
	transaction_id VARCHAR(255) NOT NULL,
    product_id VARCHAR(255),
    PRIMARY KEY(transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES `transaction`(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- SHOW VARIABLES LIKE 'secure_file_priv';
-- SHOW VARIABLES LIKE 'local_infile';
-- SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\companies.csv'
INTO TABLE company
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(@id, company_name, @phone, email, country, website)
SET 
	id = REPLACE(@id, 'b-', ''),
    phone = REPLACE(@phone, ' ', '');

DESCRIBE company;
SELECT * FROM company;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\american_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

DESCRIBE user;
SELECT * FROM user;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\european_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

DESCRIBE user;
SELECT * FROM user;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\credit_cards.csv'
INTO TABLE credit_card
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(@id, user_id, iban, pan, pin, cvv, @track1, @track2, expiring_date)
SET 
	id = REPLACE(REPLACE(@id, 'CcS-',''), 'CcU-',''),
	track1 = REPLACE(@track1, '%', ''),
    track2 = REPLACE(@track2, '%', '');


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\products.csv'
INTO TABLE product
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(id, product_name, @price, @colour, weight, @warehouse_id)
SET 
	price = REPLACE(@price, '$', ''),
    colour = REPLACE(@colour, '#', ''),
    warehouse_id = REPLACE(@warehouse_id, '-', '');
    
UPDATE product
SET warehouse_id = REPLACE(warehouse_id, 'WH', '');

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\transactions.csv'
INTO TABLE `transaction`
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS
(id, @card_id, @company_id, @timestamp, amount, declined, products_id, user_id, lat, longitude)
SET 
	card_id = REPLACE(REPLACE(@card_id, 'CcS-',''), 'CcU-',''),
    company_id = REPLACE(@company_id, 'b-', ''),
    timestamp = CAST(timestamp AS DATE);

DESCRIBE `transaction`;
SELECT * FROM `transaction`;

	ALTER TABLE `transaction`
    ADD CONSTRAINT fk_card_id
		FOREIGN KEY (card_id)
        REFERENCES credit_card(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
    
    ALTER TABLE `transaction`
	ADD CONSTRAINT fk_company_id
		FOREIGN KEY (company_id)
        REFERENCES company(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
    
 /*   ALTER TABLE `transaction`
	ADD CONSTRAINT fk_products_id
		FOREIGN KEY (products_id)
        REFERENCES product(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE; */
    
    ALTER TABLE `transaction`
	ADD CONSTRAINT fk_user_id
		FOREIGN KEY (user_id)
        REFERENCES user(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

SELECT * FROM company;
DESCRIBE table company;
SELECT * FROM user;
DESCRIBE table user;
SELECT * FROM credit_card;
DESCRIBE table credit_card;
SELECT * FROM product;
DESCRIBE table product;
SELECT * FROM `transaction`;
DESCRIBE table `transaction`;
SELECT * FROM product_transaction;


INSERT INTO product_transaction
SELECT t.id, js.product_id
FROM `transaction` t
JOIN JSON_TABLE(
	CONCAT('[', REPLACE(t.products_id, ' ', ''), ']'),
    '$[*]' COLUMNS (
		product_id INT PATH '$'
    )
) AS js;

SELECT * FROM product_transaction;
DESCRIBE product_transaction;

-- ####################
-- NIVEL 1 ############
-- ####################
-- Exercici 1 #########
-- ####################

-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.

SELECT u.*
FROM user u
WHERE EXISTS (
		SELECT u.id, count(t.id) as transaccions
        FROM `transaction` t
        WHERE t.user_id = u.id
        group by u.id
        HAVING count(t.id) > 80
);

-- ####################
-- NIVEL 1 ############
-- ####################
-- Exercici 2 #########
-- ####################
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

SELECT cc.iban, avg(t.amount) AS media_gasto
FROM credit_card cc
JOIN `transaction` t on t.card_id = cc.id
JOIN company c on c.id = t.company_id
WHERE c.company_name = 'Donec Ltd'
GROUP BY cc.iban;

/* ####################
NIVEL 2 ############
####################
Exercici 1 #########
#################### */

/* Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions 
han estat declinades aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. */

CREATE TABLE active_credit_card (
	id INT NOT NULL PRIMARY KEY,
    active BOOLEAN
);

SELECT c.id, t.declined, t.timestamp,
ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY c.id, t.timestamp DESC)
FROM credit_card c
JOIN `transaction` t
	ON t.card_id = c.id
WHERE t.declined = 1; 

/* ####################
NIVEL 3 ############
####################
Exercici 1 #########
#################### 

Necessitem conèixer el nombre de vegades que s'ha venut cada producte. */

SELECT p.*, 
		count(pt.product_id) AS numero_ventas
FROM product_transaction pt
JOIN product p
	ON p.id = pt.product_id
GROUP BY pt.product_id
ORDER BY numero_ventas DESC;

SELECT p.*, 
		count(pt.product_id) AS numero_ventas,
        sum(p.price) AS total
FROM product_transaction pt
JOIN product p
	ON p.id = pt.product_id
JOIN `transaction` t
	ON t.id = pt.transaction_id
GROUP BY pt.product_id
ORDER BY numero_ventas DESC;








