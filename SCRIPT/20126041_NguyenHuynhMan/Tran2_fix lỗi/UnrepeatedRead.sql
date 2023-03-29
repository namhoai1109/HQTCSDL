use HQTCSDL
go

--Câu 5: Unrepeatable read
set transaction isolation level REPEATABLE READ
begin transaction
update DONHANG
set TIENDON = 100000
where MADON = 1
waitfor delay '00:00:05'

rollback