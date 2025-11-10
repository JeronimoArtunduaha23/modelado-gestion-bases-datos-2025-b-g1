DROP DATABASE IF EXISTS shopping_cart;

CREATE DATABASE shopping_cart;

USE shopping_cart;

-- ==============================================
-- 🔐 SECURITY MODULE
-- ==============================================

CREATE TABLE person (
    id INT PRIMARY KEY,
    document_type VARCHAR(10) NOT NULL,
    document_number VARCHAR(30) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    address VARCHAR(150),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE role (
    id INT PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE shopping_cart.user_account (
    id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    person_id INT NOT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (shopping_cart.person_id) REFERENCES person(id),
    FOREIGN KEY (shopping_cart.role_id) REFERENCES role(id)
);

-- ==============================================
-- 🏢 PROVIDER MODULE
-- ==============================================

CREATE TABLE company (
    id INT PRIMARY KEY,
    company_name VARCHAR(150) UNIQUE NOT NULL,
    tax_id VARCHAR(30) UNIQUE NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(150)
);


-- ==============================================
-- 📦 INVENTORY MODULE
-- ==============================================

CREATE TABLE category (
    id INT AUTO_INCREMENT PRIMARY KEY ,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);


CREATE TABLE product (
    id INT PRIMARY KEY,
    product_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    unit_price NUMERIC(12,2) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES shopping_cart.category(id)
);


CREATE TABLE inventory (
    id INT PRIMARY KEY,
    product_id INT NOT NULL,
    supplier_id INT NOT NULL,
    current_stock INT DEFAULT 0,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id)
    -- supplier_id will reference company (provider module)
);

-- ==============================================
-- 💰 BILLING MODULE
-- ==============================================

CREATE TABLE invoice (
    id INT PRIMARY KEY,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    issue_date DATE NOT NULL,
    client_id INT NOT NULL,
    user_account_id INT NOT NULL,
    total NUMERIC(14,2) DEFAULT 0,
    FOREIGN KEY (client_id) REFERENCES client(id),
    FOREIGN KEY (user_account_id) REFERENCES user_account(id)
);

CREATE TABLE invoice_detail (
    id INT PRIMARY KEY,
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,
    subtotal NUMERIC(14,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (invoice_id) REFERENCES invoice(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE branch (
    id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    address VARCHAR(150),
    phone VARCHAR(20),
    company_id INT NOT NULL,
    FOREIGN KEY (company_id) REFERENCES company(id)
);

-- ==============================================
-- 👥 CLIENT MODULE
-- ==============================================

CREATE TABLE client (
    id INT PRIMARY KEY,
    person_id INT NOT NULL,
    client_code VARCHAR(20) UNIQUE NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES person(id)
);

-- ==============================================
-- 🔗 CROSS-MODULE RELATIONSHIPS
-- ==============================================

ALTER TABLE shopping_cart.inventory
ADD CONSTRAINT fk_inventory_supplier
FOREIGN KEY (supplier_id) REFERENCES company(id);
