/*****************************************
*	DDL : Lenguaje de definición de datos
*		CREATE [DABTASE, TABLE]
*		ALTER [DABTASE, TABLE]
		DROP [DABTASE, TABLE]
	DML : Lenguaje de manipulación de datos
		INSERT
		UPDATE
		DELETE
		SELECT FROM [INNER JOIN]
*****************************************/
-- Auditoria [create_at, update_at, delete_at][create_by, update_by, delete_by]

/******************************************************************
* person{id, type_document, document, name, lastname, email, phone, date_birth, status}
* user{id, user, password, person_id, status}
* role{id, code, name, description, status}
* user_role{id, user_id, role_id, status}
* view{id, code, name, description, url, status}
* role_view{id, role_id, view_id, status}
*******************************************************************/

--------------
-- user: jesus.gonzalez [admin, profesor, estudiante]
-- user: wendy.perez [estudiante]
-- user: pedro.gomez [estudiante, profesor]
-- role: admin {Productos, Factura, Nota, Estudiantes, Profesores}
-- role: estudiante{Nota, Estudiante, Factura}
-- role: profesor{Nota, Estudiante, profesor} 
-- view: 1010 | Registro producto | Esta página permite el registro de productos | www.softcom.com/productos |Activo |  

	
/*******************************************************************
* continent{id, code, name, description, url, status}
* country{id, code, name, description, url, status, continent_id}
* estate{id, code, name, description, url, status, country_id}
* city{id, code, name, description, url, status, estate_id}
*********************************************************************/
DROP DATABASE IF EXISTS security_gmbd;
CREATE DATABASE security_gmbd;
USE security_gmbd;

CREATE TABLE person(
	id INT PRIMARY KEY AUTO_INCREMENT, 
	type_document ENUM('CC', 'TI', 'CE', 'Registro Civil', 'Pasaporte'), 
	document VARCHAR(12) NOT NULL UNIQUE, 
	name VARCHAR(50),
	lastname VARCHAR(50), 
	email VARCHAR(50),
	phone VARCHAR(20),
	date_birth DATE,
	status BOOLEAN
);

CREATE TABLE user(
	id INT PRIMARY KEY AUTO_INCREMENT,
	user VARCHAR(50) NOT NULL UNIQUE, 
	password VARCHAR(100) NOT NULL,
	person_id INT NOT NULL, 
	status BOOLEAN,
	CONSTRAINT fk_user_person_id_person_id FOREIGN KEY (person_id) REFERENCES person(id)
);

CREATE TABLE role(
	id INT PRIMARY KEY AUTO_INCREMENT,
	code VARCHAR(20) NOT NULL UNIQUE, 
	name VARCHAR(50) NOT NULL UNIQUE,
	description VARCHAR(200), 
	status BOOLEAN
);

CREATE TABLE user_role(
	id INT PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL,
	role_id INT NOT NULL,
	CONSTRAINT fk_user_role_user_id_user_id FOREIGN KEY (user_id) REFERENCES user(id),
	CONSTRAINT fk_user_role_role_id_role_id FOREIGN KEY (role_id) REFERENCES role(id),
	status BOOLEAN
);

CREATE TABLE view(
	id INT PRIMARY KEY AUTO_INCREMENT,
	code VARCHAR(20) NOT NULL UNIQUE, 
	name VARCHAR(50) NOT NULL UNIQUE,
	description VARCHAR(200), 
	url VARCHAR(200) NOT NULL,
	status BOOLEAN
);

CREATE TABLE role_view(
	id INT PRIMARY KEY AUTO_INCREMENT,	
	role_id INT NOT NULL,
	view_id INT NOT NULL,	
	CONSTRAINT fk_role_view_role_id_role_id FOREIGN KEY (role_id) REFERENCES role(id),
	CONSTRAINT fk_role_view_view_id_view_id FOREIGN KEY (view_id) REFERENCES view(id),
	status BOOLEAN
);

-- DML 
INSERT INTO person(
		type_document, document, name, lastname, email, phone, date_birth,	status
	)VALUES(
		'CC','105645645', 'Pedro Pablo','Perez', 'pedro@corhuila.edu.co', '312321321', '2010-05-12',true
	);	
INSERT INTO person(type_document, document, name, lastname, email, phone, date_birth,	status)VALUES
	('CC','63248732', 'María','Salcedo', 'maria@corhuila.edu.co', '312436456', '2008-10-08',true),
	('CC','7632424', 'Sergio','Gutierrez', 'sergio@corhuila.edu.co', '312214323', '2000-02-03',true);

INSERT INTO user(
	user,
	password,
	person_id,
	status
)VALUES(
	'pedro21',
	'holamundo',
	1,
	true
);
INSERT INTO user(user, password, person_id, status )VALUES
('maria12',	'nuevo', 1, true),
('segio11',	'ksdfr', 1, true);

INSERT INTO role(
	code,
	name,
	description,
	status
)VALUES
('1010','admin', 'Gestor de admistración',true),
('1011','proferor', 'Gestor de profesor',true),
('1012','estudiante', 'Gestor de estudiante',true);

INSERT INTO user_role(
	user_id,
	role_id,
	status
)VALUES
	(1,1,true),
	(1,2,true),
	(1,3,true),
	(2,2,true),
	(3,3,true);

INSERT INTO view(
	code,
	name,
	description,
	url,
	status
)VALUES
	('1010','Continente', 'Gestor de continentes', 'geolocation/continent.html',true),
	('1011','Pais', 'Gestor de paises', 'geolocation/country.html',true),
	('1012','Departamento', 'Gestor de departamentos', 'geolocation/estate.html' ,true),
	('1013','Ciudad', 'Gestor de ciudades', 'geolocation/city.html',true);

INSERT INTO role_view(
	role_id,
	view_id,
	status
)VALUES
	(1,1,true),
	(1,2,true),
	(1,3,true),
	(1,4,true),
	(2,4,true),
	(3,4,true);
    
    
-- Permisos por nombre de usuario (vistas que puede usar)
SELECT 
	u.user username,
    r.name role,
    v.name view,
    v.url
FROM 
	user u
    INNER JOIN user_role ur ON u.id = ur.user_id
    INNER JOIN role r ON ur.role_id = r.id
    INNER JOIN role_view vr ON r.id = vr.role_id
    INNER JOIN view v ON vr.view_id = v.id
WHERE u.user = 'pedro21';
