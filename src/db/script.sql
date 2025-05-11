-- correccion de la wea de bd

-- =============================
-- SCRIPT: BD EcoMarket Optimizada (Oracle SQL)
-- =============================

-- DROP ORDER (por restricciones de FK existentes)
BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/

-- =============================
-- ROLES Y USUARIOS
-- =============================
CREATE TABLE Roles (
    rol_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE,
    descripcion VARCHAR2(255)
);

CREATE TABLE Usuarios (
    usuario_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    password_hash VARCHAR2(255) NOT NULL,
    rol_id NUMBER NOT NULL,
    telefono VARCHAR2(20),
    direccion VARCHAR2(4000),
    rut VARCHAR2(12) UNIQUE,  -- Campo para almacenar el RUT
    tipo_usuario VARCHAR2(20) CHECK (tipo_usuario IN ('administrador', 'gerente', 'empleado', 'cliente')),
    activo NUMBER(1) DEFAULT 1,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_rol FOREIGN KEY (rol_id) REFERENCES Roles(rol_id)
);


-- =============================
-- TIENDAS
-- =============================
CREATE TABLE Tiendas (
    tienda_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    direccion VARCHAR2(4000) NOT NULL,
    ciudad VARCHAR2(50) NOT NULL,
    telefono VARCHAR2(20),
    activa NUMBER(1) DEFAULT 1
);

-- =============================
-- CATEGORÍAS Y PROVEEDORES
-- =============================
CREATE TABLE Categorias (
    categoria_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) UNIQUE NOT NULL
);

CREATE TABLE Proveedores (
    proveedor_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    contacto VARCHAR2(100),
    telefono VARCHAR2(20),
    email VARCHAR2(100),
    activo NUMBER(1) DEFAULT 1
);

-- =============================
-- PRODUCTOS
-- =============================
CREATE TABLE Productos (
    producto_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(4000),
    precio NUMBER(10,2) NOT NULL,
    categoria_id NUMBER,
    proveedor_id NUMBER,
    ecoscore VARCHAR2(1),
    activo NUMBER(1) DEFAULT 1,
    CONSTRAINT fk_categoria FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id),
    CONSTRAINT fk_proveedor FOREIGN KEY (proveedor_id) REFERENCES Proveedores(proveedor_id)
);

-- =============================
-- INVENTARIO Y MOVIMIENTOS
-- =============================
CREATE TABLE Inventario (
    inventario_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    producto_id NUMBER NOT NULL,
    tienda_id NUMBER NOT NULL,
    cantidad NUMBER NOT NULL ,
    stock_minimo NUMBER ,
    CONSTRAINT fk_inventario_producto FOREIGN KEY (producto_id) REFERENCES Productos(producto_id),
    CONSTRAINT fk_inventario_tienda FOREIGN KEY (tienda_id) REFERENCES Tiendas(tienda_id),
    CONSTRAINT uq_inventario UNIQUE (producto_id, tienda_id)
);

CREATE TABLE MovimientosInventario (
    movimiento_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    inventario_id NUMBER NOT NULL,
    tipo VARCHAR2(20) CHECK (tipo IN ('entrada', 'salida', 'ajuste')),
    cantidad NUMBER NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descripcion VARCHAR2(400),
    CONSTRAINT fk_mov_inv FOREIGN KEY (inventario_id) REFERENCES Inventario(inventario_id)
);

-- =============================
-- PEDIDOS, DETALLE Y ENVÍOS
-- =============================
CREATE TABLE Pedidos (
    pedido_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cliente_id NUMBER NOT NULL,
    tienda_id NUMBER,
    empleado_id NUMBER,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR2(20) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    subtotal NUMBER(10,2) NOT NULL,
    descuento NUMBER(10,2) ,
    total NUMBER(10,2) NOT NULL,
    metodo_pago VARCHAR2(50),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES Usuarios(usuario_id),
    CONSTRAINT fk_pedido_tienda FOREIGN KEY (tienda_id) REFERENCES Tiendas(tienda_id),
    CONSTRAINT fk_pedido_empleado FOREIGN KEY (empleado_id) REFERENCES Usuarios(usuario_id)
);

CREATE TABLE DetallePedidos (
    detalle_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pedido_id NUMBER NOT NULL,
    producto_id NUMBER NOT NULL,
    cantidad NUMBER NOT NULL,
    precio_unitario NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    CONSTRAINT fk_detalle_producto FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);

CREATE TABLE Envios (
    envio_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pedido_id NUMBER NOT NULL,
    fecha_envio TIMESTAMP,
    fecha_entrega TIMESTAMP,
    estado VARCHAR2(20) CHECK (estado IN ('preparando', 'en ruta', 'entregado', 'fallido')),
    tracking_code VARCHAR2(100),
    CONSTRAINT fk_envio_pedido FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id)
);

-- =============================
-- RESEÑAS Y CARRITO
-- =============================
CREATE TABLE Resenas (
    resena_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    producto_id NUMBER NOT NULL,
    cliente_id NUMBER NOT NULL,
    pedido_id NUMBER,
    tipo VARCHAR2(20) DEFAULT 'reseña' CHECK (tipo IN ('reseña', 'reclamo')),
    calificacion NUMBER CHECK (calificacion BETWEEN 1 AND 5),
    comentario VARCHAR2(4000),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR2(20) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'aprobado', 'rechazado', 'solucionado')),
    CONSTRAINT fk_resena_producto FOREIGN KEY (producto_id) REFERENCES Productos(producto_id),
    CONSTRAINT fk_resena_cliente FOREIGN KEY (cliente_id) REFERENCES Usuarios(usuario_id),
    CONSTRAINT fk_resena_pedido FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id)
);

CREATE TABLE Carrito (
    carrito_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cliente_id NUMBER NOT NULL,
    producto_id NUMBER NOT NULL,
    cantidad NUMBER DEFAULT 1,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_carrito_cliente FOREIGN KEY (cliente_id) REFERENCES Usuarios(usuario_id),
    CONSTRAINT fk_carrito_producto FOREIGN KEY (producto_id) REFERENCES Productos(producto_id),
    CONSTRAINT uq_carrito UNIQUE (cliente_id, producto_id)
);

-- =============================
-- INDICES
-- =============================
CREATE INDEX idx_usuario_email ON Usuarios(email);
CREATE INDEX idx_inventario_producto_tienda ON Inventario(producto_id, tienda_id);
CREATE INDEX idx_pedido_cliente ON Pedidos(cliente_id);

-- =============================
-- ROLES BASE
-- =============================
INSERT INTO Roles (nombre, descripcion) VALUES ('administrador', 'Administrador del sistema');
INSERT INTO Roles (nombre, descripcion) VALUES ('gerente', 'Gerente de tienda');
INSERT INTO Roles (nombre, descripcion) VALUES ('empleado', 'Empleado de ventas');
INSERT INTO Roles (nombre, descripcion) VALUES ('cliente', 'Cliente de la tienda');

