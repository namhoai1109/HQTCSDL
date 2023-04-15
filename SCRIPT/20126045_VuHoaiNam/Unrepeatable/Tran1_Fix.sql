use HQTCSDL_DEMO
go 
--truong hop 7
--khach hang tao don hang
set transaction isolation level repeatable read  
begin transaction 
	declare @quantityFromCustomer int
	set @quantityFromCustomer = 2
	declare @dishId int
	set @dishId = 1
	declare @dishDetailId int
	set @dishDetailId = 2

	--them thong tin vao bang Order
	insert into [dbo].[Order] ([customerId], [branchId], [orderCode])
	output inserted.ID values (3, 1, '10eisbo6a54y1olks')
	--lay thong tin chi tiet mon, insert vao bang chi tiet hoa don 
	select [name], [price] from [dbo].[DishDetail] where [dishId] = @dishId and [id] = @dishDetailId
	--them vao bang chi tiet hoa don

	waitfor delay '00:00:05'

	--tinh gia tien cho chi tiet hoa don
	select [price] * @quantityFromCustomer from [dbo].[DishDetail] where [id] = @dishDetailId and [dishId] = @dishId
commit

