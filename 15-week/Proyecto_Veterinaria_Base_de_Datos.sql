-- Base de datos: veterinaria

DROP DATABASE IF EXISTS veterinaria;
CREATE DATABASE veterinaria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE veterinaria;

-- TABLAS PRINCIPALES (10 entidades)

-- 1. TABLA DE ESPECIES
CREATE TABLE especies (
    id_especie INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

-- 2. TABLA DE RAZAS
CREATE TABLE razas (
    id_raza INT AUTO_INCREMENT PRIMARY KEY,
    id_especie INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_razas_especies
        FOREIGN KEY (id_especie) REFERENCES especies(id_especie)
        ON DELETE CASCADE
);

-- 3. TABLA DE DUEÑOS
CREATE TABLE duenos (
    id_dueno INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    correo VARCHAR(150),
    telefono VARCHAR(30),
    direccion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

-- 4. TABLA DE MASCOTAS
CREATE TABLE mascotas (
    id_mascota INT AUTO_INCREMENT PRIMARY KEY,
    id_dueno INT NOT NULL,
    id_especie INT NOT NULL,
    id_raza INT,
    nombre VARCHAR(80) NOT NULL,
    sexo ENUM('M','F') NOT NULL,
    fecha_nacimiento DATE,
    color VARCHAR(80),
    peso DECIMAL(5,2),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_dueno) REFERENCES duenos(id_dueno) ON DELETE CASCADE,
    FOREIGN KEY (id_especie) REFERENCES especies(id_especie),
    FOREIGN KEY (id_raza) REFERENCES razas(id_raza)
); 

-- 5. TABLA DE CITAS
CREATE TABLE citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT NOT NULL,
    fecha DATETIME NOT NULL,
    motivo VARCHAR(200),
    estado ENUM('programada','completada','cancelada') DEFAULT 'programada',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota) ON DELETE CASCADE
); 

-- 6. HISTORIALES MEDICOS
CREATE TABLE historiales_medicos (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT NOT NULL,
    descripcion TEXT NOT NULL,
    diagnostico TEXT,
    tratamiento TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota) ON DELETE CASCADE
);

-- 7. TABLA DE VACUNAS
CREATE TABLE vacunas (
    id_vacuna INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

-- 8. VACUNAS APLICADAS A MASCOTAS
CREATE TABLE mascotas_vacunas (
    id_mascota_vacuna INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT NOT NULL,
    id_vacuna INT NOT NULL,
    fecha_aplicacion DATE NOT NULL,
    proxima_dosis DATE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota) ON DELETE CASCADE,
    FOREIGN KEY (id_vacuna) REFERENCES vacunas(id_vacuna) ON DELETE RESTRICT
);

-- 9. TABLA DE TRATAMIENTOS
CREATE TABLE tratamientos (
    id_tratamiento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. TRATAMIENTOS APLICADOS A MASCOTAS
CREATE TABLE mascotas_tratamientos (
    id_mascota_tratamiento INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT NOT NULL,
    id_tratamiento INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    observaciones TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota) ON DELETE CASCADE,
    FOREIGN KEY (id_tratamiento) REFERENCES tratamientos(id_tratamiento) ON DELETE RESTRICT
); 

-- TABLAS DE SEGURIDAD (8 entidades)

-- 11. USUARIOS
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(80) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nombre_completo VARCHAR(150),
    correo VARCHAR(150) UNIQUE,
    activo TINYINT(1) DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_login TIMESTAMP NULL
); 

-- 12. ROLES
CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

-- 13. PERMISOS
CREATE TABLE permisos (
    id_permiso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

-- 14. USUARIOS_ROLES (mapeo)
CREATE TABLE usuarios_roles (
    id_usuario_rol INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY ux_usuario_rol (id_usuario, id_rol),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol) ON DELETE CASCADE
); 

-- 15. ROLES_PERMISOS (mapeo)
CREATE TABLE roles_permisos (
    id_rol_permiso INT AUTO_INCREMENT PRIMARY KEY,
    id_rol INT NOT NULL,
    id_permiso INT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY ux_rol_permiso (id_rol, id_permiso),
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol) ON DELETE CASCADE,
    FOREIGN KEY (id_permiso) REFERENCES permisos(id_permiso) ON DELETE CASCADE
); 

-- 16. SESIONES_USUARIO
CREATE TABLE sesiones_usuario (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fin DATETIME,
    ip_origen VARCHAR(45),
    agente_usuario VARCHAR(255),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    INDEX (token)
); 

-- 17. BITACORA (logs de acciones)
CREATE TABLE bitacora (
    id_bitacora INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NULL,
    accion VARCHAR(100) NOT NULL,
    tabla_afectada VARCHAR(100),
    id_registro INT,
    descripcion TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_origen VARCHAR(45),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
); 

-- 18. AUDITORIA_CAMBIOS (detalle de cambios por campo)
CREATE TABLE auditoria_cambios (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    tabla_nombre VARCHAR(100) NOT NULL,
    clave_pk VARCHAR(255) NOT NULL,
    campo_nombre VARCHAR(100) NOT NULL,
    valor_anterior TEXT,
    valor_nuevo TEXT,
    id_usuario INT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
); 


-- (20 registros por tabla usando multi-INSERT)

-- 1. ESPECIES
INSERT INTO especies (nombre, descripcion) VALUES
('Canino','Perros domésticos'),('Felino','Gatos domésticos'),('Ave','Aves comunes'),('Reptil','Reptiles varios'),('Pez','Peces acuarios'),
('Roedor','Roedores pequeños'),('Anfibio','Anfibios comunes'),('Equino','Caballos'),('Bovino','Vacas'),('Porcino','Cerdos'),
('Caprino','Cabras'),('Ovino','Ovejas'),('Primates','Monos'),('Arácnido','Arañas'),('Molusco','Caracoles'),
('Anélido','Lombrices'),('Insecto','Insectos varios'),('Exótico','Especies exóticas'),('Mixto','Varios tipos mezclados'),('Otro','Otros animales');

-- 2. RAZAS
INSERT INTO razas (id_especie, nombre, descripcion) VALUES
(1,'Labrador','Raza de perro'),(1,'Pitbull','Raza poderosa'),(1,'Chihuahua','Pequeña raza'),(2,'Persa','Gato elegante'),(2,'Siames','Gato fino'),
(2,'Esfinge','Gato sin pelo'),(3,'Loro','Ave doméstica'),(3,'Canario','Ave cantora'),(3,'Perico','Ave pequeña'),(4,'Iguana','Reptil verde'),
(4,'Tortuga','Reptil de caparazón'),(5,'Goldfish','Pez común'),(5,'Betta','Pez de colores'),(6,'Hamster','Roedor pequeño'),(6,'Ratón','Roedor ágil'),
(7,'Rana verde','Anfibio común'),(8,'Pura sangre','Caballo veloz'),(9,'Holstein','Vaca lechera'),(10,'Duroc','Cerdo fuerte'),(11,'Saanen','Cabra lechera');

-- 3. DUEÑOS
INSERT INTO duenos (nombres, apellidos, correo, telefono, direccion) VALUES
('Carlos','Gomez','carlos@mail.com','3001111111','Cll 1 #1-11'),('Ana','Lopez','ana@mail.com','3002222222','Cll 2 #2-22'),
('Juan','Martinez','juan@mail.com','3003333333','Cll 3 #3-33'),('Maria','Perez','maria@mail.com','3004444444','Cll 4 #4-44'),
('Sofia','Ramirez','sofia@mail.com','3005555555','Cll 5 #5-55'),('Pedro','Diaz','pedro@mail.com','3006666666','Cll 6 #6-66'),
('Andres','Mora','andres@mail.com','3007777777','Cll 7 #7-77'),('Luisa','Henao','luisa@mail.com','3008888888','Cll 8 #8-88'),
('Laura','Jimenez','laura@mail.com','3009999999','Cll 9 #9-99'),('Felipe','Rios','felipe@mail.com','3100000000','Cra 10 #10-10'),
('Victor','Castro','victor@mail.com','3101111111','Cra 11 #11-11'),('Camila','Silva','camila@mail.com','3102222222','Cra 12 #12-12'),
('Jorge','Quintero','jorge@mail.com','3103333333','Cra 13 #13-13'),('Diana','Pardo','diana@mail.com','3104444444','Cra 14 #14-14'),
('Natalia','Cortes','natalia@mail.com','3105555555','Cra 15 #15-15'),('Daniel','Rodriguez','daniel@mail.com','3106666666','Cra 16 #16-16'),
('Paula','Cardenas','paula@mail.com','3107777777','Cra 17 #17-17'),('Esteban','Muñoz','esteban@mail.com','3108888888','Cra 18 #18-18'),
('Santiago','Loaiza','santiago@mail.com','3109999999','Cra 19 #19-19'),('Lucia','Arango','lucia@mail.com','3110000000','Cra 20 #20-20');

-- 4. MASCOTAS
INSERT INTO mascotas (id_dueno,id_especie,id_raza,nombre,sexo,fecha_nacimiento,color,peso) VALUES
(1,1,1,'Max','M','2020-01-02','Café',12.5),(2,2,4,'Mia','F','2019-03-10','Blanco',4.2),
(3,1,2,'Rocky','M','2021-05-20','Negro',18.0),(4,2,5,'Luna','F','2022-02-18','Gris',3.9),
(5,3,7,'Tico','M','2020-12-01','Verde',0.5),(6,4,10,'Rex','M','2018-07-15','Verde oscuro',2.1),
(7,5,12,'Nemo','M','2022-09-29','Naranja',0.1),(8,6,14,'Hammy','M','2021-11-11','Marrón',0.3),
(9,1,3,'Tiny','F','2020-04-04','Café claro',2.0),(10,8,17,'Spirit','M','2019-08-22','Café',450),
(11,9,18,'Lola','F','2018-02-02','Blanco',300),(12,10,19,'Porky','M','2017-06-19','Rosado',110),
(13,11,20,'Cabrilla','F','2021-01-09','Beige',45),(14,1,1,'Buddy','M','2022-03-03','Dorado',10.5),
(15,2,4,'Kira','F','2019-10-10','Marfil',4.4),(16,3,7,'Paco','M','2023-01-01','Amarillo',0.4),
(17,4,11,'Speedy','F','2020-11-21','Verde',1.9),(18,5,13,'Blue','M','2021-05-05','Azul',0.2),
(19,6,15,'Mini','F','2022-12-12','Gris',0.25),(20,1,2,'Thor','M','2020-09-09','Negro',20.1);

-- 5. CITAS
INSERT INTO citas (id_mascota,fecha,motivo,estado) VALUES
(1,'2024-01-01 10:00','Consulta general','programada'),(2,'2024-01-02 09:00','Vacunación','completada'),
(3,'2024-01-03 11:00','Control','cancelada'),(4,'2024-01-04 13:00','Desparasitación','programada'),
(5,'2024-01-05 15:00','Ala rota','completada'),(6,'2024-01-06 16:00','Cambio de terrario','programada'),
(7,'2024-01-07 14:00','Agua sucia','completada'),(8,'2024-01-08 09:00','Revisión','programada'),
(9,'2024-01-09 12:00','Herida leve','completada'),(10,'2024-01-10 08:30','Control equino','programada'),
(11,'2024-01-11 10:30','Mastitis','completada'),(12,'2024-01-12 11:15','Chequeo porcino','programada'),
(13,'2024-01-13 14:15','Golpe','completada'),(14,'2024-01-14 16:10','Revisión anual','programada'),
(15,'2024-01-15 17:00','Revisión','cancelada'),(16,'2024-01-16 08:00','Ala caída','programada'),
(17,'2024-01-17 09:30','Caparazón dañado','completada'),(18,'2024-01-18 11:50','Aletas dañadas','programada'),
(19,'2024-01-19 13:40','Chequeo roedor','completada'),(20,'2024-01-20 15:00','Rutina','programada');

-- 6. HISTORIALES MEDICOS
INSERT INTO historiales_medicos (id_mascota, descripcion, diagnostico, tratamiento) VALUES
(1,'Vomitos','Gastritis','Omeprazol'),(2,'Tos','Alergia','Antihistamínico'),(3,'Herida','Corte','Suturas'),(4,'Ojos llorosos','Conjuntivitis','Gotas'),
(5,'Ala caída','Fractura','Inmovilización'),(6,'Deshidratación','Ambiente seco','Humedad'),(7,'Aletas dañadas','Golpe','Reposo'),(8,'Fiebre','Infección','Antibiótico'),
(9,'Cojera','Golpe','Analgésico'),(10,'Sarro dental','Higiene','Limpieza'),(11,'Mastitis','Infección','Antibióticos'),(12,'Tos','Virus','Reposo'),
(13,'Golpe','Trauma','Vendaje'),(14,'Dermatitis','Alergia','Crema'),(15,'Otitis','Infección','Gotas'),(16,'Desnutrición','Falta de comida','Suplementos'),
(17,'Caparazón roto','Fractura','Resina'),(18,'Infección','Hongos','Baño'),(19,'Parásitos','Lombrices','Desparasitación'),(20,'Fiebre','Infección','Antibiótico');

-- 7. VACUNAS
INSERT INTO vacunas (nombre, descripcion) VALUES
('Rabia','Previene rabia'),('Parvovirus','Previene virus'),('Triple Felina','Protección completa'),('Moquillo','Enfermedad viral'),('Hepatitis','Protección hepática'),
('Influenza','Previene gripe'),('Leucemia Felina','Protección viral'),('Castas','Protección aves'),('Brucelosis','Ganado'),('Aftosa','Protección bovina'),
('Tétano','Equinos'),('Peste Porcina','Protección cerdos'),('Salmonella','Previene infección'),('Distemper','Virus'),('Parainfluenza','Respiratoria'),
('Leptospirosis','Bacteriana'),('Antirrábica','Prevención total'),('Polivalente','Varios virus'),('Refuerzo Canino','Inmunidad'),('Refuerzo Felino','Inmunidad');

-- 8. MASCOTAS_VACUNAS
INSERT INTO mascotas_vacunas (id_mascota, id_vacuna, fecha_aplicacion, proxima_dosis) VALUES
(1, 1, '2024-01-15', '2024-07-15'),(2, 2, '2024-02-10', '2025-02-10'),
(3, 3, '2024-03-05', '2025-03-05'),
(4, 4, '2024-04-12', '2025-04-12'),
(5, 5, '2024-05-18', '2024-11-18'),
(6, 1, '2024-06-22', '2024-12-22'),
(7, 2, '2024-07-30', '2025-07-30'),
(8, 3, '2024-08-25', '2025-08-25'),
(9, 4, '2024-09-11', '2025-09-11'),
(10, 5, '2024-10-05', '2025-10-05'),
(11, 1, '2024-01-22', '2024-07-22'),
(12, 2, '2024-02-15', '2025-02-15'),
(13, 3, '2024-03-10', '2025-03-10'),
(14, 4, '2024-04-07', '2025-04-07'),
(15, 5, '2024-05-29', '2024-11-29'),
(16, 1, '2024-06-14', '2024-12-14'),
(17, 2, '2024-07-05', '2025-07-05'),
(18, 3, '2024-08-20', '2025-08-20'),
(19, 4, '2024-09-14', '2025-09-14'),
(20, 5, '2024-10-23', '2025-10-23');

-- 9. INSERTS PARA TABLA tratamientos
INSERT INTO tratamientos (nombre, descripcion) VALUES
('Desparasitación', 'Tratamiento para eliminar parásitos internos.'),
('Control de pulgas', 'Aplicación de antipulgas mensual.'),
('Antibiótico general', 'Tratamiento para infecciones bacterianas.'),
('Corte y limpieza', 'Servicio de estética y salud.'),
('Tratamiento renal', 'Medicamentos para mejorar función renal.'),
('Vitaminas', 'Suplemento vitamínico.'),
('Cicatrización', 'Pomadas y medicamentos para heridas.'),
('Control alérgico', 'Medicamento para alergias crónicas.'),
('Tratamiento ocular', 'Gotas y medicinas para ojos.'),
('Tratamiento dental', 'Limpieza y medicación oral.'),
('Antiinflamatorio', 'Medicamento para inflamación.'),
('Analgesia', 'Control del dolor.'),
('Terapia respiratoria', 'Medicamentos para vías respiratorias.'),
('Control hormonal', 'Regulación hormonal.'),
('Curación de heridas', 'Limpieza y curación avanzada.'),
('Tratamiento digestivo', 'Medicamento para problemas digestivos.'),
('Terapia de movilidad', 'Medicamentos para articulaciones.'),
('Fortalecimiento óseo', 'Suplementos de calcio.'),
('Rehidratación', 'Tratamiento con suero.'),
('Control metabólico', 'Medicamento para metabolismo.');

-- 10. INSERTS PARA TABLA mascotas_tratamientos
INSERT INTO mascotas_tratamientos 
(id_mascota, id_tratamiento, fecha_inicio, fecha_fin, observaciones) VALUES
(1, 1, '2024-01-10', NULL, 'Tratamiento inicial'),
(1, 2, '2024-02-01', '2024-02-10', 'Sin novedades'),
(2, 1, '2024-03-05', NULL, 'Seguimiento'),
(3, 3, '2024-04-12', NULL, 'Revisión programada'),
(4, 2, '2024-05-01', '2024-05-07', 'Recuperación correcta'),
(5, 1, '2024-06-03', NULL, 'Control'),
(6, 3, '2024-06-10', NULL, 'Tratamiento recomendado'),
(7, 1, '2024-06-15', NULL, 'Pendiente evaluación'),
(8, 2, '2024-07-01', '2024-07-08', 'Mejoría visible'),
(9, 3, '2024-07-20', NULL, 'En observación'),
(10, 1, '2024-08-01', NULL, 'Control mensual'),
(11, 2, '2024-08-10', '2024-08-15', 'Caso estable'),
(12, 3, '2024-08-22', NULL, 'Revisión continua'),
(13, 1, '2024-09-01', NULL, 'Tratamiento básico'),
(14, 2, '2024-09-10', '2024-09-17', 'Buena respuesta'),
(15, 3, '2024-09-22', NULL, 'Chequeo regular'),
(16, 1, '2024-10-01', NULL, 'Sin cambios'),
(17, 2, '2024-10-12', '2024-10-19', 'Proceso estable'),
(18, 3, '2024-10-25', NULL, 'Seguimiento final'),
(19, 1, '2024-11-01', NULL, 'Control periódico');


-- 11. INSERTS PARA TABLA usuarios
INSERT INTO usuarios (username, password_hash, nombre_completo, correo, activo)
VALUES
('admin1','hash1','Usuario 1','u1@mail.com',1),
('admin2','hash2','Usuario 2','u2@mail.com',1),
('admin3','hash3','Usuario 3','u3@mail.com',1),
('admin4','hash4','Usuario 4','u4@mail.com',1),
('admin5','hash5','Usuario 5','u5@mail.com',1),
('admin6','hash6','Usuario 6','u6@mail.com',1),
('admin7','hash7','Usuario 7','u7@mail.com',1),
('admin8','hash8','Usuario 8','u8@mail.com',1),
('admin9','hash9','Usuario 9','u9@mail.com',1),
('admin10','hash10','Usuario 10','u10@mail.com',1),
('admin11','hash11','Usuario 11','u11@mail.com',1),
('admin12','hash12','Usuario 12','u12@mail.com',1),
('admin13','hash13','Usuario 13','u13@mail.com',1),
('admin14','hash14','Usuario 14','u14@mail.com',1),
('admin15','hash15','Usuario 15','u15@mail.com',1),
('admin16','hash16','Usuario 16','u16@mail.com',1),
('admin17','hash17','Usuario 17','u17@mail.com',1),
('admin18','hash18','Usuario 18','u18@mail.com',1),
('admin19','hash19','Usuario 19','u19@mail.com',1),
('admin20','hash20','Usuario 20','u20@mail.com',1);


-- 12. INSERTS PARA TABLA roles
INSERT INTO roles (nombre, descripcion) VALUES
('Admin General','Acceso total al sistema'),
('Recepcionista','Gestión básica'),
('Veterinario','Atención de mascotas'),
('Auxiliar','Apoyo general'),
('Supervisor','Control de procesos'),
('Auditor','Revisión de datos'),
('Asistente','Tareas menores'),
('Invitado','Acceso limitado'),
('Directivo','Gestión estratégica'),
('Soporte','Atención interna');


-- 13. INSERTS PARA TABLA permisos
INSERT INTO permisos (nombre, descripcion) VALUES
('CREAR_HISTORIAL','Registrar historial'),
('EDITAR_HISTORIAL','Modificar historial'),
('VER_HISTORIAL','Ver historial'),

('CREAR_VACUNA','Crear vacuna'),
('EDITAR_VACUNA','Editar vacuna'),
('ELIMINAR_VACUNA','Eliminar vacuna'),

('ASIGNAR_ROL','Asignar roles'),
('ASIGNAR_PERMISO','Asignar permisos'),
('VER_BITACORA','Ver bitácora'),
('VER_AUDITORIA','Ver auditoría'),
('GESTION_MASCOTAS','Administrar mascotas'),
('GESTION_TRATAMIENTOS','Administrar tratamientos'),
('GESTION_SEGURIDAD','Control de seguridad');

-- 14. INSERTS PARA usuarios_roles
INSERT INTO usuarios_roles (id_usuario, id_rol) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),
(11,2),(12,3),(13,4),(14,5),(15,6),(16,7),(17,8),(18,9),(19,10),(1,2);


-- 15. INSERTS PARA roles_permisos
INSERT INTO roles_permisos (id_rol, id_permiso) VALUES
-- Rol 1: Admin total
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),

-- Rol 2: Recepcionista
(2,8),(2,9),(2,10),

-- Rol 3: Veterinario
(3,5),(3,6),(3,7),

-- Rol 4: Auxiliar veterinario
(4,4),(4,5),

-- Rol 5: Encargado de vacunas
(5,6),(5,7),

-- Rol 6: Gestor de usuarios
(6,1),(6,2),(6,3),

-- Rol 7: Observador
(7,4),

-- Rol 8: Analista de informes
(8,10),

-- Rol 9: Auditor
(9,5),

-- Rol 10: Control recepción
(10,8),(10,9),(10,10);



-- 16. INSERTS PARA sesiones_usuario
INSERT INTO sesiones_usuario (id_usuario, token, inicio, ip_origen, agente_usuario) VALUES
(1,'token1','2024-01-10 10:00:00','192.168.1.1','Chrome'),
(2,'token2','2024-01-11 11:00:00','192.168.1.2','Firefox'),
(3,'token3','2024-01-12 12:00:00','192.168.1.3','Safari'),
(4,'token4','2024-01-13 13:00:00','192.168.1.4','Opera'),
(5,'token5','2024-01-14 14:00:00','192.168.1.5','Edge'),
(6,'token6','2024-01-15 15:00:00','192.168.1.6','Chrome'),
(7,'token7','2024-01-16 16:00:00','192.168.1.7','Chrome'),
(8,'token8','2024-01-17 17:00:00','192.168.1.8','Firefox'),
(9,'token9','2024-01-18 18:00:00','192.168.1.9','Edge'),
(10,'token10','2024-01-19 19:00:00','192.168.1.10','Opera'),
(11,'token11','2024-01-10 10:30:00','192.168.1.11','Chrome'),
(12,'token12','2024-01-11 11:30:00','192.168.1.12','Firefox'),
(13,'token13','2024-01-12 12:30:00','192.168.1.13','Safari'),
(14,'token14','2024-01-13 13:30:00','192.168.1.14','Edge'),
(15,'token15','2024-01-14 14:30:00','192.168.1.15','Chrome'),
(16,'token16','2024-01-15 15:30:00','192.168.1.16','Firefox'),
(17,'token17','2024-01-16 16:30:00','192.168.1.17','Chrome'),
(18,'token18','2024-01-17 17:30:00','192.168.1.18','Safari'),
(19,'token19','2024-01-18 18:30:00','192.168.1.19','Opera'),
(1,'token20','2024-01-19 19:30:00','192.168.1.20','Edge');


-- 17. INSERTS PARA bitacora (20 registros)
INSERT INTO bitacora (id_usuario, accion, tabla_afectada, id_registro, descripcion, ip_origen) VALUES
(1, 'LOGIN', 'usuarios', 1, 'Inicio de sesión exitoso', '192.168.1.1'),
(2, 'CREAR', 'mascotas', 5, 'Nueva mascota creada', '192.168.1.2'),
(3, 'EDITAR', 'citas', 3, 'Cita actualizada', '192.168.1.3'),
(4, 'ELIMINAR', 'vacunas', 2, 'Vacuna eliminada', '192.168.1.4'),
(5, 'LOGIN', 'usuarios', 5, 'Inicio de sesión exitoso', '192.168.1.5'),
(6, 'CREAR', 'tratamientos', 7, 'Nuevo tratamiento registrado', '192.168.1.6'),
(7, 'EDITAR', 'duenos', 2, 'Actualización de datos de dueño', '192.168.1.7'),
(8, 'ELIMINAR', 'razas', 4, 'Raza eliminada por inconsistencia', '192.168.1.8'),
(9, 'LOGIN', 'usuarios', 9, 'Inicio de sesión exitoso', '192.168.1.9'),
(10, 'CREAR', 'historiales_medicos', 10, 'Registro de historial médico', '192.168.1.10'),
(11, 'LOGIN', 'usuarios', 11, 'Inicio de sesión exitoso', '192.168.1.11'),
(12, 'CREAR', 'citas', 12, 'Nueva cita creada', '192.168.1.12'),
(13, 'EDITAR', 'mascotas', 3, 'Cambio en información de mascota', '192.168.1.13'),
(14, 'ELIMINAR', 'vacunas', 1, 'Vacuna retirada', '192.168.1.14'),
(15, 'LOGIN', 'usuarios', 15, 'Inicio de sesión exitoso', '192.168.1.15'),
(16, 'CREAR', 'tratamientos', 16, 'Tratamiento agregado al catálogo', '192.168.1.16'),
(17, 'EDITAR', 'especies', 1, 'Actualización de descripción de especie', '192.168.1.17'),
(18, 'ELIMINAR', 'razas', 3, 'Raza eliminada por duplicado', '192.168.1.18'),
(19, 'LOGIN', 'usuarios', 19, 'Inicio de sesión exitoso', '192.168.1.19'),
(NULL, 'SISTEMA', 'migracion', NULL, 'Ejecución de proceso de migración automática', '127.0.0.1');

-- 18. INSERTS PARA auditoria_cambios (20 registros)
INSERT INTO auditoria_cambios (tabla_nombre, clave_pk, campo_nombre, valor_anterior, valor_nuevo, id_usuario) VALUES
('mascotas','1','nombre','Max','Maximo',1),
('mascotas','2','peso','4.00','4.20',2),
('duenos','3','telefono','3003333333','3003334444',7),
('citas','4','estado','programada','completada',3),
('vacunas','5','descripcion','Protección ','Protección extendida',4),
('tratamientos','6','nombre','Control de pulgas','Control pulgas mensual',6),
('historiales_medicos','7','diagnostico','Indeterminado','Alergia',2),
('razas','8','nombre','Iguana','Iguana verde',8),
('especies','9','descripcion','Perros domésticos','Caninos domésticos y de trabajo',17),
('mascotas_vacunas','10','proxima_dosis','2025-01-10','2025-07-10',12),
('mascotas_tratamientos','11','fecha_fin','2024-10-13','2024-10-20',16),
('usuarios','12','activo','1','0',1),
('roles','13','descripcion','Acceso limitado','Acceso limitado y supervisado',5),
('permisos','14','nombre','VER_USUARIO','VER_DETALLE_USUARIO',5),
('sesiones_usuario','15','fin',NULL,'2024-01-19 19:30:00',1),
('bitacora','16','descripcion','Registro viejo','Actualizado con detalles',9),
('mascotas','17','fecha_nacimiento','2020-01-02','2020-01-03',13),
('historiales_medicos','18','tratamiento','Reposo','Antibiótico y reposo',11),
('vacunas','19','nombre','Refuerzo Canino','Refuerzo Canino Anual',14),
('auditoria_cambios','20','valor_nuevo','NULL','Registro inicial',NULL);

-- cosultas

-- mascotas con su dueño especie y raza 

SELECT 
    m.id_mascota,
    m.nombre AS mascota,
    d.nombres AS dueno,
    e.nombre AS especie,
    r.nombre AS razausuarios
FROM mascotas m
INNER JOIN duenos d ON m.id_dueno = d.id_dueno
INNER JOIN especies e ON m.id_especie = e.id_especie
LEFT JOIN razas r ON m.id_raza = r.id_raza;


-- Citas programadas con información completa de la mascota y dueño

SELECT 
    c.id_cita,
    c.fecha,
    c.motivo,
    m.nombre AS mascota,
    d.nombres AS dueno,
    d.telefono
FROM citas c
INNER JOIN mascotas m ON c.id_mascota = m.id_mascota
INNER JOIN duenos d ON m.id_dueno = d.id_dueno
WHERE c.estado = 'programada';

-- Historial médico completo de cada mascota

SELECT 
    m.nombre AS mascota,
    h.descripcion,
    h.diagnostico,
    h.tratamiento,
    h.fecha
FROM historiales_medicos h
INNER JOIN mascotas m ON h.id_mascota = m.id_mascota
ORDER BY h.fecha DESC;

-- Vacunas aplicadas con datos de mascota, especie y dueño

SELECT 
    mv.fecha_aplicacion,
    v.nombre AS vacuna,
    m.nombre AS mascota,
    e.nombre AS especie,
    d.nombres AS dueno
FROM mascotas_vacunas mv
INNER JOIN vacunas v ON mv.id_vacuna = v.id_vacuna
INNER JOIN mascotas m ON mv.id_mascota = m.id_mascota
INNER JOIN especies e ON m.id_especie = e.id_especie
INNER JOIN duenos d ON m.id_dueno = d.id_dueno;

-- Mascotas con sus tratamientos activos

SELECT 
    m.nombre AS mascota,
    t.nombre AS tratamiento,
    mt.fecha_inicio,
    mt.fecha_fin
FROM mascotas_tratamientos mt
INNER JOIN tratamientos t ON mt.id_tratamiento = t.id_tratamiento
INNER JOIN mascotas m ON mt.id_mascota = m.id_mascota
WHERE mt.fecha_fin IS NULL;

-- Usuarios con sus roles asignados

SELECT 
    u.username,
    u.nombre_completo,
    r.nombre AS rol
FROM usuarios u
INNER JOIN usuarios_roles ur ON u.id_usuario = ur.id_usuario
INNER JOIN roles r ON ur.id_rol = r.id_rol;

-- Usuarios con sus permisos (JOIN múltiple encadenado)

SELECT 
    u.username,
    r.nombre AS rol,
    p.nombre AS permiso
FROM usuarios u
INNER JOIN usuarios_roles ur ON u.id_usuario = ur.id_usuario
INNER JOIN roles r ON ur.id_rol = r.id_rol
INNER JOIN roles_permisos rp ON r.id_rol = rp.id_rol
INNER JOIN permisos p ON rp.id_permiso = p.id_permiso;

-- Sesiones activas con info del usuario

SELECT 
    s.id_sesion,
    u.username,
    s.token,
    s.inicio,
    s.ip_origen
FROM sesiones_usuario s
INNER JOIN usuarios u ON s.id_usuario = u.id_usuario
WHERE s.fin IS NULL;

-- Bitácora completa con datos del usuario que realizó la acción

SELECT 
    b.id_bitacora,
    u.username,
    b.accion,
    b.tabla_afectada,
    b.id_registro,
    b.descripcion,
    b.fecha
FROM bitacora b
LEFT JOIN usuarios u ON b.id_usuario = u.id_usuario
ORDER BY b.fecha DESC;

-- Auditoría detallada por campo, con información del usuario

SELECT 
    a.tabla_nombre,
    a.clave_pk,
    a.campo_nombre,
    a.valor_anterior,
    a.valor_nuevo,
    u.username,
    a.fecha
FROM auditoria_cambios a
LEFT JOIN usuarios u ON a.id_usuario = u.id_usuario
ORDER BY a.fecha DESC;

-- procedimiento almaceenados 1, 2 

DELIMITER $$

CREATE PROCEDURE registrar_mascota (
    IN p_dueno INT,
    IN p_especie INT,
    IN p_raza INT,
    IN p_nombre VARCHAR(80),
    IN p_sexo ENUM('M','F'),
    IN p_fecha_nacimiento DATE,
    IN p_color VARCHAR(80),
    IN p_peso DECIMAL(5,2)
)
BEGIN
    -- Validar dueño
    IF (SELECT COUNT(*) FROM duenos WHERE id_dueno = p_dueno) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: el dueño no existe.';
    END IF;

    -- Validar especie
    IF (SELECT COUNT(*) FROM especies WHERE id_especie = p_especie) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: la especie no existe.';
    END IF;

    -- Insertar mascota
    INSERT INTO mascotas (
        id_dueno, id_especie, id_raza, nombre, sexo,
        fecha_nacimiento, color, peso
    ) VALUES (
        p_dueno, p_especie, p_raza, p_nombre, p_sexo,
        p_fecha_nacimiento, p_color, p_peso
    );

    -- Devolver ID
    SELECT LAST_INSERT_ID() AS id_mascota_creada;
END $$

DELIMITER ;

-- 2 

DELIMITER $$

CREATE PROCEDURE registrar_cita (
    IN p_mascota INT,
    IN p_fecha DATETIME,
    IN p_motivo VARCHAR(200)
)
BEGIN
    -- Validar mascota
    IF (SELECT COUNT(*) FROM mascotas WHERE id_mascota = p_mascota) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: la mascota no existe.';
    END IF;

    -- Insertar nueva cita
    INSERT INTO citas (
        id_mascota, fecha, motivo
    ) VALUES (
        p_mascota, p_fecha, p_motivo
    );

    SELECT 'Cita registrada correctamente' AS mensaje;
END $$

DELIMITER ;

-- funciones 

DELIMITER $$

CREATE FUNCTION calcular_edad_mascota (fecha_nac DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE());
END $$

DELIMITER ;

SELECT nombre, calcular_edad_mascota(fecha_nacimiento) AS edad FROM mascotas;


DELIMITER $$

CREATE FUNCTION contar_vacunas (p_mascota INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM mascotas_vacunas
        WHERE id_mascota = p_mascota
    );
END $$

DELIMITER ;

SELECT nombre, contar_vacunas(id_mascota) AS total_vacunas
FROM mascotas;

-- triggers

DELIMITER $$

CREATE TRIGGER tr_auditar_mascotas_update
AFTER UPDATE ON mascotas
FOR EACH ROW
BEGIN
    -- Nombre
    IF OLD.nombre <> NEW.nombre THEN
        INSERT INTO auditoria_cambios (
            tabla_nombre, clave_pk, campo_nombre,
            valor_anterior, valor_nuevo, id_usuario
        ) VALUES (
            'mascotas', OLD.id_mascota, 'nombre',
            OLD.nombre, NEW.nombre, NULL
        );
    END IF;

    -- Color
    IF OLD.color <> NEW.color THEN
        INSERT INTO auditoria_cambios (
            tabla_nombre, clave_pk, campo_nombre,
            valor_anterior, valor_nuevo, id_usuario
        ) VALUES (
            'mascotas', OLD.id_mascota, 'color',
            OLD.color, NEW.color, NULL
        );
    END IF;

    -- Peso
    IF OLD.peso <> NEW.peso THEN
        INSERT INTO auditoria_cambios (
            tabla_nombre, clave_pk, campo_nombre,
            valor_anterior, valor_nuevo, id_usuario
        ) VALUES (
            'mascotas', OLD.id_mascota, 'peso',
            OLD.peso, NEW.peso, NULL
        );
    END IF;
END $$
DELIMITER ;






