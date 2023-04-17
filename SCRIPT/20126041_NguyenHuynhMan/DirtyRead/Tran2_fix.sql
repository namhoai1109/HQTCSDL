use HQTCSDL_DEMO
go


set transaction isolation level read committed
set dateformat dmy

-- C�u 1: Dirty read
begin transaction
select * from [dbo].[Dish] where [status] = 'available' 
commit


