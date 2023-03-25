use HQTCSDL2
go 
--truong hop 11
--thong ke doanh thu
set transaction isolation level serializable 
begin transaction 
	insert into DONHANG (ID_KHACH_HANG, ID_TAI_XE, ID_CHI_NHANH, TRANGTHAI, QUATRINH, TG_TAO, TIENDON, TIENSHIP)
	values (2,1,2,'Xac nhan','Dang chuan bi', GETDATE(), 70000, 20000)
commit