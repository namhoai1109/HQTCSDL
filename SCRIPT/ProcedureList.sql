use HQTCSDL2_EL
go
--									=============== Concurrency ===============
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


--									=============== Shipper ===============
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
-- GO

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
