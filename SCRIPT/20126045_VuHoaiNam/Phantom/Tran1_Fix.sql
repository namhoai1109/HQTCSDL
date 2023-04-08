use HQTCSDL_DEMO
go 
--truong hop 11
--thong ke doanh thu
set transaction isolation level serializable
begin transaction 
	--thong ke doanh thu thang nay
	select sum([orderPrice]) from [dbo].[Order] where MONTH([createdAt]) = MONTH(GETDATE())

	waitfor delay '00:00:05'

	--thong ke doanh thu trong ngay hom nay
	select sum([orderPrice]) from [dbo].[Order] where MONTH([createdAt]) = MONTH(GETDATE())
commit
