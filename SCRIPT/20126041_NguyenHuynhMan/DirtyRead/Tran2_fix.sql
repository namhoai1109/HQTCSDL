use HQTCSDL
go


set transaction isolation level read committed
set dateformat dmy

-- C�u 1: Dirty read
begin transaction
select * from Mon 
waitfor delay '00:00:05'
commit

