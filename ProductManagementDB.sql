-- Create the Products database
CREATE DATABASE ProductManagement;
GO

USE ProductManagement;
GO

-- Create Products table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Barcode NVARCHAR(50) NULL,
    Price DECIMAL(10, 2) NULL,
    Description NVARCHAR(MAX) NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- Insert sample data
INSERT INTO Products (Name, Barcode, Price, Description)
VALUES 
('Oishi Prawn Crackers', '4800194151000', 1.99, 'Crispy prawn-flavored crackers'),
('Oishi Potato Chips', '4800194152000', 2.49, 'Classic potato chips'),
('Coca-Cola', '5449000000996', 1.29, 'Classic cola drink'),
('Oreo Cookies', '7622300335823', 3.99, 'Chocolate sandwich cookies'),
('Del Monte Corn', '24000141822', 1.79, 'Canned sweet corn');
GO

-- Create stored procedures for CRUD operations

-- Get all products
CREATE PROCEDURE GetAllProducts
AS
BEGIN
    SELECT ProductID, Name, Barcode, Price, Description, CreatedDate
    FROM Products
    ORDER BY Name;
END
GO

-- Get product by ID
CREATE PROCEDURE GetProductByID
    @ProductID INT
AS
BEGIN
    SELECT ProductID, Name, Barcode, Price, Description, CreatedDate
    FROM Products
    WHERE ProductID = @ProductID;
END
GO

-- Insert new product
CREATE PROCEDURE InsertProduct
    @Name NVARCHAR(100),
    @Barcode NVARCHAR(50) = NULL,
    @Price DECIMAL(10, 2) = NULL,
    @Description NVARCHAR(MAX) = NULL
AS
BEGIN
    INSERT INTO Products (Name, Barcode, Price, Description)
    VALUES (@Name, @Barcode, @Price, @Description);
    
    SELECT SCOPE_IDENTITY() AS ProductID;
END
GO

-- Update existing product
CREATE PROCEDURE UpdateProduct
    @ProductID INT,
    @Name NVARCHAR(100),
    @Barcode NVARCHAR(50) = NULL,
    @Price DECIMAL(10, 2) = NULL,
    @Description NVARCHAR(MAX) = NULL
AS
BEGIN
    UPDATE Products
    SET Name = @Name,
        Barcode = @Barcode,
        Price = @Price,
        Description = @Description
    WHERE ProductID = @ProductID;
END
GO

-- Delete product
CREATE PROCEDURE DeleteProduct
    @ProductID INT
AS
BEGIN
    DELETE FROM Products
    WHERE ProductID = @ProductID;
END
GO

-- Search products
CREATE PROCEDURE SearchProducts
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    SELECT ProductID, Name, Barcode, Price, Description, CreatedDate
    FROM Products
    WHERE Name LIKE '%' + @SearchTerm + '%'
       OR Barcode LIKE '%' + @SearchTerm + '%'
    ORDER BY Name;
END
GO

-- Check if barcode exists
CREATE PROCEDURE CheckBarcodeExists
    @Barcode NVARCHAR(50),
    @ProductID INT = NULL
AS
BEGIN
    IF @ProductID IS NULL
    BEGIN
        -- For new products
        SELECT COUNT(*) AS BarcodeCount
        FROM Products
        WHERE Barcode = @Barcode AND Barcode IS NOT NULL;
    END
    ELSE
    BEGIN
        -- For existing products (exclude current product)
        SELECT COUNT(*) AS BarcodeCount
        FROM Products
        WHERE Barcode = @Barcode AND ProductID != @ProductID AND Barcode IS NOT NULL;
    END
END
GO