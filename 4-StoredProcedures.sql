
--Stored Procedures


--Usuario

--Parametros: 
--Los parametros que se pasan son los correspondientes a la tabla usuario, a diferencia del rol
--el cál se asigna automaticamente como Cliente (la unica forma de crear un Admin o Cocina es hacerlo manualmente)
create procedure insert_usuario (v_nombre varchar, v_apellido varchar, v_email varchar, v_telefono varchar, v_direccion varchar) 
language sql
as $$ 
	insert into usuario (nombre, apellido, email, telefono, direccion, rol_id) 
		values (v_nombre, v_apellido, v_email, v_telefono, v_direccion, 1);
$$;

--Parametros: 
--'a_email' es la variable por la que se buscará al usuario que se quiere actualizar
--El resto de parametros son los nuevos valores a actualizar (si no se quiere actualizar el dato se debe insertar el que ya estaba)
create procedure update_usuario (a_email varchar, v_nombre varchar, v_apellido varchar, v_email varchar, v_telefono varchar, v_direccion varchar)
language plpgsql
as $$ 
	declare
		usu_id integer := (select id from usuario where email=a_email);
	begin
		if (usu_id is NULL) then
			raise notice 'No existe ese usuario';
		else
			update usuario set nombre = v_nombre, apellido = v_apellido, email = v_email, telefono = v_telefono, direccion = v_direccion where email = a_email;
		end if;
	end;
$$;

--Parametros: 'v_email' es la variable por la que se buscará al usuario que se quiere eliminar
create or replace procedure delete_usuario (v_email varchar)
language plpgsql
as $$ 
	declare
		usu_id integer := (select id from usuario where email=v_email);
	begin
		if (usu_id is NULL) then
			raise notice 'No existe ese usuario';
		else
			delete from usuario where email = v_email;
		end if;
	end;
$$;

--Producto

--Parametros:
--Los parametros que se pasan son los correspondientes a la tabla pedido, a diferencia de la valoracion
--que se inicia por defecto en 0 y se actualizará cada vez que se inserte una valoracion en la tabla valoraciones

create procedure insert_producto (v_nombre varchar, v_descripcion varchar, v_precio float) 
language sql
as $$
	insert into producto (nombre, descripcion, precio, valoracion) 
		values (v_nombre, v_descripcion, v_precio, 0.00);
$$;

--Parametros:
--'a_nombre' es la variable por la que se buscará el producto que se quiere actualizar
--El resto de parametros son los nuevos valores a actualizar (si no se quiere actualizar el dato se debe insertar el que ya estaba)
create procedure update_producto (a_nombre varchar, v_nombre varchar, v_descripcion varchar, v_precio float) 
language plpgsql
as $$ 
	declare
		prod_id integer := (select id from producto where nombre=a_nombre);
	begin
		if (prod_id is NULL) then
			raise notice 'No existe ese producto';
		else
			update producto set nombre = v_nombre, descripcion = v_descripcion , precio = v_precio where nombre = a_nombre;
		end if;
	end;
$$;

--Parametros: 'v_email' es la variable por la que se buscará el producto que se quiere eliminar

create or replace procedure delete_producto (v_nombre varchar)
language plpgsql
as $$ 
	declare
		prod_id integer := (select id from producto where nombre=v_nombre);
	begin
		if (prod_id is NULL) then
			raise notice 'No existe ese producto';
		else
			delete from producto where nombre = v_nombre;
		end if;
	end;
$$;

--Insertar etiquetas a un producto
--Parametros: 
--'v_etiqueta' es el nombre de la etiqueta y 'v_producto' es el nombre del producto al que se asigna la etiqueta
create or replace procedure insert_etiqueta (v_etiqueta varchar, v_producto varchar)
language sql
as $$
	insert into producto_etiqueta (id_etiqueta, id_producto) values
		((select id from etiqueta where nombre = v_etiqueta), (select id from producto where nombre = v_producto));
$$;

--Borrar etiqueta de un producto
--Parametros:
--'v_etiqueta' es el nombre de la etiqueta y 'v_producto' es el nombre del producto al que se le debe quitar la etiqueta
create or replace procedure delete_etiqueta (v_etiqueta varchar, v_producto varchar)
language sql
as $$
	delete from producto_etiqueta where
		id_etiqueta=(select id from etiqueta where nombre = v_etiqueta) and id_producto=(select id from producto where nombre = v_producto);
$$;


--Crear carrito
--Parametros: 'v_usuario' es el ID del usuario al que pertenece el carrito
create or replace procedure insert_carrito (v_usuario integer)
language sql
as $$
	insert into carrito(usuario_id) values (v_usuario);
$$;

--Parametros: 'v_email' es el email del usuario al que pertenece el carrito
--(postgre identifica autamicamente que procedimiento es segun el valor del parametro)
create or replace procedure insert_carrito (v_email varchar)
language plpgsql
as $$
	declare 
		usu_id integer := (select id from usuario where email = v_email);
	begin
		call insert_carrito(usu_id);
	end;
$$;

--Insertar lineas de carrito
--Parametros: 
--'v_producto' es el id del producto que se inserta en la linea
--'v_cantidad' es la cantidad de productos insertados
--'v_email' es el email del usuario al que pertenece el carrito
create or replace procedure insert_linea_carrito (v_producto integer, v_cantidad integer, v_email varchar)
language plpgsql
as $$
	declare
		--Como no borramos los carritos, sino que creamos nuevos, 'last_carrito_id' selecciona el ultimo carrito asignado al usuario
		last_carrito_id integer := (select (max(c.id)) from carrito c left join usuario u on c.usuario_id=u.id where u.email=v_email);
	begin
		insert into linea_de_carrito(producto_id, cantidad, carrito_id) values (v_producto, v_cantidad, last_carrito_id);
	end;
$$;


--Insertar pedido y linea_de_producto

--Parametros: 'v_carrito' es el ID del carrito del que se toman los producto con el que se crea el pedido
create or replace procedure insert_pedido (v_carrito integer)
language 'plpgsql'
as $$
	declare
		u_carrito integer := (select c.usuario_id from carrito c where c.id=v_carrito);
		new_id integer := (select (max(id)+1) from pedido);
		temprow record;
	begin
		insert into pedido (id, fecha, usuario_id) values (new_id, now(), u_carrito);
		for temprow in
			select lc.*, p.* from carrito c
				left join linea_de_carrito lc on c.id=lc.carrito_id
					left join producto p on p.id=lc.producto_id
						where c.id=v_carrito
		loop
			insert into linea_de_producto(producto_id, cantidad, precio_unitario, total, pedido_id) values
				(temprow.producto_id, temprow.cantidad, temprow.precio, temprow.cantidad*temprow.precio, new_id);
		end loop;
		call insert_carrito(u_carrito);--Se le asigna un nuevo carrito al usuario
	end;
$$;

--Parametros: 'v_email' es el email del usuario al que pertence el carrito de donde se tomarán los productos del pedido
create or replace procedure insert_pedido (v_email varchar)
language 'plpgsql'
as $$
	declare
		last_carrito_id integer := (select (max(c.id)) from carrito c left join usuario u on c.usuario_id=u.id where u.email=v_email);
	begin
		call insert_pedido(last_carrito_id);
	end;
$$;

--Asignar un nuevo estado a un pedido
--Parametros:
--'v_estado' es el nombre del estado a asignar
--'v_pedido' es el ID del pedido al que se le asigna el nuevo estado
create or replace procedure update_estado_pedido (v_estado varchar, v_pedido integer)
language plpgsql
as $$
	declare
		id_estado_actual integer := (select id_categoria_estado from estado_pedido where id_pedido = v_pedido order by fecha desc limit 1);
	begin
		if (id_estado_actual=1 and (v_estado='preparando' or v_estado='cancelado'))
			or (id_estado_actual=2 and (v_estado='enviado' or v_estado='demorado' or v_estado='cancelado'))
			or (id_estado_actual=3 and v_estado='finalizado')
			or (id_estado_actual=4 and (v_estado='enviado' or v_estado='cancelado' or v_estado='finalizado'))
		then
			insert into estado_pedido (id_categoria_estado, id_pedido, fecha) values
				((select id from categoria_estado_pedido where nombre = v_estado), v_pedido, now());
		else
			RAISE NOTICE 'No se puede asignar ese nuevo estado';
		end if;
	end;
$$;


--Ver etiquetas de un producto
--Parametros: 'v_producto' es el ID del producto del que se quiere ver las etiquetas asignadas
create or replace procedure etiquetas_por_producto (v_producto integer)
language 'plpgsql'
as $$
	declare
		cursortabla cursor for SELECT e.* FROM producto_etiqueta pe LEFT JOIN etiqueta e ON e.id = pe.id_etiqueta WHERE pe.id_producto = v_producto;
		tuplaEtiqueta etiqueta;
	begin
		for tuplaEtiqueta in cursortabla loop
			raise notice 'Etiqueta: %', tuplaEtiqueta.nombre;
		end loop;
	end;
$$;	

--Ver productos de una etiqueta
--Parametros: 'v_etiquetas' es el nombre de la etiqueta de la que se quiere ver los productos que tengan
--asignada dicha etiqueta
create or replace procedure productos_por_etiqueta (v_etiqueta varchar)
language 'plpgsql'
as $$
	declare
		cursortabla cursor for SELECT p.* FROM etiqueta e LEFT JOIN producto_etiqueta pe ON e.id = pe.id_etiqueta LEFT JOIN producto p ON pe.id_producto = p.id WHERE e.nombre = v_etiqueta;
		tuplaProducto producto;
	begin
		for tuplaProducto in cursortabla loop
			raise notice 'ID_Producto: %, Nombre: %', tuplaProducto.id, tuplaProducto.nombre;
		end loop;
	end;
$$;

--Ver favoritos de un usuario
--Parametros: 'v_email' es el email del usuario del que se quiere ver los productos marcados como Favoritos
create or replace procedure favoritos_por_usuario (v_email varchar)
language 'plpgsql'
as $$
	declare
		cursortabla cursor for SELECT p.* FROM favoritos f LEFT JOIN usuario u ON u.id = f.usuario_id LEFT JOIN producto p ON p.id = f.producto_id WHERE u.email = v_email;
		tuplaFavorito producto;
	begin
		for tuplaFavorito in cursortabla loop
			raise notice 'ID_Producto: %, Nombre: %', tuplaFavorito.id, tuplaFavorito.nombre;
		end loop;
	end;
$$;

--Busqueda de productos por cadena parcial
--Parametros: 'v_busqueda' es el texto por el que se buscarán los producto tanto en su Nombre como es Descripcion
create or replace procedure busqueda_parcial (v_busqueda varchar)
language 'plpgsql'
as $$
	declare
		cursortabla cursor for SELECT * FROM producto p WHERE (p.nombre LIKE ('%'||v_busqueda||'%')) OR (p.descripcion LIKE ('%'||v_busqueda||'%'));
		tuplaBuscado producto;
	begin
		for tuplaBuscado in cursortabla loop
			raise notice 'ID_Producto: %, Nombre: %, Descripcion: %', tuplaBuscado.id, tuplaBuscado.nombre, tuplaBuscado.descripcion;
		end loop;
	end;
$$;
