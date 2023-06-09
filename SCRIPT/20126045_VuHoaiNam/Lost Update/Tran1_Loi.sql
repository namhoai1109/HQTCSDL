﻿use HQTCSDL_DEMO
go 
--truong hop 15
--cap nhat hop dong
set transaction isolation level read uncommitted 
begin transaction 
	if exists (select * from [dbo].[Contract] where [representative] = N'Nguyễn Huỳnh Mẫn')
	begin
		waitfor delay '00:00:05'
		update [dbo].[Contract]
		set [bankAccount] = '1111111111111111'
		where [representative] = N'Nguyễn Huỳnh Mẫn'
	end

	if @@ERROR <> null
	begin
		rollback
	end
commit