use HQTCSDL_DEMO
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
     IF EXISTS (SELECT * FROM [dbo].[Rating] WHERE customerId = @customerId)
     BEGIN
         UPDATE [dbo].[Rating] SET [isLike] = @isLike, [description] = @description, [updatedAt] = GETDATE()
         WHERE [customerId] = @customerId AND [dishId] = @dishId
     END
     ELSE
     BEGIN
         INSERT INTO [dbo].[Rating] (isLike, createdAt, description, updatedAt, customerId, dishId)
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
	 WHERE [id] = @shipperId AND MONTH(createdAt) = MONTH(GETDATE())
 END
 GO

 

-- +) Staff.updateContract()
 CREATE PROCEDURE StaffUpdateContract
     @contractId INT,
     @isConfirmed BIT
 AS
 BEGIN
     UPDATE [dbo].[Contract]
     SET [isConfirmed] = @isConfirmed , [confirmedAt] = GETDATE()
     WHERE [id] = @contractId
 END
 GO

 -- +) Partner.updateDish()
 CREATE PROCEDURE partnerUpdateDish
	 @dishId int,
	 @name NVARCHAR(50),
	 @description NVARCHAR(50),
	 @status NVARCHAR(50)

 AS
 BEGIN

	 UPDATE [dbo].[Dish] WITH (UPDLOCK, ROWLOCK)
	 SET [name] = @name, [description] = @description, [status] = @status
	 WHERE [id] = @dishId
 END
 

-- +) Partner.getIncome()
 CREATE PROCEDURE partnerGetIncome
	@partnerId INT

 AS
 BEGIN
	 SELECT SUM(orderPrice) AS INCOME
	 FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
	 WHERE [partnerId] = @partnerId AND month(createdAt) = MONTH(GETDATE())
 END
 GO



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
	BEGIN TRAN
		BEGIN TRY
			SELECT *
			FROM [dbo].[Order] orders
			INNER JOIN [dbo].[OrderDetail] ordetail ON orders.[id] = ordetail.[orderId]
			JOIN [dbo].[Branch] b ON orders.[branchId] = b.[id] 
			WHERE orders.[shipperId] = @shipperId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
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
	IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND shipperId IS NULL AND status = 'confirmed')
 		BEGIN
 			UPDATE[dbo].[Order]  WITH (UPDLOCK, ROWLOCK)
 			SET process = 'preparing', shipperId = @shipperId
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
	IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND shipperId = @shipperId AND status = 'confirmed' AND process = 'preparing')
 		BEGIN
 			UPDATE[dbo].[Order]  WITH (UPDLOCK, ROWLOCK)
 			SET process = 'shipping'
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
	IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND AND shipperId = @shipperId AND status = 'confirmed' AND process = 'shipping')
 		BEGIN
 			UPDATE[dbo].[Order]  WITH (UPDLOCK, ROWLOCK)
 			SET process = 'shipped'
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
	@address NVARCHAR(100),
	@licensePlate NVARCHAR(100)
AS
BEGIN
	UPDATE[dbo].[Shipper]  WITH (UPDLOCK, ROWLOCK)
	SET [districtId] = @districtId, [name] = @name, 
 		[address]= @address, [licensePlate] = @licensePlate,
 		
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
	@address NVARCHAR(100)
	
AS
BEGIN
	UPDATE[dbo].[Customer]  WITH (UPDLOCK, ROWLOCK)
	SET [name] = @name, [address]= @address
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
	IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND status = 'pending')
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
	
	@representative NVARCHAR(100),
	@orderQuantity INT,
	@brandName NVARCHAR(100),
	@status NVARCHAR(100),
	@culinaryStyle NVARCHAR(100)
		
AS
BEGIN
	UPDATE[dbo].[Partner]  WITH (UPDLOCK, ROWLOCK)
	SET [representative] = @representative,
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
	WHERE [id] = @dishId AND [status] = 'in stock'
END
GO
EXEC partnerGetDishes 1
GO

-- deleteDish
CREATE PROCEDURE partnerDeleteDish
	@dishId INT
AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[Dish] WHERE id = @dishId AND [status] = 'out of stock')
 		BEGIN
        DELETE FROM [dbo].[Dish] WITH (UPDLOCK, ROWLOCK) WHERE [id] = @dishId
        DELETE FROM [dbo].[DishDetail] WITH (UPDLOCK, ROWLOCK) WHERE [dishId] = @dishId
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
	SET [status] = 'cancelled'
	WHERE id = @orderId AND [partnerId] = @partnerId
END
GO



GO
-- updateDishDetail
CREATE PROCEDURE partnerUpdateDishDetail
	@dishDetailId INT,
    @name NVARCHAR(50),
    @price FLOAT(53),
	@quantity INT
AS
BEGIN
	UPDATE[dbo].[DishDetail]  WITH (UPDLOCK, ROWLOCK)
	SET [price] = @price, [name] = @name, [quantity] = @quantity
	WHERE id = @dishDetailId
END
GO



-- getOrders()
CREATE PROCEDURE partnerGetOrders
	@partnerId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			SELECT * FROM [dbo].[Order] o JOIN [dbo].OrderDetail od ON  o.[id] = od.[orderId]
										JOIN [dbo].Branch b ON o.branchId = b.id
			WHERE b.[partnerId] = @partnerId
			
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO



