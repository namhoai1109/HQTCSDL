use HQTCSDL_DEMO
go
--truong hop 3
--doi tac cap nhat so luong mon
set transaction isolation level read uncommitted 
begin transaction
	update [dbo].[DishDetail]
	set [quantity] = 30
	where [dishId] = 2
	waitfor delay '00:00:05'
rollback
