
--Creación de triggers

--Recordar ejecutar el insert faltante (es por el trigger de valoracion)

--Trigger para promediar las valoraciones de los producto
CREATE OR REPLACE FUNCTION prom_valor() RETURNS trigger AS $prom_valor$
    BEGIN
		UPDATE producto 
			SET valoracion = (SELECT ROUND(AVG(1.0*valoracion), 2) FROM valoraciones WHERE (producto_id = NEW.producto_id))
				WHERE id = NEW.producto_id;
		RETURN NULL;
    END;
$prom_valor$ LANGUAGE 'plpgsql';

CREATE TRIGGER prom_valor AFTER INSERT OR UPDATE ON valoraciones
    FOR EACH ROW EXECUTE PROCEDURE prom_valor();


--Trigger para asignarle un estado a un pedido nuevo
CREATE OR REPLACE FUNCTION asig_estado() RETURNS trigger AS $asig_estado$
	BEGIN
		INSERT INTO estado_pedido (id_categoria_estado, id_pedido, fecha) VALUES
			(1, NEW.id, now());
		RETURN NULL;
	END;
$asig_estado$ LANGUAGE 'plpgsql';

CREATE TRIGGER asig_estado AFTER INSERT ON pedido
	FOR EACH ROW EXECUTE PROCEDURE asig_estado();


-- tabla de cambios   
CREATE SCHEMA logging;
CREATE TABLE logging.t_history (
	id	serial,
    tstamp timestamp DEFAULT now(),
	schemaname text,
    tabname	text,
	operation text,
	who text DEFAULT current_user,
    new_val json,
	old_val json
);   

CREATE FUNCTION change_trigger() RETURNS trigger AS $$
	BEGIN
	    IF	TG_OP = 'INSERT'
	    THEN
			INSERT INTO logging.t_history (tabname, schemaname, operation, new_val)
				VALUES (TG_RELNAME, TG_TABLE_SCHEMA, TG_OP, row_to_json(NEW));
			RETURN NEW;
		ELSIF   TG_OP = 'UPDATE'
		THEN    
			INSERT INTO logging.t_history (tabname, schemaname, operation, new_val, old_val)
				VALUES (TG_RELNAME, TG_TABLE_SCHEMA, TG_OP, row_to_json(NEW), row_to_json(OLD));
			RETURN NEW;
        ELSIF   TG_OP = 'DELETE'
        	THEN
				INSERT INTO logging.t_history (tabname, schemaname, operation, old_val)
					VALUES (TG_RELNAME, TG_TABLE_SCHEMA, TG_OP, row_to_json(OLD));
				RETURN OLD;
        END IF;
    END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;

CREATE TRIGGER val_t BEFORE INSERT OR UPDATE OR DELETE ON valoraciones 
        FOR EACH ROW EXECUTE PROCEDURE change_trigger();


--Vista de las ventas diarias (requerimiento)
CREATE OR REPLACE VIEW ventas_diarias AS
SELECT to_char( ped.fecha,'YYYY-MM-DD' ) as fecha_venta, SUM(p.importe) AS total_ventas FROM pago p
LEFT JOIN pedido ped ON p.pedido_id = ped.id
WHERE
	p.estado_id = 2 --pagado
GROUP BY fecha_venta;

--Vista de los pedidos activos
CREATE or replace VIEW pedidos_activos AS
	select p.*, cat.nombre from pedido p 
		left join estado_pedido ep on p.id=ep.id_pedido 
			left join categoria_estado_pedido cat on ep.id_categoria_estado=cat.id 
				where cat.nombre='en espera' or cat.nombre='preparando' or cat.nombre='enviado' or cat.nombre='demorado'
	order by fecha;

--Vista de los pedidos finalizados
CREATE or replace VIEW pedidos_finalizados AS
	select p.*, cat.nombre from pedido p 
		left join estado_pedido ep on p.id=ep.id_pedido 
			left join categoria_estado_pedido cat on ep.id_categoria_estado=cat.id 
				where cat.nombre='finalizado' or cat.nombre='cancelado'
	order by fecha;

--Vista para ver los pedidos que aun no se pagaron
CREATE or replace VIEW pedidos_impagos AS
	select * from pedido where
		id = ANY(select pedido_id from pago
			  	where estado_id = ANY(select id from estado_pago
							where estado='impago'));

--Vista para ver los productos organizados por valoracion
create view producto_por_valoracion as
	select * from producto order by valoracion desc;
