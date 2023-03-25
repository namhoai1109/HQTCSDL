use HQTCSDL2
go
--Truong hop 3
--khach hang xem so luong mon
set transaction isolation level read committed
begin transaction
	select SOLUONG from MON where ID = 1
commit