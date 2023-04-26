USE HQTCSDL_DEMO
GO

--Truong hop 16: Lost Update
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION placeOrder
	declare @quantity int
	set @quantity = 1

	--check so luong tuy chon
	if ((select [quantity] from [dbo].[DishDetail]  where [dishId] = 1 and [name] = 'S') < @quantity)
	begin
		raiserror(N'Số lượng không đủ', 16, 1)
		rollback
		return
	end

	update [dbo].[DishDetail]
	set [quantity] = [quantity] - @quantity
	where [dishId] = 1 and [name] = 'S'

	--tao don hang
	--insert chi tiet

	if @@ERROR <> null
	begin
		rollback
		return
	end

COMMIT