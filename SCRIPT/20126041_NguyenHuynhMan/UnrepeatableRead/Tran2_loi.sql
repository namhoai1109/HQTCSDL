use HQTCSDL_DEMO
go

--C�u 5: Unrepeatable read
begin transaction
update [dbo].[Order]
set [dbo].[Order].[orderPrice] = 100000
where [dbo].[Order].[id] = 1
waitfor delay '00:00:05'

rollback