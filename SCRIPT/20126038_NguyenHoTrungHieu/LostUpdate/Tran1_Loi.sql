USE HQTCSDL_DEMO
GO

--Truong hop 16: Lost Update
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION placeOrder
	declare @quantity int
	set @quantity = 1

	--check so luong tuy chon
	if ((select [quantity] from [dbo].[DishDetail] where [id] = 1) < @quantity)
	begin
		raiserror(N'Số lượng không đủ', 16, 1)
		rollback
		return
	end

	waitfor delay '00:00:05'
	update [dbo].[DishDetail]
	set [quantity] = [quantity] - @quantity
	where [id] = 1

	--tao don hang
	--insert chi tiet
COMMIT

select * from [dbo].[DishDetail]

--Run this after transaction
--update [dbo].[DishDetail]
--set [quantity] = 1
--where [id] = 1