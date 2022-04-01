-- Creación de tablas

CREATE TABLE rol(
	id serial PRIMARY KEY,
	nombre varchar(30) UNIQUE NOT NULL
);

CREATE TABLE usuario (
	id serial PRIMARY KEY,
	nombre varchar(30) NOT NULL,
	apellido varchar(30) NOT NULL,
	email varchar(50) UNIQUE NOT NULL,
	telefono varchar(30) NOT NULL,
	direccion varchar(500) NOT NULL,
	rol_id integer NOT NULL,
	CONSTRAINT rol_id FOREIGN KEY(rol_id) references rol(id)
);

CREATE TABLE carrito (
	id serial PRIMARY KEY,
	usuario_id integer NOT NULL,
	CONSTRAINT usuario_id FOREIGN KEY(usuario_id) references usuario(id)
);

CREATE TABLE etiqueta (
	id serial PRIMARY KEY,
	nombre varchar(30) UNIQUE NOT NULL
);

CREATE TABLE producto (
	id serial PRIMARY KEY,
	nombre varchar(30) UNIQUE NOT NULL,
	descripcion varchar(500) NOT NULL,
	precio float NOT NULL CHECK(precio>=0.00),
	valoracion float NOT NULL CHECK(valoracion>=0.00 AND valoracion<=5.00)
);

CREATE TABLE valoraciones (
	usuario_id integer NOT NULL,
	producto_id integer NOT NULL,
	valoracion integer NOT NULL CHECK(valoracion>=0 AND valoracion<=5),
	CONSTRAINT usuario_id FOREIGN KEY(usuario_id) references usuario(id),
	CONSTRAINT producto_id FOREIGN KEY(producto_id) references producto(id),
	CONSTRAINT PK_valoraciones PRIMARY KEY (usuario_id, producto_id)
);

CREATE TABLE producto_etiqueta (
	id_etiqueta integer NOT NULL,
	id_producto integer NOT NULL,
	CONSTRAINT id_etiqueta FOREIGN KEY(id_etiqueta) references etiqueta(id),
	CONSTRAINT id_producto FOREIGN KEY(id_producto) references producto(id),
	CONSTRAINT PK_etiqueta_producto PRIMARY KEY (id_etiqueta, id_producto)
);

CREATE TABLE linea_de_carrito (
	producto_id integer NOT NULL,
	CONSTRAINT producto_id FOREIGN KEY(producto_id) references producto(id),
	cantidad float NOT NULL CHECK(cantidad>=1),
	carrito_id integer NOT NULL,
	CONSTRAINT carrito_id FOREIGN KEY(carrito_id) references carrito(id),
	CONSTRAINT PK_linea_de_carrito PRIMARY KEY (producto_id, carrito_id)
);

CREATE TABLE pedido (
	id serial PRIMARY KEY,
	fecha timestamp NOT NULL,
	usuario_id integer NOT NULL,
	CONSTRAINT usuario_id FOREIGN KEY(usuario_id) references usuario(id)
);

CREATE TABLE categoria_estado_pedido (
	id serial PRIMARY KEY,
	nombre varchar(30) UNIQUE NOT NULL
);

CREATE TABLE estado_pedido (
	id_categoria_estado integer NOT NULL,
	id_pedido integer NOT NULL,
	fecha timestamp NOT NULL,
	CONSTRAINT id_pedido FOREIGN KEY(id_pedido) references pedido(id),
	CONSTRAINT id_categoria_estado FOREIGN KEY(id_categoria_estado) references categoria_estado_pedido(id),
	CONSTRAINT PK_estado_pedido PRIMARY KEY (id_categoria_estado, id_pedido)
);

CREATE TABLE linea_de_producto (
	producto_id integer NOT NULL,
	CONSTRAINT producto_id FOREIGN KEY(producto_id) references producto(id),
	cantidad float NOT NULL,
	precio_unitario float NOT NULL CHECK(precio_unitario>=0.00),
	total float NOT NULL CHECK(total>=0.00),
	pedido_id integer NOT NULL,
	CONSTRAINT pedido_id FOREIGN KEY(pedido_id) references pedido(id),
	CONSTRAINT PK_linea_de_producto PRIMARY KEY (producto_id, pedido_id)
);

CREATE TABLE estado_pago (
	id serial PRIMARY KEY,
	estado varchar(30) UNIQUE NOT NULL
);

CREATE TABLE pago (
	id serial PRIMARY KEY,
	importe float NOT NULL CHECK(importe>=0.00),
	estado_id integer NOT NULL,
	pedido_id integer NOT NULL,
	CONSTRAINT estado_id FOREIGN KEY(estado_id) references estado_pago(id),
	CONSTRAINT pedido_id FOREIGN KEY(pedido_id) references pedido(id)
);

CREATE TABLE favoritos (
	usuario_id integer NOT NULL,
	producto_id integer NOT NULL,
	CONSTRAINT usuario_id FOREIGN KEY(usuario_id) references usuario(id),
	CONSTRAINT producto_id FOREIGN KEY(producto_id) references producto(id),
	CONSTRAINT PK_favoritos PRIMARY KEY (usuario_id, producto_id)
);

CREATE TABLE images (
	id serial PRIMARY KEY,
	url varchar NOT NULL,
	producto_id integer NOT NULL,
	CONSTRAINT producto_id FOREIGN KEY(producto_id) references producto(id)
);
