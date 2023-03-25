use HQTCSDL2
go 
--truong hop 7
--doi tac sua gia tien
set transaction isolation level read uncommitted 
begin transaction 
	update TUYCHONMON
	set GIA = 70000
	where ID = 1 and ID_MON = 1
commit