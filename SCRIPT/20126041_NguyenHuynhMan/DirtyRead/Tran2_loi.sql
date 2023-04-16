use HQTCSDL_DEMO
go

set dateformat dmy
-- C�u 1: Dirty read


begin transaction  
Update [dbo].[Dish]
set [status] = 'unavailable'
where [name] Like N'Yakisoba'
rollback transaction