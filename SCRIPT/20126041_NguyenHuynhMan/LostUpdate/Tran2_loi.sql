use HQTCSDL_DEMO
go

--C�u 13 : Lost Updated

begin transaction

update [dbo].[Order]
set [dbo].[Order].[shipperId] = 2
where [dbo].[Order].[id] = 2

commit
