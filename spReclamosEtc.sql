--------------------------------------
------------ PROCEDURES --------------
--------------------------------------

--RECLAMOS


CREATE PROCEDURE DB_OWNERS.migrar_estado_reclamo AS
BEGIN
	INSERT INTO DB_OWNERS.ESTADO_RECLAMO
	SELECT DISTINCT 
		RECLAMO_ESTADO
	FROM gd_esquema.Maestra
	WHERE RECLAMO_ESTADO IS NOT NULL
END
GO


CREATE PROCEDURE DB_OWNERS.migrar_tipo_reclamo AS
BEGIN
	INSERT INTO DB_OWNERS.TIPO_RECLAMO
	SELECT DISTINCT 
		RECLAMO_TIPO
	FROM gd_esquema.Maestra
	WHERE RECLAMO_TIPO IS NOT NULL
END
GO


CREATE PROCEDURE DB_OWNERS.migrar_solucion_reclamo AS
BEGIN
	INSERT INTO DB_OWNERS.SOLUCION
	SELECT DISTINCT 
		RECLAMO_SOLUCION
	FROM gd_esquema.Maestra
	WHERE RECLAMO_SOLUCION IS NOT NULL
END
GO

CREATE PROCEDURE DB_OWNERS.migrar_operador AS
BEGIN
	INSERT INTO DB_OWNERS.OPERADOR
	SELECT DISTINCT 
		m.OPERADOR_RECLAMO_NOMBRE,
		m.OPERADOR_RECLAMO_APELLIDO,
		m.OPERADOR_RECLAMO_DNI,
		m.OPERADOR_RECLAMO_TELEFONO,
		m.OPERADOR_RECLAMO_MAIL,
		m.OPERADOR_RECLAMO_FECHA_NAC,
		d.id_direccion
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.DIRECCION d ON d.calle_numero = m.OPERADOR_RECLAMO_DIRECCION
	WHERE 
		m.OPERADOR_RECLAMO_NOMBRE IS NOT NULL and
		m.OPERADOR_RECLAMO_APELLIDO IS NOT NULL and
		m.OPERADOR_RECLAMO_DNI IS NOT NULL and
		m.OPERADOR_RECLAMO_TELEFONO IS NOT NULL and
		m.OPERADOR_RECLAMO_MAIL IS NOT NULL and
		m.OPERADOR_RECLAMO_FECHA_NAC IS NOT NULL
END
GO




--LUGARES

CREATE PROCEDURE DB_OWNERS.migrar_provincias AS
BEGIN
	INSERT INTO DB_OWNERS.PROVINCIA(
		nombre
	)
	SELECT DISTINCT 
		m.DIRECCION_USUARIO_PROVINCIA
		FROM gd_esquema.Maestra m
		WHERE m.DIRECCION_USUARIO_PROVINCIA IS NOT NULL
	UNION
	SELECT DISTINCT 
		m.ENVIO_MENSAJERIA_PROVINCIA
		FROM gd_esquema.Maestra m
		WHERE m.ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL
	UNION
	SELECT DISTINCT 
		m.LOCAL_PROVINCIA
		FROM gd_esquema.Maestra m
		WHERE m.LOCAL_PROVINCIA IS NOT NULL
END
GO



CREATE PROCEDURE DB_OWNERS.migrar_localidades AS
BEGIN
	INSERT INTO DB_OWNERS.LOCALIDAD(
		nombre, 
		id_provincia
	)
	SELECT DISTINCT
             M.LOCAL_LOCALIDAD,
             P.id_provincia
         FROM
             gd_esquema.Maestra M
			 JOIN DB_OWNERS.PROVINCIA P ON P.nombre = M.LOCAL_PROVINCIA
         WHERE
             M.LOCAL_LOCALIDAD IS NOT NULL
	UNION
	SELECT DISTINCT
			M.DIRECCION_USUARIO_LOCALIDAD,
			P.id_provincia
		FROM
			gd_esquema.Maestra M
			JOIN DB_OWNERS.PROVINCIA P ON P.nombre = M.DIRECCION_USUARIO_PROVINCIA
		WHERE
			M.DIRECCION_USUARIO_LOCALIDAD IS NOT NULL
	UNION
	SELECT DISTINCT
			M.ENVIO_MENSAJERIA_LOCALIDAD,
			P.id_provincia
		FROM
			gd_esquema.Maestra M
			JOIN DB_OWNERS.PROVINCIA P ON P.nombre = M.ENVIO_MENSAJERIA_PROVINCIA
		WHERE
			M.ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL
END
GO



IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_direcciones')
DROP PROCEDURE DB_OWNERS.migrar_direcciones
GO
CREATE PROCEDURE DB_OWNERS.migrar_direcciones AS
BEGIN
DELETE FROM DB_OWNERS.DIRECCION
	DBCC CHECKIDENT ('DB_OWNERS.DIRECCION', RESEED, 0)
INSERT INTO DB_OWNERS.DIRECCION(
	calle_numero,
	id_localidad
	)
	SELECT DISTINCT
		m.DIRECCION_USUARIO_DIRECCION,
		L.id_localidad
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.nombre = m.DIRECCION_USUARIO_LOCALIDAD
	where DIRECCION_USUARIO_DIRECCION is NOT NULL
	UNION
	SELECT DISTINCT
		m.LOCAL_DIRECCION,
		L.id_localidad
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.nombre = m.LOCAL_LOCALIDAD
	where LOCAL_DIRECCION is NOT NULL
	SELECT DISTINCT
		m.ENVIO_MENSAJERIA_DIR_DEST,
		L.id_localidad
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.nombre = m.ENVIO_MENSAJERIA_LOCALIDAD
	where ENVIO_MENSAJERIA_DIR_DEST is NOT NULL
	SELECT DISTINCT
		m.ENVIO_MENSAJERIA_DIR_ORIG,
		L.id_localidad
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.nombre = m.ENVIO_MENSAJERIA_LOCALIDAD
	where ENVIO_MENSAJERIA_DIR_ORIG is NOT NULL
	SELECT DISTINCT
		m.OPERADOR_RECLAMO_DIRECCION
	from gd_esquema.Maestra m
	where OPERADOR_RECLAMO_DIRECCION is NOT NULL 
	SELECT DISTINCT
		m.REPARTIDOR_DIRECION
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.nombre = m.LOCAL_LOCALIDAD
	where REPARTIDOR_DIRECION is NOT NULL

END
GO



IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_direcciones2')
DROP PROCEDURE DB_OWNERS.migrar_direcciones2
GO
CREATE PROCEDURE DB_OWNERS.migrar_direcciones2 AS
BEGIN
INSERT INTO DB_OWNERS.DIRECCION(
	calle_numero
	)
	SELECT DISTINCT
		m.OPERADOR_RECLAMO_DIRECCION
	from gd_esquema.Maestra m
	where OPERADOR_RECLAMO_DIRECCION is NOT NULL 
END
GO



	

BEGIN TRANSACTION 
--RECLAMOS
	--EXECUTE DB_OWNERS.migrar_estado_reclamo
	--EXECUTE DB_OWNERS.migrar_tipo_reclamo
	--EXECUTE DB_OWNERS.migrar_solucion_reclamo


--LUGARES
	--EXECUTE DB_OWNERS.migrar_provincias
	--EXECUTE DB_OWNERS.migrar_localidades
	--EXECUTE DB_OWNERS.migrar_direcciones
	--EXECUTE DB_OWNERS.migrar_direcciones2
	EXECUTE DB_OWNERS.migrar_operador
COMMIT TRANSACTION




select * from db_owners.operador

