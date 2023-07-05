--CHEQUEO TABLAS CREADAS POR SP

--usuario
select * FROM DB_OWNERS.USUARIO order by DNI asc
select DISTINCT USUARIO_APELLIDO, USUARIO_DNI FROM gd_esquema.Maestra where USUARIO_APELLIDO is not null and USUARIO_DNI is not null order by USUARIO_DNI asc

--tipo_reclamo
select * FROM DB_OWNERS.TIPO_RECLAMO
select DISTINCT RECLAMO_TIPO FROM gd_esquema.Maestra where RECLAMO_TIPO is not null

--tipo_cupon
select * FROM DB_OWNERS.TIPO_CUPON
select DISTINCT CUPON_TIPO FROM gd_esquema.Maestra where CUPON_TIPO is not null

--movilidad
select * FROM DB_OWNERS.MOVILIDAD
select DISTINCT REPARTIDOR_TIPO_MOVILIDAD FROM gd_esquema.Maestra where REPARTIDOR_TIPO_MOVILIDAD is not null

--estado
select * FROM DB_OWNERS.ESTADO
select DISTINCT ENVIO_MENSAJERIA_ESTADO FROM gd_esquema.Maestra where ENVIO_MENSAJERIA_ESTADO is not null 
select DISTINCT PEDIDO_ESTADO FROM gd_esquema.Maestra where PEDIDO_ESTADO is not null
select DISTINCT RECLAMO_ESTADO FROM gd_esquema.Maestra where RECLAMO_ESTADO is not null

--tipos-local
select * from DB_OWNERS.TIPO_LOCAL
select DISTINCT LOCAL_TIPO FROM gd_esquema.Maestra

--categoria
select * FROM DB_OWNERS.CATEGORIA

--categoria-local
select * FROM DB_OWNERS.CATEGORIA_LOCAL cl 
		join DB_OWNERS.CATEGORIA c on c.id_categoria = cl.id_categoria
		join DB_OWNERS.TIPO_LOCAL tl on tl.id_tipo_local = cl.id_tipo_local

--provincia
select * FROM DB_OWNERS.PROVINCIA
select DISTINCT ENVIO_MENSAJERIA_PROVINCIA FROM gd_esquema.Maestra where ENVIO_MENSAJERIA_PROVINCIA is not null UNION
select DISTINCT DIRECCION_USUARIO_PROVINCIA FROM gd_esquema.Maestra where DIRECCION_USUARIO_PROVINCIA is not null UNION
select DISTINCT LOCAL_PROVINCIA FROM gd_esquema.Maestra where LOCAL_PROVINCIA is not null 

--dia_semana
select * FROM DB_OWNERS.DIA_SEMANA
select DISTINCT HORARIO_LOCAL_DIA FROM gd_esquema.Maestra where HORARIO_LOCAL_DIA is not null

--tipo_paquete
select * FROM DB_OWNERS.TIPO_PAQUETE
select DISTINCT PAQUETE_TIPO FROM gd_esquema.Maestra where PAQUETE_TIPO is not null

--producto
select * FROM DB_OWNERS.PRODUCTO
select DISTINCT PRODUCTO_LOCAL_NOMBRE FROM gd_esquema.Maestra where PRODUCTO_LOCAL_NOMBRE is not null

--localidad
--DAN DIFERENTES CANTIDADES PORQUE ALGUNAS LOCALIDADES SE REPITEN, EJ: SAN JOSE
select * FROM DB_OWNERS.LOCALIDAD ORDER BY NOMBRE
select DISTINCT ENVIO_MENSAJERIA_LOCALIDAD FROM gd_esquema.Maestra where ENVIO_MENSAJERIA_LOCALIDAD is not null UNION
select DISTINCT DIRECCION_USUARIO_LOCALIDAD FROM gd_esquema.Maestra where DIRECCION_USUARIO_LOCALIDAD is not null UNION
select DISTINCT LOCAL_LOCALIDAD FROM gd_esquema.Maestra where LOCAL_LOCALIDAD is not null 

select l.nombre, c.nombre FROM DB_OWNERS.LOCALIDAD l
join DB_OWNERS.PROVINCIA c on c.id_provincia = l.id_provincia WHERE l.NOMBRE = 'San Jose'

select distinct ENVIO_MENSAJERIA_LOCALIDAD,ENVIO_MENSAJERIA_PROVINCIA, DIRECCION_USUARIO_LOCALIDAD, DIRECCION_USUARIO_PROVINCIA, LOCAL_LOCALIDAD, LOCAL_PROVINCIA FROM gd_esquema.Maestra where ENVIO_MENSAJERIA_LOCALIDAD is not null or
DIRECCION_USUARIO_LOCALIDAD is not null or LOCAL_LOCALIDAD is not null 

--datos_tarjeta
select * FROM DB_OWNERS.DATOS_TARJETA ORDER BY NUMERO
select DISTINCT MEDIO_PAGO_NRO_TARJETA FROM gd_esquema.Maestra where MEDIO_PAGO_NRO_TARJETA is not null AND MEDIO_PAGO_TIPO != 'Efectivo' ORDER BY MEDIO_PAGO_NRO_TARJETA

--medio_de_pago
select * FROM DB_OWNERS.MEDIO_DE_PAGO
select DISTINCT id_datos_tarjeta FROM DB_OWNERS.DATOS_TARJETA

--direccion
select calle_numero, l.nombre FROM DB_OWNERS.DIRECCION d join DB_OWNERS.LOCALIDAD l on d.id_localidad = l.id_localidad
select * FROM gd_esquema.Maestra where ENVIO_MENSAJERIA_DIR_DEST = 'Agüero6476' or ENVIO_MENSAJERIA_DIR_ORIG = 'Agüero6476' OR REPARTIDOR_DIRECION = 'Agüero6476' OR DIRECCION_USUARIO_DIRECCION = 'Agüero6476' OR LOCAL_DIRECCION = 'Agüero6476' OR OPERADOR_RECLAMO_DIRECCION = 'Agüero6476'is not null UNION
select DISTINCT ENVIO_MENSAJERIA_DIR_DEST FROM gd_esquema.Maestra where ENVIO_MENSAJERIA_DIR_DEST is not null UNION
select DISTINCT REPARTIDOR_DIRECION FROM gd_esquema.Maestra where REPARTIDOR_DIRECION is not null UNION
select DISTINCT DIRECCION_USUARIO_DIRECCION FROM gd_esquema.Maestra where DIRECCION_USUARIO_DIRECCION is not null UNION
select DISTINCT LOCAL_DIRECCION FROM gd_esquema.Maestra where LOCAL_DIRECCION is not null UNION
select DISTINCT OPERADOR_RECLAMO_DIRECCION FROM gd_esquema.Maestra where OPERADOR_RECLAMO_DIRECCION is not null

--operador
select distinct dni FROM DB_OWNERS.OPERADOR
select DISTINCT OPERADOR_RECLAMO_DNI FROM gd_esquema.Maestra where OPERADOR_RECLAMO_DNI is not null

--locales
select * FROM DB_OWNERS.LOCAL_ l join DB_OWNERS.DIRECCION d on d.id_direccion = l.id_direccion order by nombre 
select distinct LOCAL_NOMBRE FROM gd_esquema.Maestra where local_nombre is not null

--horarios de atencion
select * FROM DB_OWNERS.HORARIO_ATENCION order by id_local asc
select distinct HORARIO_LOCAL_HORA_APERTURA FROM gd_esquema.Maestra where HORARIO_LOCAL_HORA_APERTURA is not null
select distinct HORARIO_LOCAL_HORA_CIERRE FROM gd_esquema.Maestra where HORARIO_LOCAL_HORA_CIERRE is not null

--direcciones_por_usuario
select u.nombre, d.calle_numero FROM DB_OWNERS.DIRECCION_POR_USUARIO du join DB_OWNERS.usuario u on u.id_usuario = du.id_usuario join DB_OWNERS.DIRECCION d on d.id_direccion = du.id_direccion  where u.nombre= 'FLAMA' order by d.id_direccion
select distinct DIRECCION_USUARIO_NOMBRE, DIRECCION_USUARIO_DIRECCION FROM gd_esquema.Maestra where DIRECCION_USUARIO_NOMBRE is not null

--cupones
select * FROM DB_OWNERS.CUPON c join DB_OWNERS.USUARIO u on c.id_usuario = u.id_usuario  where u.nombre = 'POMPONIO' order by c.nro_cupon asc
select * from gd_esquema.Maestra WHERE CUPON_NRO = '11119211' or  CUPON_RECLAMO_NRO = '11119211'
select * FROM DB_OWNERS.CUPON c join DB_OWNERS.USUARIO u on c.id_usuario = u.id_usuario  where u.nombre = 'GERMAN' order by c.nro_cupon asc
select * from gd_esquema.Maestra WHERE CUPON_RECLAMO_NRO = '11119211'

--producto_por_local
select * FROM DB_OWNERS.PRODUCTO_POR_LOCAL 
select distinct PRODUCTO_LOCAL_CODIGO FROM gd_esquema.Maestra where PRODUCTO_LOCAL_CODIGO is not null

--repartidor
select * FROM DB_OWNERS.REPARTIDOR c join DB_OWNERS.LOCALIDAD u on c.id_localidad = u.id_localidad

--envio mensajeria
select * FROM DB_OWNERS.ENVIO_MENSAJERIA em JOIN DB_OWNERS.MEDIO_DE_PAGO u on u.id_medio_de_pago = em.id_medio_de_pago JOIN DB_OWNERS.REPARTIDOR r on r.id_repartidor = em.id_repartidor order by nro_mensajeria

select * from gd_esquema.Maestra where ENVIO_MENSAJERIA_NRO is not null order by ENVIO_MENSAJERIA_NRO 

--pedido
select * FROM DB_OWNERS.PEDIDO em JOIN DB_OWNERS.MEDIO_DE_PAGO u on u.id_medio_de_pago = em.id_medio_de_pago JOIN DB_OWNERS.LOCAL_ l on l.id_local = em.id_local JOIN DB_OWNERS.REPARTIDOR r on r.id_repartidor = em.id_repartidor order by nro_pedido

select * from gd_esquema.Maestra where PEDIDO_NRO is not null order by PEDIDO_NRO 

--reclamo
select * FROM DB_OWNERS.RECLAMO em 
JOIN DB_OWNERS.USUARIO u on u.id_usuario = em.id_usuario 
JOIN DB_OWNERS.PEDIDO p on p.id_pedido = em.id_pedido 
JOIN DB_OWNERS.TIPO_RECLAMO tr on tr.id_tipo_reclamo = em.id_tipo_reclamo 
JOIN DB_OWNERS.ESTADO e on e.id_estado = em.id_estado 
JOIN DB_OWNERS.OPERADOR ep on ep.id_operador = em.id_operador
order by em.nro_reclamo asc

select * from gd_esquema.Maestra where RECLAMO_NRO is not null order by RECLAMO_NRO asc

--cupon_reclamo
select * from DB_OWNERS.CUPON_RECLAMO em
JOIN DB_OWNERS.RECLAMO u on u.id_reclamo = em.id_reclamo 
JOIN DB_OWNERS.CUPON p on p.id_nro_cupon = em.id_nro_cupon 
order by nro_cupon

select * from gd_esquema.Maestra where CUPON_RECLAMO_NRO IS NOT NULL AND CUPON_NRO IS NULL order by CUPON_RECLAMO_NRO

--cupon_usado
select * from DB_OWNERS.CUPON_USADO em
JOIN DB_OWNERS.PEDIDO u on u.id_pedido = em.id_pedido 
JOIN DB_OWNERS.CUPON p on p.id_nro_cupon = em.id_cupon 
order by u.nro_pedido

SELECT USUARIO_APELLIDO, ENVIO_MENSAJERIA_NRO, PEDIDO_NRO, CUPON_NRO, RECLAMO_NRO, CUPON_RECLAMO_NRO, OPERADOR_RECLAMO_DNI FROM gd_esquema.Maestra where ENVIO_MENSAJERIA_NRO is null order by PEDIDO_NRO

--item
select * from DB_OWNERS.ITEM 
