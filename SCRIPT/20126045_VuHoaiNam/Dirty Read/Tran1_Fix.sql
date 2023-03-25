use HQTCSDL2
go
--truong hop 3
--doi tac cap nhat so luong mon
set transaction isolation level read committed 
begin transaction
	update MON
	set SOLUONG = 30
	where ID = 1
	waitfor delay '00:00:05'
rollback