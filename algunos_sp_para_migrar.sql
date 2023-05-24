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

/*ESTE NO SE BIEN COMO HACERLO, SINO DE ULTIMA DEJAR LA DIRECCION COMPLETA CON EL NRO Y CALLE EN UN SOLO CAMPO*/
CREATE PROCEDURE DB_OWNERS.migrar_direcciones AS
BEGIN
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
END
GO

/*ACA FALTA TAMBIEN MIGRAR TABLA DIRECCION_POR_USUARIO*/

CREATE PROCEDURE DB_OWNERS.migrar_datos_tarjetas AS
BEGIN
	INSERT INTO DB_OWNERS.DATOS_TARJETA(
		id_usuario,
		tipo,
		numero,
		marca
	)
	SELECT DISTINCT 
		U.id_usuario,
		m.MEDIO_PAGO_TIPO,
		m.MEDIO_PAGO_NRO_TARJETA,
		m.MARCA_TARJETA
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.USUARIO U ON 
		U.nombre = m.USUARIO_NOMBRE 
		AND U.apellido = m.USUARIO_APELLIDO 
		AND U.dni = m.USUARIO_DNI 
		AND U.fecha_registro = m.USUARIO_FECHA_REGISTRO
		AND U.telefono = m.USUARIO_TELEFONO
		AND U.mail = m.USUARIO_MAIL
		AND U.fecha_nac = m.USUARIO_FECHA_NAC
	WHERE m.MEDIO_PAGO_TIPO LIKE 'TARJETA%'
END
GO

--DE ESTA TENGO DUDAS POR LOS DATOS DE TARJETA NULLEABLES CUANDO ES EFECTIVO, SUPONGO QUE SE ARREGLA CON EL LEFT JOIN 
CREATE PROCEDURE DB_OWNERS.migrar_medios_de_pago AS
BEGIN
	INSERT INTO DB_OWNERS.MEDIO_DE_PAGO(
		medio,
		id_datos_tarjeta
	)
	SELECT DISTINCT 
		m.MEDIO_PAGO_TIPO,
		DT.id_datos_tarjeta
	FROM gd_esquema.Maestra m
	LEFT JOIN DB_OWNERS.DATOS_TARJETA DT ON 
		DT.tipo = m.MEDIO_PAGO_TIPO
		AND DT.numero = m.MEDIO_PAGO_NRO_TARJETA
		AND DT.marca = m.MARCA_TARJETA
	WHERE m.MEDIO_PAGO_TIPO IS NOT NULL
END
GO

--NO ENTIENDO MUY BIEN QUE CAMPOS DE LA TABLA MAESTRA TIENE PAGOS, creo que deberia tener una referencia al total por lo menos
CREATE PROCEDURE DB_OWNERS.migrar_pagos AS
BEGIN
	INSERT INTO DB_OWNERS.PAGO(
		id_medio_de_pago
	)
	SELECT DISTINCT 
	FROM gd_esquema.Maestra m
END
GO

CREATE PROCEDURE DB_OWNERS.migrar_tipos_local AS
BEGIN
	INSERT INTO DB_OWNERS.TIPO_LOCAL(
		descripcion
	)
	SELECT DISTINCT 
		m.LOCAL_TIPO
	FROM gd_esquema.Maestra m 
	WHERE m.LOCAL_TIPO IS NOT NULL
END
GO

--QUE MIGRO ACA SI NO HAYYYY CATEGORIAS :'c, por ahora uso la descripcion como categoria
CREATE PROCEDURE DB_OWNERS.migrar_categorias AS
BEGIN
	INSERT INTO DB_OWNERS.CATEGORIA(
		descripcion
	)
	SELECT DISTINCT 
		m.LOCAL_DESCRIPCION --reemplazar por campo categoria cuando lo suban
	FROM gd_esquema.Maestra m
END
GO


CREATE PROCEDURE DB_OWNERS.migrar_categoria_local AS
BEGIN
	INSERT INTO DB_OWNERS.CATEGORIA_LOCAL(
		id_tipo_local,
		id_categoria
	)
	SELECT DISTINCT 
	FROM gd_esquema.Maestra m JOIN DB_OWNERS.TIPO_LOCAL TL ON TL.id_tipo_local = m.LOCAL_TIPO
	JOIN DB_OWNERS.CATEGORIA C ON C.id_categoria = m.LOCAL_DESCRIPCION --reemplazar por campo categoria cuando lo suban
END
GO

CREATE PROCEDURE DB_OWNERS.migrar_locales AS
BEGIN
	INSERT INTO DB_OWNERS.LOCAL_(
		nombre,
		descripcion,
		id_direccion,
		id_categoria_local
	)
	SELECT DISTINCT 
		m.LOCAL_NOMBRE,
		m.LOCAL_DESCRIPCION,
		m.LOCAL_DIRECCION,
		D.id_direccion,
		C.id_categoria_local
	FROM gd_esquema.Maestra m JOIN DB_OWNERS.DIRECCION D ON D.calle = m.LOCAL_DIRECCION 
	AND D.id_localidad = m.LOCAL_LOCALIDAD
	JOIN DB_OWNERS.CATEGORIA_LOCAL CL ON CL.id_tipo_local = m.LOCAL_TIPO
	AND CL.id_categoria = m.LOCAL_DESCRIPCION --reemplazar por campo categoria cuando lo suban
	WHERE m.LOCAL_NOMBRE IS NOT NULL AND m.LOCAL_DESCRIPCION IS NOT NULL
END
GO

CREATE PROCEDURE DB_OWNERS.migrar_dias_semana AS
BEGIN
	INSERT INTO DB_OWNERS.DIA_SEMANA(
		nombre_dia
	)
	SELECT DISTINCT 
		m.HORARIO_LOCAL_DIA
	FROM gd_esquema.Maestra m
	WHERE m.HORARIO_LOCAL_DIA IS NOT NULL
END
GO

CREATE PROCEDURE DB_OWNERS.migrar_horarios_atencion AS
BEGIN
	INSERT INTO DB_OWNERS.HORARIO_ATENCION(
		hora_apertura,
		hora_cierre,
		id_dia_semana,
		id_local
	)
	SELECT DISTINCT 
		m.HORARIO_LOCAL_HORA_APERTURA,
		m.HORARIO_LOCAL_HORA_CIERRE,
		DS.id_dia_semana,
		L.id_local
	FROM gd_esquema.Maestra m JOIN DB_OWNERS.DIA_SEMANA DS ON DS.nombre_dia = m.HORARIO_LOCAL_DIA
	JOIN DB_OWNERS.LOCAL_ L ON L.nombre = m.LOCAL_NOMBRE AND L.descripcion = m.LOCAL_DESCRIPCION
	WHERE m.HORARIO_LOCAL_HORA_APERTURA IS NOT NULL AND m.HORARIO_LOCAL_HORA_CIERRE IS NOT NULL
END
GO

