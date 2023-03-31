create database HQTCSDL1
go
use HQTCSDL1
go

BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[Account] (
    [id] INT NOT NULL IDENTITY(1,1),
    [username] NVARCHAR(1000) NOT NULL UNIQUE,
    [password] NVARCHAR(1000) NOT NULL,
    [role] NVARCHAR(1000) NOT NULL ,
    [confirmed] BIT NOT NULL CONSTRAINT [Account_confirmed_df] DEFAULT 0,
    [confirmCode] NVARCHAR(1000) UNIQUE,
    [status] NVARCHAR(1000) NOT NULL CONSTRAINT [Account_status_df] DEFAULT 'active',
    CONSTRAINT [Account_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Account_username_key] UNIQUE NONCLUSTERED ([username])
);

-- CreateTable
CREATE TABLE [dbo].[Customer] (
    [id] INT NOT NULL IDENTITY(1,1),
    [accountId] INT NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    [address] NVARCHAR(1000) NOT NULL,
    [phone] NVARCHAR(1000) NOT NULL,
    [email] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Customer_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Customer_accountId_key] UNIQUE NONCLUSTERED ([accountId]),
    CONSTRAINT [Customer_email_key] UNIQUE NONCLUSTERED ([email]),
    CONSTRAINT [Customer_phone_key] UNIQUE NONCLUSTERED ([phone])
);

-- CreateTable
CREATE TABLE [dbo].[Partner] (
    [id] INT NOT NULL IDENTITY(1,1),
    [accountId] INT NOT NULL,
    [contractId] INT,
    [email] NVARCHAR(1000) NOT NULL,
    [bankAccount] NVARCHAR(1000) NOT NULL,
    [representative] NVARCHAR(1000),
    [phone] NVARCHAR(1000) NOT NULL,
    [orderQuantity] INT,
    [brandName] NVARCHAR(1000) NOT NULL,
    [status] NVARCHAR(1000),
    [culinaryStyle] NVARCHAR(1000),
    CONSTRAINT [Partner_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Partner_accountId_key] UNIQUE NONCLUSTERED ([accountId]),
    CONSTRAINT [Partner_contractId_key] UNIQUE NONCLUSTERED ([contractId]),
    CONSTRAINT [Partner_email_key] UNIQUE NONCLUSTERED ([email]),
    CONSTRAINT [Partner_phone_key] UNIQUE NONCLUSTERED ([phone]),
    CONSTRAINT [Partner_bankAccount_key] UNIQUE NONCLUSTERED ([bankAccount])
);

-- CreateTable
CREATE TABLE [dbo].[Shipper] (
    [id] INT NOT NULL IDENTITY(1,1),
    [accountId] INT NOT NULL,
    [districtId] INT NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    [nationalId] NVARCHAR(1000) NOT NULL,
    [phone] NVARCHAR(1000) NOT NULL,
    [licensePlate] NVARCHAR(1000),
    [address] NVARCHAR(1000),
    [bankAccount] NVARCHAR(1000),
    CONSTRAINT [Shipper_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Shipper_accountId_key] UNIQUE NONCLUSTERED ([accountId]),
    CONSTRAINT [Shipper_nationalId_key] UNIQUE NONCLUSTERED ([nationalId]),
    CONSTRAINT [Shipper_phone_key] UNIQUE NONCLUSTERED ([phone]),
    CONSTRAINT [Shipper_licensePlate_key] UNIQUE NONCLUSTERED ([licensePlate]),
    CONSTRAINT [Shipper_bankAccount_key] UNIQUE NONCLUSTERED ([bankAccount])
);

-- CreateTable
CREATE TABLE [dbo].[Contract] (
    [id] INT NOT NULL IDENTITY(1,1),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Contract_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [confirmedAt] DATETIME2,
    [expiredAt] DATETIME2,
    [isConfirmed] BIT NOT NULL CONSTRAINT [Contract_isConfirmed_df] DEFAULT 0,
    [isExpired] BIT NOT NULL CONSTRAINT [Contract_isExpired_df] DEFAULT 0,
    [taxCode] NVARCHAR(1000) NOT NULL,
    [representative] NVARCHAR(1000),
    [accessCode] NVARCHAR(1000),
    [bankAccount] NVARCHAR(1000),
    CONSTRAINT [Contract_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Contract_taxCode_key] UNIQUE NONCLUSTERED ([taxCode]),
    CONSTRAINT [Contract_accessCode_key] UNIQUE NONCLUSTERED ([accessCode]),
    CONSTRAINT [Contract_bankAccount_key] UNIQUE NONCLUSTERED ([bankAccount])
);

-- CreateTable
CREATE TABLE [dbo].[Branch] (
    [id] INT NOT NULL IDENTITY(1,1),
    [partnerId] INT NOT NULL,
    [districtId] INT NOT NULL,
    [orderNumber] INT,
    [address] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Branch_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Dish] (
    [id] INT NOT NULL IDENTITY(1,1),
    [partnerId] INT NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    [description] NVARCHAR(1000),
    [status] NVARCHAR(1000),
    [rating] INT,
    CONSTRAINT [Dish_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[DishDetail] (
    [id] INT NOT NULL IDENTITY(1,1),
    [dishId] INT NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    [price] FLOAT(53) NOT NULL,
    CONSTRAINT [DishDetail_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Order] (
    [id] INT NOT NULL IDENTITY(1,1),
    [customerId] INT NOT NULL,
    [shipperId] INT,
    [partnerId] INT NOT NULL,
    [status] NVARCHAR(1000) NOT NULL CONSTRAINT [Order_status_df] DEFAULT 'pending',
    [process] NVARCHAR(1000) NOT NULL CONSTRAINT [Order_process_df] DEFAULT 'pending',
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Order_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [deliveredAt] DATETIME2,
    [orderPrice] FLOAT(53) NOT NULL,
    [shippingPrice] FLOAT(53),
    CONSTRAINT [Order_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[OrderDetail] (
    [id] INT NOT NULL IDENTITY(1,1),
    [orderId] INT NOT NULL,
    [dishName] NVARCHAR(1000) NOT NULL,
    [dishDetail] NVARCHAR(1000) NOT NULL,
    [quantity] INT NOT NULL,
    [price] FLOAT(53) NOT NULL,
    CONSTRAINT [OrderDetail_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[City] (
    [id] INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [City_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [City_name_key] UNIQUE NONCLUSTERED ([name])
);

-- CreateTable
CREATE TABLE [dbo].[District] (
    [id] INT NOT NULL IDENTITY(1,1),
    [cityId] INT NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [District_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Rating] (
    [customerId] INT NOT NULL,
    [description] NVARCHAR(1000),
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Rating_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    [isLike] BIT NOT NULL,
    [dishId] INT NOT NULL,
    CONSTRAINT [Rating_pkey] PRIMARY KEY CLUSTERED ([customerId],[dishId])
);

-- AddForeignKey
ALTER TABLE [dbo].[Customer] ADD CONSTRAINT [Customer_accountId_fkey] FOREIGN KEY ([accountId]) REFERENCES [dbo].[Account]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Partner] ADD CONSTRAINT [Partner_accountId_fkey] FOREIGN KEY ([accountId]) REFERENCES [dbo].[Account]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Partner] ADD CONSTRAINT [Partner_contractId_fkey] FOREIGN KEY ([contractId]) REFERENCES [dbo].[Contract]([id]) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Shipper] ADD CONSTRAINT [Shipper_accountId_fkey] FOREIGN KEY ([accountId]) REFERENCES [dbo].[Account]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Shipper] ADD CONSTRAINT [Shipper_districtId_fkey] FOREIGN KEY ([districtId]) REFERENCES [dbo].[District]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Branch] ADD CONSTRAINT [Branch_partnerId_fkey] FOREIGN KEY ([partnerId]) REFERENCES [dbo].[Partner]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Branch] ADD CONSTRAINT [Branch_districtId_fkey] FOREIGN KEY ([districtId]) REFERENCES [dbo].[District]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Dish] ADD CONSTRAINT [Dish_partnerId_fkey] FOREIGN KEY ([partnerId]) REFERENCES [dbo].[Partner]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[DishDetail] ADD CONSTRAINT [DishDetail_dishId_fkey] FOREIGN KEY ([dishId]) REFERENCES [dbo].[Dish]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Order] ADD CONSTRAINT [Order_customerId_fkey] FOREIGN KEY ([customerId]) REFERENCES [dbo].[Customer]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Order] ADD CONSTRAINT [Order_shipperId_fkey] FOREIGN KEY ([shipperId]) REFERENCES [dbo].[Shipper]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Order] ADD CONSTRAINT [Order_partnerId_fkey] FOREIGN KEY ([partnerId]) REFERENCES [dbo].[Partner]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[OrderDetail] ADD CONSTRAINT [OrderDetail_orderId_fkey] FOREIGN KEY ([orderId]) REFERENCES [dbo].[Order]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[District] ADD CONSTRAINT [District_cityId_fkey] FOREIGN KEY ([cityId]) REFERENCES [dbo].[City]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Rating] ADD CONSTRAINT [Rating_customerId_fkey] FOREIGN KEY ([customerId]) REFERENCES [dbo].[Customer]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE [dbo].[Rating] ADD CONSTRAINT [Rating_dishId_fkey] FOREIGN KEY ([dishId]) REFERENCES [dbo].[Dish]([id]) ON DELETE CASCADE ON UPDATE CASCADE;




COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH


INSERT INTO [dbo].[City]([name]) OUTPUT inserted.ID values(N'Hồ Chí Minh')
INSERT INTO [dbo].[City]([name]) OUTPUT inserted.ID values(N'Hà Nội')
INSERT INTO [dbo].[City]([name]) OUTPUT inserted.ID values(N'Nha Trang')
INSERT INTO [dbo].[City]([name]) OUTPUT inserted.ID values(N'Đà Nẵng')

INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(01,N'Quận 1')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(01,N'Quận 2')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(01,N'Quận 3')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(01,N'Quận 4')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(02,N'Quận Hoàn Kiếm')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(02,N'Quận Đống Đa')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(02,N'Quận Thanh Xuân')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(02,N'Quận Hà Đông')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(03,N'Vĩnh Hòa')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(03,N'Vĩnh Phước')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(03,N'Vĩnh Hải')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(03,N'Vĩnh Thọ')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(04,N'Hải Châu')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(04,N'Cẩm Lệ')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(04,N'Thanh Khê')
INSERT INTO [dbo].[District]([cityId],[name]) OUTPUT inserted.ID values(04,N'Sơn Trà')

INSERT INTO [dbo].[Account](username, [password], [role],[confirmed],[confirmCode], [status]) OUTPUT inserted.ID values ('taixe1','taixe','taixe',0,'123456','active')
INSERT INTO [dbo].[Account](username, [password], [role],[confirmed],[confirmCode], [status]) OUTPUT inserted.ID values ('taixe2','taixe','taixe',0,'312645','active')
INSERT INTO [dbo].[Account](username, [password], [role],[confirmed],[confirmCode], [status]) OUTPUT inserted.ID values ('taixe3','taixe','taixe',0,'213456','active')
INSERT INTO [dbo].[Account](username, [password], [role],[confirmed],[confirmCode], [status]) OUTPUT inserted.ID values ('khach1','khachhang','khachhang',0,'987654','active')
INSERT INTO [dbo].[Account](username, [password], [role],[confirmed],[confirmCode], [status]) OUTPUT inserted.ID values ('khach2','khachhang','khachhang',0,'978564','active')
INSERT INTO [dbo].[Account](username, [password], [role],[confirmed],[confirmCode], [status]) OUTPUT inserted.ID values ('khach3','khachhang','khachhang',0,'983671','active')
INSERT INTO [dbo].[Account](username, [password], [role],[confirmed],[confirmCode], [status]) OUTPUT inserted.ID values ('doitac1','doitac','doitac',0,'382914','active')
INSERT INTO [dbo].[Account](username, [password], [role],[confirmed],[confirmCode], [status]) OUTPUT inserted.ID values ('doitac2','doitac','doitac',0,'917823','active')
INSERT INTO [dbo].[Account](username, [password], [role],[confirmed],[confirmCode], [status]) OUTPUT inserted.ID values ('doitac3','doitac','doitac',0,'123753','active')

INSERT INTO [dbo].[Shipper] OUTPUT inserted.ID values (01,02,N'Nguyễn Văn A','123123321321','0123456789', '59D657892','227 Nguyen Van Cu', '9867986712341234')
INSERT INTO [dbo].[Shipper] OUTPUT inserted.ID values (02,02,N'Nguyễn Văn B','758111928099','0987654321', '59F123456','227 Dien Bien Phu', '4536728192873024')
INSERT INTO [dbo].[Shipper] OUTPUT inserted.ID values (03,04,N'Nguyễn Văn C','102111928293','0123123421', '59A987654','123 Tran Hung Dao', '1234897859172101')

INSERT INTO [dbo].[Contract] OUTPUT inserted.ID values( GETDATE(),null,null,0,0,'8271892819', N'Nguyễn Huỳnh Mẫn', '551717', '9817293085828371')
INSERT INTO [dbo].[Contract] OUTPUT inserted.ID values( GETDATE(),null,null,0,0,'8291829187', N'Nguyễn Hồ Trung Hiếu', '1231223', '4627110829189840')
INSERT INTO [dbo].[Contract] OUTPUT inserted.ID values( GETDATE(),null,null,0,0,'1829908118', N'Thiều Vĩnh Trung', '551718', '40198568920129130')

INSERT INTO [dbo].[Partner] OUTPUT inserted.ID values (07, 01,'abc@gmail.com', '9817293085828371', N'Nguyễn Huỳnh Mẫn', '087691920192', 20, N'CAFE N GO','active','Nuoc')
INSERT INTO [dbo].[Partner] OUTPUT inserted.ID values (08, 02,'xyz@gmail.com', '4627110829189840', N'Nguyễn Hồ Trung Hiếu', '0777058016', 20, N'GO CAFE','active', 'Nuoc')
INSERT INTO [dbo].[Partner] OUTPUT inserted.ID values (09, 03,'def@gmail.com', '40198568920129130', N'Thiều Vĩnh Trung', '013458910291', 25, N'3 MIEN','active', 'Thuc An')

INSERT INTO [dbo].[Customer] OUTPUT inserted.ID values (04,N'Tran Thi A', N'400 Điện Biên Phủ, HCM','09810238912','hello@gmail.com')
INSERT INTO [dbo].[Customer] OUTPUT inserted.ID values (05,N'Tran Thi B', N'250 Trần Hưng đạo','09898798798','hello1@gmail.com')
INSERT INTO [dbo].[Customer] OUTPUT inserted.ID values (06,N'Tran Thi C', N'1000 Trường Chinh','09879872231','hello2@gmail.com')

INSERT INTO [dbo].[Branch] OUTPUT inserted.ID values (01, 04, 1,'227 Nguyen Van Cu')
INSERT INTO [dbo].[Branch] OUTPUT inserted.ID values (01, 01, 2,'210 Tran Hung Dao')
INSERT INTO [dbo].[Branch] OUTPUT inserted.ID values (02, 02, 1,'550 Truong Son')
INSERT INTO [dbo].[Branch] OUTPUT inserted.ID values (03, 01, 1,'100 Nam Ky Khoi Nghia')

INSERT INTO [dbo].[Dish] OUTPUT inserted.ID values (01,N'Soba Noodle',N'Cold Noodle', 'In stock',null)
INSERT INTO [dbo].[Dish] OUTPUT inserted.ID values (01,N'Instant Noodle',N'Hảo Hảo Noodle','In stock',null)
INSERT INTO [dbo].[Dish] OUTPUT inserted.ID values (02,N'Ramen Noodle',N'Water Noodle','In stock',null)
INSERT INTO [dbo].[Dish] OUTPUT inserted.ID values (02,N'Udon Noodle',N'Water Noodle','In stock',null)
INSERT INTO [dbo].[Dish] OUTPUT inserted.ID values (03,N'Yakisoba',N'Fried Noodle','In stock',null)
INSERT INTO [dbo].[Dish] OUTPUT inserted.ID values (03,N'Katsudon',N'Fried Meat','In stock',null)

INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (01,N'Default', 50000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (01,N'Add Egg', 15000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (01,N'Add green', 7000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (02,N'Default',50000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (02,N'Add Egg',15000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (02,N'Add green',7000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (03,N'Default',50000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (03,N'Add Egg',15000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (03,N'Add green',7000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (04,N'Default',50000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (04,N'Add Egg',15000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (04,N'Add green',7000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (05,N'Default',50000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (05,N'Add Egg',15000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (05,N'Add green',7000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (06,N'Default',50000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (06,N'Add Egg',15000)
INSERT INTO [dbo].[DishDetail] OUTPUT inserted.ID values (06,N'Add green',7000)

INSERT INTO [dbo].[Order] OUTPUT inserted.ID values (01,null,01,'Pending', 'Pending', GETDATE(),null, 50000, 20000)
INSERT INTO [dbo].[Order] OUTPUT inserted.ID values (02,null,02,'Pending', 'Pending', GETDATE(),null, 50000, 25000)	
INSERT INTO [dbo].[Order] OUTPUT inserted.ID values (03,null,03,'Pending', 'Pending', GETDATE(),null, 50000, 25000)	

INSERT INTO [dbo].[Rating] values (01,'Delicious',GETDATE(),GETDATE(),1,1)
INSERT INTO [dbo].[Rating] values (02,'Delicious',GETDATE(),GETDATE(),1,1)
INSERT INTO [dbo].[Rating] values (03,'Delicious',GETDATE(),GETDATE(),1,1)
--Tạo thêm danhgia

--sửa lại unique ở id món,tùy chọn
INSERT INTO [dbo].[OrderDetail] values (1,N'Soba Noodle','Default',01,100000)
INSERT INTO [dbo].[OrderDetail] values (1,N'Instant Noodle','Default',02,100000)
INSERT INTO [dbo].[OrderDetail] values (1,N'Ramen Noodle','Default',04,100000)
INSERT INTO [dbo].[OrderDetail] values (2,N'Yakisoba','Default',02,100000)
INSERT INTO [dbo].[OrderDetail] values (2,N'Katsudon','Default',05,100000)

-- Used for drop the database
--use master 
--go
--alter database HQTCSDL3 set single_user with rollback immediate
--drop database HQTCSDL3