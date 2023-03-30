use HQTCSDL
go


set transaction isolation level read committed
set dateformat dmy
-- Câu 1: Dirty read
set transaction isolation level read uncommitted
begin transaction
select * from Mon 
waitfor delay '00:00:05'
commit

