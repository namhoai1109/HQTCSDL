use HQTCSDL_DEMO
go 
--truong hop 7
--doi tac sua gia tien
set transaction isolation level read uncommitted 
begin transaction 
	update [dbo].[DishDetail]
	set [price] = 70000
	where [id] = 3 and [dishId] = 1
commit

select * from [dbo].[DishDetail]