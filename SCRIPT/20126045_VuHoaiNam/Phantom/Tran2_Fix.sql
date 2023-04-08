use HQTCSDL_DEMO
go 
--truong hop 11
--thong ke doanh thu
set transaction isolation level serializable
begin transaction 
	insert into [dbo].[Order] ([customerId], [branchId], [status], [process], [orderCode])
	output inserted.ID values (1, 1, 'confirmed', 'pending', '82alal1ksl1958l11')

	insert into [dbo].[OrderDetail] ([orderId], [dishName], [dishDetail], [quantity], [price])
	output inserted.id values(1, N'Cà phê', 'M', 2, 70000)

	update [dbo].[Order] set [orderPrice] = 100000 where [id] = 1
commit