use HQTCSDL_DEMO
go
--truong hop 3
--doi tac cap nhat so luong mon
set transaction isolation level read committed 
begin transaction
	declare @dishId int
	set @dishId = 2
	declare @quantity int
	set @quantity = 20
	declare @detailName nvarchar(1000)
	set @detailName = 'S'

	update [dbo].[DishDetail]
	set [quantity] = @quantity
	where [dishId] = @dishId
	and [name] = @detailName
	--waitfor delay '00:00:05'
	if @@ERROR <> null
	begin
		raiserror(N'Cập nhật không thành công', 16, 1)
		rollback
		return
	end
rollback