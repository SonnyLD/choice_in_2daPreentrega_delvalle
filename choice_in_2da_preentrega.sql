DROP DATABASE IF EXISTS choice_in;
CREATE DATABASE choice_in;
USE choice_in;

CREATE TABLE CLIENTE_CATEGORIA(
categoria_id INT NOT NULL AUTO_INCREMENT,
nombre_categoria VARCHAR(100) NOT NULL,
descripción TEXT,
beneficios TEXT,
PRIMARY KEY (categoria_id)
) COMMENT 'INFORMACION DE LA CATEGORIA';

CREATE TABLE CLIENTE(
cliente_id INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(100),
apellido VARCHAR(100),
documento_identidad VARCHAR(30), 
email VARCHAR(200),
teléfono VARCHAR(50),
categoría_id INT,
PRIMARY KEY (cliente_id),
FOREIGN KEY (categoría_id) REFERENCES CLIENTE_CATEGORIA(categoria_id)
) COMMENT 'INFORMACION BASICA DEL CLIENTE';

CREATE TABLE PAQUETE_TURISTICO(
paquete_id INT NOT NULL AUTO_INCREMENT,
nombre_paquete VARCHAR(100) NOT NULL,
descripción TEXT,
precio DECIMAL(10, 2),
disponibilidad INT,
PRIMARY KEY (paquete_id)
) COMMENT 'INFORMACION DEL PAQUETE QUE ESTA ADQUIRIENDO';

CREATE TABLE RESERVA(
 reserva_id INT NOT NULL AUTO_INCREMENT,
cliente_id INT,
paquete_id INT,
fecha_reserva DATE,
estado VARCHAR(50),
PRIMARY KEY (reserva_id),
FOREIGN KEY (cliente_id) REFERENCES CLIENTE(cliente_id),
FOREIGN KEY (paquete_id) REFERENCES PAQUETE_TURISTICO(paquete_id)
) COMMENT 'INFORMACION DE LAS RESERVAS';

CREATE TABLE PAGO(
pago_id INT NOT NULL AUTO_INCREMENT,
reserva_id INT,
método_pago VARCHAR(50),
monto DECIMAL(10, 2),
fecha_pago DATE DEFAULT (CURRENT_DATE),
estatus VARCHAR(50),
PRIMARY KEY (pago_id),
FOREIGN KEY (reserva_id) REFERENCES RESERVA(reserva_id)
) COMMENT 'INFORMACION DEL DETALLE DE LOS PAGOS';

CREATE TABLE PROVEEDOR(
proveedor_id INT NOT NULL AUTO_INCREMENT,
nombre_proveedor VARCHAR(100) NOT NULL,
tipo_servicio VARCHAR(50),
contacto VARCHAR(100),
PRIMARY KEY (proveedor_id)
) COMMENT 'INFORMACION DEL PROVEEDOR DE LOS VUELOS, ALOJAMIENTO Y DE LAS ACTIVIDADES';

CREATE TABLE VUELO(
vuelo_id INT NOT NULL AUTO_INCREMENT,
proveedor_id INT,
aerolínea VARCHAR(100),
origen VARCHAR(100),
destino VARCHAR(100),
fecha DATE,
hora TIME,
precio DECIMAL(10, 2),
disponibilidad INT,
PRIMARY KEY (vuelo_id),
FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(proveedor_id)
) COMMENT 'INFORMACION DEL DETALLE DEL VUELO';

CREATE TABLE ALOJAMIENTO(
alojamiento_id INT NOT NULL AUTO_INCREMENT,
proveedor_id INT,
hotel VARCHAR(100),
tipo_habitación VARCHAR(50),
precio DECIMAL(10, 2),
disponibilidad INT,
PRIMARY KEY (alojamiento_id),
FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(proveedor_id)
) COMMENT 'INFORMACION DEL ALOJAMIENTO';

CREATE TABLE ACTIVIDAD(
actividad_id INT NOT NULL AUTO_INCREMENT,
proveedor_id INT,
nombre_actividad VARCHAR(100),
descripción TEXT,
precio DECIMAL(10, 2),
disponibilidad INT,
PRIMARY KEY (actividad_id),
FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(proveedor_id)
) COMMENT 'INFORMACION DE LAS ACTIVIDADES A REALIZAR';

CREATE TABLE OPINION_CALIFICACION(
opinion_id INT NOT NULL AUTO_INCREMENT,
cliente_id INT,
entidad_id INT,
tipo_entidad ENUM('VUELO', 'ALOJAMIENTO', 'ACTIVIDAD'),
comentario TEXT,
calificación INT,
PRIMARY KEY (opinion_id),
FOREIGN KEY (cliente_id) REFERENCES CLIENTE(cliente_id),
-- No direct FK for entidad_id due to multiple possible table references
CHECK (tipo_entidad IN ('VUELO', 'ALOJAMIENTO', 'ACTIVIDAD'))
) COMMENT 'INFORMACION DE LA CALIFICACION Y OPINIONES DEL SERVICIO';

-- Crear tablas intermedias para gestionar las relaciones entre paquetes turísticos, vuelos, alojamientos y actividades

-- Paquete-Turístico y Vuelos
CREATE TABLE PAQUETE_VUELO(
    paquete_id INT,
    vuelo_id INT,
    PRIMARY KEY (paquete_id, vuelo_id),
    FOREIGN KEY (paquete_id) REFERENCES PAQUETE_TURISTICO(paquete_id),
    FOREIGN KEY (vuelo_id) REFERENCES VUELO(vuelo_id)
) COMMENT 'RELACION ENTRE PAQUETE TURISTICO Y VUELOS';

-- Paquete-Turístico y Alojamientos
CREATE TABLE PAQUETE_ALOJAMIENTO(
    paquete_id INT,
    alojamiento_id INT,
    PRIMARY KEY (paquete_id, alojamiento_id),
    FOREIGN KEY (paquete_id) REFERENCES PAQUETE_TURISTICO(paquete_id),
    FOREIGN KEY (alojamiento_id) REFERENCES ALOJAMIENTO(alojamiento_id)
) COMMENT 'RELACION ENTRE PAQUETE TURISTICO Y ALOJAMIENTOS';

-- Paquete-Turístico y Actividades
CREATE TABLE PAQUETE_ACTIVIDAD(
    paquete_id INT,
    actividad_id INT,
    PRIMARY KEY (paquete_id, actividad_id),
    FOREIGN KEY (paquete_id) REFERENCES PAQUETE_TURISTICO(paquete_id),
    FOREIGN KEY (actividad_id) REFERENCES ACTIVIDAD(actividad_id)
) COMMENT 'RELACION ENTRE PAQUETE TURISTICO Y ACTIVIDADES';

-- ALTER

-- Agregar clave foránea a la tabla CLIENTE para referenciar CLIENTE_CATEGORIA
ALTER TABLE CLIENTE 
ADD CONSTRAINT FK_CLIENTE_CATEGORIA
FOREIGN KEY (categoría_id) REFERENCES CLIENTE_CATEGORIA(categoria_id);

-- Agregar clave foránea a la tabla PAGO para referenciar RESERVA
ALTER TABLE PAGO 
ADD CONSTRAINT FK_PAGO_RESERVA
FOREIGN KEY (reserva_id) REFERENCES RESERVA(reserva_id);

-- Agregar claves foráneas a la tabla RESERVA para referenciar CLIENTE y PAQUETE_TURISTICO
ALTER TABLE RESERVA 
ADD CONSTRAINT FK_RESERVA_CLIENTE
FOREIGN KEY (cliente_id) REFERENCES CLIENTE(cliente_id),
ADD CONSTRAINT FK_RESERVA_PAQUETE
FOREIGN KEY (paquete_id) REFERENCES PAQUETE_TURISTICO(paquete_id);

-- Agregar clave foránea a la tabla VUELO para referenciar PROVEEDOR
ALTER TABLE VUELO 
ADD CONSTRAINT FK_VUELO_PROVEEDOR
FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(proveedor_id);

-- Agregar clave foránea a la tabla ALOJAMIENTO para referenciar PROVEEDOR
ALTER TABLE ALOJAMIENTO 
ADD CONSTRAINT FK_ALOJAMIENTO_PROVEEDOR
FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(proveedor_id);

-- Agregar clave foránea a la tabla ACTIVIDAD para referenciar PROVEEDOR
ALTER TABLE ACTIVIDAD 
ADD CONSTRAINT FK_ACTIVIDAD_PROVEEDOR
FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR(proveedor_id);

-- Agregar clave foránea a la tabla OPINION_CALIFICACION para referenciar CLIENTE
ALTER TABLE OPINION_CALIFICACION 
ADD CONSTRAINT FK_OPINION_CALIFICACION_CLIENTE
FOREIGN KEY (cliente_id) REFERENCES CLIENTE(cliente_id);

-- Inserción de datos en las tablas
-- Datos de CLIENTE_CATEGORIA
INSERT INTO CLIENTE_CATEGORIA (categoria_id, nombre_categoria, descripción, beneficios) VALUES
(1, 'Premium', 'Clientes premium con acceso a descuentos exclusivos.', 'Descuentos en vuelos y hoteles, acceso a actividades VIP.'),
(2, 'Estandar', 'Clientes estándar con beneficios básicos.', 'Acceso a ofertas estándar, servicios personalizados.'),
(3, 'Básico', 'Clientes con beneficios mínimos.', 'Acceso limitado a ofertas y servicios.');

-- Datos de CLIENTE(HAY UN ARCHIVO .CSV)
-- LOAD DATA LOCAL INFILE 'C:\\Users\\SONNY\\Desktop\\Curso de SQL\\primera_pre_entrega\\CLIENTE.csv'
-- INTO TABLE CLIENTE
-- FIELDS TERMINATED BY ','
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (cliente_id, nombre, apellido, documento_identidad, email, telefono, categoria_id);

-- Datos de CLIENTE
INSERT INTO CLIENTE (cliente_id, nombre, apellido, documento_identidad, email, teléfono, categoría_id) VALUES
(1, 'Benji', 'Robertshaw', 'Genderqueer', 'brobertshaw0@odnoklassniki.ru', '560-647-3621', 1),
(2, 'Erda', 'Cuxon', 'Female', 'ecuxon1@boston.com', '523-688-4175', 2),
(3, 'Terrance', 'Lissandrini', 'Male', 'tlissandrini3@yale.edu', '399-744-5095', 1);

-- Datos de PROVEEDOR
INSERT INTO PROVEEDOR (nombre_proveedor, tipo_servicio, contacto)
VALUES 
('Airways', 'Vuelo', 'contacto@airways.com'),
('Hotel Lux', 'Alojamiento', 'contacto@hotellux.com'),
('Tour Adventures', 'Actividad', 'contacto@touradventures.com');

-- Datos de PAQUETE_TURISTICO
INSERT INTO PAQUETE_TURISTICO (paquete_id, nombre_paquete, descripción, precio, disponibilidad)
VALUES 
(1, 'Paquete Aventura', 'Incluye actividades de aventura', 1500.00, 10),
(2, 'Paquete Relax', 'Incluye actividades de relajación', 1200.00, 8);

-- Datos de VUELO
INSERT INTO VUELO (proveedor_id, aerolínea, origen, destino, fecha, hora, precio, disponibilidad)
VALUES 
(1, 'Airways', 'Lima', 'Cusco', '2024-10-10', '08:00:00', 500.00, 50);

-- Datos de ALOJAMIENTO
INSERT INTO ALOJAMIENTO (proveedor_id, hotel, tipo_habitación, precio, disponibilidad)
VALUES 
(2, 'Hotel Lux', 'Suite', 300.00, 5);

-- Datos de ACTIVIDAD
INSERT INTO ACTIVIDAD (proveedor_id, nombre_actividad, descripción, precio, disponibilidad)
VALUES 
(3, 'Tour Machu Picchu', 'Visita guiada a Machu Picchu', 200.00, 30);

-- Datos de RESERVA
INSERT INTO RESERVA (cliente_id, paquete_id, fecha_reserva, estado) VALUES
(1, 1, '2024-09-15', 'Confirmada'),
(2, 2, '2024-09-18', 'Pendiente');

-- Datos de PAGO
INSERT INTO PAGO (reserva_id, método_pago, monto, estatus) VALUES
(1, 'Tarjeta de crédito', 1500.00, 'Completado'),
(2, 'Transferencia bancaria', 1200.00, 'Pendiente');

-- Datos de OPINION_CALIFICACION
INSERT INTO OPINION_CALIFICACION (cliente_id, entidad_id, tipo_entidad, comentario, calificación) VALUES
(1, 1, 'VUELO', 'Muy buen servicio, cómodo y puntual.', 5),
(2, 2, 'ALOJAMIENTO', 'Habitación cómoda, pero el servicio al cliente puede mejorar.', 3);

-- Función para obtener el total de pagos por reserva
DELIMITER //
CREATE FUNCTION TotalPagosPorReserva(reservaId INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2);
    SELECT SUM(monto) INTO total 
    FROM PAGO 
    WHERE reserva_id = reservaId;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

-- Funcion para la calificacion promedio del cliente
DELIMITER //
CREATE FUNCTION CalificacionPromedioCliente(clienteId INT) 
RETURNS DECIMAL(3, 2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(3, 2);
    SELECT AVG(calificación) INTO promedio 
    FROM OPINION_CALIFICACION 
    WHERE cliente_id = clienteId;
    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

-- -- Crear Stored Procedure 
DELIMITER //
CREATE PROCEDURE CrearReserva(
    IN clienteId INT, 
    IN paqueteId INT,
    IN fechaReserva DATE)
BEGIN
    INSERT INTO RESERVA (cliente_id, paquete_id, fecha_reserva, estado) 
    VALUES (clienteId, paqueteId, fechaReserva, 'Pendiente');
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ActualizarEstadoReserva(
    IN reservaId INT,
    IN nuevoEstado VARCHAR(50))
BEGIN
    UPDATE RESERVA 
    SET estado = nuevoEstado 
    WHERE reserva_id = reservaId;
END //
DELIMITER ;

-- Stored Procedure para procesar un pago
DELIMITER //
CREATE PROCEDURE ProcesarPago(
    IN p_reserva_id INT,
    IN p_metodo_pago VARCHAR(50),
    IN p_monto DECIMAL(10, 2)
)
BEGIN
    INSERT INTO PAGO(reserva_id, metodo_pago, monto, estatus)
    VALUES (p_reserva_id, p_metodo_pago, p_monto, 'Completado');
END //
DELIMITER ;

-- Creación de triggers (ejemplo)
DELIMITER $$
CREATE TRIGGER before_insert_reserva
BEFORE INSERT ON RESERVA
FOR EACH ROW
BEGIN
    IF NEW.fecha_reserva < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de reserva no puede ser en el pasado.';
    END IF;
END $$
DELIMITER ;

-- Trigger para actualizar la disponibilidad del paquete turístico tras una reserva
DELIMITER //
CREATE TRIGGER ActualizarDisponibilidadPaquete
AFTER INSERT ON RESERVA
FOR EACH ROW
BEGIN
    UPDATE PAQUETE_TURISTICO 
    SET disponibilidad = disponibilidad - 1 
    WHERE paquete_id = NEW.paquete_id;
END //
DELIMITER ;

-- Crear vistas
CREATE VIEW ReservasActivas AS
SELECT r.reserva_id, c.nombre, c.apellido, p.nombre_paquete, r.fecha_reserva
FROM RESERVA r
JOIN CLIENTE c ON r.cliente_id = c.cliente_id
JOIN PAQUETE_TURISTICO p ON r.paquete_id = p.paquete_id
WHERE r.estado = 'Confirmada';

CREATE VIEW OpinionesPorCliente AS
SELECT o.opinion_id, c.nombre, c.apellido, o.tipo_entidad, o.comentario, o.calificación
FROM OPINION_CALIFICACION o
JOIN CLIENTE c ON o.cliente_id = c.cliente_id;



