use HQTCSDL_DEMO
go

set dateformat dmy
-- C�u 1: Dirty read
set transaction isolation level read uncommitted
begin transaction
select * from [dbo].[Dish] where [status] = 'available' 
waitfor delay '00:00:05'
commit

