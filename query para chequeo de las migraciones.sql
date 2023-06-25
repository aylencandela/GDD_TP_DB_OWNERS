
--ELIMINA TODAS LAS TABLAS CREADAS
drop table 
DB_OWNERS.USUARIO, 
DB_OWNERS.DATOS_TARJETA,
DB_OWNERS.DIRECCION,
DB_OWNERS.LOCALIDAD,
DB_OWNERS.PROVINCIA,
DB_OWNERS.DIRECCION_POR_USUARIO,
DB_OWNERS.TIPO_CUPON,
DB_OWNERS.CUPON,
DB_OWNERS.MEDIO_DE_PAGO,
DB_OWNERS.LOCAL_,
DB_OWNERS.TIPO_LOCAL,
DB_OWNERS.REPARTIDOR,
DB_OWNERS.PRODUCTO,
DB_OWNERS.PRODUCTO_POR_LOCAL,
DB_OWNERS.ITEM,
DB_OWNERS.ENVIO,
DB_OWNERS.MOVILIDAD,
DB_OWNERS.HORARIO_ATENCION,
DB_OWNERS.DIA_SEMANA,
DB_OWNERS.RECLAMO,
DB_OWNERS.TIPO_RECLAMO,
DB_OWNERS.OPERADOR,
DB_OWNERS.SOLUCION,
DB_OWNERS.CUPON_RECLAMO,
DB_OWNERS.TIPO_PAQUETE,
DB_OWNERS.ENVIO_MENSAJERIA,
DB_OWNERS.ESTADO,
DB_OWNERS.CUPON_USADO,
DB_OWNERS.PEDIDO


--CHEQUEO TABLAS CREADAS POR SP

--usuario
select * FROM DB_OWNERS.USUARIO order by DNI asc
select DISTINCT USUARIO_APELLIDO, USUARIO_DNI FROM gd_esquema.Maestra where USUARIO_APELLIDO is not null and USUARIO_DNI is not null

--tipo_reclamo
select * FROM DB_OWNERS.TIPO_RECLAMO
select DISTINCT RECLAMO_TIPO FROM gd_esquema.Maestra where RECLAMO_TIPO is not null

--solucion_reclamo
select * FROM DB_OWNERS.SOLUCION order by fecha_solucion asc
select DISTINCT RECLAMO_SOLUCION, RECLAMO_FECHA_SOLUCION FROM gd_esquema.Maestra where RECLAMO_NRO is not null AND RECLAMO_SOLUCION is not null AND RECLAMO_FECHA_SOLUCION is not null order by RECLAMO_FECHA_SOLUCION asc

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
select nombre, id_provincia FROM DB_OWNERS.LOCALIDAD WHERE NOMBRE = 'San Jose' --ambas consultas dan diferentes cantidades
where not exists(
select  * FROM gd_esquema.Maestra where ENVIO_MENSAJERIA_LOCALIDAD = 'San Jose' is not null UNION
select DISTINCT DIRECCION_USUARIO_LOCALIDAD FROM gd_esquema.Maestra where DIRECCION_USUARIO_LOCALIDAD is not null UNION
select DISTINCT LOCAL_LOCALIDAD FROM gd_esquema.Maestra where LOCAL_LOCALIDAD is not null) 

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
select * from gd_esquema.Maestra WHERE CUPON_RECLAMO_NRO = '11119211'

--producto_por_local
select * FROM DB_OWNERS.PRODUCTO_POR_LOCAL 
select distinct PRODUCTO_LOCAL_CODIGO FROM gd_esquema.Maestra where PRODUCTO_LOCAL_CODIGO is not null

--repartidor
select * FROM DB_OWNERS.REPARTIDOR

--envio
select E.TIEMPO_EST_ENTREGA, E.PROPINA, R.NOMBRE, R.APELLIDO FROM DB_OWNERS.ENVIO E JOIN DB_OWNERS.REPARTIDOR r ON R.ID_REPARTIDOR = E.ID_REPARTIDOR


--envio mensajeria
select * FROM DB_OWNERS.ENVIO_MENSAJERIA em JOIN DB_OWNERS.MEDIO_DE_PAGO u on u.id_medio_de_pago = em.id_medio_de_pago order by nro_mensajeria

select * from gd_esquema.Maestra where ENVIO_MENSAJERIA_NRO is not null order by ENVIO_MENSAJERIA_NRO 

--pedido
select * FROM DB_OWNERS.PEDIDO em JOIN DB_OWNERS.MEDIO_DE_PAGO u on u.id_medio_de_pago = em.id_medio_de_pago JOIN DB_OWNERS.LOCAL_ l on l.id_local = em.id_local order by nro_pedido

select * from gd_esquema.Maestra where PEDIDO_NRO is not null order by PEDIDO_NRO 

--reclamo
select * FROM DB_OWNERS.RECLAMO em 
JOIN DB_OWNERS.USUARIO u on u.id_usuario = em.id_usuario 
JOIN DB_OWNERS.PEDIDO p on p.id_pedido = em.id_pedido 
JOIN DB_OWNERS.TIPO_RECLAMO tr on tr.id_tipo_reclamo = em.id_tipo_reclamo 
JOIN DB_OWNERS.ESTADO e on e.id_estado = em.id_estado 
JOIN DB_OWNERS.OPERADOR ep on ep.id_operador = em.id_operador
JOIN DB_OWNERS.SOLUCION s on s.id_solucion = em.id_solucion
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



/*ESTO ES PARA ASIGNARLE A UN REPARTIDOR UNA LOCALIDAD
envio mensajeria
Debo buscar el repartidor, el nombre apellido etc de ese reparidor, fijarme donde fue la ultima entrega que hizo, y asignarle esa lolcaludad, para eso, necesito ver cualfue el envio_mensajeria_fecha_entrega ultimo, de ahi sacar la localidad de ese envio mensajeria


envio pedido
Debo buscar el repartidor, el nombre apellido etc de ese reparidor, fijarme donde fue la ultima entrega que hizo, y asignarle esa lolcaludad, para eso, necesito ver cualfue el pedido_fecha_entrega ultimo de ese repartidor, de ahi sacar la localidad de ese direccion usuario localidad	
*/