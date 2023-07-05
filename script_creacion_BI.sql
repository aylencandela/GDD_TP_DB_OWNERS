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

--drop table DB_OWNERS.BI_PEDIDOS 
CREATE TABLE DB_OWNERS.BI_PEDIDOS 
(
	id_pedido INT IDENTITY (1,1) PRIMARY KEY,
	id_tiempo INT NOT NULL, --fk
	id_dia INT NOT NULL, --fk
	id_rango_horario INT NOT NULL, --fk
	id_localidad INT NOT NULL, --fk
	id_rango_etario_usuario INT NOT NULL, --fk
	id_rango_etario_repartidor INT NOT NULL, --fk
	id_medio_pago INT NOT NULL, --fk
	id_local INT NOT NULL, --fk
	id_categoria_local INT NOT NULL, --fk
	id_tipo_movilidad INT NOT NULL, --fk
	cantidad_pedidos DECIMAL(18,0) NOT NULL,
	monto_cancelado DECIMAL(18,0) NOT NULL,
	promedio_envio DECIMAL(18,2) NOT NULL,
	promedio_desvio DECIMAL(18,0) NOT NULL,
	monto_total_cupones DECIMAL(18,2) NOT NULL,
	promedio_calificacion DECIMAL(18,0) NOT NULL,
	porcentaje_entregado DECIMAL(18,0) NOT NULL,
)
GO

--drop table DB_OWNERS.BI_ENVIOS_MENSAJERIA 
CREATE TABLE DB_OWNERS.BI_ENVIOS_MENSAJERIA 
(
	id_envio_mensajeria INT IDENTITY (1,1) PRIMARY KEY,
	id_tiempo INT NOT NULL, --fk
	id_dia INT NOT NULL, --fk
	id_rango_horario INT NOT NULL, --fk
	id_localidad INT NOT NULL, --fk
	id_rango_etario_usuario INT NOT NULL, --fk
	id_rango_etario_repartidor INT NOT NULL, --fk
	id_medio_pago INT NOT NULL, --fk
	id_tipo_paquete INT NOT NULL, --fk
	id_estado_envio INT NOT NULL, --fk
	id_tipo_movilidad INT NOT NULL, --fk
	promedio_desvio DECIMAL(18,0) NOT NULL,
	porcentaje_entregado DECIMAL(18,0) NOT NULL,
	promedio_valor_asegurado DECIMAL(18,2) NOT NULL
)
GO

--drop table DB_OWNERS.BI_RECLAMOS 
CREATE TABLE DB_OWNERS.BI_RECLAMOS 
(
	id_reclamo INT IDENTITY (1,1) PRIMARY KEY,
	id_tiempo INT NOT NULL, --fk
	id_dia INT NOT NULL, --fk
	id_rango_horario INT NOT NULL, --fk
	id_rango_etario_usuario INT NOT NULL, --fk
	id_rango_etario_operador INT NOT NULL, --fk
	id_tipo_reclamo INT NOT NULL, --fk
	id_local INT NOT NULL, --fk
	cantidad_reclamos DECIMAL(18,0) NOT NULL,
	tiempo_resolucion DECIMAL(18,0) NOT NULL,
	monto_generado_cupones DECIMAL(18,2) NOT NULL
)
GO



--DROP TABLE DB_OWNERS.BI_TIEMPO
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

--SELECT * FROM DB_OWNERS.BI_TIEMPO


--DROP TABLE DB_OWNERS.BI_DIA
CREATE TABLE DB_OWNERS.BI_DIA
(
	id_dia INT IDENTITY (1,1) PRIMARY KEY,
	nombre varchar(10)
)
GO
INSERT INTO DB_OWNERS.BI_DIA
VALUES('lunes'),('martes'),('miércoles'),('jueves'),('viernes'),('sábado'),('domingo')
--SELECT * FROM DB_OWNERS.BI_DIA


--DROP TABLE DB_OWNERS.BI_RANGO_HORARIO
CREATE TABLE DB_OWNERS.BI_RANGO_HORARIO
(
	id_rango_horario INT IDENTITY (1,1) PRIMARY KEY,
	hora_desde DECIMAL(2,0) NOT NULL,
	hora_hasta DECIMAL(2,0) NOT NULL
)
GO
INSERT INTO DB_OWNERS.BI_RANGO_HORARIO
VALUES('08','10'),('10','12'),('12','14'),('14','16'),('16','18'),('18','20'),('20','22'),('22','24')
--SELECT * FROM DB_OWNERS.BI_RANGO_HORARIO

--SELECT DATEPART(HOUR, fecha) FROM DB_OWNERS.PEDIDO


--DROP TABLE DB_OWNERS.BI_LOCALIDAD
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

--SELECT * FROM DB_OWNERS.BI_LOCALIDAD


--DROP TABLE DB_OWNERS.BI_RANGO_ETARIO
CREATE TABLE DB_OWNERS.BI_RANGO_ETARIO
(
	id_rango_etario INT IDENTITY (1,1) PRIMARY KEY,
	edad_desde DECIMAL(2,0) NOT NULL,
	edad_hasta DECIMAL(3,0) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_RANGO_ETARIO
VALUES('00','25'),('25','35'),('35','55'),('55','150')

--SELECT * FROM DB_OWNERS.BI_RANGO_ETARIO

--SELECT DATEDIFF(year, fecha_nacimiento, GETDATE()) FROM DB_OWNERS.USUARIO order by DATEDIFF(year, fecha_nacimiento, GETDATE()) desc


--DROP TABLE DB_OWNERS.BI_MEDIO_DE_PAGO
CREATE TABLE DB_OWNERS.BI_MEDIO_DE_PAGO
(	
	id_medio_pago INT IDENTITY (1,1) PRIMARY KEY,
	detalle nvarchar(20) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_MEDIO_DE_PAGO
SELECT DISTINCT medio FROM DB_OWNERS.MEDIO_DE_PAGO
--SELECT * FROM DB_OWNERS.BI_MEDIO_DE_PAGO




--DROP TABLE DB_OWNERS.BI_LOCAL
CREATE TABLE DB_OWNERS.BI_LOCAL
(	
	id_local INT IDENTITY (1,1) PRIMARY KEY,
	nombre nvarchar(100) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_LOCAL
SELECT nombre FROM DB_OWNERS.LOCAL_


--DROP TABLE DB_OWNERS.BI_CATEGORIA_LOCAL
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

--SELECT * FROM DB_OWNERS.BI_CATEGORIA_LOCAL


--DROP TABLE DB_OWNERS.BI_TIPO_MOVILIDAD
CREATE TABLE DB_OWNERS.BI_TIPO_MOVILIDAD
(
	id_tipo_movilidad INT IDENTITY (1,1) PRIMARY KEY,	
	descripcion nvarchar(50) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_TIPO_MOVILIDAD
	SELECT vehiculo
	FROM DB_OWNERS.MOVILIDAD 

--SELECT * FROM DB_OWNERS.BI_TIPO_MOVILIDAD


--DROP TABLE DB_OWNERS.BI_TIPO_PAQUETE
CREATE TABLE DB_OWNERS.BI_TIPO_PAQUETE
(
	id_tipo_paquete INT IDENTITY (1,1) PRIMARY KEY,	
	descripcion nvarchar(50) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_TIPO_PAQUETE
	SELECT descripcion
	FROM DB_OWNERS.TIPO_PAQUETE 

--SELECT * FROM DB_OWNERS.BI_TIPO_PAQUETE


--DROP TABLE DB_OWNERS.BI_ESTADO_ENVIO
CREATE TABLE DB_OWNERS.BI_ESTADO_ENVIO
(
	id_estado_envio INT IDENTITY (1,1) PRIMARY KEY,	
	descripcion nvarchar(50) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_ESTADO_ENVIO
	SELECT DISTINCT E.estado FROM DB_OWNERS.ENVIO_MENSAJERIA EM
	join DB_OWNERS.ESTADO E ON E.id_estado = EM.id_estado

--SELECT * FROM DB_OWNERS.BI_ESTADO_ENVIO


--DROP TABLE DB_OWNERS.BI_TIPO_RECLAMO
CREATE TABLE DB_OWNERS.BI_TIPO_RECLAMO
(
	id_tipo_reclamo INT IDENTITY (1,1) PRIMARY KEY,	
	descripcion nvarchar(50) NOT NULL,
)
GO
INSERT INTO DB_OWNERS.BI_TIPO_RECLAMO
	SELECT DISTINCT descripcion FROM DB_OWNERS.TIPO_RECLAMO 

--SELECT * FROM DB_OWNERS.BI_TIPO_RECLAMO


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

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
		id_rango_etario_usuario,
		id_rango_etario_operador,
		id_tipo_reclamo, 
		id_local,
		cantidad_reclamos,
		tiempo_resolucion,
		monto_generado_cupones
	)
	SELECT 
		BT.id_tiempo,
		BD.id_dia,
		BRH.id_rango_horario,
		BRE.id_rango_etario,
		BRE2.id_rango_etario,
		BTR.id_tipo_reclamo,
		BL.id_local,
		COUNT(*) AS [Cantidad de reclamos],
		AVG(DATEDIFF(MINUTE, R.fecha, R.fecha_solucion)) AS [Tiempo de resolucion promedio],
		ISNULL(SUM(C.monto),0) AS [Monto generado por cupones]
		FROM DB_OWNERS.RECLAMO R
		JOIN DB_OWNERS.USUARIO U ON U.id_usuario = R.id_usuario
		JOIN DB_OWNERS.OPERADOR O ON O.id_operador = R.id_operador
		JOIN DB_OWNERS.PEDIDO P ON P.id_pedido = R.id_pedido
		JOIN DB_OWNERS.LOCAL_ L ON L.id_local = P.id_local
		LEFT JOIN DB_OWNERS.CUPON_RECLAMO CR ON CR.id_reclamo = R.id_reclamo
		LEFT JOIN DB_OWNERS.CUPON C ON C.id_nro_cupon = CR.id_cupon_reclamo
		JOIN DB_OWNERS.BI_TIEMPO BT ON año = YEAR(R.FECHA) AND mes = MONTH(R.FECHA)
		JOIN DB_OWNERS.BI_DIA BD ON FORMAT(R.FECHA, 'dddd') = BD.nombre
		JOIN DB_OWNERS.BI_RANGO_HORARIO BRH ON DATEPART(HOUR, R.FECHA) >= BRH.hora_desde AND DATEPART(HOUR, R.FECHA) < BRH.hora_hasta
		JOIN DB_OWNERS.BI_RANGO_ETARIO BRE ON DATEDIFF(year, U.fecha_nacimiento , GETDATE()) >= BRE.edad_desde AND DATEDIFF(year, U.fecha_nacimiento, GETDATE()) < BRE.edad_hasta
		JOIN DB_OWNERS.BI_RANGO_ETARIO BRE2 ON DATEDIFF(year, O.fecha_nacimiento , GETDATE()) >= BRE2.edad_desde AND DATEDIFF(year, O.fecha_nacimiento, GETDATE()) < BRE2.edad_hasta
		JOIN DB_OWNERS.BI_TIPO_RECLAMO BTR ON BTR.id_tipo_reclamo = R.id_tipo_reclamo
		JOIN DB_OWNERS.BI_LOCAL BL ON BL.id_local = L.id_local
		GROUP BY BT.id_tiempo, BD.id_dia,BRH.id_rango_horario, BRE.id_rango_etario,BRE2.id_rango_etario, BTR.id_tipo_reclamo, BL.id_local
END
GO


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
		id_rango_etario_usuario,
		id_rango_etario_repartidor,
		id_medio_pago,
		id_local,
		id_categoria_local,
		id_tipo_movilidad, 
		cantidad_pedidos,
		monto_cancelado,
		promedio_envio,
		promedio_desvio,
		monto_total_cupones,
		promedio_calificacion,
		porcentaje_entregado
	)
	SELECT 
		BT.id_tiempo,
		BD.id_dia,
		BRH.id_rango_horario,
		BLI.id_localidad,
		BREU.id_rango_etario,
		BRER.id_rango_etario,
		BMP.id_medio_pago,
		BL.id_local,
		BCL.id_categoria_local,
		BTM.id_tipo_movilidad,
		COUNT(*) AS [Pedidos],
		SUM(CASE WHEN e.id_estado = '0' THEN p.precio_total_servicio ELSE 0 END) AS [Monto Cancelado],
		AVG(P.precio_envio) AS [Valor promedio del envio],
		AVG( ABS( p.tiempo_est_entrega - DATEDIFF(MINUTE, P.fecha, P.fecha_hora_entrega) ) ) AS [Desvio promedio en tiempo de entrega],
		ISNULL(SUM(c.monto),0) AS [Monto Cupones],
		AVG(p.calificacion) AS [Promedio Calificaciones],
		(SUM(CASE WHEN e.id_estado = '1' THEN 1 ELSE 0 END) *100) / COUNT(*) AS [Porcentaje entregado]
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
		JOIN DB_OWNERS.REPARTIDOR R ON R.id_repartidor = P.id_repartidor
		JOIN DB_OWNERS.MOVILIDAD M ON M.id_movilidad = R.id_movilidad
		JOIN DB_OWNERS.BI_TIEMPO BT ON año = YEAR(P.fecha) AND mes = MONTH(P.fecha)
		JOIN DB_OWNERS.BI_DIA BD ON FORMAT(P.fecha, 'dddd') = BD.nombre
		JOIN DB_OWNERS.BI_RANGO_HORARIO BRH ON DATEPART(HOUR, P.fecha) >= BRH.hora_desde AND DATEPART(HOUR, P.fecha) < BRH.hora_hasta
		JOIN DB_OWNERS.BI_LOCALIDAD BLI ON BLI.provicia = PR.nombre AND BLI.localidad = LI.nombre
		JOIN DB_OWNERS.BI_RANGO_ETARIO BREU ON DATEDIFF(year, U.fecha_nacimiento , GETDATE()) >= BREU.edad_desde AND DATEDIFF(year, U.fecha_nacimiento, GETDATE()) < BREU.edad_hasta
		JOIN DB_OWNERS.BI_RANGO_ETARIO BRER ON DATEDIFF(year, R.fecha_nacimiento , GETDATE()) >= BRER.edad_desde AND DATEDIFF(year, R.fecha_nacimiento, GETDATE()) < BRER.edad_hasta
		JOIN DB_OWNERS.BI_MEDIO_DE_PAGO BMP ON BMP.detalle = MP.medio
		JOIN DB_OWNERS.BI_LOCAL BL ON BL.nombre = L.nombre
		JOIN DB_OWNERS.BI_CATEGORIA_LOCAL BCL ON BCL.tipo_local = TL.descripcion AND BCL.categoria = CA.descripcion
		JOIN DB_OWNERS.BI_TIPO_MOVILIDAD BTM ON BTM.descripcion = M.vehiculo
		GROUP BY BT.id_tiempo, BD.id_dia,BRH.id_rango_horario,BLI.id_localidad, BREU.id_rango_etario,BRER.id_rango_etario, BMP.id_medio_pago, BL.id_local, BCL.id_categoria_local, BTM.id_tipo_movilidad
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'migrar_bi_envios_mensajeria')
DROP PROCEDURE DB_OWNERS.migrar_bi_envios_mensajeria
GO
CREATE PROCEDURE DB_OWNERS.migrar_bi_envios_mensajeria AS
BEGIN
DELETE FROM DB_OWNERS.BI_ENVIOS_MENSAJERIA -- Usar para evitar duplicar entradas
	DBCC CHECKIDENT ('DB_OWNERS.BI_ENVIOS_MENSAJERIA', RESEED, 0) -- Usar para evitar duplicar entradas
	INSERT INTO DB_OWNERS.BI_ENVIOS_MENSAJERIA(
		id_tiempo,
		id_dia,
		id_rango_horario,
		id_localidad,
		id_rango_etario_usuario,
		id_rango_etario_repartidor,
		id_medio_pago,
		id_tipo_paquete,
		id_estado_envio,
		id_tipo_movilidad,
		promedio_desvio,
		porcentaje_entregado,
		promedio_valor_asegurado
	)
	SELECT 
		BT.id_tiempo,
		BD.id_dia,
		BRH.id_rango_horario,
		BLI.id_localidad,
		BREU.id_rango_etario,
		BRER.id_rango_etario,
		BMP.id_medio_pago,
		BTP.id_tipo_paquete,
		BEE.id_estado_envio,
		BTM.id_tipo_movilidad,
		AVG( ABS( EM.tiempo_est_entrega - DATEDIFF(MINUTE, EM.fecha_hora, EM.fecha_hora_entrega) ) ) AS [Desvio promedio en tiempo de entrega],
		(SUM(CASE WHEN e.id_estado = '1' THEN 1 ELSE 0 END) *100) / COUNT(*) AS [Porcentaje entregado],
		AVG(EM.valor_asegurado)
		FROM DB_OWNERS.ENVIO_MENSAJERIA EM
		JOIN DB_OWNERS.ESTADO E ON E.id_estado = EM.id_estado
		JOIN DB_OWNERS.REPARTIDOR R ON R.id_repartidor = EM.id_repartidor
		JOIN DB_OWNERS.LOCALIDAD LI ON LI.id_localidad = R.id_localidad
		JOIN DB_OWNERS.PROVINCIA PR ON PR.id_provincia = LI.id_provincia
		JOIN DB_OWNERS.USUARIO U ON U.id_usuario = EM.id_usuario
		JOIN DB_OWNERS.MEDIO_DE_PAGO MP ON MP.id_medio_de_pago = EM.id_medio_de_pago
		JOIN DB_OWNERS.MOVILIDAD M ON M.id_movilidad = R.id_movilidad
		JOIN DB_OWNERS.TIPO_PAQUETE TP ON TP.id_tipo_paquete = EM.id_tipo_paquete
		JOIN DB_OWNERS.BI_TIEMPO BT ON año = YEAR(EM.fecha_hora) AND mes = MONTH(EM.fecha_hora)
		JOIN DB_OWNERS.BI_DIA BD ON FORMAT(EM.fecha_hora, 'dddd') = BD.nombre
		JOIN DB_OWNERS.BI_RANGO_HORARIO BRH ON DATEPART(HOUR, EM.fecha_hora) >= BRH.hora_desde AND DATEPART(HOUR, EM.fecha_hora) < BRH.hora_hasta
		JOIN DB_OWNERS.BI_LOCALIDAD BLI ON BLI.provicia = PR.nombre AND BLI.localidad = LI.nombre
		JOIN DB_OWNERS.BI_RANGO_ETARIO BREU ON DATEDIFF(year, U.fecha_nacimiento , GETDATE()) >= BREU.edad_desde AND DATEDIFF(year, U.fecha_nacimiento, GETDATE()) < BREU.edad_hasta
		JOIN DB_OWNERS.BI_RANGO_ETARIO BRER ON DATEDIFF(year, R.fecha_nacimiento , GETDATE()) >= BRER.edad_desde AND DATEDIFF(year, R.fecha_nacimiento, GETDATE()) < BRER.edad_hasta
		JOIN DB_OWNERS.BI_MEDIO_DE_PAGO BMP ON BMP.detalle = MP.medio
		JOIN DB_OWNERS.BI_TIPO_PAQUETE BTP ON BTP.descripcion = TP.descripcion
		JOIN DB_OWNERS.BI_ESTADO_ENVIO BEE ON BEE.descripcion = E.estado
		JOIN DB_OWNERS.BI_TIPO_MOVILIDAD BTM ON BTM.descripcion = M.vehiculo
		GROUP BY BT.id_tiempo, BD.id_dia,BRH.id_rango_horario,BLI.id_localidad, BREU.id_rango_etario, BRER.id_rango_etario, BMP.id_medio_pago, BTP.id_tipo_paquete, BEE.id_estado_envio, BTM.id_tipo_movilidad
END
GO



--DROP VIEW vista_pedidos_mayor_dia_y_fh_por_localidad_categoria_mes
CREATE VIEW vista_pedidos_mayor_dia_y_fh_por_localidad_categoria_mes AS
SELECT 
BD.nombre AS [Dia de la semana],
BRH.hora_desde AS [Hora desde],
BRH.hora_hasta AS [Hora hasta],
BL.localidad AS [Localidad],
BCL.categoria AS [Categoria],
BT.mes AS [Mes],
BT.año AS [Año],
SUM(cantidad_pedidos) as [Cantidad de pedidos]
FROM DB_OWNERS.BI_PEDIDOS BP
JOIN DB_OWNERS.BI_TIEMPO BT ON BT.id_tiempo = BP.id_tiempo
JOIN DB_OWNERS.BI_CATEGORIA_LOCAL BCL ON BCL.id_categoria_local = BP.id_categoria_local
JOIN DB_OWNERS.BI_LOCALIDAD BL ON BL.id_localidad = BP.id_localidad
JOIN DB_OWNERS.BI_DIA BD ON BD.id_dia = BP.id_dia
JOIN DB_OWNERS.BI_RANGO_HORARIO BRH ON BRH.id_rango_horario = BP.id_rango_horario
WHERE (BP.id_dia) = (select TOP 1 BP2.id_dia from DB_OWNERS.BI_PEDIDOS BP2 
									WHERE BP2.id_localidad = BP.id_localidad AND BP2.id_categoria_local = BP.id_categoria_local AND BP2.id_tiempo = BP.id_tiempo 
									GROUP BY BP2.id_localidad, BP2.id_categoria_local, BP2.id_tiempo, BP2.id_rango_horario, BP2.id_dia ORDER BY SUM(cantidad_pedidos) DESC)
	AND (BP.id_rango_horario) = (select TOP 1 BP2.id_rango_horario from DB_OWNERS.BI_PEDIDOS BP2 
									WHERE BP2.id_localidad = BP.id_localidad AND BP2.id_categoria_local = BP.id_categoria_local AND BP2.id_tiempo = BP.id_tiempo 
									GROUP BY BP2.id_localidad, BP2.id_categoria_local, BP2.id_tiempo, BP2.id_rango_horario, BP2.id_dia ORDER BY SUM(cantidad_pedidos) DESC)
GROUP BY BD.nombre, BRH.hora_desde,BRH.hora_hasta, BL.localidad, BCL.categoria, bt.mes, bt.año
GO
--SELECT * FROM vista_pedidos_mayor_dia_y_fh_por_localidad_categoria_mes
--order by [Localidad],[Categoria], [Mes]


--DROP VIEW vista_pedidos_monto_no_cobrado_por_local_dia_fh
CREATE VIEW vista_pedidos_monto_no_cobrado_por_local_dia_fh AS
SELECT 
BL.nombre AS [Local],
BD.nombre AS [Dia de la semana],
BRH.hora_desde AS [Hora desde],
BRH.hora_hasta AS [Hora hasta],
SUM(BP.monto_cancelado) AS [Monto Total no cobrado]
FROM DB_OWNERS.BI_PEDIDOS BP
JOIN DB_OWNERS.BI_LOCAL BL ON BL.id_local = BP.id_local
JOIN DB_OWNERS.BI_DIA BD ON BD.id_dia = BP.id_dia
JOIN DB_OWNERS.BI_RANGO_HORARIO BRH ON BRH.id_rango_horario = BP.id_rango_horario
GROUP BY BL.nombre, BD.nombre, BRH.hora_desde,BRH.hora_hasta
GO

--SELECT * FROM vista_pedidos_monto_no_cobrado_por_local_dia_fh
--order by [Local],[Dia de la semana],[Hora desde],[Hora hasta]


--DROP VIEW vista_promedio_coste_envio_por_localidad_mes
CREATE VIEW vista_promedio_coste_envio_por_localidad_mes AS
SELECT 
BL.localidad AS [Localidad],
BT.año AS [Año],
BT.mes AS [Mes],
AVG(BP.promedio_envio) AS [Promedio costo de envio]
FROM DB_OWNERS.BI_PEDIDOS BP
JOIN DB_OWNERS.BI_LOCALIDAD BL ON BL.id_localidad = BP.id_localidad
JOIN DB_OWNERS.BI_TIEMPO BT ON BT.id_tiempo = BP.id_tiempo
GROUP BY BL.localidad, BT.mes, BT.año
GO

--SELECT * FROM vista_promedio_coste_envio_por_localidad_mes
--order by [Localidad],[Año],[Mes]


--DROP VIEW vista_desvio_promedio_tiempo_entrega_por_movilidad_dia_fh
CREATE VIEW vista_desvio_promedio_tiempo_entrega_por_movilidad_dia_fh AS
SELECT 
	BTM.descripcion AS [Movilidad],
	BD.nombre AS [Dia],
	BRH.hora_desde AS [Hora desde],
	BRH.hora_hasta AS [Hora hasta],
	AVG(subquery.promedio_desvio) AS [Promedio desvio]
	FROM (
		SELECT
		BP.id_tipo_movilidad,
		BP.id_dia,
		BP.id_rango_horario,
		BP.promedio_desvio
		FROM DB_OWNERS.BI_PEDIDOS BP
		UNION all
		SELECT
		BEM.id_tipo_movilidad,
		BEM.id_dia,
		BEM.id_rango_horario,
		BEM.promedio_desvio
		FROM DB_OWNERS.BI_ENVIOS_MENSAJERIA BEM
	) AS subquery
	JOIN DB_OWNERS.BI_TIPO_MOVILIDAD BTM ON BTM.id_tipo_movilidad = subquery.id_tipo_movilidad
	JOIN DB_OWNERS.BI_DIA BD ON BD.id_dia = subquery.id_dia
	JOIN DB_OWNERS.BI_RANGO_HORARIO BRH ON BRH.id_rango_horario = subquery.id_rango_horario
	GROUP BY BTM.descripcion , BD.nombre, BRH.hora_desde, BRH.hora_hasta
GO

--SELECT * FROM vista_desvio_promedio_tiempo_entrega_por_movilidad_dia_fh
--order by [Movilidad],[Dia],[Hora desde],[Hora hasta]


--DROP VIEW vista_monto_cupones_por_mes_reu
CREATE VIEW vista_monto_cupones_por_mes_reu AS
SELECT 
BT.año AS [Año],
BT.mes AS [Mes],
BREU.edad_desde AS [Usuario Edad desde],
BREU.edad_hasta [Usuario Edad hasta],
SUM(BP.monto_total_cupones) AS [Monto Total Cupones]
FROM DB_OWNERS.BI_PEDIDOS BP
JOIN DB_OWNERS.BI_RANGO_ETARIO BREU ON BREU.id_rango_etario = BP.id_rango_etario_usuario
JOIN DB_OWNERS.BI_TIEMPO BT ON BT.id_tiempo = BP.id_tiempo
GROUP BY BT.mes, BT.año, BREU.edad_desde, BREU.edad_hasta
GO
--SELECT * FROM vista_monto_cupones_por_mes_reu
--order by [Año],[Mes],[Usuario Edad desde],[Usuario Edad hasta]


--DROP VIEW vista_calificacion_por_mes_local
CREATE VIEW vista_calificacion_por_mes_local AS
SELECT 
BL.nombre AS [Local],
BT.año AS [Año],
BT.mes AS [Mes],

AVG(BP.promedio_calificacion) AS [Promedio Calificacion]
FROM DB_OWNERS.BI_PEDIDOS BP
JOIN DB_OWNERS.BI_LOCAL BL ON BL.id_local = BP.id_local
JOIN DB_OWNERS.BI_TIEMPO BT ON BT.id_tiempo = BP.id_tiempo
GROUP BY BL.nombre, BT.mes, BT.año
GO
--SELECT * FROM vista_calificacion_por_mes_local
--order by [Local],[Año],[Mes]



--DROP VIEW vista_pedidos_mensajeria_entregados_por_re_repartidor_localidad
CREATE VIEW vista_pedidos_mensajeria_entregados_por_re_repartidor_localidad AS
SELECT 
	BL.localidad AS [Localidad],
	BRER.edad_desde AS [Repartidor Edad desde],
	BRER.edad_hasta as [Repartidor Edad hasta],
	AVG(subquery.porcentaje_entregado) AS [Porcentaje Entregado]
	FROM (
		SELECT
		BP.id_rango_etario_repartidor,
		BP.id_localidad,
		BP.porcentaje_entregado
		FROM DB_OWNERS.BI_PEDIDOS BP
		UNION all
		SELECT
		BEM.id_rango_etario_repartidor,
		BEM.id_localidad,
		BEM.porcentaje_entregado
		FROM DB_OWNERS.BI_ENVIOS_MENSAJERIA BEM
	) AS subquery
	JOIN DB_OWNERS.BI_LOCALIDAD BL ON BL.id_localidad = subquery.id_localidad
	JOIN DB_OWNERS.BI_RANGO_ETARIO BRER ON BRER.id_rango_etario = subquery.id_rango_etario_repartidor
	GROUP BY BL.localidad , BRER.edad_desde, BRER.edad_hasta
GO
--SELECT * FROM vista_pedidos_mensajeria_entregados_por_re_repartidor_localidad
--order by [Localidad],[Repartidor Edad desde],[Repartidor Edad hasta]


--DROP VIEW vista_promedio_valor_asegurado_por_mes_tipopaquete
CREATE VIEW vista_promedio_valor_asegurado_por_mes_tipopaquete AS
SELECT 
BT.año AS [Año],
BT.mes AS [Mes],
BTP.descripcion AS [Tipo Paquete],
AVG(BEM.promedio_valor_asegurado) AS [Promedio Valor Asegurado]
FROM DB_OWNERS.BI_ENVIOS_MENSAJERIA BEM
JOIN DB_OWNERS.BI_TIEMPO BT ON BT.id_tiempo = BEM.id_tiempo
JOIN DB_OWNERS.BI_TIPO_PAQUETE BTP ON BTP.id_tipo_paquete = BEM.id_tipo_paquete
GROUP BY BT.mes, BT.año, BTP.descripcion
GO
--SELECT * FROM vista_promedio_valor_asegurado_por_mes_tipopaquete
--order by [Año],[Mes],[Tipo Paquete]


--DROP VIEW vista_reclamos_recibidos_por_mes_local_dia_rh
CREATE VIEW vista_reclamos_recibidos_por_mes_local_dia_rh AS
SELECT 
BT.año AS [Año],
BT.mes AS [Mes],
BD.nombre AS [Dia de la semana],
BRH.hora_desde AS [Hora desde],
BRH.hora_hasta AS [Hora hasta],
SUM(BR.cantidad_reclamos) AS [Cantidad reclamos]
FROM DB_OWNERS.BI_RECLAMOS BR
JOIN DB_OWNERS.BI_TIEMPO BT ON BT.id_tiempo = BR.id_tiempo
JOIN DB_OWNERS.BI_LOCAL BL ON BL.id_local = BR.id_local
JOIN DB_OWNERS.BI_DIA BD ON BD.id_dia = BR.id_dia
JOIN DB_OWNERS.BI_RANGO_HORARIO BRH ON BRH.id_rango_horario = BR.id_rango_horario
GROUP BY BT.mes, BT.año, BD.nombre, BRH.hora_desde, BRH.hora_hasta
GO

--SELECT * FROM vista_reclamos_recibidos_por_mes_local_dia_rh
--order by [Año],[Mes],[Dia de la semana],[Hora desde], [Hora hasta]


--DROP VIEW vista_tiempo_resolucion_reclamo_por_mes_tiporeclamo_reo
CREATE VIEW vista_tiempo_resolucion_reclamo_por_mes_tiporeclamo_reo AS
SELECT 
BT.año AS [Año],
BT.mes AS [Mes],
BTR.descripcion AS [Tipo Reclamo],
BREO.edad_desde AS [Operador Edad desde],
BREO.edad_hasta AS [Operador Edad hasta],
AVG(BR.tiempo_resolucion) AS [Promedio Tiempo Resolucion]
FROM DB_OWNERS.BI_RECLAMOS BR
JOIN DB_OWNERS.BI_TIEMPO BT ON BT.id_tiempo = BR.id_tiempo
JOIN DB_OWNERS.BI_TIPO_RECLAMO BTR ON BTR.id_tipo_reclamo = BR.id_tipo_reclamo
JOIN DB_OWNERS.BI_RANGO_ETARIO BREO ON BREO.id_rango_etario = BR.id_rango_etario_operador
GROUP BY BT.mes, BT.año, BTR.descripcion, BREO.edad_desde, BREO.edad_hasta
GO
--SELECT * FROM vista_tiempo_resolucion_reclamo_por_mes_tiporeclamo_reo
--order by [Año],[Mes],[Tipo Reclamo],[Operador Edad desde], [Operador Edad hasta]


--DROP VIEW vista_monto_cupones_reclamo_por_mes
CREATE VIEW vista_monto_cupones_reclamo_por_mes AS
SELECT 
BT.año AS [Año],
BT.mes AS [Mes],
SUM(BR.monto_generado_cupones) AS [Monto Cupones Reclamos]
FROM DB_OWNERS.BI_RECLAMOS BR
JOIN DB_OWNERS.BI_TIEMPO BT ON BT.id_tiempo = BR.id_tiempo
GROUP BY BT.mes, BT.año
GO
--SELECT * FROM vista_monto_cupones_reclamo_por_mes
--order by [Año],[Mes]


EXECUTE DB_OWNERS.migrar_bi_pedidos
EXECUTE DB_OWNERS.migrar_bi_envios_mensajeria
EXECUTE DB_OWNERS.migrar_bi_reclamos


ALTER TABLE DB_OWNERS.BI_PEDIDOS
ADD FOREIGN KEY (id_tiempo) REFERENCES DB_OWNERS.BI_TIEMPO(id_tiempo),
	FOREIGN KEY (id_dia) REFERENCES DB_OWNERS.BI_DIA(id_dia),
	FOREIGN KEY (id_rango_horario) REFERENCES DB_OWNERS.BI_RANGO_HORARIO(id_rango_horario),
	FOREIGN KEY (id_localidad) REFERENCES DB_OWNERS.BI_LOCALIDAD(id_localidad),
	FOREIGN KEY (id_rango_etario_usuario) REFERENCES DB_OWNERS.BI_RANGO_ETARIO(id_rango_etario),
	FOREIGN KEY (id_rango_etario_repartidor) REFERENCES DB_OWNERS.BI_RANGO_ETARIO(id_rango_etario),
	FOREIGN KEY (id_medio_pago) REFERENCES DB_OWNERS.BI_MEDIO_DE_PAGO(id_medio_pago),
	FOREIGN KEY (id_local) REFERENCES DB_OWNERS.BI_LOCAL(id_local),
	FOREIGN KEY (id_categoria_local) REFERENCES DB_OWNERS.BI_CATEGORIA_LOCAL(id_categoria_local),
	FOREIGN KEY (id_tipo_movilidad) REFERENCES DB_OWNERS.BI_TIPO_MOVILIDAD(id_tipo_movilidad);

ALTER TABLE DB_OWNERS.BI_ENVIOS_MENSAJERIA
ADD FOREIGN KEY (id_tiempo) REFERENCES DB_OWNERS.BI_TIEMPO(id_tiempo),
	FOREIGN KEY (id_dia) REFERENCES DB_OWNERS.BI_DIA(id_dia),
	FOREIGN KEY (id_rango_horario) REFERENCES DB_OWNERS.BI_RANGO_HORARIO(id_rango_horario),
	FOREIGN KEY (id_localidad) REFERENCES DB_OWNERS.BI_LOCALIDAD(id_localidad),
	FOREIGN KEY (id_rango_etario_usuario) REFERENCES DB_OWNERS.BI_RANGO_ETARIO(id_rango_etario),
	FOREIGN KEY (id_rango_etario_repartidor) REFERENCES DB_OWNERS.BI_RANGO_ETARIO(id_rango_etario),
	FOREIGN KEY (id_medio_pago) REFERENCES DB_OWNERS.BI_MEDIO_DE_PAGO(id_medio_pago),
	FOREIGN KEY (id_tipo_paquete) REFERENCES DB_OWNERS.BI_TIPO_PAQUETE(id_tipo_paquete),
	FOREIGN KEY (id_estado_envio) REFERENCES DB_OWNERS.BI_ESTADO_ENVIO(id_estado_envio),
	FOREIGN KEY (id_tipo_movilidad) REFERENCES DB_OWNERS.BI_TIPO_MOVILIDAD(id_tipo_movilidad);


ALTER TABLE DB_OWNERS.BI_RECLAMOS
ADD FOREIGN KEY (id_tiempo) REFERENCES DB_OWNERS.BI_TIEMPO(id_tiempo),
	FOREIGN KEY (id_dia) REFERENCES DB_OWNERS.BI_DIA(id_dia),
	FOREIGN KEY (id_rango_horario) REFERENCES DB_OWNERS.BI_RANGO_HORARIO(id_rango_horario),
	FOREIGN KEY (id_rango_etario_usuario) REFERENCES DB_OWNERS.BI_RANGO_ETARIO(id_rango_etario),
	FOREIGN KEY (id_rango_etario_operador) REFERENCES DB_OWNERS.BI_RANGO_ETARIO(id_rango_etario),
	FOREIGN KEY (id_tipo_reclamo) REFERENCES DB_OWNERS.BI_TIPO_RECLAMO(id_tipo_reclamo),
	FOREIGN KEY (id_local) REFERENCES DB_OWNERS.BI_LOCAL(id_local);

