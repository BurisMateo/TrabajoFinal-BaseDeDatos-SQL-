
-- Inserción de Datos

/* Este insert ejecutar despues del script 3

INSERT INTO valoraciones (usuario_id, producto_id, valoracion) VALUES
	(4, 1, 5),
	(7, 1, 3),
	(8, 1, 2),
	(10, 2, 4),
	(5, 2, 5),
	(7, 3, 4),
	(6, 3, 3),
	(4, 4, 5),
	(9, 4, 3),
	(7, 4, 4),
	(5, 5, 4),
	(4, 6, 1),
	(10, 6, 3),
	(10, 7, 3),
	(9, 7, 5),
	(4, 8, 1),
	(6, 8, 2),
	(7, 9, 4),
	(5, 9, 5),
	(10, 9, 4),
	(9, 9, 3),
	(8, 10, 3),
	(4, 10, 2),
	(7, 11, 4),
	(5, 12, 2),
	(10, 12, 2),
	(6, 12, 4),
	(5, 13, 2),
	(7, 13, 3),
	(9, 14, 5),
	(4, 14, 4),
	(10, 14, 4),
	(6, 15, 3),
	(7, 15, 4);
*/


--Ejecutar normalmente

INSERT INTO rol (nombre) VALUES 
	('cliente'),
	('administrador'),
	('cocina');

INSERT INTO usuario (nombre, apellido, email, telefono, direccion, rol_id) VALUES
	('matias', 'nuñez', 'mati.nuniez@gmail.com', '43623425', 'dra ratto 464', 2),
	('mateo', 'buris', 'mateoburis@gmail.com', '24556253', 'rieter 1177', 2),
	('franco', 'valledor', 'francovalledor@gmail.com', '55413393', 'perón 342', 2),
	('janna', 'terry', 'bibendum.sed@yahoo.edu', '54678624', 'egestas Rd. 3453', 1),
  	('isabella', 'collier', 'aliquet.libero@hotmail.net', '43216784', 'Pede Avenue 252', 1),
  	('audrey', 'mcpherson', 'lacinia.orci@icloud.edu', '45637813', 'Suspendisse Avenue', 1),
  	('grace', 'cross', 'elit.erat.vitae@outlook.edu', '12417635', 'Arcu. St. 567', 1),
  	('xyla', 'collins', 'viverra.donec@outlook.couk', '65734513', 'Nam Ave 1435', 1),	
	('paloma', 'maxwell', 'congue@icloud.org', '65247843','Nam Rd. 245', 1),
  	('clarke', 'bentley', 'nulla.facilisi@hotmail.com', '12452374','Blandit Av. 542', 1);


INSERT INTO etiqueta (nombre) VALUES
	('regular'),
	('vegano'),
	('bebida no alcoholica'),
	('bebida alcoholica'),
	('sandwich'),
	('hamburguesa'),
	('pizza'),
	('papas fritas');

INSERT INTO producto (nombre, descripcion, precio, valoracion)	VALUES
	('sandwich de milanesa', 'bife de vacuno con jamón, queso, huevo, tomate y lechuga', 400.00, 0.00),
	('hamburguesa simple', 'hamburguesa con jamón, queso, lechuga y tomate', 350.00, 0.00),
	('hamburguesa infantil', 'solo hamburguesa al pan + fritas', 250.00, 0.00),
	('hamburguesa viggie', 'haburguesa de legumbres con lechuga y tomate', 350.00, 0.00),
	('pizza mozzarella', 'pizza simple con queso mozzarella', 500.00, 0.00),
	('pizza especial', 'pizza con queso mozzarella, jamón y morrones', 610.00, 0.00),
	('pizza fugazza', 'pizza sin salsa, mozzarella y cebolla', 610.00, 0.00),
	('papas clásicas', 'bastoncitos de papas fritos', 280.00, 0.00),
	('papas con cheddar y panceta', 'bastoncitos de papas fritos con queso cheddar y panceta', 400.00, 0.00),
	('papas noisette clásicas', 'papas estilo noisette fritas', 300.00, 0.00),
	('agua mineral', 'botella de agua mineral de 500 ml', 180.00, 0.00),
	('coca-cola chica', 'botella de coca-cola de 350 ml', 180.00, 0.00),
	('coca-cola', 'botella de coca-cola de 1.25 lts', 250.00, 0.00),
	('cerveza imperial golden', 'botella de cerveza rubia de 1 lts', 420.00, 0.00),
	('cerveza imperial amber', 'botella de cerveza roja de 1 lts', 480.00, 0.00);

INSERT INTO producto_etiqueta (id_etiqueta, id_producto) values
	(1, 1),
	(5, 1),
	(1, 2),
	(6, 2),
	(1, 3),
	(6, 3),
	(2, 4),
	(6, 4),
	(1, 5),
	(7, 5),
	(1, 6),
	(7, 6),
	(1, 7),
	(7, 7),
	(1, 8),
	(2, 8),
	(8, 8),
	(1, 9),
	(8, 9),
	(1, 10),
	(2, 10),
	(8, 10),
	(3, 11),
	(3, 12),
	(3, 13),
	(4, 14),
	(4, 15);

INSERT INTO estado_pago(estado) VALUES
	('impago'), 
	('pagado'),
	('rechazado');

insert into categoria_estado_pedido (nombre) values 
	('en espera'),
	('preparando'),
	('enviado'),
	('demorado'),
	('cancelado'),
	('finalizado');

insert into pedido (fecha, usuario_id) values
	('2022-01-29 11:48:12', 4),
	('2022-01-29 12:31:34', 7),
	('2022-01-29 12:56:35', 8),
	('2022-01-30 21:44:15', 5),
	('2022-01-30 22:01:49', 9),
	('2022-02-01 19:12:31', 4),
	('2022-02-01 20:56:43', 5),
	('2022-02-02 11:54:45', 8),
	('2022-02-02 12:41:19', 10),
	('2022-02-02 19:55:44', 9),
	('2022-02-02 20:35:53', 4),
	('2022-02-02 22:11:32', 2);

insert into estado_pedido (id_categoria_estado, id_pedido, fecha) values
	(6, 1, '2022-01-29 11:48:12'),
	(6, 2, '2022-01-29 12:31:34'),
	(6, 3, '2022-01-29 12:56:35'),
	(5, 4, '2022-01-30 21:44:15'),
	(6, 5, '2022-01-30 22:01:49'),
	(6, 6, '2022-02-01 19:12:31'),
	(6, 7, '2022-02-01 20:56:43'),
	(6, 8, '2022-02-02 11:54:45'),
	(3, 9, '2022-02-02 12:41:19'),
	(3, 10, '2022-02-02 19:55:44'),
	(4, 11, '2022-02-02 20:35:53'),
	(2, 12, '2022-02-02 22:11:32');
	
insert into linea_de_producto (producto_id, cantidad, precio_unitario, total, pedido_id) values 
	(1, 2, 400.00, 800.00, 1),
	(13, 1, 250.00, 250.00, 1),
	(2, 1, 350.00, 350.00, 2),
	(11, 1, 180.00, 180.00, 2),
	(6, 2, 610.00, 1220, 3),
	(4, 1, 350.00, 350.00, 4),
	(11, 1, 180.00, 180.00, 4),
	(2, 2, 350.00, 700.00, 5),
	(9, 1, 400.00, 400.00, 5),
	(14, 1, 420.00, 420.00, 5),
	(5, 3, 500.00, 1500.00, 6),
	(1, 1, 400.00, 400.00, 7),
	(10, 2, 300.00, 600.00, 7),
	(7, 1, 610.00, 610.00, 8),
	(12, 2, 180.00, 360.00, 8),
	(10, 2, 400.00, 800.00, 9),
	(6, 1, 610.00, 610.00, 10),
	(15, 1, 480.00, 480.00, 10),
	(3, 2, 250.00, 500.00, 11),
	(2, 2, 350.00, 700.00, 11),
	(12, 2, 180.00, 360.00, 11),
	(13, 1, 250.00, 250.00, 11),
	(8, 3, 280.00, 840.00, 12),
	(15, 1, 480.00, 480.00, 12);
	
insert into pago (importe, estado_id, pedido_id) values 
	(1050.00, 2, 1),
	(530.00, 2, 2),
	(1220.00, 2, 3),
	(530.00, 3, 4),
	(1520.00, 2, 5),
	(1500.00, 2, 6),
	(1000.00, 2, 7),
	(970.00, 2, 8),
	(800.00, 2, 9),
	(1090.00, 2, 10),
	(1810.00, 1, 11),
	(1320.00, 1, 12);

insert into favoritos (usuario_id, producto_id) values
	(4, 6),
	(4, 3),
	(4, 13),
	(7, 2),
	(7, 3),
	(7, 14),
	(8, 1),
	(8, 2),
	(8, 15),
	(8, 7);





/*Reinicia la secuencia serial de los IDs
alter sequence rol_id_seq restart with 1;
alter sequence usuario_id_seq restart with 1;
alter sequence etiqueta_id_seq restart with 1;
alter sequence producto_id_seq restart with 1;
alter sequence estado_pago_id_seq restart with 1;
alter sequence categoria_estado_pedido_id_seq restart with 1;
alter sequence pedido_id_seq restart with 1;
alter sequence pago_id_seq restart with 1;
*/

