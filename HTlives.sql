Create Database HTLivestream
Go
use HTLivestream
Go
-- 1. Thực thể Khách hàng (Trích xuất từ D3)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE,
    Email VARCHAR(100),
    Address NVARCHAR(MAX),
    SocialMediaID VARCHAR(50) UNIQUE, 
    TrustScore INT DEFAULT 100,      
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 2. Thực thể Sản phẩm (Trích xuất từ D2)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(200) NOT NULL,
    BasePrice DECIMAL(15, 2) NOT NULL,
    Keyword_ChotDon NVARCHAR(50) NOT NULL, 
    Category NVARCHAR(50),
    IsActive BIT DEFAULT 1
);

-- 3. Thực thể Kho hàng (Trích xuất từ D2)
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT UNIQUE,
    PhysicalStock INT NOT NULL DEFAULT 0, 
    HoldStock INT NOT NULL DEFAULT 0,     
    Location NVARCHAR(100),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT CHK_Inventory_Logic CHECK (PhysicalStock >= 0)
);

-- 4. Thực thể Phiên Livestream (Trích xuất từ D4)
CREATE TABLE LivestreamSessions (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(200),
    StartTime DATETIME NOT NULL,
    EndTime DATETIME,
    Platform NVARCHAR(50) DEFAULT 'Facebook',
    HostName NVARCHAR(100),
    Status NVARCHAR(20) DEFAULT 'Scheduled' -- SQL Server không có kiểu ENUM mặc định
);

-- 5. Thực thể Tương tác (Trích xuất từ D4)
CREATE TABLE Interactions (
    InteractionID INT PRIMARY KEY IDENTITY(1,1),
    SessionID INT,
    CustomerID INT NULL, 
    SocialMediaAccount NVARCHAR(100), 
    CommentText NVARCHAR(MAX),
    InteractionTime DATETIME DEFAULT GETDATE(),
    IsProcessed BIT DEFAULT 0, 
    FOREIGN KEY (SessionID) REFERENCES LivestreamSessions(SessionID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 6. Thực thể Đơn hàng (Trích xuất từ D1)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    SessionID INT NULL, 
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(15, 2),
    OrderStatus NVARCHAR(50) DEFAULT 'Pending',
    PaymentStatus NVARCHAR(50) DEFAULT 'Unpaid',
    ShippingCode VARCHAR(50), 
    Source NVARCHAR(50) DEFAULT 'Website',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SessionID) REFERENCES LivestreamSessions(SessionID)
);

-- 7. Thực thể Chi tiết đơn hàng (Trích xuất từ D1)
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
