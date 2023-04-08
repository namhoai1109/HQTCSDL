use HQTCSDL_DEMO
go

--Truong hop 12: Phantom
-- Khach hang dat mon
-- Hướng giải quyêt: Sử dụng ISOLATION LEVEL SERIALIZABLE để cho các thao tác chạy tuần tự
-- Giao tác nào vào trước sẽ chạy trước, những thao tác khác phải đợi
-- => Giải quyết được phantom
-- Ko sử dụng khóa vì thao tác như Delete hay Insert vẫn có thể chen vào được

--SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION placeOrder
	declare @quantity int
	set @quantity = 1

	--check so luong tuy chon
	-- lay khoa update
	if ((select [quantity] from [dbo].[DishDetail] with (XLOCK) where [dishId] = 1 and [name] = 'S') < @quantity)
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

-- rerun this after transaction
--update [dbo].[DishDetail]
--set [quantity] = 1
--where [dishId] = 1 and [name] = 'S'