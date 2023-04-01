use HQTCSDL_EL
go
--									=======================================
--									=============== Concurrency ===========
--									=======================================
-- CREATE PROCEDURE addOrder
-- @customerId int,
-- @shipperId int,
-- @partnerId int,
-- @createdAt DATETIME2,
-- @deliveredAt DATETIME2,
-- @status NVARCHAR(50),
-- @process NVARCHAR(50),
-- @orderPrice FLOAT(50),
-- @shippingPrice FLOAT(50),
-- @dishName NVARCHAR(50)




-- AS
-- BEGIN

-- DECLARE @orderID int

-- INSERT INTO [dbo].[Order] OUTPUT inserted.id 
-- values(@customerId,@shipperId,@partnerId,@createdAt ,@deliveredAt ,@status ,@process ,@orderPrice ,@shippingPrice )

-- --SELECT SCOPE_IDENTITY() as ID into @orderID 
-- set @orderID = @@IDENTITY

-- INSERT INTO [dbo].[OrderDetail] OUTPUT inserted.id
-- values(@orderID)



-- END



-- +) Customer.rateDish()
 CREATE PROCEDURE customerRateDish
     @customerId INT,
     @dishId INT,
     @isLike BIT,
     @description NVARCHAR(1000)

 AS
 BEGIN
     SET NOCOUNT ON;
    
     -- Check if the customer has already rated the dish
     IF EXISTS (SELECT * FROM Rating WHERE customerId = @customerId)
     BEGIN
         UPDATE Rating SET isLike = @isLike, description = @description, updatedAt = GETDATE()
         WHERE customerId = @customerId AND dishId = @dishId
     END
     ELSE
     BEGIN
         INSERT INTO Rating (isLike, createdAt, description, updatedAt, customerId, dishId)
         VALUES (@isLike, GETDATE(), @description, GETDATE(), @customerId, @dishId)
     END
 END
 GO

-- +) Shipper.getIncome()
 CREATE PROCEDURE shipperGetIncome
	 @shipperId INT
 AS
 BEGIN
	 SELECT SUM(shippingPrice) 
	 FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
	 WHERE shipperId = @shipperId AND MONTH(createdAt) = MONTH(GETDATE())
 END




-- +) Staff.updateContract()
 CREATE PROCEDURE StaffUpdateContract
     @contractId INT,
     @isConfirmed BIT
 AS
 BEGIN
     UPDATE [dbo].[Contract]
     SET [isConfirmed] = @isConfirmed , confirmedAt = GETDATE()
     WHERE [id] = @contractId
 END


 -- +) Partner.updateDish()
 CREATE PROCEDURE partnerUpdateDish
	 @dishId int,
	 @name NVARCHAR(50),
	 @description NVARCHAR(50),
	 @status NVARCHAR(50)

 AS
 BEGIN

	 UPDATE [dbo].[Dish] WITH (UPDLOCK, ROWLOCK)
	 SET name = @name, description = @description, status = @status
	 WHERE id = @dishId
 END
 

-- +) Partner.getIncome()
 CREATE PROCEDURE partnerGetIncome
 @partnerId INT

 AS
 BEGIN
	 SELECT SUM(orderPrice) AS INCOME
	 FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
	 WHERE partnerId = @partnerId AND month(createdAt) = MONTH(GETDATE())
 END




-- +) Partner.deleteDishDetail()

 CREATE PROCEDURE partnerDeleteDishDetail
 	@dishID INT
 AS
 BEGIN
 	DELETE [dbo].DishDetail
 	WHERE [id] = @dishID
 END
 GO


 -- +) Partner.getNumberOfOrders()
 CREATE PROCEDURE partnerGetNumberOfOrders
	@partnerId INT
 AS
 BEGIN
	 SELECT count(*) 
	 FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
	 WHERE partnerId = @partnerId AND month(createdAt) = MONTH(GETDATE())
 END
 GO

 
--+) Partner.updateOrder()

CREATE PROCEDURE partnerUpdateOrder
	@orderID INT,
	@status NVARCHAR(50)
AS
BEGIN
	UPDATE [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
	SET [status] = @status
	WHERE [id] = @orderID
END
GO
EXEC partnerUpdateOrder
GO

--									=======================================
--									=============== Shipper ===============
--									=======================================
-- register()

-- getOrders()    ==> PHẢI CÓ TRƯỜNG ĐỊA CHỈ CỦA ORDER
CREATE PROCEDURE shipperGetOrders
	  @shipperId INT
AS
BEGIN
    SELECT *
    FROM [dbo].[Order] orders
    INNER JOIN [dbo].[OrderDetail] ordetail ON orders.id = ordetail.orderId
    WHERE orders.shipperId = @shipperId
END
GO

EXEC shipperGetOrders 1
GO


-- confirmOrder()
CREATE PROCEDURE shipperConfirmOrder
	@orderId INT,
	@shipperId INT

AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND shipperId IS NULL AND status = 'Verified')
 		BEGIN
 			UPDATE[dbo].[Order]  WITH (UPDLOCK, ROWLOCK)
 			SET process = 'Preparing', shipperId = @shipperId
 			WHERE id = @orderId
 		END
	ELSE
	BEGIN
 		RAISERROR (N'Order has been confirmed by another shipper',16,1)
 		ROLLBACK
	END 
END
EXEC shipperConfirmOrder 1, 1
GO



-- getOrderHistory()
CREATE PROCEDURE shipperGetOrderHistory
    @shipperId INT
AS
BEGIN
    SELECT *
    FROM [dbo].[Order] AS o
    INNER JOIN [dbo].[OrderDetail] AS od ON o.id = od.orderId
    WHERE o.shipperId = @shipperId AND MONTH(o.createdAt) = MONTH(GETDATE())
END
GO
EXEC shipperGetOrderHistory 2
GO

-- getIncome()
CREATE PROCEDURE shipperGetIncome
	@shipperId INT
AS
BEGIN
	SELECT SUM(shippingPrice) 
	FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
	WHERE shipperId = @shipperId AND MONTH(createdAt) = MONTH(GETDATE())
END
GO
	EXEC shipperGetIncome 1
GO


-- updateOrder()
CREATE PROCEDURE shipperUpdateOrder
	@orderId INT,
	@shipperId INT

AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND shipperId = @shipperId AND status = 'Verified' AND process = 'Preparing')
 		BEGIN
 			UPDATE[dbo].[Order]  WITH (UPDLOCK, ROWLOCK)
 			SET process = 'Shipping'
 			WHERE id = @orderId
 		END
	ELSE
	BEGIN
 		RAISERROR (N'Something went wrong!',16,1)
 		ROLLBACK
	END 
END
GO

-- confirmShipped()
CREATE PROCEDURE shipperconfirmShipped
	@orderId INT,
	@shipperId INT

AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND AND shipperId = @shipperId AND status = 'Verified' AND process = 'Shipping')
 		BEGIN
 			UPDATE[dbo].[Order]  WITH (UPDLOCK, ROWLOCK)
 			SET process = 'Shipped'
 			WHERE id = @orderId
 		END
	ELSE
	BEGIN
 		RAISERROR (N'Something went wrong!',16,1)
 		ROLLBACK
	END 
END
GO

-- updateProfile()
CREATE PROCEDURE shipperUpdateProfile
	@shipperId INT,
	@districtId INT,
	@name NVARCHAR(100),
	@nationalId NVARCHAR(100),
	@phone NVARCHAR(100),
	@address NVARCHAR(100),
	@licensePlate NVARCHAR(100),
	@bankAccount NVARCHAR(100)
AS
BEGIN
	UPDATE[dbo].[Shipper]  WITH (UPDLOCK, ROWLOCK)
	SET [districtId] = @districtId, [name] = @name, 
 		[nationalId] = @nationalId, [phone] = @phone, 
 		[address]= @address, [licensePlate] = @licensePlate,
 		[bankAccount] = @bankAccount
	WHERE id = @shipperId
END
GO

--									=======================================
--									=============== Customer ===============
--									=======================================

-- updateProfile()
CREATE PROCEDURE customerUpdateProfile
	@customerId INT,
	
	@name NVARCHAR(100),
	@address NVARCHAR(100),
	@phone NVARCHAR(100),
	@email NVARCHAR(100)
AS
BEGIN
	UPDATE[dbo].[Customer]  WITH (UPDLOCK, ROWLOCK)
	SET [name] = @name, [address]= @address,
 		[phone] = @phone, [email] = @email
	WHERE [id] = @customerId
END
GO

-- viewOrderDetail()
CREATE PROCEDURE customerViewOrderDetail
	@orderId INT
AS
BEGIN
	SELECT *
    FROM [dbo].[Order] AS o
    INNER JOIN [dbo].[OrderDetail] AS od ON o.id = od.orderId
    WHERE o.id = @orderId
END
GO
EXEC customerViewOrderDetail 1
GO

-- cancelOrder()
CREATE PROCEDURE customerCancelOrder
	@orderId INT
AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND status = 'Pending')
 		BEGIN
       
        DELETE FROM [dbo].[Order] WHERE [id] = @orderId
    END
    ELSE
    BEGIN
        PRINT N' --> This order cannot be DELETED, as it has already been CONFIRMED';  
    END
END
GO
EXEC customerCancelOrder 1
GO

--									=======================================
--									=============== Partner ===============
--									=======================================

-- getProfile
CREATE PROCEDURE partnergetProfile
	@partnerId INT
AS
BEGIN
	SELECT * FROM [dbo].[Partner]
	WHERE [id] = @partnerId
END
GO

-- updateProfile
CREATE PROCEDURE partnerUpdateProfile
	@partnerId INT,
	
	@email NVARCHAR(100),
	@bankAccount NVARCHAR(100),
	@representative NVARCHAR(100),
	@phone NVARCHAR(100),
	@orderQuantity INT,
	@brandName NVARCHAR(100),
	@status NVARCHAR(100),
	@culinaryStyle NVARCHAR(100)
		
AS
BEGIN
	UPDATE[dbo].[Partner]  WITH (UPDLOCK, ROWLOCK)
	SET [email] = @email, [bankAccount]= @bankAccount,
 		[representative] = @representative, [phone] = @phone,
		[orderQuantity] = @orderQuantity, [brandName] = @brandName,
		[status] = @status, [culinaryStyle] = @culinaryStyle
	WHERE [id] = @partnerId
END
GO

-- getDishes
CREATE PROCEDURE partnerGetDishes
	@dishId INT
AS
BEGIN
	SELECT * FROM [dbo].[Dish] 
	WHERE [id] = @dishId AND [status] = 'In stock'
END
GO
EXEC partnerGetDishes 1
GO

-- deleteDish
CREATE PROCEDURE partnerDeleteDish
	@dishId INT
AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[Dish] WHERE id = @dishId AND [status] = 'Out of stock')
 		BEGIN
        DELETE FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK) WHERE [id] = @dishId
    END
    ELSE
    BEGIN
        PRINT N' --> This dish cannot be DELETED';  
    END
END
GO

-- getDishDetail
CREATE PROCEDURE partnerGetDishDetail
	@dishId INT
AS
BEGIN
	SELECT *
    FROM [dbo].[Dish] AS o
    INNER JOIN [dbo].[DishDetail] AS od ON o.id = od.dishId
    WHERE o.id = @dishId
END
GO
EXEC partnerGetDishDetail 1
GO
-- deleteOrder
CREATE PROCEDURE partnerDeleteOrder
	@orderId INT,
    @partnerId INT
AS
BEGIN
	UPDATE[dbo].[Order]  WITH (UPDLOCK, ROWLOCK)
	SET [status] = 'Cancelled'
	WHERE id = @orderId AND [partnerId] = @partnerId
END
GO



GO
-- updateDishDetail
CREATE PROCEDURE partnerUpdateDishDetail
	@dishDetailId INT,
    @name NVARCHAR(50),
    @price FLOAT(53)
AS
BEGIN
	UPDATE[dbo].[DishDetail]  WITH (UPDLOCK, ROWLOCK)
	SET [price] = @price, [name] = @name
	WHERE id = @dishDetailId
END
GO



-- getOrders()
CREATE PROCEDURE partnerGetOrders
	@id INT
AS
BEGIN
	SELECT * FROM [dbo].[Order]
    WHERE [partnerId] = id AND [status] = 'Pending'
END
GO


