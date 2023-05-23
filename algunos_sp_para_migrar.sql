--------------------------------------
------------ PROCEDURES --------------
--------------------------------------

CREATE PROCEDURE DB_OWNERS.migrar_usuarios AS
BEGIN
	INSERT INTO DB_OWNERS.USUARIO(
		nombre,
		apellido,
		dni,
		fecha_registro,
		telefono,
		mail,
		fecha_nacimiento
	)
	SELECT DISTINCT 
		m.USUARIO_NOMBRE,
		m.USUARIO_APELLIDO,
		m.USUARIO_DNI,
		m.USUARIO_FECHA_REGISTRO,
		m.USUARIO_TELEFONO,
		m.USUARIO_MAIL,
		m.USUARIO_FECHA_NAC
		FROM gd_esquema.Maestra m
		WHERE m.USUARIO_NOMBRE IS NOT NULL AND m.USUARIO_APELLIDO IS NOT NULL
END
GO

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
			 JOIN DB_OWNERS.PROVINCIA P ON P.id_provincia = M.LOCAL_PROVINCIA
         WHERE
             M.LOCAL_LOCALIDAD IS NOT NULL
	UNION
	SELECT DISTINCT
			M.DIRECCION_USUARIO_LOCALIDAD,
			P.id_provincia
		FROM
			gd_esquema.Maestra M
			JOIN DB_OWNERS.PROVINCIA P ON P.id_provincia = M.DIRECCION_USUARIO_PROVINCIA
		WHERE
			M.DIRECCION_USUARIO_LOCALIDAD IS NOT NULL
	UNION
	SELECT DISTINCT
			M.ENVIO_MENSAJERIA_LOCALIDAD,
			P.id_provincia
		FROM
			gd_esquema.Maestra M
			JOIN DB_OWNERS.PROVINCIA P ON P.id_provincia = M.ENVIO_MENSAJERIA_PROVINCIA
		WHERE
			M.ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL
END
GO

/*ESTE NO SE BIEN COMO HACERLO*/
INSERT INTO DB_OWNERS.DIRECCION(
	calle, 
	numero,
	id_localidad
	)
	SELECT DISTINCT
		m.DIRECCION_USUARIO_DIRECCION,-- Como separo la direccion en calle y numero, si son todas distintas?
		m.DIRECCION_USUARIO_DIRECCION, -- aca vendria el nro
		L.id_localidad
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.id_localidad = m.DIRECCION_USUARIO_LOCALIDAD
	where DIRECCION_USUARIO_DIRECCION is NOT NULL
	UNION
	SELECT DISTINCT
		m.LOCAL_DIRECCION,-- Como separo la direccion en calle y numero, si son todas distintas?
		m.LOCAL_DIRECCION, -- aca vendria el nro
		L.id_localidad
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.id_localidad = m.LOCAL_LOCALIDAD
	where LOCAL_DIRECCION is NOT NULL
	UNION
	--no hay direcciones en operador.. las paso igual?
	SELECT DISTINCT
		m.OPERADOR_RECLAMO_DIRECCION,-- Como separo la direccion en calle y numero, si son todas distintas?
		m.OPERADOR_RECLAMO_DIRECCION, -- aca vendria el nro
		L.id_localidad
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.id_localidad =  --no tiene localidad asociada a esa direccion tampoco, asi que esto nolo podria hacer
	where LOCAL_DIRECCION is NOT NULL
