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


DROP TABLE DB_OWNERS.BI_MEDIO_DE_PAGO
CREATE TABLE DB_OWNERS.BI_MEDIO_DE_PAGO
(	
	id_medio_pago INT IDENTITY (1,1) PRIMARY KEY,
	detalle nvarchar(20) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_MEDIO_DE_PAGO
SELECT DISTINCT medio FROM DB_OWNERS.MEDIO_DE_PAGO
SELECT * FROM DB_OWNERS.BI_MEDIO_DE_PAGO




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



/*
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
*/

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_bi_pedidos')
DROP PROCEDURE DB_OWNERS.migrar_bi_pedidos
GO
CREATE PROCEDURE DB_OWNERS.migrar_bi_pedidos AS
BEGIN
DELETE FROM DB_OWNERS.BI_PEDIDOS -- Usar para evitar duplicar entradas
	DBCC CHECKIDENT ('DB_OWNERS.BI_PEDIDOS', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.BI_PEDIDOS(
		id_tiempo,
		id_dia,
		id_rango_horario,
		id_localidad,
		id_rango_etario,
		id_medio_pago,
		id_local,
		id_categoria_local,
		id_tipo_movilidad, 
		cantidad_pedidos,
		pedidos_cancelados,
		promedio_envio,
		promedio_desvio,
		monto_total_cupones,
		promedio_calificacion,
		porcentaje_entregado
	)
	SELECT 
		*
		/*BT.id_tiempo,
		BD.id_dia,
		BRH.id_rango_horario,
		BLI.id_localidad,
		BRE.id_rango_etario*/
		FROM DB_OWNERS.PEDIDO P
		
		JOIN DB_OWNERS.ESTADO E ON E.id_estado = P.id_estado
		LEFT JOIN DB_OWNERS.CUPON_USADO CU ON CU.id_pedido = P.id_pedido
		LEFT JOIN DB_OWNERS.CUPON C ON C.id_nro_cupon = CU.id_cupon
		JOIN DB_OWNERS.LOCAL_ L ON L.id_local = P.id_local
		JOIN DB_OWNERS.DIRECCION D ON D.id_direccion = L.id_direccion
		JOIN DB_OWNERS.LOCALIDAD LI ON LI.id_localidad = D.id_localidad
		JOIN DB_OWNERS.PROVINCIA PR ON PR.id_provincia = LI.id_provincia
		JOIN DB_OWNERS.USUARIO U ON U.id_usuario = P.id_usuario
		JOIN DB_OWNERS.MEDIO_DE_PAGO MP ON MP.id_medio_de_pago = P.id_medio_de_pago
		JOIN DB_OWNERS.CATEGORIA_LOCAL CL ON CL.id_categoria_local = L.id_categoria_local
		JOIN DB_OWNERS.TIPO_LOCAL TL ON TL.id_tipo_local = CL.id_tipo_local
		JOIN DB_OWNERS.CATEGORIAS CA ON CA.id_categoria = CL.id_categoria
		JOIN DB_OWNERS.BI_TIEMPO BT ON año = YEAR(P.fecha) AND mes = MONTH(P.fecha)
		JOIN DB_OWNERS.BI_DIA BD ON FORMAT(P.fecha, 'dddd') = BD.nombre
		JOIN DB_OWNERS.BI_RANGO_HORARIO BRH ON DATEPART(HOUR, P.fecha) >= BRH.hora_desde AND DATEPART(HOUR, P.fecha) < BRH.hora_hasta
		JOIN DB_OWNERS.BI_LOCALIDAD BLI ON BLI.provicia = PR.nombre AND BLI.localidad = LI.nombre
		JOIN DB_OWNERS.BI_RANGO_ETARIO BRE ON DATEDIFF(year, U.fecha_nacimiento , GETDATE()) >= BRE.edad_desde AND DATEDIFF(year, U.fecha_nacimiento, GETDATE()) < BRE.edad_hasta
		JOIN DB_OWNERS.BI_MEDIO_DE_PAGO BMP ON BMP.detalle = MP.medio
		JOIN DB_OWNERS.BI_LOCAL BL ON BL.nombre = L.nombre
		JOIN DB_OWNERS.BI_CATEGORIA_LOCAL BCL ON BCL.tipo_local = TL.descripcion AND BCL.categoria = CA.descripcion
		JOIN DB_OWNERS.BI_TIPO_RECLAMO BTR ON BTR.id_tipo_reclamo = R.id_tipo_reclamo
		GROUP BY BT.id_tiempo, BD.id_dia,BRH.id_rango_horario,BLI.id_localidad, BRE.id_rango_etario, BTR.id_tipo_reclamo


		SELECT * FROM DB_OWNERS.PEDIDO
		SELECT * FROM DB_OWNERS.ENVIO_MENSAJERIA
		select * from DB_OWNERS.ENVIO

		GROUP BY BT.id_tiempo, BD.id_dia,BRH.id_rango_horario, BRE.id_rango_etario, BTR.id_tipo_reclamo
END
GO







