use HQTCSDL_DEMO
go
-- Câu 1: Dirty read : Khi khách hàng A đặt 1 món X thì số lượng món X giảm xuống 1 và hết hàng, 
-- thì cùng lúc đó khách hàng B không đọc được món mà khách hàng A vừa chọn. 
-- Nhưng sau đó, giao dịch của đơn hàng khách A bị lỗi → rollback. 
-- Làm cho khách B đọc sai dữ liệu.
-- Không cần fix vì isolation level default của database là read committed 
-- Câu truy vấn: set transaction isolation level read committed

set transaction isolation level read committed
begin transaction  
Update DISH d
set d.status = 'unavailable'
where d.name Like N'Yakisoba'
waitfor delay '00:00:05'
rollback transaction