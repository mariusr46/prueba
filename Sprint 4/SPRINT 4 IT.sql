CREATE DATABASE sprint4;
USE SPRINT4;


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
	id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2),
    colour VARCHAR(255),
    weight VARCHAR(255),
    warehouse_id VARCHAR(255)
);

DROP TABLE transaction;

CREATE TABLE IF NOT EXISTS transaction (
	id VARCHAR(255) NOT NULL PRIMARY KEY,
    card_id INT NOT NULL,
    company_id INT NOT NULL,
    timestamp VARCHAR(255),
    amount DECIMAL(10,2),
    declined BOOLEAN,
    products_id VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    lat FLOAT,
    longitude FLOAT
);



SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

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

DESCRIBE credit_card;
SELECT * FROM credit_card;

SELECT id
FROM credit_card
WHERE id LIKE 'CcU%';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\products.csv'
INTO TABLE product
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(id, product_name, @price, @colour, weight, @warehouse_id)
SET 
	price = REPLACE(@price, '$', ''),
    colour = REPLACE(@colour, '#', ''),
    warehouse_id = REPLACE(@warehouse_id, '-', '');
    
DESCRIBE product;
SELECT * FROM product;
    
UPDATE product
SET warehouse_id = REPLACE(warehouse_id, 'WH', '');


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\transactions.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS
(id, @card_id, @company_id, timestamp, amount, declined, products_id, user_id, lat, longitude)
SET 
	card_id = REPLACE(REPLACE(@card_id, 'CcS-',''), 'CcU-',''),
    company_id = REPLACE(@company_id, 'b-', '');

DESCRIBE transaction;
SELECT * FROM transaction;

	ALTER TABLE transaction
    ADD CONSTRAINT fk_card_id
		FOREIGN KEY (card_id)
        REFERENCES credit_card(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
    
    ALTER TABLE transaction
	ADD CONSTRAINT fk_company_id
		FOREIGN KEY (company_id)
        REFERENCES company(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
    
    ALTER TABLE transaction
	ADD CONSTRAINT fk_products_id
		FOREIGN KEY (products_id)
        REFERENCES product(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
    
    ALTER TABLE transaction
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
SELECT price FROM product
WHERE id = 87;
DESCRIBE table product;
SELECT * FROM transaction;
DESCRIBE table transaction;
SHOW CREATE TABLE product;



