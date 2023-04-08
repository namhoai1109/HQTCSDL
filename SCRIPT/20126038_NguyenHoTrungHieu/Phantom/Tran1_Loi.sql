use HQTCSDL_DEMO
go

--Truong hop 12: Phantom
-- Khach hang dat mon
BEGIN TRANSACTION placeOrder
	declare @quantity int
	set @quantity = 1

	--check so luong tuy chon
	-- lay khoa update
	if ((select [quantity] from [dbo].[DishDetail] where [dishId] = 1 and [name] = 'S') < @quantity)
	begin
		raiserror(N'Số lượng không đủ', 16, 1)
		rollback
		return
	end

	waitfor delay '00:00:5'

	update [dbo].[DishDetail]
	set [quantity] = [quantity] - @quantity
	where [dishId] = 1 and [name] = 'S'

	if @@ERROR <> null
	begin
		rollback
		return
	end
	
	--tao don hang...
	--insert chi tiet...

COMMIT

--select * from [dbo].[DishDetail]
