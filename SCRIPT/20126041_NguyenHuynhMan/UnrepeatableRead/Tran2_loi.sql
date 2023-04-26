use HQTCSDL_DEMO
go

--C�u 5: Unrepeatable read
begin transaction
set transaction isolation level read uncommitted
update [dbo].[Order]
set [orderPrice] = 100000
where [id] = 1

commit