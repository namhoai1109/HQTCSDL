use HQTCSDL_DEMO
go 
--truong hop 11
--thong ke doanh thu
set transaction isolation level read uncommitted 
begin transaction 
	declare @partnerId int
	set @partnerId = 1

	--thong ke doanh thu thang nay
	select sum([dbo].[Order].[orderPrice]) from [dbo].[Order] join [dbo].[Branch] 
	on [dbo].[Order].[branchId] = [dbo].[Branch].[id] and [dbo].[Branch].[partnerId] = @partnerId   
	and MONTH([dbo].[Order].[createdAt]) = MONTH(GETDATE())
	waitfor delay '00:00:05'

	--thong ke doanh thu trong ngay hom nay
	select sum([dbo].[Order].[orderPrice]) from [dbo].[Order] join [dbo].[Branch] 
	on [dbo].[Order].[branchId] = [dbo].[Branch].[id] and [dbo].[Branch].[partnerId] = @partnerId   
	and DAY([createdAt]) = DAY(GETDATE())
commit
