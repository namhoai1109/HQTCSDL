use HQTCSDL2
go 
--truong hop 15
--cap nhat hop dong
set transaction isolation level serializable
begin transaction 
	if exists (select * from HOPDONG where NGUOI_DAI_DIEN = N'Nguyễn Huỳnh Mẫn')
	begin
		select * from HOPDONG
		update HOPDONG
		set TK_NGAN_HANG = '2222222222222222'
		where NGUOI_DAI_DIEN = N'Nguyễn Huỳnh Mẫn'
	end
commit