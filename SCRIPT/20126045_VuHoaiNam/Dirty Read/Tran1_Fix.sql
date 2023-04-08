use HQTCSDL_DEMO
go
--truong hop 3
--doi tac cap nhat so luong mon
set transaction isolation level read committed 
begin transaction
	update [dbo].[DishDetail]
	set [quantity] = 30
	where [dishId] = 1
	waitfor delay '00:00:05'
rollback