DO $$
BEGIN
  RAISE INFO '* Server version:     %', (select setting from pg_config where pg_config.name='VERSION');
  RAISE INFO '* Current Database:   %', (select current_database());
  RAISE INFO '* Date:               %', (select now());
  RAISE INFO '* Current User/Role:  %', (select current_role);
END$$;

\! echo

\C 'Tables per Database'
SELECT COUNT(tables.table_name) AS "Tables", table_catalog AS "Databases" FROM information_schema.tables WHERE table_schema='public'  GROUP BY table_catalog;
