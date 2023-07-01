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

CREATE TABLE DB_OWNERS.BI_PEDIDOS 
(
	id_pedido INT IDENTITY (1,1) PRIMARY KEY,
	id_tiempo INT NOT NULL, --fk
	id_dia INT NOT NULL, --fk
	id_rango_horario INT NOT NULL, --fk
	id_localidad INT NOT NULL, --fk
	id_rango_etario INT NOT NULL, --fk
	id_medio_pago INT NOT NULL, --fk
	id_local INT NOT NULL, --fk
	id_categoria_local INT NOT NULL, --fk
	id_tipo_movilidad INT NOT NULL, --fk
	cantidad_pedidos DECIMAL(18,0) NOT NULL,
	pedidos_cancelados DECIMAL(18,0) NOT NULL,
	promedio_envio DECIMAL(18,2) NOT NULL,
	promedio_desvio DECIMAL(18,0) NOT NULL,
	monto_total_cupones DECIMAL(18,2) NOT NULL,
	promedio_calificacion DECIMAL(18,0) NOT NULL,
	porcentaje_entregado DECIMAL(18,0) NOT NULL,
)
GO
CREATE TABLE DB_OWNERS.BI_ENVIO_MENSAJERIA 
(
	id_envio_mensajeria INT IDENTITY (1,1) PRIMARY KEY,
	id_tiempo INT NOT NULL, --fk
	id_dia INT NOT NULL, --fk
	id_rango_horario INT NOT NULL, --fk
	id_localidad INT NOT NULL, --fk
	id_rango_etario INT NOT NULL, --fk
	id_medio_pago INT NOT NULL, --fk
	id_tipo_paquete INT NOT NULL, --fk
	id_estado_envio INT NOT NULL, --fk
	promedio_desvio DECIMAL(18,0) NOT NULL,
	porcentaje_entregado DECIMAL(18,0) NOT NULL,
	promedio_valor_asegurado DECIMAL(18,2) NOT NULL
)
GO
CREATE TABLE DB_OWNERS.BI_RECLAMOS 
(
	id_reclamo INT IDENTITY (1,1) PRIMARY KEY,
	id_tiempo INT NOT NULL, --fk
	id_dia INT NOT NULL, --fk
	id_rango_horario INT NOT NULL, --fk
	id_rango_etario INT NOT NULL, --fk
	id_tipo_reclamo INT NOT NULL, --fk
	cantidad_reclamos DECIMAL(18,0) NOT NULL,
	tiempo_resolucion DECIMAL(18,0) NOT NULL,
	monto_generado_cupones DECIMAL(18,2) NOT NULL
)
GO



DROP TABLE DB_OWNERS.BI_TIEMPO
CREATE TABLE DB_OWNERS.BI_TIEMPO
(
	id_tiempo INT IDENTITY (1,1) PRIMARY KEY,
	año DECIMAL(4,0) NOT NULL,
	mes DECIMAL(4,0) NOT NULL
)
GO

INSERT INTO DB_OWNERS.BI_TIEMPO (año, mes)
SELECT DISTINCT YEAR(fecha) AS año, MONTH(fecha) AS mes FROM DB_OWNERS.PEDIDO
UNION
SELECT DISTINCT YEAR(fecha_hora), MONTH(fecha_hora) FROM DB_OWNERS.ENVIO_MENSAJERIA
UNION
SELECT DISTINCT YEAR(fecha), MONTH(fecha) FROM DB_OWNERS.RECLAMO

SELECT * FROM DB_OWNERS.BI_TIEMPO


DROP TABLE DB_OWNERS.BI_DIA
CREATE TABLE DB_OWNERS.BI_DIA
(
	id_dia INT IDENTITY (1,1) PRIMARY KEY,
	nombre varchar(10)
)
GO
INSERT INTO DB_OWNERS.BI_DIA
VALUES('lunes'),('martes'),('miércoles'),('jueves'),('viernes'),('sábado'),('domingo')
SELECT * FROM DB_OWNERS.BI_DIA


DROP TABLE DB_OWNERS.BI_RANGO_HORARIO
CREATE TABLE DB_OWNERS.BI_RANGO_HORARIO
(
	id_rango_horario INT IDENTITY (1,1) PRIMARY KEY,
	hora_desde DECIMAL(2,0) NOT NULL,
	hora_hasta DECIMAL(2,0) NOT NULL
)
GO
INSERT INTO DB_OWNERS.BI_RANGO_HORARIO
VALUES('08','10'),('10','12'),('12','14'),('14','16'),('16','18'),('18','20'),('20','22'),('22','24')
SELECT * FROM DB_OWNERS.BI_RANGO_HORARIO

SELECT DATEPART(HOUR, fecha) FROM DB_OWNERS.PEDIDO


DROP TABLE DB_OWNERS.BI_LOCALIDAD
CREATE TABLE DB_OWNERS.BI_LOCALIDAD
(
	id_localidad INT IDENTITY (1,1) PRIMARY KEY,
	provicia nvarchar(255) NOT NULL,
	localidad nvarchar(255) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_LOCALIDAD
select P.nombre , L.nombre from DB_OWNERS.LOCALIDAD L
join DB_OWNERS.PROVINCIA P on p.id_provincia = l.id_provincia

SELECT * FROM DB_OWNERS.BI_LOCALIDAD


DROP TABLE DB_OWNERS.BI_RANGO_ETARIO
CREATE TABLE DB_OWNERS.BI_RANGO_ETARIO
(
	id_rango_etario INT IDENTITY (1,1) PRIMARY KEY,
	edad_desde DECIMAL(2,0) NOT NULL,
	edad_hasta DECIMAL(3,0) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_RANGO_ETARIO
VALUES('00','25'),('25','35'),('35','55'),('55','150')

SELECT * FROM DB_OWNERS.BI_RANGO_ETARIO

SELECT DATEDIFF(year, fecha_nacimiento, GETDATE()) FROM DB_OWNERS.USUARIO
order by DATEDIFF(year, fecha_nacimiento, GETDATE()) desc


DROP TABLE DB_OWNERS.BI_MEDIO_PAGO
CREATE TABLE DB_OWNERS.BI_MEDIO_PAGO
(	
	id_medio_pago INT IDENTITY (1,1) PRIMARY KEY,
	detalle nvarchar(20) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_MEDIO_PAGO
VALUES('efectivo'),('tarjeta credito'),('tarjeta debito')
SELECT * FROM DB_OWNERS.BI_MEDIO_PAGO




DROP TABLE DB_OWNERS.BI_LOCAL
CREATE TABLE DB_OWNERS.BI_LOCAL
(	
	id_local INT IDENTITY (1,1) PRIMARY KEY,
	nombre nvarchar(100) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_LOCAL
SELECT * FROM DB_OWNERS.BI_LOCAL


DROP TABLE DB_OWNERS.BI_CATEGORIA_LOCAL
CREATE TABLE DB_OWNERS.BI_CATEGORIA_LOCAL
(
	id_categoria_local INT IDENTITY (1,1) PRIMARY KEY,	
	tipo_local nvarchar(50) NOT NULL,
	categoria nvarchar(50) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_CATEGORIA_LOCAL
	SELECT TL.descripcion,
			C.descripcion
	FROM DB_OWNERS.CATEGORIA_LOCAL CL
	JOIN DB_OWNERS.TIPO_LOCAL TL ON TL.id_tipo_local = CL.id_tipo_local
	JOIN DB_OWNERS.CATEGORIAS C ON C.id_categoria = CL.id_categoria

SELECT * FROM DB_OWNERS.BI_CATEGORIA_LOCAL


DROP TABLE DB_OWNERS.BI_TIPO_MOVILIDAD
CREATE TABLE DB_OWNERS.BI_TIPO_MOVILIDAD
(
	id_tipo_movilidad INT IDENTITY (1,1) PRIMARY KEY,	
	descripcion nvarchar(50) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_TIPO_MOVILIDAD
	SELECT vehiculo
	FROM DB_OWNERS.MOVILIDAD 

SELECT * FROM DB_OWNERS.BI_TIPO_MOVILIDAD


DROP TABLE DB_OWNERS.BI_TIPO_PAQUETE
CREATE TABLE DB_OWNERS.BI_TIPO_PAQUETE
(
	id_tipo_paquete INT IDENTITY (1,1) PRIMARY KEY,	
	descripcion nvarchar(50) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_TIPO_PAQUETE
	SELECT descripcion
	FROM DB_OWNERS.TIPO_PAQUETE 

SELECT * FROM DB_OWNERS.BI_TIPO_PAQUETE


DROP TABLE DB_OWNERS.BI_ESTADO_ENVIO
CREATE TABLE DB_OWNERS.BI_ESTADO_ENVIO
(
	id_estado_envio INT IDENTITY (1,1) PRIMARY KEY,	
	descripcion nvarchar(50) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_ESTADO_ENVIO
	SELECT DISTINCT E.estado FROM DB_OWNERS.ENVIO_MENSAJERIA EM
	join DB_OWNERS.ESTADO E ON E.id_estado = EM.id_estado

SELECT * FROM DB_OWNERS.BI_ESTADO_ENVIO


DROP TABLE DB_OWNERS.BI_TIPO_RECLAMO
CREATE TABLE DB_OWNERS.BI_TIPO_RECLAMO
(
	id_tipo_reclamo INT IDENTITY (1,1) PRIMARY KEY,	
	descripcion nvarchar(50) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_TIPO_RECLAMO
	SELECT DISTINCT descripcion FROM DB_OWNERS.TIPO_RECLAMO 

SELECT * FROM DB_OWNERS.BI_TIPO_RECLAMO


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



/*
	id_reclamo INT IDENTITY (1,1) PRIMARY KEY,
	id_tiempo INT NOT NULL, --fk
	id_dia INT NOT NULL, --fk
	id_rango_horario INT NOT NULL, --fk
	id_rango_etario INT NOT NULL, --fk
	id_tipo_reclamo INT NOT NULL, --fk
	cantidad_reclamos DECIMAL(18,0) NOT NULL,
	tiempo_resolucion DECIMAL(18,0) NOT NULL,
	monto_generado_cupones DECIMAL(18,2) NOT NULL
*/

SELECT * FROM DB_OWNERS.RECLAMO R
JOIN DB_OWNERS.SOLUCION S ON S.id_solucion = R.id_solucion
LEFT JOIN DB_OWNERS.CUPON_RECLAMO CR ON CR.id_reclamo = R.id_reclamo
LEFT JOIN DB_OWNERS.CUPON C ON C.id_nro_cupon = CR.id_cupon_reclamo

select R.fecha, S.fecha_solucion, C.monto
from DB_OWNERS.RECLAMO R
JOIN DB_OWNERS.SOLUCION S ON S.id_solucion = R.id_solucion
LEFT JOIN DB_OWNERS.CUPON_RECLAMO CR ON CR.id_reclamo = R.id_reclamo
LEFT JOIN DB_OWNERS.CUPON C ON C.id_nro_cupon = CR.id_cupon_reclamo

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_bi_reclamos')
DROP PROCEDURE DB_OWNERS.migrar_bi_reclamos
GO
CREATE PROCEDURE DB_OWNERS.migrar_bi_reclamos AS
BEGIN
DELETE FROM DB_OWNERS.BI_RECLAMOS -- Usar para evitar duplicar entradas
	DBCC CHECKIDENT ('DB_OWNERS.BI_RECLAMOS', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.BI_RECLAMOS(
		id_tiempo,
		id_dia,
		id_rango_horario,
		id_rango_etario,
		id_tipo_reclamo, 
		cantidad_reclamos,
		tiempo_resolucion,
		monto_generado_cupones
	)
	SELECT 
		BT.id_tiempo,
		BD.id_dia,
		BRH.id_rango_horario,
		BRE.id_rango_etario,
		BTR.id_tipo_reclamo,
		COUNT(*) AS [Cantidad de reclamos],
		AVG(DATEDIFF(MINUTE, R.fecha, S.fecha_solucion)) AS [Tiempo de resolucion promedio],
		SUM(C.monto) AS [Monto generado por cupones]

		/*(SELECT BT.id_tiempo FROM DB_OWNERS.BI_TIEMPO BT WHERE año = YEAR(R.FECHA) AND mes = MONTH(R.FECHA)),
		(SELECT BD.id_dia FROM DB_OWNERS.BI_DIA BD WHERE FORMAT(R.FECHA, 'dddd') = BD.nombre),
		(SELECT BRH.id_rango_horario FROM DB_OWNERS.BI_RANGO_HORARIO BRH WHERE DATEPART(HOUR, R.FECHA) >= BRH.hora_desde AND DATEPART(HOUR, R.FECHA) < BRH.hora_hasta ),
		(SELECT BRE.id_rango_etario FROM DB_OWNERS.BI_RANGO_ETARIO BRE WHERE DATEDIFF(year, U.fecha_nacimiento , GETDATE()) >= BRE.edad_desde AND DATEDIFF(year, U.fecha_nacimiento, GETDATE()) < BRE.edad_hasta ),
		(SELECT BTR.id_tipo_reclamo FROM DB_OWNERS.BI_TIPO_RECLAMO BTR WHERE BTR.id_tipo_reclamo = TR.id_tipo_reclamo ),*/
		/*R.fecha ,S.fecha_solucion,C.monto*/
		
		FROM DB_OWNERS.RECLAMO R
		JOIN DB_OWNERS.SOLUCION S ON S.id_solucion = R.id_solucion
		JOIN DB_OWNERS.USUARIO U ON U.id_usuario = R.id_usuario
		LEFT JOIN DB_OWNERS.CUPON_RECLAMO CR ON CR.id_reclamo = R.id_reclamo
		LEFT JOIN DB_OWNERS.CUPON C ON C.id_nro_cupon = CR.id_cupon_reclamo
		JOIN DB_OWNERS.BI_TIEMPO BT ON año = YEAR(R.FECHA) AND mes = MONTH(R.FECHA)
		JOIN DB_OWNERS.BI_DIA BD ON FORMAT(R.FECHA, 'dddd') = BD.nombre
		JOIN DB_OWNERS.BI_RANGO_HORARIO BRH ON DATEPART(HOUR, R.FECHA) >= BRH.hora_desde AND DATEPART(HOUR, R.FECHA) < BRH.hora_hasta
		JOIN DB_OWNERS.BI_RANGO_ETARIO BRE ON DATEDIFF(year, U.fecha_nacimiento , GETDATE()) >= BRE.edad_desde AND DATEDIFF(year, U.fecha_nacimiento, GETDATE()) < BRE.edad_hasta
		JOIN DB_OWNERS.BI_TIPO_RECLAMO BTR ON BTR.id_tipo_reclamo = R.id_tipo_reclamo
		GROUP BY BT.id_tiempo, BD.id_dia,BRH.id_rango_horario, BRE.id_rango_etario, BTR.id_tipo_reclamo
END
GO

select * from DB_OWNERS.USUARIO





