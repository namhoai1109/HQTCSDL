use HQTCSDL_DEMO
go 
--truong hop 7
--doi tac sua gia tien
set transaction isolation level repeatable read 
begin transaction 
	declare @dishId int
	set @dishId = 1
	declare @dishDetailId int
	set @dishDetailId = 2

	update [dbo].[DishDetail]
	set [price] = 40000
	where [id] = @dishDetailId and [dishId] = @dishId
commit