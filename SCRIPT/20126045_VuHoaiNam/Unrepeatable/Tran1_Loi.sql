use HQTCSDL2
go 
--truong hop 7
--khach hang tao don hang
set transaction isolation level read uncommitted 
begin transaction 
	--doc du lieu tu bang de hien thi cho nguoi dung
	select * from MON where ID_DOI_TAC = 1
	select * from TUYCHONMON tuychon join MON mon on tuychon.ID_MON = mon.ID and mon.ID_DOI_TAC = 1

	--khach hang chon mon
	waitfor delay '00:00:10'
	--he thong tinh tong bill
	select sum(GIA) from TUYCHONMON where (ID = 1 or ID = 2) and ID_MON = 1
commit

