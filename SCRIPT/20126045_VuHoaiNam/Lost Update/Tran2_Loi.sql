use HQTCSDL_DEMO
go 
--truong hop 15
--cap nhat hop dong
set transaction isolation level read uncommitted 
begin transaction 
	if exists (select * from [dbo].[Contract] where [representative] = N'Nguyễn Huỳnh Mẫn')
	begin
		select * from [dbo].[Contract]
		update [dbo].[Contract]
		set [bankAccount] = '2222222222222222'
		where [representative] = N'Nguyễn Huỳnh Mẫn'
	end
commit

--update [dbo].[Contract]
--set [bankAccount] = '9995123444909555'
--where [representative] = N'Nguyễn Huỳnh Mẫn'