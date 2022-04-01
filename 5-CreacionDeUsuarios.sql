
--Creación de Usuarios y Roles de la base de datos
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'readonly') THEN

      CREATE ROLE readonly;
   END IF;
END
$do$;

DO 
$$ 
BEGIN
  EXECUTE format('GRANT CONNECT ON DATABASE %I to %I', current_database(), 'readonly');
END;
$$;

GRANT USAGE ON SCHEMA public TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly;

DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'readwrite') THEN

      CREATE ROLE readwrite;
   END IF;
END
$do$;

DO 
$$ 
BEGIN
  EXECUTE format('GRANT CONNECT ON DATABASE %I to %I', current_database(), 'readwrite');
END;
$$;

GRANT USAGE ON SCHEMA public TO readwrite;
GRANT USAGE, CREATE ON SCHEMA public TO readwrite;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO readwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO readwrite;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO readwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO readwrite;

DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_user
      WHERE  usename = 'usuario1'
  ) 
  THEN

      CREATE USER usuario1 WITH PASSWORD 'contraseña_1';
      GRANT readonly TO usuario1; 
   END IF;
END
$do$;

DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_user
      WHERE  usename = 'usuario2'
  ) 
  THEN

      CREATE USER usuario2 WITH PASSWORD 'contraseña_2';
      GRANT readonly TO usuario2; 
   END IF;
END
$do$;
