--------------------------------------
---------------- INIT ----------------
--------------------------------------



USE GD1C2023
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'DB_OWNERS')
BEGIN 
	EXEC ('CREATE SCHEMA DB_OWNERS')
END
GO



--------------------------------------
--------------- TABLES ---------------
--------------------------------------

CREATE TABLE DB_OWNERS.USUARIO 
(
	id_usuario INT IDENTITY (1,1) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL,
	apellido NVARCHAR(255) NOT NULL,
	dni DECIMAL(18, 0) NOT NULL,
	fecha_registro DATETIME2(3) NOT NULL,
	telefono DECIMAL(18,0) NOT NULL,
	mail NVARCHAR(255) NOT NULL,
	fecha_nacimiento DATE
)
GO

CREATE TABLE DB_OWNERS.DATOS_TARJETA
(
	id_datos_tarjeta INT IDENTITY (1,1) PRIMARY KEY,
	id_usuario INT NOT NULL,     --FK
	marca NVARCHAR(100) NOT NULL,
	numero NVARCHAR(50) NOT NULL,
	tipo NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.DIRECCION
(
	id_direccion INT IDENTITY (1,1) PRIMARY KEY,
	calle_numero NVARCHAR(255) NOT NULL, 
	id_localidad INT --FK
)
GO

CREATE TABLE DB_OWNERS.LOCALIDAD
(

	id_localidad INT IDENTITY (1,1) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL, 
	id_provincia INT NOT NULL --FK
)
GO

CREATE TABLE DB_OWNERS.PROVINCIA
(

	id_provincia INT IDENTITY (1,1) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL
)

GO

CREATE TABLE DB_OWNERS.DIRECCION_POR_USUARIO
(
	id_usuario INT,  ---FK
	id_direccion INT,  ---FK
	PRIMARY KEY(id_usuario, id_direccion),
	nombre NVARCHAR(50) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.TIPO_CUPON
(
	id_tipo_cupon INT IDENTITY(1,1) PRIMARY KEY,
	descripcion NVARCHAR(255) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.CUPON
(
	id_nro_cupon INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL, ---FK
	nro_cupon INT NOT NULL,
	monto DECIMAL(18,2) NOT NULL,
	fecha_alta DATETIME2(3) NOT NULL,
	fecha_vencimiento DATETIME2(3) NOT NULL,
	id_tipo_cupon INT NOT NULL--FK
)
GO

CREATE TABLE DB_OWNERS.MEDIO_DE_PAGO
(
	id_medio_de_pago INT IDENTITY(1,1) PRIMARY KEY,
	id_datos_tarjeta INT, --FK
	medio NVARCHAR(50) NOT NULL
)
GO


CREATE TABLE DB_OWNERS.LOCAL_
(
	id_local INT IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL,
	descripcion NVARCHAR(255) NOT NULL,
	id_direccion INT NOT NULL, --FK
	id_tipo_local INT NOT NULL --FK
)
GO


CREATE TABLE DB_OWNERS.TIPO_LOCAL
(
	id_tipo_local INT IDENTITY(1,1) PRIMARY KEY,
	descripcion NVARCHAR(50) NOT NULL
)
GO


CREATE TABLE DB_OWNERS.REPARTIDOR(
	id_repartidor INT IDENTITY(1,1) PRIMARY KEY,
	--id_localidad int, --fk
	id_movilidad int NOT NULL, --fk
	nombre nvarchar(255) NOT NULL,
	apellido nvarchar(255) NOT NULL,
	direccion nvarchar(255) NOT NULL,
	dni decimal(18,0) NOT NULL,
	telefono decimal(18,0) NOT NULL,
	mail nvarchar(255) NOT NULL,
	fecha_nacimiento date NOT NULL	
)
GO

CREATE TABLE DB_OWNERS.TRAYECTO(
	id_trayecto INT IDENTITY(1,1) PRIMARY KEY,
	id_direccion_origen int NOT NULL, --fk
	id_direccion_destino int NOT NULL, --fk
	distancia decimal(18,2) NOT NULL
)
GO


IF OBJECT_ID (N'DB_OWNERS.PRODUCTO', N'U') IS NULL
CREATE TABLE DB_OWNERS.PRODUCTO(
	cod_producto nvarchar(50) PRIMARY KEY,
	nombre nvarchar(50) NOT NULL,
	descripcion nvarchar(255) NOT NULL,

)
GO


CREATE TABLE DB_OWNERS.PRODUCTO_POR_LOCAL(
	cod_producto nvarchar(50) NOT NULL,---FK,
	id_local int NOT NULL,---FK
	precio_unitario decimal(18,2) NOT NULL,
	PRIMARY KEY(cod_producto, id_local)
)
GO

CREATE TABLE DB_OWNERS.ITEM(
	id_item INT IDENTITY(1,1) PRIMARY KEY,
	cod_producto nvarchar(50) NOT NULL, --fk
	id_pedido int NOT NULL, --fk
	cantidad int NOT NULL,
	precio_total decimal(18,2) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.ENVIO(
	id_envio INT IDENTITY(1,1) PRIMARY KEY,
	id_repartidor int NOT NULL, --fk
	tiempo_est_entrega decimal(18,2) NOT NULL,
	propina decimal(18,2) NOT NULL,
	precio_envio decimal(18,2) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.MOVILIDAD(
	id_movilidad INT IDENTITY(1,1) PRIMARY KEY,
	vehiculo nvarchar(50) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.HORARIO_ATENCION(
	id_horario_atencion INT IDENTITY(1,1) PRIMARY KEY,
	hora_apertura decimal(18,0) NOT NULL,
	hora_cierre decimal(18,0) NOT NULL,
	id_dia_semana int NOT NULL, --fk
	id_local int NOT NULL --fk
)
GO

CREATE TABLE DB_OWNERS.DIA_SEMANA(
	id_dia_semana INT IDENTITY(1,1) PRIMARY KEY,
	nombre_dia nvarchar(15) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.RECLAMO
(
	nro_reclamo INT PRIMARY KEY,
	id_usuario INT NOT NULL, --FK
	id_pedido INT NOT NULL, --FK
	id_tipo_reclamo INT NOT NULL,  --FK
	id_estado INT NOT NULL,   ---FK
	id_operador INT NOT NULL,  --FK
	id_solucion INT NOT NULL,  --FK 
	fecha DATETIME2(3) NOT NULL,
	descripcion NVARCHAR(255) NOT NULL,
	calificacion DECIMAL(18,0),
	fecha_solucion DATETIME2(3)
)
GO

CREATE TABLE DB_OWNERS.TIPO_RECLAMO
(
	id_tipo_reclamo INT IDENTITY (1,1) PRIMARY KEY,
	descripcion NVARCHAR(50) NOT NULL,
)
GO

CREATE TABLE DB_OWNERS.ESTADO_RECLAMO
(
	id_estado_reclamo INT IDENTITY (1,1) PRIMARY KEY,
	descripcion NVARCHAR(50)
)
GO

CREATE TABLE DB_OWNERS.OPERADOR
(
	id_operador INT IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL,
	apellido VARCHAR(255) NOT NULL,
	dni DECIMAL(18,0) NOT NULL,
	telefono DECIMAL(18,0) NOT NULL,
	mail NVARCHAR(255) NOT NULL,
	fecha_nacimiento DATE NOT NULL,
	id_direccion INT NOT NULL --fk
)
GO

CREATE TABLE DB_OWNERS.SOLUCION
(
	id_solucion INT IDENTITY (1,1) PRIMARY KEY,
	descripcion NVARCHAR(255) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.CUPON_RECLAMO
(
	id_cupon_reclamo INT IDENTITY (1,1) PRIMARY KEY,
	id_reclamo INT NOT NULL, --FK
	id_nro_cupon INT NOT NULL --FK
)
GO

CREATE TABLE DB_OWNERS.TIPO_PAQUETE 
(
	id_tipo_paquete INT IDENTITY(1,1) PRIMARY KEY,
	descripcion NVARCHAR(50) NOT NULL,
	alto_max DECIMAL(18,2) NOT NULL,
	ancho_max DECIMAL(18,2) NOT NULL,
	largo_max DECIMAL(18,2) NOT NULL,
	peso_max DECIMAL(18,2) NOT NULL,
	precio DECIMAL(18,2) NOT NULL,
)
GO

CREATE TABLE DB_OWNERS.ENVIO_MENSAJERIA
(
	id_envio_mensajeria INT IDENTITY(1,1) PRIMARY KEY,
	nro_mensajeria DECIMAL(18,0) NOT NULL,
	id_usuario INT NOT NULL, --fk
	fecha_hora DATETIME2(3) NOT NULL,
	id_tipo_paquete INT NOT NULL, --fk
	precio_total DECIMAL(18,2) NOT NULL,
	observaciones NVARCHAR(255),
	id_envio INT NOT NULL, --fk
	calificacion DECIMAL(18,0),
	fecha_hora_entrega DATETIME2(3),
	id_estado INT NOT NULL, --fk
	valor_asegurado DECIMAL(18,2) NOT NULL,
	precio_seguro DECIMAL(18,2) NOT NULL,
	precio_envio_mensajeria DECIMAL(18,2) NOT NULL,
	id_medio_de_pago INT NOT NULL, --fk
	id_trayecto INT NOT NULL, --fk	
)
GO

CREATE TABLE DB_OWNERS.ESTADO
(
	id_estado INT IDENTITY(1,1) PRIMARY KEY,
	estado NVARCHAR (50) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.CUPON_USADO
(
	id_cupon_usado INT IDENTITY(1,1) PRIMARY KEY,
	id_cupon INT NOT NULL,-- (fk)
	nro_pedido INT NOT NULL-- (fk)
)
GO

CREATE TABLE DB_OWNERS.PEDIDO 
(
	id_pedido INT IDENTITY (1,1) PRIMARY KEY,
	nro_pedido DECIMAL(18, 0) NOT NULL,
	id_usuario INT NOT NULL, -- (fk)
	id_local INT NOT NULL, -- (fk)
	fecha DATETIME2(3) NOT NULL,
	id_envio INT NOT NULL, -- (fk)
	observaciones NVARCHAR(255),
	id_estado INT NOT NULL, -- (fk)
	calificacion DECIMAL(18,0),
	fecha_hora_entrega DATETIME2(3),
	tarifa_servicio DECIMAL(18, 2) NOT NULL,
	id_medio_de_pago INT NOT NULL, --fk
	precio_total_servicio DECIMAL(18, 2) NOT NULL,
	total_cupones DECIMAL(18, 2)
)
GO


--------------------------------------
------------ PROCEDURES --------------
--------------------------------------

--USUARIO
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_usuario')
DROP PROCEDURE DB_OWNERS.migrar_usuario
GO
CREATE PROCEDURE DB_OWNERS.migrar_usuario AS
BEGIN
	DELETE FROM DB_OWNERS.USUARIO -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.USUARIO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.USUARIO
	SELECT DISTINCT 
		m.USUARIO_NOMBRE,
		m.USUARIO_APELLIDO, 
		m.USUARIO_DNI, 
		m.USUARIO_FECHA_REGISTRO, 
		m.USUARIO_TELEFONO, 
		m.USUARIO_MAIL,
		m.USUARIO_FECHA_NAC
	FROM gd_esquema.Maestra m
	WHERE m.USUARIO_DNI is not null
END
GO
/*
select count(*) from db_owners.usuario 
select count(*) from gd_esquema.Maestra 
*/
--CUPONES
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_tipo_cupon')
DROP PROCEDURE DB_OWNERS.migrar_tipo_cupon
GO
CREATE PROCEDURE DB_OWNERS.migrar_tipo_cupon AS
BEGIN
	DELETE FROM DB_OWNERS.TIPO_CUPON -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.TIPO_CUPON', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.TIPO_CUPON(
		descripcion
	)
	SELECT DISTINCT 
		m.CUPON_TIPO
	FROM gd_esquema.Maestra m 
	WHERE m.CUPON_TIPO IS NOT NULL
	UNION
	SELECT DISTINCT 
		m.CUPON_RECLAMO_TIPO
	FROM gd_esquema.Maestra m 
	WHERE m.CUPON_RECLAMO_TIPO IS NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_cupon')
DROP PROCEDURE DB_OWNERS.migrar_cupon
GO
CREATE PROCEDURE DB_OWNERS.migrar_cupon AS
BEGIN
	DELETE FROM DB_OWNERS.CUPON
	DBCC CHECKIDENT ('DB_OWNERS.CUPON', RESEED, 0)
	INSERT INTO DB_OWNERS.CUPON(
		nro_cupon,
		id_usuario,
		monto,
		fecha_alta,
		fecha_vencimiento,
		id_tipo_cupon
	)
	SELECT 
		m.CUPON_NRO,
		u.id_usuario,
		m.CUPON_MONTO,
		m.CUPON_FECHA_ALTA,
		m.CUPON_FECHA_VENCIMIENTO,
		T.id_tipo_cupon
	FROM (
		SELECT DISTINCT m.CUPON_NRO, m.CUPON_MONTO, m.CUPON_FECHA_ALTA, m.CUPON_FECHA_VENCIMIENTO,m.CUPON_TIPO,m.USUARIO_DNI
		FROM gd_esquema.Maestra m
	) m
	JOIN DB_OWNERS.TIPO_CUPON T ON T.descripcion = m.CUPON_TIPO
	JOIN DB_OWNERS.USUARIO U ON u.dni = m.USUARIO_DNI
	WHERE m.CUPON_NRO IS NOT NULL
	UNION
	SELECT 
		m.CUPON_RECLAMO_NRO,
		u.id_usuario,
		m.CUPON_RECLAMO_MONTO,
		m.CUPON_RECLAMO_FECHA_ALTA,
		m.CUPON_RECLAMO_FECHA_VENCIMIENTO,
		T.id_tipo_cupon
	FROM (
		SELECT DISTINCT m.CUPON_RECLAMO_NRO, m.CUPON_RECLAMO_MONTO, m.CUPON_RECLAMO_FECHA_ALTA, m.CUPON_RECLAMO_FECHA_VENCIMIENTO,m.CUPON_RECLAMO_TIPO,m.USUARIO_DNI
		FROM [GD1C2023].[gd_esquema].[Maestra] m
	) m
	JOIN DB_OWNERS.TIPO_CUPON T ON T.descripcion = m.CUPON_RECLAMO_TIPO
	JOIN DB_OWNERS.USUARIO U ON u.dni = m.USUARIO_DNI
	WHERE m.CUPON_RECLAMO_NRO IS NOT NULL
END
GO
/*
SELECT RECLAMO_NRO FROM gd_esquema.Maestra WHERE RECLAMO_NRO IS NOT NULL ORDER BY RECLAMO_NRO ASC

SELECT * FROM db_owners.cupon order by nro_cupon*/

--LOCALES
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_tipos_local')
DROP PROCEDURE DB_OWNERS.migrar_tipos_local
GO
CREATE PROCEDURE DB_OWNERS.migrar_tipos_local AS
BEGIN
	DELETE FROM DB_OWNERS.TIPO_LOCAL -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.TIPO_LOCAL', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.TIPO_LOCAL(
		descripcion
	)
	SELECT DISTINCT 
		m.LOCAL_TIPO
	FROM gd_esquema.Maestra m 
	WHERE m.LOCAL_TIPO IS NOT NULL
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_locales')
DROP PROCEDURE DB_OWNERS.migrar_locales
GO
CREATE PROCEDURE DB_OWNERS.migrar_locales AS
BEGIN
	DELETE FROM DB_OWNERS.LOCAL_ -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.LOCAL_', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.LOCAL_(
		nombre,
		descripcion,
		id_direccion,
		id_tipo_local
	)
	SELECT DISTINCT 
		m.LOCAL_NOMBRE,
		m.LOCAL_DESCRIPCION,
		D.id_direccion,
		CL.id_tipo_local
	FROM gd_esquema.Maestra m 
	JOIN DB_OWNERS.DIRECCION D ON D.calle_numero = m.LOCAL_DIRECCION 
	JOIN DB_OWNERS.LOCALIDAD L ON L.id_localidad = D.id_localidad and L.nombre = m.LOCAL_LOCALIDAD
	JOIN DB_OWNERS.PROVINCIA P ON P.id_provincia = L.id_provincia and P.nombre = m.LOCAL_PROVINCIA
	JOIN DB_OWNERS.TIPO_LOCAL CL ON CL.descripcion = m.LOCAL_TIPO
	WHERE m.LOCAL_NOMBRE IS NOT NULL 
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_dias_semana')
DROP PROCEDURE DB_OWNERS.migrar_dias_semana
GO
CREATE PROCEDURE DB_OWNERS.migrar_dias_semana AS
BEGIN
	DELETE FROM DB_OWNERS.DIA_SEMANA -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.DIA_SEMANA', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.DIA_SEMANA(
		nombre_dia
	)
	SELECT DISTINCT 
		m.HORARIO_LOCAL_DIA
	FROM gd_esquema.Maestra m
	WHERE m.HORARIO_LOCAL_DIA IS NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_horarios_atencion')
DROP PROCEDURE DB_OWNERS.migrar_horarios_atencion
GO
CREATE PROCEDURE DB_OWNERS.migrar_horarios_atencion AS
BEGIN
	DELETE FROM DB_OWNERS.HORARIO_ATENCION -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.HORARIO_ATENCION', RESEED, 0) -- Usar para evitar duplicar entradas
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


--RECLAMOS
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_estado_reclamo')
DROP PROCEDURE DB_OWNERS.migrar_estado_reclamo
GO
CREATE PROCEDURE DB_OWNERS.migrar_estado_reclamo AS
BEGIN
	DELETE FROM DB_OWNERS.ESTADO_RECLAMO -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.ESTADO_RECLAMO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.ESTADO_RECLAMO
	SELECT DISTINCT 
		RECLAMO_ESTADO
	FROM gd_esquema.Maestra
	WHERE RECLAMO_ESTADO IS NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_tipo_reclamo')
DROP PROCEDURE DB_OWNERS.migrar_tipo_reclamo
GO
CREATE PROCEDURE DB_OWNERS.migrar_tipo_reclamo AS
BEGIN
	DELETE FROM DB_OWNERS.TIPO_RECLAMO -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.TIPO_RECLAMO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.TIPO_RECLAMO
	SELECT DISTINCT 
		RECLAMO_TIPO
	FROM gd_esquema.Maestra
	WHERE RECLAMO_TIPO IS NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_solucion_reclamo')
DROP PROCEDURE DB_OWNERS.migrar_solucion_reclamo
GO
CREATE PROCEDURE DB_OWNERS.migrar_solucion_reclamo AS
BEGIN
	DELETE FROM DB_OWNERS.SOLUCION -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.SOLUCION', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.SOLUCION
	SELECT DISTINCT 
		RECLAMO_SOLUCION
	FROM gd_esquema.Maestra
	WHERE RECLAMO_SOLUCION IS NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_operador')
DROP PROCEDURE DB_OWNERS.migrar_operador
GO
CREATE PROCEDURE DB_OWNERS.migrar_operador AS
BEGIN
	DELETE FROM DB_OWNERS.OPERADOR -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.OPERADOR', RESEED, 0) -- Usar para evitar duplicar entradas
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



IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_reclamos')
DROP PROCEDURE DB_OWNERS.migrar_reclamos
GO
CREATE PROCEDURE DB_OWNERS.migrar_reclamos AS
BEGIN
	DELETE FROM DB_OWNERS.RECLAMO -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.RECLAMO
	SELECT DISTINCT 
		m.RECLAMO_NRO,
		U.id_usuario,
		P.id_pedido,
		TR.id_tipo_reclamo,
		E.id_estado,
		O.id_operador,
		S.id_solucion,
		m.RECLAMO_FECHA,
		m.RECLAMO_DESCRIPCION,
		m.RECLAMO_CALIFICACION,
		m.RECLAMO_FECHA_SOLUCION
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.USUARIO U ON U.dni = m.USUARIO_DNI
	JOIN DB_OWNERS.PEDIDO P ON p.nro_pedido = m.PEDIDO_NRO AND P.id_usuario = U.id_usuario
	JOIN DB_OWNERS.TIPO_RECLAMO TR ON TR.descripcion = m.RECLAMO_TIPO
	JOIN DB_OWNERS.ESTADO E ON E.estado = m.RECLAMO_ESTADO
	JOIN DB_OWNERS.OPERADOR O ON O.dni = m.OPERADOR_RECLAMO_DNI
	JOIN DB_OWNERS.SOLUCION S ON S.descripcion = m.RECLAMO_SOLUCION
	WHERE m.RECLAMO_NRO IS NOT NULL 
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_cupones_reclamo')
DROP PROCEDURE DB_OWNERS.migrar_cupones_reclamo
GO
CREATE PROCEDURE DB_OWNERS.migrar_cupones_reclamo AS
BEGIN
	DELETE FROM DB_OWNERS.CUPON_RECLAMO -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.CUPON_RECLAMO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.CUPON_RECLAMO
	SELECT DISTINCT 
		R.nro_reclamo,
		C.id_nro_cupon
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.RECLAMO R ON R.nro_reclamo = m.RECLAMO_NRO
	JOIN DB_OWNERS.USUARIO U ON U.dni = M.USUARIO_DNI
	JOIN DB_OWNERS.CUPON C ON C.nro_cupon = m.CUPON_RECLAMO_NRO AND C.id_usuario = U.id_usuario
	WHERE m.CUPON_RECLAMO_NRO IS NOT NULL AND CUPON_NRO IS NULL
END
GO

--ENVIO PAQUETES
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_tipo_paquete')
DROP PROCEDURE DB_OWNERS.migrar_tipo_paquete
GO
CREATE PROCEDURE DB_OWNERS.migrar_tipo_paquete AS
BEGIN
	DELETE FROM DB_OWNERS.TIPO_PAQUETE -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.TIPO_PAQUETE', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.TIPO_PAQUETE
	SELECT DISTINCT 
		m.PAQUETE_TIPO,
		m.PAQUETE_ALTO_MAX,
		m.PAQUETE_ANCHO_MAX,
		m.PAQUETE_LARGO_MAX,
		m.PAQUETE_PESO_MAX,
		m.PAQUETE_TIPO_PRECIO
	FROM gd_esquema.Maestra m
	WHERE 
		m.PAQUETE_TIPO IS NOT NULL and
		m.PAQUETE_ALTO_MAX IS NOT NULL and
		m.PAQUETE_ANCHO_MAX IS NOT NULL and
		m.PAQUETE_LARGO_MAX IS NOT NULL and
		m.PAQUETE_PESO_MAX IS NOT NULL and
		m.PAQUETE_TIPO_PRECIO IS NOT NULL
END
GO	

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_movilidad')
DROP PROCEDURE DB_OWNERS.migrar_movilidad
GO
CREATE PROCEDURE DB_OWNERS.migrar_movilidad
AS BEGIN
	DELETE FROM DB_OWNERS.MOVILIDAD -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.MOVILIDAD', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.MOVILIDAD
	SELECT DISTINCT 
		m.REPARTIDOR_TIPO_MOVILIDAD
	FROM gd_esquema.Maestra m 
	WHERE m.REPARTIDOR_TIPO_MOVILIDAD IS NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_repartidor')
DROP PROCEDURE DB_OWNERS.migrar_repartidor
GO
CREATE PROCEDURE DB_OWNERS.migrar_repartidor
AS BEGIN
	DELETE FROM DB_OWNERS.REPARTIDOR -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.REPARTIDOR', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.REPARTIDOR
	SELECT DISTINCT 
		mov.id_movilidad,
		m.REPARTIDOR_NOMBRE,
		m.REPARTIDOR_APELLIDO,
		m.REPARTIDOR_DIRECION,
		m.REPARTIDOR_DNI,
		m.REPARTIDOR_TELEFONO,
		m.REPARTIDOR_EMAIL,
		m.REPARTIDOR_FECHA_NAC
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.MOVILIDAD mov ON mov.vehiculo = m.REPARTIDOR_TIPO_MOVILIDAD
	WHERE 
		m.REPARTIDOR_NOMBRE IS NOT NULL and
		m.REPARTIDOR_APELLIDO IS NOT NULL and
		m.REPARTIDOR_DIRECION IS NOT NULL and
		m.REPARTIDOR_DNI IS NOT NULL and
		m.REPARTIDOR_TELEFONO IS NOT NULL and
		m.REPARTIDOR_EMAIL IS NOT NULL and
		m.REPARTIDOR_FECHA_NAC IS NOT NULL

END
GO	


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_trayecto')
DROP PROCEDURE DB_OWNERS.migrar_trayecto
GO
CREATE PROCEDURE DB_OWNERS.migrar_trayecto AS
BEGIN
	DELETE FROM DB_OWNERS.TRAYECTO -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.TRAYECTO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.TRAYECTO
	SELECT DISTINCT 
		d.id_direccion,
		d2.id_direccion,
		m.ENVIO_MENSAJERIA_KM
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.DIRECCION D ON D.calle_numero = m.ENVIO_MENSAJERIA_DIR_ORIG 
	JOIN DB_OWNERS.LOCALIDAD L ON L.id_localidad = D.id_localidad and L.nombre = m.ENVIO_MENSAJERIA_LOCALIDAD
	JOIN DB_OWNERS.PROVINCIA P ON P.id_provincia = L.id_provincia and P.nombre = m.ENVIO_MENSAJERIA_PROVINCIA
	JOIN DB_OWNERS.DIRECCION d2 ON d2.calle_numero = m.ENVIO_MENSAJERIA_DIR_DEST
	JOIN DB_OWNERS.LOCALIDAD L2 ON L2.id_localidad = d2.id_localidad and L2.nombre = m.ENVIO_MENSAJERIA_LOCALIDAD
	JOIN DB_OWNERS.PROVINCIA P2 ON P2.id_provincia = L2.id_provincia and P2.nombre = m.ENVIO_MENSAJERIA_PROVINCIA
	WHERE 
		m.ENVIO_MENSAJERIA_KM IS NOT NULL
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_estado')
DROP PROCEDURE DB_OWNERS.migrar_estado
GO
CREATE PROCEDURE DB_OWNERS.migrar_estado AS
BEGIN
	DELETE FROM DB_OWNERS.ESTADO -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.ESTADO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.ESTADO(
		estado
	)
	SELECT DISTINCT 
		m.ENVIO_MENSAJERIA_ESTADO
		FROM gd_esquema.Maestra m
		WHERE m.ENVIO_MENSAJERIA_ESTADO IS NOT NULL
	UNION
	SELECT DISTINCT 
		m.PEDIDO_ESTADO
		FROM gd_esquema.Maestra m
		WHERE m.PEDIDO_ESTADO IS NOT NULL
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_envio')
DROP PROCEDURE DB_OWNERS.migrar_envio
GO
CREATE PROCEDURE DB_OWNERS.migrar_envio
AS BEGIN
	DELETE FROM DB_OWNERS.ENVIO -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.ENVIO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.ENVIO
	/*55642 filas*/
	SELECT DISTINCT 
		r.id_repartidor,
		m.ENVIO_MENSAJERIA_TIEMPO_ESTIMADO,
		m.ENVIO_MENSAJERIA_PROPINA,
		m.ENVIO_MENSAJERIA_PRECIO_ENVIO
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.REPARTIDOR R ON R.nombre = m.REPARTIDOR_NOMBRE and R.apellido = m.REPARTIDOR_APELLIDO and R.dni = m.REPARTIDOR_DNI
	WHERE 
		m.PEDIDO_NRO IS NULL and
		m.ENVIO_MENSAJERIA_NRO IS NOT NULL and
		m.ENVIO_MENSAJERIA_TIEMPO_ESTIMADO IS NOT NULL and
		m.ENVIO_MENSAJERIA_PROPINA IS NOT NULL and
		m.ENVIO_MENSAJERIA_PRECIO_ENVIO IS NOT NULL
	INSERT INTO DB_OWNERS.ENVIO
	/*59447 pedidos correcto*/
	SELECT DISTINCT 
		r.id_repartidor,
		m.PEDIDO_TIEMPO_ESTIMADO_ENTREGA,
		m.PEDIDO_PROPINA,
		m.PEDIDO_PRECIO_ENVIO
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.REPARTIDOR R ON R.nombre = m.REPARTIDOR_NOMBRE and R.apellido = m.REPARTIDOR_APELLIDO and R.dni = m.REPARTIDOR_DNI
	WHERE 
		m.ENVIO_MENSAJERIA_NRO IS NULL and
		m.PEDIDO_NRO IS NOT NULL AND
		m.PEDIDO_TIEMPO_ESTIMADO_ENTREGA IS NOT NULL and
		m.PEDIDO_PROPINA IS NOT NULL and
		m.PEDIDO_PRECIO_ENVIO IS NOT NULL
END
GO	

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_envio_mensajeria')
DROP PROCEDURE DB_OWNERS.migrar_envio_mensajeria
GO
CREATE PROCEDURE DB_OWNERS.migrar_envio_mensajeria
AS BEGIN
	DELETE FROM DB_OWNERS.ENVIO_MENSAJERIA -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.ENVIO_MENSAJERIA', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.ENVIO_MENSAJERIA
	SELECT DISTINCT 
		m.ENVIO_MENSAJERIA_NRO,
		u.id_usuario,
		m.ENVIO_MENSAJERIA_FECHA,
		tp.id_tipo_paquete,
		m.ENVIO_MENSAJERIA_TOTAL,
		m.ENVIO_MENSAJERIA_OBSERV,
		e.id_envio,
		m.ENVIO_MENSAJERIA_CALIFICACION,
		m.ENVIO_MENSAJERIA_FECHA_ENTREGA,
		es.id_estado,
		m.ENVIO_MENSAJERIA_VALOR_ASEGURADO,
		m.ENVIO_MENSAJERIA_PRECIO_SEGURO,
		m.ENVIO_MENSAJERIA_PRECIO_ENVIO,
		mp.id_medio_de_pago,
		t.id_trayecto
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.USUARIO u ON u.dni = m.USUARIO_DNI AND u.fecha_nacimiento = m.USUARIO_FECHA_NAC
	JOIN DB_OWNERS.TIPO_PAQUETE tp ON tp.descripcion = m.PAQUETE_TIPO
	JOIN DB_OWNERS.ENVIO e ON e.precio_envio = m.ENVIO_MENSAJERIA_PRECIO_ENVIO AND e.propina = m.ENVIO_MENSAJERIA_PROPINA AND e.tiempo_est_entrega = m.ENVIO_MENSAJERIA_TIEMPO_ESTIMADO
	JOIN DB_OWNERS.ESTADO es ON es.estado = m.ENVIO_MENSAJERIA_ESTADO
	JOIN DB_OWNERS.DATOS_TARJETA dt ON dt.numero = m.MEDIO_PAGO_NRO_TARJETA AND dt.id_usuario = u.id_usuario
	JOIN DB_OWNERS.MEDIO_DE_PAGO mp ON mp.id_datos_tarjeta = dt.id_datos_tarjeta AND mp.medio = m.MEDIO_PAGO_TIPO
	JOIN DB_OWNERS.TRAYECTO t ON t.distancia = m.ENVIO_MENSAJERIA_KM
	JOIN DB_OWNERS.DIRECCION d ON d.calle_numero = m.ENVIO_MENSAJERIA_DIR_DEST AND t.id_direccion_destino = d.id_direccion
	JOIN DB_OWNERS.DIRECCION d2 ON d2.calle_numero = m.ENVIO_MENSAJERIA_DIR_ORIG AND t.id_direccion_origen = d2.id_direccion
	WHERE 
		m.ENVIO_MENSAJERIA_NRO IS NOT NULL and
		m.ENVIO_MENSAJERIA_FECHA IS NOT NULL and
		m.ENVIO_MENSAJERIA_TOTAL IS NOT NULL and
		m.ENVIO_MENSAJERIA_VALOR_ASEGURADO IS NOT NULL and
		m.ENVIO_MENSAJERIA_PRECIO_SEGURO IS NOT NULL and
		m.ENVIO_MENSAJERIA_PRECIO_ENVIO IS NOT NULL
END
GO


--LUGARES

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_provincias')
DROP PROCEDURE DB_OWNERS.migrar_provincias
GO
CREATE PROCEDURE DB_OWNERS.migrar_provincias AS
BEGIN
DELETE FROM DB_OWNERS.PROVINCIA -- Usar para evitar duplicar entradas
	DBCC CHECKIDENT ('DB_OWNERS.PROVINCIA', RESEED, 0) -- Usar para evitar duplicar entradas
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


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_localidades')
DROP PROCEDURE DB_OWNERS.migrar_localidades
GO
CREATE PROCEDURE DB_OWNERS.migrar_localidades AS
BEGIN
DELETE FROM DB_OWNERS.LOCALIDAD -- Usar para evitar duplicar entradas
	DBCC CHECKIDENT ('DB_OWNERS.LOCALIDAD', RESEED, 0) -- Usar para evitar duplicar entradas
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
DELETE FROM DB_OWNERS.DIRECCION -- Usar para evitar duplicar entradas
	DBCC CHECKIDENT ('DB_OWNERS.DIRECCION', RESEED, 0) -- Usar para evitar duplicar entradas
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
	UNION
	SELECT DISTINCT *
	FROM
	(
	SELECT DISTINCT
		m.ENVIO_MENSAJERIA_DIR_DEST,
		L.id_localidad
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.nombre = m.ENVIO_MENSAJERIA_LOCALIDAD
	where ENVIO_MENSAJERIA_DIR_DEST is NOT NULL
	UNION
	SELECT DISTINCT
		m.ENVIO_MENSAJERIA_DIR_ORIG,
		L.id_localidad
	from gd_esquema.Maestra m
	JOIN DB_OWNERS.LOCALIDAD L ON L.nombre = m.ENVIO_MENSAJERIA_LOCALIDAD
	where ENVIO_MENSAJERIA_DIR_ORIG is NOT NULL
	) as subquery
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
	UNION
	SELECT DISTINCT
		m.REPARTIDOR_DIRECION
	from gd_esquema.Maestra m
	where REPARTIDOR_DIRECION is NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_direcciones_por_usuario')
DROP PROCEDURE DB_OWNERS.migrar_direcciones_por_usuario
GO
CREATE PROCEDURE DB_OWNERS.migrar_direcciones_por_usuario AS
BEGIN
	DELETE FROM DB_OWNERS.DIRECCION_POR_USUARIO -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.DIRECCION_POR_USUARIO
	SELECT DISTINCT 
		U.id_usuario,
		D.id_direccion,
		m.DIRECCION_USUARIO_NOMBRE
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.USUARIO U ON U.dni = m.USUARIO_DNI
	JOIN DB_OWNERS.DIRECCION D ON D.calle_numero = m.DIRECCION_USUARIO_DIRECCION 
	JOIN DB_OWNERS.LOCALIDAD L ON L.id_localidad = D.id_localidad and L.nombre = m.DIRECCION_USUARIO_LOCALIDAD
	JOIN DB_OWNERS.PROVINCIA P ON P.id_provincia = L.id_provincia and P.nombre = m.DIRECCION_USUARIO_PROVINCIA
	WHERE m.DIRECCION_USUARIO_NOMBRE IS NOT NULL
END
GO

--TARJETAS
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_datos_tarjeta')
DROP PROCEDURE DB_OWNERS.migrar_datos_tarjeta
GO
CREATE PROCEDURE DB_OWNERS.migrar_datos_tarjeta
AS BEGIN
	DELETE FROM DB_OWNERS.DATOS_TARJETA -- Usar para evitar duplicar entradas
	DBCC CHECKIDENT ('DB_OWNERS.DATOS_TARJETA', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.DATOS_TARJETA(id_usuario, marca, numero, tipo)
	SELECT DISTINCT 
		u.id_usuario,
		m.MARCA_TARJETA,
		m.MEDIO_PAGO_NRO_TARJETA,
		m.MEDIO_PAGO_TIPO
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.USUARIO u
	ON u.dni = m.USUARIO_DNI AND u.fecha_nacimiento = m.USUARIO_FECHA_NAC
	WHERE m.MEDIO_PAGO_TIPO != 'Efectivo'
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_medio_de_pago')
DROP PROCEDURE DB_OWNERS.migrar_medio_de_pago
GO
CREATE PROCEDURE DB_OWNERS.migrar_medio_de_pago
AS BEGIN
	DELETE FROM DB_OWNERS.MEDIO_DE_PAGO -- Usar para evitar duplicar entradas
	DBCC CHECKIDENT ('DB_OWNERS.MEDIO_DE_PAGO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.MEDIO_DE_PAGO(medio)
	VALUES ('Efectivo')
	INSERT INTO DB_OWNERS.MEDIO_DE_PAGO(id_datos_tarjeta, medio)
	SELECT DISTINCT 
		dt.id_datos_tarjeta,
		dt.tipo
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.DATOS_TARJETA dt 
	ON dt.numero = m.MEDIO_PAGO_NRO_TARJETA AND dt.tipo = m.MEDIO_PAGO_TIPO AND dt.marca = m.MARCA_TARJETA
	WHERE m.MEDIO_PAGO_TIPO != 'Efectivo'
END
GO

--PEDIDOS

/*funciona, tarda bastante....*/
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_pedidos')
DROP PROCEDURE DB_OWNERS.migrar_pedidos
GO
CREATE PROCEDURE DB_OWNERS.migrar_pedidos
AS BEGIN
	DELETE FROM DB_OWNERS.PEDIDO -- Usar para evitar duplicar entradas
	DBCC CHECKIDENT ('DB_OWNERS.PEDIDO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.PEDIDO
	SELECT DISTINCT 
		m.PEDIDO_NRO,
		U.id_usuario,
		LA.id_local,
		m.PEDIDO_FECHA,
		id_envio,
		m.PEDIDO_OBSERV,
		ES.id_estado,
		m.PEDIDO_CALIFICACION,
		m.PEDIDO_FECHA_ENTREGA,
		m.PEDIDO_TARIFA_SERVICIO,
		COALESCE(MP.id_medio_de_pago,'1') AS id_medio_pago,
		m.PEDIDO_TOTAL_SERVICIO,
		m.PEDIDO_TOTAL_CUPONES
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.USUARIO U ON U.dni = m.USUARIO_DNI
	JOIN DB_OWNERS.DIRECCION D ON D.calle_numero = m.LOCAL_DIRECCION 
	JOIN DB_OWNERS.LOCALIDAD L ON L.id_localidad = D.id_localidad and L.nombre = m.LOCAL_LOCALIDAD
	JOIN DB_OWNERS.PROVINCIA P ON P.id_provincia = L.id_provincia and P.nombre = m.LOCAL_PROVINCIA
	JOIN DB_OWNERS.LOCAL_ LA ON LA.nombre = m.LOCAL_NOMBRE and LA.id_direccion = D.id_direccion
	JOIN DB_OWNERS.REPARTIDOR R ON R.dni = m.REPARTIDOR_DNI
	JOIN DB_OWNERS.ENVIO E ON E.precio_envio = m.PEDIDO_PRECIO_ENVIO and E.tiempo_est_entrega = m.PEDIDO_TIEMPO_ESTIMADO_ENTREGA and E.propina = m.PEDIDO_PROPINA and E.id_repartidor = R.id_repartidor
	JOIN DB_OWNERS.ESTADO ES ON ES.estado = m.PEDIDO_ESTADO
	left JOIN DB_OWNERS.DATOS_TARJETA DT ON DT.tipo = m.MEDIO_PAGO_TIPO and DT.numero = m.MEDIO_PAGO_NRO_TARJETA
	left JOIN DB_OWNERS.MEDIO_DE_PAGO MP ON MP.id_datos_tarjeta = DT.id_datos_tarjeta
	WHERE m.PEDIDO_NRO IS NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_cupones_usados')
DROP PROCEDURE DB_OWNERS.migrar_cupones_usados
GO
CREATE PROCEDURE DB_OWNERS.migrar_cupones_usados AS
BEGIN
	DELETE FROM DB_OWNERS.CUPON_USADO -- Usar para evitar duplicar entradas
		DBCC CHECKIDENT ('DB_OWNERS.CUPON_USADO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.CUPON_USADO
	SELECT DISTINCT 
		C.id_nro_cupon,
		P.id_pedido
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.PEDIDO P on p.nro_pedido = m.PEDIDO_NRO
	JOIN DB_OWNERS.USUARIO U ON U.dni = M.USUARIO_DNI
	JOIN DB_OWNERS.CUPON C ON C.nro_cupon = m.CUPON_NRO AND C.id_usuario = U.id_usuario
	WHERE m.CUPON_NRO IS NOT NULL
END
GO

--PRODUCTOS

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_productos')
DROP PROCEDURE DB_OWNERS.migrar_productos
GO
CREATE PROCEDURE DB_OWNERS.migrar_productos
AS BEGIN
	--DELETE FROM DB_OWNERS.PRODUCTO -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.PRODUCTO(cod_producto, nombre, descripcion)
	SELECT DISTINCT 
		m.PRODUCTO_LOCAL_CODIGO,
		m.PRODUCTO_LOCAL_NOMBRE,
		m.PRODUCTO_LOCAL_DESCRIPCION
	FROM gd_esquema.Maestra m
	WHERE m.PRODUCTO_LOCAL_CODIGO IS NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_productos_por_local')
DROP PROCEDURE DB_OWNERS.migrar_productos_por_local
GO
CREATE PROCEDURE DB_OWNERS.migrar_productos_por_local
AS BEGIN
	DELETE FROM DB_OWNERS.PRODUCTO_POR_LOCAL -- Usar para evitar duplicar entradas
		--DBCC CHECKIDENT ('DB_OWNERS.PRODUCTO', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.PRODUCTO_POR_LOCAL
	SELECT DISTINCT 
		PR.cod_producto,
		LO.id_local,
		M.PRODUCTO_LOCAL_PRECIO
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.PRODUCTO PR ON PR.cod_producto = M.PRODUCTO_LOCAL_CODIGO
	JOIN DB_OWNERS.DIRECCION D ON D.calle_numero = m.LOCAL_DIRECCION 
	JOIN DB_OWNERS.LOCALIDAD L ON L.id_localidad = D.id_localidad and L.nombre = m.LOCAL_LOCALIDAD
	JOIN DB_OWNERS.PROVINCIA P ON P.id_provincia = L.id_provincia and P.nombre = m.LOCAL_PROVINCIA
	JOIN DB_OWNERS.LOCAL_ LO ON LO.nombre = M.LOCAL_NOMBRE
	WHERE m.PRODUCTO_LOCAL_CODIGO IS NOT NULL
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_items')
DROP PROCEDURE DB_OWNERS.migrar_items
GO
CREATE PROCEDURE DB_OWNERS.migrar_items
AS BEGIN
	DELETE FROM DB_OWNERS.ITEM -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.ITEM(cod_producto, id_pedido, cantidad, precio_total)
	SELECT DISTINCT 
		m.PRODUCTO_LOCAL_CODIGO,
		p.id_pedido,
		m.PRODUCTO_CANTIDAD,
		m.PEDIDO_TOTAL_PRODUCTOS
	FROM gd_esquema.Maestra m
	JOIN DB_OWNERS.PEDIDO p ON p.nro_pedido = m.PEDIDO_NRO
	WHERE m.PRODUCTO_LOCAL_CODIGO IS NOT NULL
END
GO



--------------------------------------
---------- DATA MIGRATION ------------
--------------------------------------

BEGIN TRANSACTION 
--USUARIO
	EXECUTE DB_OWNERS.migrar_usuario
	EXECUTE DB_OWNERS.migrar_tipo_cupon
	EXECUTE DB_OWNERS.migrar_cupon
	/*select * FROM DB_OWNERS.TIPO_CUPON
	select * FROM DB_OWNERS.USUARIO order by DNI asc
	select * FROM DB_OWNERS.CUPON order by nro_cupon asc
	select * from gd_esquema.Maestra WHERE CUPON_NRO = '11119211' or  CUPON_RECLAMO_NRO = '11119211'
	select * from gd_esquema.Maestra WHERE CUPON_RECLAMO_NRO = '11119211'*/
--TARJETAS
	EXECUTE DB_OWNERS.migrar_datos_tarjeta
	EXECUTE DB_OWNERS.migrar_medio_de_pago

--LUGARES
	EXECUTE DB_OWNERS.migrar_provincias
	EXECUTE DB_OWNERS.migrar_localidades
	EXECUTE DB_OWNERS.migrar_direcciones
	EXECUTE DB_OWNERS.migrar_direcciones2

--LOCALES
	EXECUTE DB_OWNERS.migrar_tipos_local
	EXECUTE DB_OWNERS.migrar_locales
	EXECUTE DB_OWNERS.migrar_repartidor
	EXECUTE DB_OWNERS.migrar_dias_semana
	EXECUTE DB_OWNERS.migrar_horarios_atencion 

--ENVIO PAQUETES
	EXECUTE DB_OWNERS.migrar_tipo_paquete
	EXECUTE DB_OWNERS.migrar_movilidad
	EXECUTE DB_OWNERS.migrar_repartidor
	EXECUTE DB_OWNERS.migrar_trayecto
	EXECUTE DB_OWNERS.migrar_estado
	EXECUTE DB_OWNERS.migrar_envio
	EXECUTE DB_OWNERS.migrar_envio_mensajeria

--PEDIDOS
	EXECUTE DB_OWNERS.migrar_productos
	EXECUTE DB_OWNERS.migrar_pedidos
	EXECUTE DB_OWNERS.migrar_items
	EXECUTE DB_OWNERS.migrar_productos_por_local

--RECLAMOS
	EXECUTE DB_OWNERS.migrar_estado_reclamo
	EXECUTE DB_OWNERS.migrar_tipo_reclamo
	EXECUTE DB_OWNERS.migrar_solucion_reclamo
	EXECUTE DB_OWNERS.migrar_operador
	EXECUTE DB_OWNERS.migrar_reclamos
	EXECUTE DB_OWNERS.migrar_cupones_reclamo
	EXECUTE DB_OWNERS.migrar_cupones_usados
	EXECUTE DB_OWNERS.migrar_direcciones_por_usuario

COMMIT TRANSACTION



--------------------------------------
------------ FOREING KEYS ------------
--------------------------------------

ALTER TABLE DB_OWNERS.DATOS_TARJETA
ADD FOREIGN KEY (id_usuario) REFERENCES DB_OWNERS.USUARIO(id_usuario);

ALTER TABLE DB_OWNERS.DIRECCION
ADD FOREIGN KEY (id_localidad) REFERENCES DB_OWNERS.LOCALIDAD(id_localidad);

ALTER TABLE DB_OWNERS.LOCALIDAD
ADD FOREIGN KEY (id_provincia) REFERENCES DB_OWNERS.PROVINCIA(id_provincia);

ALTER TABLE DB_OWNERS.DIRECCION_POR_USUARIO
ADD FOREIGN KEY (id_usuario) REFERENCES DB_OWNERS.USUARIO(id_usuario),
	FOREIGN KEY (id_direccion) REFERENCES DB_OWNERS.DIRECCION(id_direccion);

ALTER TABLE DB_OWNERS.CUPON
ADD FOREIGN KEY (id_usuario) REFERENCES DB_OWNERS.USUARIO(id_usuario),
	FOREIGN KEY (id_tipo_cupon) REFERENCES DB_OWNERS.TIPO_CUPON(id_tipo_cupon);

ALTER TABLE DB_OWNERS.MEDIO_DE_PAGO
ADD FOREIGN KEY (id_datos_tarjeta) REFERENCES DB_OWNERS.DATOS_TARJETA(id_datos_tarjeta);

ALTER TABLE DB_OWNERS.PAGO
ADD FOREIGN KEY (id_medio_de_pago) REFERENCES DB_OWNERS.MEDIO_DE_PAGO(id_medio_de_pago);

ALTER TABLE DB_OWNERS.LOCAL_
ADD FOREIGN KEY (id_direccion) REFERENCES DB_OWNERS.DIRECCION(id_direccion),
	FOREIGN KEY (id_categoria_local) REFERENCES DB_OWNERS.CATEGORIA_LOCAL(id_categoria_local);

ALTER TABLE DB_OWNERS.CATEGORIA_LOCAL
ADD FOREIGN KEY (id_tipo_local) REFERENCES DB_OWNERS.TIPO_LOCAL(id_tipo_local),
	FOREIGN KEY (id_categoria) REFERENCES DB_OWNERS.CATEGORIA(id_categoria);

ALTER TABLE DB_OWNERS.RECLAMO
ADD FOREIGN KEY (id_usuario) REFERENCES DB_OWNERS.USUARIO(id_usuario),
	FOREIGN KEY (id_pedido) REFERENCES DB_OWNERS.PEDIDO(nro_pedido),
	FOREIGN KEY (id_tipo_reclamo) REFERENCES DB_OWNERS.TIPO_RECLAMO(id_tipo_reclamo),
	FOREIGN KEY (id_estado) REFERENCES DB_OWNERS.ESTADO_RECLAMO(id_estado_reclamo),
	FOREIGN KEY (id_operador) REFERENCES DB_OWNERS.OPERADOR(id_operador),
	FOREIGN KEY (id_solucion) REFERENCES DB_OWNERS.SOLUCION(id_solucion);

ALTER TABLE DB_OWNERS.OPERADOR
	ADD FOREIGN KEY (id_direccion) REFERENCES DB_OWNERS.DIRECCION(id_direccion);

ALTER TABLE DB_OWNERS.CUPON_RECLAMO
ADD FOREIGN KEY (id_reclamo) REFERENCES DB_OWNERS.RECLAMO(nro_reclamo),
	FOREIGN KEY (id_nro_cupon) REFERENCES DB_OWNERS.CUPON(id_nro_cupon);	

ALTER TABLE DB_OWNERS.ENVIO_MENSAJERIA
ADD FOREIGN KEY (id_usuario) REFERENCES DB_OWNERS.USUARIO(id_usuario),
	FOREIGN KEY (id_tipo_paquete) REFERENCES DB_OWNERS.TIPO_PAQUETE(id_tipo_paquete),
	FOREIGN KEY (id_envio) REFERENCES DB_OWNERS.ENVIO(id_envio),
	FOREIGN KEY (id_estado) REFERENCES DB_OWNERS.ESTADO(id_estado),
	FOREIGN KEY (id_pago) REFERENCES DB_OWNERS.PAGO(id_pago);

ALTER TABLE DB_OWNERS.CUPON_USADO
ADD FOREIGN KEY (id_cupon) REFERENCES DB_OWNERS.CUPON(id_cupon),
	FOREIGN KEY (nro_pedido) REFERENCES DB_OWNERS.PEDIDO(nro_pedido);

ALTER TABLE DB_OWNERS.PEDIDO
ADD FOREIGN KEY (id_usuario) REFERENCES DB_OWNERS.USUARIO(id_usuario),
	FOREIGN KEY (id_local) REFERENCES DB_OWNERS.LOCAL_(id_local),
	FOREIGN KEY (id_estado) REFERENCES DB_OWNERS.ESTADO(id_estado),
	FOREIGN KEY (id_envio) REFERENCES DB_OWNERS.ENVIO(id_envio),
	FOREIGN KEY (id_pago) REFERENCES DB_OWNERS.PAGO(id_pago);
