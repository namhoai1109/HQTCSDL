use HQTCSDL
go
-- Câu 1: Dirty read : Khi khách hàng A đặt 1 món X thì số lượng món X giảm xuống 1, 
--thì cùng lúc đó khách hàng B đang đọc với số lượng món hàng X-1. 
--Nhưng sau đó, giao dịch của đơn hàng khách A bị lỗi → rollback. 
--Làm cho khách B đọc sai dữ liệu.
-- Không cần fix vì isolation level default của database là read committed 
-- Câu truy vấn: set transaction isolation level read committed

set transaction isolation level read committed
begin transaction  
Update Mon
set Solg = 0, TINH_TRANG_MON='Het hang'
where Ten_mon Like N'Mì Soba'
waitfor delay '00:00:05'
rollback transaction