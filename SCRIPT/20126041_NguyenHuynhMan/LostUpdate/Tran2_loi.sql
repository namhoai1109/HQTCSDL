use HQTCSDL_DEMO
go

--C�u 13 : Lost Updated

begin transaction

update [dbo].[Order]
set [dbo].[Order].[shipperId] =02
where [dbo].[Order].[id] = 26

commit
