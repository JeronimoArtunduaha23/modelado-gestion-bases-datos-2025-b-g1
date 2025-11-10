DROP DATABASE IF EXISTS shopping_cart;

CREATE DATABASE shopping_cart;

USE shopping_cart;

-- ==============================================
-- 🔐 SECURITY MODULE
-- ==============================================

CREATE TABLE person (
    id INT AUTO_INCREMENT PRIMARY KEY,
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
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE user_account (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    person_id INT NOT NULL,
    role_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (role_id) REFERENCES role(id)
);

CREATE TABLE module (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    route VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE module_role (
    id INT AUTO_INCREMENT PRIMARY KEY,
    module_id INT NOT NULL,
    role_id INT NOT NULL,
    can_create BOOLEAN DEFAULT FALSE,
    can_read BOOLEAN DEFAULT TRUE,
    can_update BOOLEAN DEFAULT FALSE,
    can_delete BOOLEAN DEFAULT FALSE,
    route VARCHAR(150) NOT NULL,
    FOREIGN KEY (module_id) REFERENCES module(id),
    FOREIGN KEY (role_id) REFERENCES role(id)
);

CREATE TABLE view (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    route VARCHAR(150) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE view_module (
    id INT AUTO_INCREMENT PRIMARY KEY,
    view_id INT NOT NULL,
    module_id INT NOT NULL,
    FOREIGN KEY (view_id) REFERENCES view(id),
    FOREIGN KEY (module_id) REFERENCES module(id),
    UNIQUE (view_id, module_id)
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


-- ==============================================
-- 🧩 MODULES
-- ==============================================
INSERT INTO module (id, name, description, icon, route) VALUES
(1, 'security', 'Módulo de seguridad y gestión de usuarios', 'shield-lock', '/security'),
(2, 'provider', 'Módulo de gestión de proveedores y sucursales', 'building', '/provider'),
(3, 'inventory', 'Módulo de inventario y productos', 'box', '/inventory'),
(4, 'billing', 'Módulo de facturación', 'dollar-sign', '/billing'),
(5, 'client', 'Módulo de clientes y registros', 'users', '/client');


-- ==============================================
-- 🌐 VIEWS
-- ==============================================
INSERT INTO view (id, name, description, route) VALUES
(1, 'person', 'Gestión de personas', '/person.html'),
(2, 'role', 'Gestión de roles', '/role.html'),
(3, 'user_account', 'Administración de usuarios', '/user_account.html'),
(4, 'dashboard', 'Panel principal del sistema', '/dashboard.html'),
(5, 'company', 'Gestión de empresas proveedoras', '/company.html'),
(6, 'branch', 'Gestión de sucursales', '/branch.html'),
(7, 'category', 'Gestión de categorías de productos', '/category.html'),
(8, 'product', 'Gestión de productos', '/product.html'),
(9, 'inventory', 'Gestión de inventario', '/inventory.html'),
(10, 'invoice', 'Gestión de facturas', '/invoice.html'),
(11, 'invoice_detail', 'Detalle de facturas', '/invoice_detail.html'),
(12, 'client', 'Gestión de clientes', '/client.html');


-- ==============================================
-- 🔗 VIEW_MODULE RELATIONSHIPS
-- ==============================================
INSERT INTO view_module (view_id, module_id) VALUES
-- 🔐 SECURITY
(1, 1),  -- person → security
(2, 1),  -- role → security
(3, 1),  -- user_account → security
(4, 1),  -- dashboard → security

-- 🏢 PROVIDER
(5, 2),  -- company → provider
(6, 2),  -- branch → provider

-- 📦 INVENTORY
(7, 3),  -- category → inventory
(8, 3),  -- product → inventory
(9, 3),  -- inventory → inventory

-- 💰 BILLING
(10, 4), -- invoice → billing
(11, 4), -- invoice_detail → billing

-- 👥 CLIENT
(12, 5); -- client → client


-- ==============================================
-- 👥 ROLES BASE
-- ==============================================
INSERT INTO role (id, name, description) VALUES
(1, 'admin', 'Rol con privilegios completos sobre todos los módulos y operaciones del sistema.'),
(2, 'manager', 'Rol con permisos de gestión intermedia: puede crear, actualizar y consultar información.'),
(3, 'operator', 'Rol enfocado en la operación diaria: puede registrar y consultar datos sin modificar configuraciones críticas.'),
(4, 'auditor', 'Rol de solo lectura, destinado a revisiones, reportes y control interno.'),
(5, 'client_user', 'Rol externo con acceso limitado a funcionalidades específicas del módulo de clientes.');


-- ==============================================
-- 🔐 SECURITY MODULE (module_id = 1)
-- ==============================================
INSERT INTO module_role (module_id, role_id, can_create, can_read, can_update, can_delete, route) VALUES
(1, 1, TRUE, TRUE, TRUE, TRUE, '/security'),       -- admin
(1, 2, TRUE, TRUE, TRUE, FALSE, '/security'),      -- manager
(1, 3, TRUE, TRUE, FALSE, FALSE, '/security'),     -- operator
(1, 4, FALSE, TRUE, FALSE, FALSE, '/security');    -- auditor

-- ==============================================
-- 🏢 PROVIDER MODULE (module_id = 2)
-- ==============================================
INSERT INTO module_role (module_id, role_id, can_create, can_read, can_update, can_delete, route) VALUES
(2, 1, TRUE, TRUE, TRUE, TRUE, '/provider'),
(2, 2, TRUE, TRUE, TRUE, FALSE, '/provider'),
(2, 3, TRUE, TRUE, FALSE, FALSE, '/provider'),
(2, 4, FALSE, TRUE, FALSE, FALSE, '/provider');

-- ==============================================
-- 📦 INVENTORY MODULE (module_id = 3)
-- ==============================================
INSERT INTO module_role (module_id, role_id, can_create, can_read, can_update, can_delete, route) VALUES
(3, 1, TRUE, TRUE, TRUE, TRUE, '/inventory'),
(3, 2, TRUE, TRUE, TRUE, FALSE, '/inventory'),
(3, 3, TRUE, TRUE, FALSE, FALSE, '/inventory'),
(3, 4, FALSE, TRUE, FALSE, FALSE, '/inventory');

-- ==============================================
-- 💰 BILLING MODULE (module_id = 4)
-- ==============================================
INSERT INTO module_role (module_id, role_id, can_create, can_read, can_update, can_delete, route) VALUES
(4, 1, TRUE, TRUE, TRUE, TRUE, '/billing'),
(4, 2, TRUE, TRUE, TRUE, FALSE, '/billing'),
(4, 3, TRUE, TRUE, FALSE, FALSE, '/billing'),
(4, 4, FALSE, TRUE, FALSE, FALSE, '/billing');

-- ==============================================
-- 👥 CLIENT MODULE (module_id = 5)
-- ==============================================
INSERT INTO module_role (module_id, role_id, can_create, can_read, can_update, can_delete, route) VALUES
(5, 1, TRUE, TRUE, TRUE, TRUE, '/client'),
(5, 2, TRUE, TRUE, TRUE, FALSE, '/client'),
(5, 3, TRUE, TRUE, FALSE, FALSE, '/client'),
(5, 4, FALSE, TRUE, FALSE, FALSE, '/client'),
(5, 5, FALSE, TRUE, FALSE, FALSE, '/client');  -- client_user
