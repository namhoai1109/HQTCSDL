use HQTCSDL2
go

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
-- CREATE PROCEDURE rateDish
--     @customerId INT,
--     @dishId INT,
--     @isLike BIT,
--     @description NVARCHAR(1000)

-- AS
-- BEGIN
--     SET NOCOUNT ON;
    
--     -- Check if the customer has already rated the dish
--     IF EXISTS (SELECT * FROM Rating WHERE customerId = @customerId)
--     BEGIN
--         UPDATE Rating SET isLike = @isLike, description = @description, updatedAt = GETDATE()
--         WHERE customerId = @customerId AND dishId = @dishId
--     END
--     ELSE
--     BEGIN
--         INSERT INTO Rating (isLike, createdAt, description, updatedAt, customerId, dishId)
--         VALUES (@isLike, GETDATE(), @description, GETDATE(), @customerId, @dishId)
--     END
-- END



-- +) Shipper.confirmOrder()
-- CREATE PROCEDURE shipperConfirmOrder
-- @orderId int,
-- @process NVARCHAR(50),
-- @shipperId int

-- as
-- BEGIN
-- update[dbo].[Order]  WITH (UPDLOCK, ROWLOCK)
-- set process = @process, shipperId = @shipperId
-- where id = @orderId
-- END



-- +) Shipper.getIncome()
-- CREATE PROCEDURE shipperGetIncome
-- @shipperId int

-- AS
-- BEGIN

-- SELECT SUM(shippingPrice) 
-- FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
-- where shipperId = @shipperId AND MONTH(createdAt) = MONTH(GETDATE())

-- END




-- +) Staff.updateContract()

-- CREATE PROCEDURE updateContract
--     @contractId INT,
--     @isConfirmed BIT
-- AS
-- BEGIN
--     UPDATE [dbo].[Contract]
--     SET [isConfirmed] = @isConfirmed , confirmedAt = GETDATE()
--     WHERE [id] = @contractId
-- END






-- +) Partner.updateDish()
-- CREATE PROCEDURE updateDish
-- @dishId int,
-- @name NVARCHAR(50),
-- @description NVARCHAR(50),
-- @status NVARCHAR(50)

-- AS
-- BEGIN

-- UPDATE [dbo].[Dish] WITH (UPDLOCK, ROWLOCK)
-- set name = @name, description = @description, status = @status
-- where id = @dishId

-- END








-- +) Partner.getIncome()
-- CREATE PROCEDURE getIncome
-- @partnerId int

-- as
-- BEGIN
-- SELECT SUM(orderPrice) AS INCOME
-- FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
-- where partnerId = @partnerId AND month(createdAt) = MONTH(GETDATE())
-- END




-- +) Partner.deleteDishDetail()

-- CREATE PROCEDURE deleteDishDetail
-- 	@dishID INT
-- AS
-- BEGIN
-- 	DELETE [dbo].DishDetail
-- 	WHERE [id] = @dishID
-- END




-- +) Partner.getNumberOfOrders()
-- CREATE PROCEDURE getNumberOfOrders
-- @partnerId int

-- as
-- BEGIN
-- SELECT count(*) 
-- FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
-- where partnerId = @partnerId AND month(createdAt) = MONTH(GETDATE())
-- END





--+) Partner.updateOrder()

-- CREATE PROCEDURE updateOrder
--  	@orderID INT,
--  	@status NVARCHAR(50)
--  AS
--  BEGIN
--  	UPDATE [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
--      SET [status] = @status
--      WHERE [id] = @orderID
--  END

--  EXEC updateOrder