use HQTCSDL
go

--C�u 5: Unrepeatable read
begin transaction
set transaction isolation level REPEATABLE READ
update [dbo].[Order]
set [orderPrice] = 100000
where [id] = 1 AND [status] = 'pending'

commit

