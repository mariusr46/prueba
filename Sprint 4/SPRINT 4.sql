CREATE DATABASE sprint4;
USE SPRINT4;

ALTER TABLE company
CHANGE id id VARCHAR(255);

CREATE TABLE IF NOT EXISTS company(
	id VARCHAR(255) PRIMARY KEY,
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
	id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    iban VARCHAR(255),
    pan VARCHAR(255),
    pin VARCHAR(255),
    cvv VARCHAR(255),
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date VARCHAR(255)
);

DROP TABLE product;

CREATE TABLE IF NOT EXISTS product(
	id VARCHAR(255) PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2),
    colour VARCHAR(255),
    weight VARCHAR(255),
    warehouse_id VARCHAR(255)
);

DROP TABLE transaction;

CREATE TABLE IF NOT EXISTS transaction (
	id VARCHAR(255) NOT NULL PRIMARY KEY,
    card_id VARCHAR(255) NOT NULL,
    company_id VARCHAR(255) NOT NULL,
    timestamp VARCHAR(255),
    amount DECIMAL(10,2),
    declined BOOLEAN,
    products_id VARCHAR(255),
    user_id INT NOT NULL,
    lat FLOAT,
    longitude FLOAT
    

);
	ALTER TABLE
    CONSTRAINT fk_card_id
		FOREIGN KEY (card_id)
        REFERENCES credit_card(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
        
	CONSTRAINT fk_company_id
		FOREIGN KEY (company_id)
        REFERENCES company(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_products_id
		FOREIGN KEY (products_id)
        REFERENCES product(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
	CONSTRAINT fk_user_id
		FOREIGN KEY (user_id)
        REFERENCES user(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

SHOW VARIABLES LIKE 'secure_file_priv';
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\companies.csv'
INTO TABLE company
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\american_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\european_users.csv'
INTO TABLE user
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\credit_cards.csv'
INTO TABLE credit_card
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

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
INTO TABLE transaction
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
IGNORE 1 ROWS;




DESCRIBE company;
DESCRIBE user;
DESCRIBE credit_card;
DESCRIBE product;
DESCRIBE transaction;
SELECT * FROM transaction;



