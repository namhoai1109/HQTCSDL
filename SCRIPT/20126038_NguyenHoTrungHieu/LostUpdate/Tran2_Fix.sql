USE HQTCSDL_DEMO
GO

BEGIN TRANSACTION placeOrder
	declare @quantity int
	set @quantity = 1

	--check so luong tuy chon
	if ((select [quantity] from [dbo].[DishDetail] with (UPDLOCK) where [id] = 1) < @quantity)
	begin
		raiserror(N'Số lượng không đủ', 16, 1)
		rollback
		return
	end

	update [dbo].[DishDetail]
	set [quantity] = [quantity] - @quantity
	where [id] = 1

	--tao don hang
	--insert chi tiet
COMMIT