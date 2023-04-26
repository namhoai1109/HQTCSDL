use HQTCSDL_DEMO
go
--Truong hop 3
--khach hang xem so luong mon
set transaction isolation level read committed
begin transaction
	declare @dishId int
	set @dishId = 2

	select [name], [description], [status]
	from [dbo].[Dish] 
	where [id] = @dishId

	select [name], [price], [quantity]
	from [dbo].[DishDetail] 
	where [dishId] = @dishId
commit