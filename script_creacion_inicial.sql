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
	tipo NVARCHAR(255) NOT NULL,
	numero NVARCHAR(50) NOT NULL,
	marca NVARCHAR(100) NOT NULL,
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
	nro_cupon int not null,
	monto DECIMAL(18,2) NOT NULL,
	fecha_alta DATETIME2(3) NOT NULL,
	fecha_vencimiento DATETIME2(3) NOT NULL,
	id_tipo_cupon INT NOT NULL--FK
)
GO

CREATE TABLE DB_OWNERS.MEDIO_DE_PAGO
(
	id_medio_de_pago INT IDENTITY(1,1) PRIMARY KEY,
	medio NVARCHAR(50) NOT NULL,
	id_datos_tarjeta INT --FK
)
GO

CREATE TABLE DB_OWNERS.PAGO
(
	id_pago INT IDENTITY(1,1) PRIMARY KEY,
	id_medio_de_pago INT NOT NULL --FK
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

CREATE TABLE DB_OWNERS.PRODUCTO_POR_LOCAL(
	cod_producto nvarchar(50) NOT NULL, --fk
	id_local int NOT NULL, --fk
	precio_unitario decimal(18,2) NOT NULL,
	PRIMARY KEY (cod_producto, id_local)
)
GO


CREATE TABLE DB_OWNERS.PRODUCTO(
	cod_producto INT IDENTITY(1,1) PRIMARY KEY,
	nombre nvarchar(50) NOT NULL,
	descripcion nvarchar(255) NOT NULL
)
GO

CREATE TABLE DB_OWNERS.ITEM(
	id_item INT IDENTITY(1,1) PRIMARY KEY,
	cod_producto nvarchar(50) NOT NULL, --fk
	nro_pedido int NOT NULL, --fk
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
	nro_reclamo INT IDENTITY (1,1) PRIMARY KEY,
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
	id_direccion INT NOT NULL
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
	nro_mensajeria INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL,
	id_tipo_paquete INT NOT NULL,
	id_envio INT NOT NULL,
	id_estado INT NOT NULL,
	id_pago INT NOT NULL,
	fecha_hora DATETIME NOT NULL,
	precio_total DECIMAL(18,2) NOT NULL,
	observaciones NVARCHAR(50),
	calificacion INT,
	fecha_hora_entrega DATETIME2(3),
	valor_asegurado DECIMAL(18,2) NOT NULL,
	precio_seguro DECIMAL(18,2) NOT NULL,
	precio_envio_mensajeria DECIMAL(18,2) NOT NULL,
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
	nro_pedido INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL, -- (fk)
	id_local INT NOT NULL, -- (fk)
	fecha DATETIME2(3) NOT NULL,
	id_envio INT NOT NULL, -- (fk)
	observaciones NVARCHAR(255),
	id_estado INT NOT NULL, -- (fk)
	calificacion DECIMAL(18,0),
	fecha_hora_entrega DATETIME2(3),
	tarifa_servicio DECIMAL(18, 2) NOT NULL,
	id_pago INT NOT NULL, -- (fk)
	precio_total_servicio DECIMAL(18, 2) NOT NULL,
	total_cupones DECIMAL(18, 2) NOT NULL,
	total_productos DECIMAL(18, 2) NOT NULL
)
GO




--------------------------------------
------------ PROCEDURES --------------
--------------------------------------

CREATE PROCEDURE DB_OWNERS.migrar_usuario AS
BEGIN
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
END

GO









--------------------------------------
---------- DATA MIGRATION ------------
--------------------------------------

BEGIN TRANSACTION 

	EXECUTE DB_OWNERS.migrar_usuario
	EXECUTE DB_OWNERS.migrar_provincias;
	EXECUTE DB_OWNERS.migrar_localidades;
	EXECUTE DB_OWNERS.migrar_direcciones; 
	EXECUTE DB_OWNERS.migrar_tipo_cupon;
	EXECUTE DB_OWNERS.migrar_cupon;

	
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
