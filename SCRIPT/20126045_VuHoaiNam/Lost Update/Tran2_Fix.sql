use HQTCSDL_DEMO
go 
--truong hop 15
--cap nhat hop dong
set transaction isolation level serializable
begin transaction 
	if exists (select * from [dbo].[Contract] where [representative] = N'Nguyễn Huỳnh Mẫn')
	begin
		update [dbo].[Contract]
		set [bankAccount] = '2222222222222222'
		where [representative] = N'Nguyễn Huỳnh Mẫn'
	end

	if @@ERROR <> null
	begin
		rollback
	end
commit