use HQTCSDL2
go 
--truong hop 15
--cap nhat hop dong
set transaction isolation level read uncommitted 
begin transaction 
	if exists (select * from HOPDONG with (updlock) where NGUOI_DAI_DIEN = N'Nguyễn Huỳnh Mẫn')
	begin
		waitfor delay '00:00:05'
		update HOPDONG
		set TK_NGAN_HANG = '1111111111111111'
		where NGUOI_DAI_DIEN = N'Nguyễn Huỳnh Mẫn'
	end
commit