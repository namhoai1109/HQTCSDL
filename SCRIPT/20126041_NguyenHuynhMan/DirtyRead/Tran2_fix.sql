use HQTCSDL_DEMO
go


set dateformat dmy

-- C�u 1: Dirty read
begin transaction
set transaction isolation level read committed
select * from [dbo].[Dish] where [status] = 'available' 
commit
