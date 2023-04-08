use HQTCSDL
go

--C�u 5: Unrepeatable read
set transaction isolation level REPEATABLE READ
begin transaction
update ORDER
set orderPrice = 100000
where id = 1
waitfor delay '00:00:05'

rollback