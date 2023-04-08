USE HQTCSDL_DEMO
GO

--Truong hop 16: Lost Update
-- Hướng giải quyết: Sử dụng khóa UPDLOCK khi đọc ghi trên cùng đơn vị dữ liệu
-- => Những thao tác khác khi đọc ghi trên đơn vị dữ liệu này sẽ phải đợi
-- Giao tác đang giữ khóa UPDLOCK sau đó sẽ nâng cấp lên XLOCK và tiến hành update
-- Cuối cùng nhả khóa khi commit giao tác => Giao tác khác có thể xin khóa UPDLOCK và tiến hành
-- update như thường
-- Ko còn Lost Update

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

	waitfor delay '00:00:05'
	update [dbo].[DishDetail]
	set [quantity] = [quantity] - @quantity
	where [id] = 1

	--tao don hang
	--insert chi tiet
COMMIT

--select * from [dbo].[DishDetail]

--Run this after transaction
--update [dbo].[DishDetail]
--set [quantity] = 1
--where [id] = 1