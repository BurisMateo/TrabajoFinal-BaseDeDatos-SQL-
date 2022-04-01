--Script de prueba


call insert_usuario ('pedro', 'gutierrez', 'pedritog@gmail.com', '41345423', 'av. urquiz 1453');
/*ERROR*/call insert_usuario ('pedro', 'gonzalez', 'pedritog@gmail.com', '41345423', 'av. urquiz 1453');

call update_usuario ('pedritog@gmail.com', 'pedro', 'gonzalez', 'pedritog@gmail.com', '41345423', 'av. urquiz 1453');
/*ERROR*/call update_usuario ('pedritog@gmail.com', 'pedro', 'gonzalez', 'mati.nuniez@gmail.com', '41345423', 'av. urquiz 1453');

call delete_usuario ('pedritog@gmail.com');


call insert_producto ('jugo de fruta', 'botella de jugo de naranja con pulpa de 1 lts', 250.00);

call update_producto ('jugo de fruta', 'jugo de naranja', 'botella de jugo de naranja con pulpa de 1 lts', 250.00);
/*ERROR*/call update_producto ('jugo de fruta', 'jugo de naranjas', 'botella de jugo de naranja con pulpa de 1 lts', 250.00);

/*ERROR*/call delete_producto ('jugo de fruta');
call delete_producto ('jugo de naranja');


call insert_etiqueta ('bebida no alcoholica', 'jugo de naranja');--Repetir insert y update anterior
/*ERROR*/call insert_etiqueta ('bebida', 'jugo de naranja');
/*ERROR*/call insert_etiqueta ('hamburguesa');

call delete_etiqueta ('bebida no alcoholica', 'jugo de naranja');


call insert_carrito('mateoburis@gmail.com');
/*ERROR*/ call insert_carrito('kimaski@gmail.com');

call insert_linea_carrito(1, 2, 'mateoburis@gmail.com');
call insert_linea_carrito(4, 1, 'mateoburis@gmail.com');
call insert_linea_carrito(12, 6, 'mateoburis@gmail.com');
call insert_linea_carrito(14, 2, 'mateoburis@gmail.com');
/*ERROR*/call insert_linea_carrito(14, 2, 'mateoburis@gmail.com');
/*ERROR*/call insert_linea_carrito(92, 2, 'mateoburis@gmail.com');


call insert_pedido('mateoburis@gmail.com');--Se genera solo si existe articulos en el carrito
/*ERROR*/call insert_pedido('mateoburis@gmail.com');--El carrito se vacia cuando se genera el pedido


select * from pedidos_activos;--Vista

call update_estado_pedido ('finalizado', 9);
/*ERROR*/call update_estado_pedido ('demorado', 9);
/*ERROR*/call update_estado_pedido ('en espera', 54);


call etiquetas_por_producto(4);
/*ERROR*/call etiquetas_por_producto('hamburguesa simple');

call productos_por_etiqueta ('hamburguesa');

call favoritos_por_usuario('bibendum.sed@yahoo.edu');
/*ERROR*/call favoritos_por_usuario(7);
/*ERROR*/call favoritos_por_usuario('pedro');--No mostrará nada

--Busqueda de los productos por cadena parcial
call busqueda_parcial('izz');
call busqueda_parcial('1');
call busqueda_parcial('');--Mostrará todos
/*ERROR*/call busqueda_parcial('¿');--No mostrará nada


select * from pedidos_finalizados;--Vista

select * from ventas_diarias;--Vista

select * from pedidos_impagos;--Vista

select * from producto_por_valoracion;--Vista

