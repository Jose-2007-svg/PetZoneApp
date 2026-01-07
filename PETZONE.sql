CREATE DATABASE PetZone;
GO
USE PetZone;
GO

CREATE TABLE Empresa (
    EmpresaId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(200) NOT NULL,
    RazonSocial NVARCHAR(200) NULL,
    RUC NVARCHAR(20) NULL,
    Ubicacion NVARCHAR(300) NULL,
    Telefono NVARCHAR(50) NULL,
    Email NVARCHAR(100) NULL,
    RedesSociales NVARCHAR(500) NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Usuarios (
    UsuarioId INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash VARBINARY(MAX) NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NULL,
    Email NVARCHAR(100) NULL,
    Rol NVARCHAR(50) NOT NULL, -- Admin, Vendedor, etc.
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Clientes (
    ClienteId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(150) NOT NULL,
    Documento NVARCHAR(50) NULL,
    Telefono NVARCHAR(50) NULL,
    Email NVARCHAR(100) NULL,
    Direccion NVARCHAR(300) NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Categorias (
    CategoriaId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(300) NULL
);
GO

INSERT INTO Categorias (Nombre, Descripcion)
VALUES ('Alimentos para perros', 'Croquetas, latas, snacks.'),
       ('Alimentos para gatos', 'Comida seca, húmeda y snacks'),
       ('Accesorios para perros', 'Collares, correas, camas y ropa.'),
       ('Accesorios para gatos', 'Rascadores, camas, collares.'),
       ('Accesorios para aves', 'Comederos, bebederos, juguetes.'),
       ('Alimentos para aves', 'Semillas, mezclas y suplementos.'),
       ('Peces y acuarios', 'Alimentos, peceras, filtros.'),
       ('Roedores', 'Jaulas, alimentos, accesorios.'),
       ('Higiene y cuidado', 'Shampoo, peines, limpieza.'),
       ('Juguetes', 'Pelotas, cuerdas, juguetes para todas las mascotas.');
GO

CREATE TABLE Productos (
    ProductoId INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(200) NOT NULL,
    SKU NVARCHAR(50) NULL,
    CategoriaId INT NOT NULL FOREIGN KEY REFERENCES Categorias(CategoriaId),
    Precio DECIMAL(18,2) NOT NULL DEFAULT 0,
    Stock INT NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Ordenes (
    OrdenId INT IDENTITY(1,1) PRIMARY KEY,
    ClienteId INT NULL FOREIGN KEY REFERENCES Clientes(ClienteId),
    UsuarioId INT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    Total DECIMAL(18,2) NOT NULL DEFAULT 0,
    Estado NVARCHAR(50) NOT NULL DEFAULT 'Pendiente',
    Observaciones NVARCHAR(500) NULL
);
GO

CREATE TABLE OrdenDetalle (
    OrdenDetalleId INT IDENTITY(1,1) PRIMARY KEY,
    OrdenId INT NOT NULL FOREIGN KEY REFERENCES Ordenes(OrdenId) ON DELETE CASCADE,
    ProductoId INT NOT NULL FOREIGN KEY REFERENCES Productos(ProductoId),
    Cantidad INT NOT NULL DEFAULT 1,
    PrecioUnitario DECIMAL(18,2) NOT NULL,
    SubTotal AS (Cantidad * PrecioUnitario) PERSISTED
);
GO

CREATE INDEX IX_Productos_Nombre ON Productos(Nombre);
CREATE INDEX IX_Ordenes_Fecha ON Ordenes(Fecha);
GO

INSERT INTO Empresa (Nombre, RazonSocial, RUC, Ubicacion, Telefono, Email, RedesSociales)
VALUES ('PetZone', 'PetZone SAC', '20678945612', 'Av. Primavera 456 - Lima', '+51 955055685', 'contacto@petzone.pe', 'facebook:petzone,instagram:@petzoneoficial');

INSERT INTO Usuarios (Username, PasswordHash, Nombre, Apellido, Email, Rol)
VALUES ('admin', NULL, 'Paulo', 'André', 'admin@petzone.pe', 'Administrador'),
       ('vendedor1', NULL, 'Juan', 'Perez', 'juan@petzone.pe', 'Vendedor');

INSERT INTO Clientes (Nombre, Documento, Telefono, Email, Direccion)
VALUES ('Cliente General', 'DNI 12345678', '+51 987654321', 'cliente@correo.com', 'Calle Lima 123');
GO

INSERT INTO Productos (Nombre, SKU, CategoriaId, Precio, Stock)
VALUES 

('Croquetas para perro Adulto 10kg', 'PER-ALIM-01', 1, 89.90, 40),
('Snack dental para perro - Grande', 'PER-SNK-01', 1, 15.50, 80),
('Correa reforzada antitirones', 'PER-ACC-01', 3, 25.00, 50),
('Cama acolchada para perro (L)', 'PER-ACC-02', 3, 79.90, 20),

('Alimento seco para gato 5kg', 'GAT-ALIM-01', 2, 55.00, 35),
('Arena sanitaria aglomerante 10L', 'GAT-HIG-01', 9, 22.00, 60),
('Rascador básico para gato', 'GAT-ACC-01', 4, 49.90, 15),

('Comedero para aves pequeño', 'AVE-ACC-01', 5, 9.00, 50),
('Bañera para aves mediana', 'AVE-ACC-02', 5, 18.00, 25),
('Mezcla de semillas premium 1kg', 'AVE-ALIM-01', 6, 14.50, 40),

('Pecera 40L con tapa', 'PEC-AQUA-01', 7, 120.00, 10),
('Alimento para peces tropicales 200g', 'PEC-FD-01', 7, 12.00, 55),
('Filtro sumergible pequeño', 'PEC-FLT-01', 7, 39.90, 18),

('Jaula para hámster básica', 'ROE-JAULA-01', 8, 75.00, 14),
('Alimento para hámster 1kg', 'ROE-ALIM-01', 8, 13.00, 25),

('Shampoo para perro y gato 500ml', 'HIG-SHAM-01', 9, 19.90, 30),
('Peine quitapelos metálico', 'HIG-PEINE-01', 9, 12.00, 35),

('Pelota de goma para perros', 'JUG-PER-01', 10, 8.00, 70),
('Pluma interactiva para gatos', 'JUG-GAT-01', 10, 15.00, 40);
GO

INSERT INTO Productos (Nombre, SKU, CategoriaId, Precio, Stock)
VALUES

('Croquetas cachorro 4kg', 'PER-ALIM-02', 1, 45.90, 60),
('Croquetas senior 10kg', 'PER-ALIM-03', 1, 95.00, 30),
('Comida húmeda lata 400g – Carne', 'PER-ALIM-04', 1, 8.50, 80),
('Comida húmeda lata 400g – Pollo', 'PER-ALIM-05', 1, 8.50, 90),

('Alimento húmedo para gato – Atún 120g', 'GAT-HUM-01', 2, 5.00, 120),
('Alimento húmedo para gato – Salmón 120g', 'GAT-HUM-02', 2, 5.20, 110),
('Snack crujiente para gato – Bolsita 60g', 'GAT-SNK-01', 2, 7.90, 80),
('Croquetas gato esterilizado 3kg', 'GAT-ALIM-02', 2, 42.00, 40),

('Collar de cuero (M)', 'PER-CLR-01', 3, 18.90, 50),
('Collar reflectante (S)', 'PER-CLR-02', 3, 12.50, 40),
('Arnés ajustable antitirón (L)', 'PER-ARN-01', 3, 34.90, 25),
('Abrigo impermeable para perro (M)', 'PER-ROP-01', 3, 55.00, 15),
('Cama ortopédica para perro (XL)', 'PER-CAM-03', 3, 110.00, 10),

('Collar con cascabel para gato', 'GAT-CLR-01', 4, 9.50, 70),
('Cama iglú para gato', 'GAT-CAM-01', 4, 65.00, 20),
('Rascador torre de dos niveles', 'GAT-RASC-02', 4, 140.00, 8),
('Arenero cerrado con filtro', 'GAT-ARE-01', 4, 59.90, 25),

('Bebedero para aves pequeño', 'AVE-BEB-01', 5, 6.00, 100),
('Juguete colgante de madera para aves', 'AVE-JUG-01', 5, 14.00, 40),
('Nido para periquitos', 'AVE-NID-01', 5, 22.00, 18),
('Percha de lija 20cm', 'AVE-PER-01', 5, 7.50, 60),

('Semilla para canarios 1kg', 'AVE-SEM-02', 6, 12.00, 50),
('Mezcla de semillas para pericos 1kg', 'AVE-SEM-03', 6, 11.00, 50),
('Suplemento vitamínico para aves 100ml', 'AVE-VIT-01', 6, 16.90, 30),
('Barritas de miel para aves – Pack 2', 'AVE-SNK-01', 6, 9.50, 35),

('Pecera 20L básica', 'PEC-P20-01', 7, 75.00, 12),
('Pecera 100L con tapa y luz LED', 'PEC-P100-01', 7, 280.00, 6),
('Decoración acuario – Castillo pequeño', 'PEC-DECO-01', 7, 22.00, 20),
('Calentador sumergible 50W', 'PEC-CAL-01', 7, 35.90, 15),
('Acondicionador de agua 250ml', 'PEC-ACD-01', 7, 18.00, 30),

('Rueda para hámster 18cm', 'ROE-RUE-01', 8, 20.00, 25),
('Casita de madera para hámster', 'ROE-CASA-01', 8, 30.90, 12),
('Sustrato viruta prensada 2kg', 'ROE-SUST-01', 8, 18.00, 30),
('Snacks para conejos – Zanahoria 80g', 'ROE-SNK-01', 8, 9.90, 40),

('Shampoo antipulgas 500ml', 'HIG-SHAM-02', 9, 21.90, 30),
('Toallitas húmedas para mascotas 50un', 'HIG-TLL-01', 9, 12.00, 45),
('Cortaúñas para perros y gatos', 'HIG-CUT-01', 9, 14.50, 35),
('Perfume para perros – Vainilla 120ml', 'HIG-PERF-01', 9, 23.00, 18),

('Cuerda resistente para perros (M)', 'JUG-CUE-01', 10, 18.00, 50),
('Pelota sonora para gatos', 'JUG-PEL-01', 10, 10.00, 60),
('Ratón de felpa para gatos', 'JUG-RAT-01', 10, 6.50, 80),
('Juguete interactivo para perro – Kong M', 'JUG-KNG-01', 10, 42.00, 20),
('Tunel plegable para gatos', 'JUG-TUN-01', 10, 38.00, 15);
GO

ALTER TABLE Usuarios DROP COLUMN PasswordHash;
ALTER TABLE Usuarios ADD Password NVARCHAR(50) NULL;
GO

UPDATE Usuarios SET Password = '123' WHERE Username = 'admin';
UPDATE Usuarios SET Password = '123' WHERE Username = 'vendedor1';
GO



-- Esto borra TODAS las ventas y sus detalles, dejando a los clientes "libres" para ser borrados.
DELETE FROM OrdenDetalle;
DELETE FROM Ordenes;
GO



