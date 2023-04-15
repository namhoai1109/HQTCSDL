use HQTCSDL_DEMO
go 
--truong hop 11
--thong ke doanh thu
set transaction isolation level read uncommitted 
begin transaction 
	insert into [dbo].[Order] ([customerId], [branchId], [status], [process], [orderCode])
	output inserted.ID values (1, 1, 'confirmed', 'pending', '82albl1ksl1958l11')
	update [dbo].[Order] set [orderPrice] = 70000 where [id] = SCOPE_IDENTITY()
commit