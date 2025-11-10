-- Verificar si existe la base de datos con anterioridad. 
DROP DATABASE IF EXISTS modelado_bd;

-- Crear base de datos 
CREATE DATABASE modelado_bd;

-- Seleccionar la base de datos a seleccionar
USE modelado_bd; 

-- Crear la entidad persona
CREATE TABLE person(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    second_name VARCHAR(50) NOT NULL,
    first_lastname VARCHAR(50) NOT NULL,
    second_lastname VARCHAR(50) NOT NULL,
    addres VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL
);

-- Crear la entidad userio
CREATE TABLE user(
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    person_id INT,
    FOREIGN KEY (person_id) REFERENCES person(id)
);

-- Ingresar datos a la base de datos modelado_bd.
INSERT INTO person(
	first_name,
	second_name,
	first_lastname,
	second_lastname,
	addres,
	phone
)VALUES(
	'Juan',
    'Manuel',
    'Ortiz',
    'Perez',
    'Calle 21 # 12-A1',
    '32045436456'
);

INSERT INTO person(	first_name,	second_name, first_lastname, second_lastname, addres, phone )VALUES
	('Adriana', 'María', 'Mendez', '', 'Calle 34 # 01-A1', '4324522343'),
    ('Karol', '', 'Rodroguéz', '', 'Calle 34 # 01-A1', '4324522343');

INSERT INTO user(
	username,
    password,
    person_id
)VALUES(
	'juan12',
    'helloworld',
    3
);

INSERT INTO user(username, password, person_id )VALUES
('adriana33', 'abcd1234', 2),
('karol11', 'qwerty', 3);

-- Consultar registros
SELECT * FROM person;
SELECT * FROM user;

-- Actualizar registro
UPDATE person
	SET 
		first_name = 'Carol',
        second_name = 'Ximena'
WHERE id = 3;

-- Eliminar registros
DELETE FROM user WHERE person_id = 2;
DELETE FROM person WHERE id = 2;


