use HQTCSDL_DEMO
go

-- ===========================================
-- =============== Concurrency ===============
-- ===========================================
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
	 BEGIN TRAN
		BEGIN TRY
		 -- Check if the customer has already rated the dish
			 IF EXISTS (SELECT * FROM [dbo].[Rating] WHERE [customerId] = @customerId and [dishId] = @dishId)
			 BEGIN
				 UPDATE [dbo].[Rating] SET [isLike] = @isLike, [description] = @description, [updatedAt] = GETDATE()
				 WHERE [customerId] = @customerId AND [dishId] = @dishId
			 END
			 ELSE
			 BEGIN
				 INSERT INTO [dbo].[Rating] ([isLike], [createdAt], [description], [customerId], [dishId])
				 VALUES (@isLike, GETDATE(), @description, @customerId, @dishId)
			 END
			 COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
 END
 GO

-- +) Staff.updateContract()
 CREATE PROCEDURE staffUpdateContract
     @contractId INT,
     @isConfirmed BIT
 AS
 BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[Contract]
			SET [isConfirmed] = @isConfirmed , [confirmedAt] = GETDATE()
			WHERE [id] = @contractId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
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
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[Dish] WITH (UPDLOCK)
			SET [name] = @name, [description] = @description, [status] = @status
			WHERE [id] = @dishId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
 END
 GO
 
-- +) Partner.getIncome() 
 CREATE PROCEDURE partnerGetIncome
	@partnerId INT
 AS
 BEGIN
	BEGIN TRAN
		BEGIN TRY
			    SELECT SUM(o.orderPrice) 
				FROM [dbo].[Order] o
				INNER JOIN [dbo].[Branch] b ON o.[branchId] = b.id
				INNER JOIN [dbo].[Partner] p ON b.[partnerId] = p.id
				WHERE p.id = @partnerId AND month(createdAt) = MONTH(GETDATE())
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
 END
 GO

-- +) Partner.deleteDishDetail()
 CREATE PROCEDURE partnerDeleteDishDetail
 	@dishDetailId INT
 AS
 BEGIN
	BEGIN TRAN
		BEGIN TRY
 			DELETE [dbo].DishDetail
 			WHERE [id] = @dishDetailId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
 END
 GO

 -- +) Partner.getNumberOfOrders()
 CREATE PROCEDURE partnerGetNumberOfOrders
	@partnerId INT
 AS
 BEGIN
 BEGIN TRAN
		BEGIN TRY
			SELECT SUM(b.[orderQuantity]) as numberOfOrders
			FROM [dbo].[Partner] p
			JOIN [dbo].[Branch] b ON p.id = b.partnerId
			JOIN [dbo].[Order] o ON b.id = o.branchId
			WHERE [branchId] = @partnerId AND MONTH(createdAt) = MONTH(GETDATE())
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
 END
 GO
 EXEC partnerGetNumberOfOrders 1
GO


--+) Partner.updateOrder()
CREATE PROCEDURE partnerUpdateOrder
	@orderID INT,
	@status NVARCHAR(50)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE [dbo].[Order] WITH (UPDLOCK)
			SET [status] = @status
			WHERE [id] = @orderID
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- ========================================
-- =============== Shipper ================
--=========================================
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

-- confirmOrder()
CREATE PROCEDURE shipperConfirmOrder
	@orderId INT,
	@shipperId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND shipperId IS NULL AND status = 'confirmed')
 				BEGIN
 					UPDATE[dbo].[Order] WITH (UPDLOCK)
 					SET process = 'taken', shipperId = @shipperId
 					WHERE id = @orderId
 				END
			ELSE
			BEGIN
 				RAISERROR (N'Something went wrong',16,1)
 				ROLLBACK
			END 
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- getOrderHistory()
CREATE PROCEDURE shipperGetOrderHistory
    @shipperId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			SELECT *
			FROM [dbo].[Order] AS o
			JOIN [dbo].[OrderDetail] AS od ON o.id = od.orderId
			WHERE o.shipperId = @shipperId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- getIncome()
 CREATE PROCEDURE shipperGetIncome
	 @shipperId INT
 AS
 BEGIN
	BEGIN TRAN
		BEGIN TRY
			SELECT SUM(shippingPrice) 
			FROM [dbo].[Order] WITH (ROWLOCK)
			WHERE [shipperId] = @shipperId AND MONTH(deliveredAt) = MONTH(GETDATE())
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
 GO

-- updateOrder()
CREATE PROCEDURE shipperUpdateOrder
	@orderId INT,
	@shipperId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND shipperId = @shipperId AND status = 'confirmed' AND process = 'taken')
 				BEGIN
 					UPDATE[dbo].[Order] WITH (UPDLOCK, ROWLOCK)
 					SET process = 'delivering'
 					WHERE id = @orderId
 				END
			ELSE
			BEGIN
 				RAISERROR (N'Something went wrong!',16,1)
 				ROLLBACK
			END
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- confirmShipped()
CREATE PROCEDURE shipperConfirmShipped
	@orderId INT,
	@shipperId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND shipperId = @shipperId AND status = 'confirmed' AND process = 'delivering')
 				BEGIN
 					UPDATE[dbo].[Order]  WITH (UPDLOCK)
 					SET process = 'delivered'
 					WHERE id = @orderId
 				END
			ELSE
			BEGIN
 				RAISERROR (N'Something went wrong!',16,1)
 				ROLLBACK
			END
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
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
	BEGIN TRAN
		BEGIN TRY
			UPDATE[dbo].[Shipper]  WITH (UPDLOCK)
			SET [districtId] = @districtId, [name] = @name, 
 				[address]= @address, [licensePlate] = @licensePlate
			WHERE id = @shipperId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- =========================================
-- =============== Customer ================
-- =========================================

-- updateProfile()
CREATE PROCEDURE customerUpdateProfile
	@customerId INT,
	@name NVARCHAR(100),
	@address NVARCHAR(100)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE[dbo].[Customer] WITH (UPDLOCK)
			SET [name] = @name, [address] = @address
			WHERE [id] = @customerId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

--viewOrders
CREATE PROCEDURE customerViewOrders
	@customerId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			SELECT * FROM [dbo].[Order] where [customerId] = @customerId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- viewOrderDetails()
CREATE PROCEDURE customerViewOrderDetail
	@orderId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			SELECT * FROM [dbo].[OrderDetail] where orderId = @orderId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- cancelOrder()
CREATE PROCEDURE customerCancelOrder
	@orderId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[Order] WHERE id = @orderId AND status = 'pending')
 				BEGIN
					DELETE FROM [dbo].[Order] WHERE [id] = @orderId
				END
		
			ELSE
			BEGIN
 				RAISERROR (N'Something went wrong!',16,1)
 				ROLLBACK
			END
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- =======================================
-- =============== Partner ===============
-- =======================================

-- viewProfile
CREATE PROCEDURE partnerViewProfile
	@partnerId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			SELECT * FROM [dbo].[Partner] p
			JOIN [dbo].[Branch] b on p.id = b.partnerId
			WHERE p.[id] = @partnerId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
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
	BEGIN TRAN
		BEGIN TRY
			UPDATE[dbo].[Partner]  WITH (UPDLOCK)
			SET [representative] = @representative,
				[orderQuantity] = @orderQuantity, [brandName] = @brandName,
				[status] = @status, [culinaryStyle] = @culinaryStyle
			WHERE [id] = @partnerId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- getDishes
CREATE PROCEDURE partnerGetDishes
	@partnerId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			SELECT * FROM [dbo].[Dish] 
			WHERE [partnerId] = @partnerId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- deleteDish
CREATE PROCEDURE partnerDeleteDish
	@dishId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[Dish] WHERE id = @dishId)
 				BEGIN
					DELETE FROM [dbo].[Dish] WITH (UPDLOCK, ROWLOCK) WHERE [id] = @dishId
					DELETE FROM [dbo].[DishDetail] WITH (UPDLOCK, ROWLOCK) WHERE [dishId] = @dishId
				END
			ELSE
			BEGIN
 				RAISERROR (N'Something went wrong!',16,1)
 				ROLLBACK
			END
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- getDishDetail
CREATE PROCEDURE partnerGetDishDetail
	@dishId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			SELECT * FROM [dbo].[DishDetail] where dishId = @dishId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- deleteOrder
CREATE PROCEDURE partnerDeleteOrder
	@orderId INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[Order] WHERE [shipperId] is not null)
			BEGIN
				RAISERROR (N'Already confirmed by shipper',16,1)
 				ROLLBACK
			END
			ELSE
			BEGIN
				DELETE FROM [dbo].[Order] WHERE [id] = @orderId
			END
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

-- updateDishDetail
CREATE PROCEDURE partnerUpdateDishDetail
	@dishDetailId INT,
    @name NVARCHAR(50),
    @price FLOAT(53),
	@quantity INT
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			UPDATE[dbo].[DishDetail]  WITH (UPDLOCK, ROWLOCK)
			SET [price] = @price, [name] = @name, [quantity] = @quantity
			WHERE [id] = @dishDetailId
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
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



