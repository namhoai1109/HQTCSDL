

--Câu 5 : Unrepeatable read : Khi đối tác xem tổng thu nhập của mình trên tất cả chi nhánh 
--(mang tính realtime, kể cả những đơn hàng chưa được xác nhận). 
--Sau đó có một đơn hàng được cập nhật đơn giá (tăng hoặc giảm). 
--Tiếp theo đối tác muốn vào một chi nhánh để xem tổng thu nhập của một chi nhánh cụ thể 
--thì thấy tổng thu nhập của chi nhánh đó đã được thay đổi so với lần kiểm tra trên tất cả chi nhánh của đối tác.

-- Câu truy vấn để khắc phục lỗi: set transaction isolation level REPEATABLE READ
/*
Tạo Shared Lock trên đơn vị dữ liệu được
đọc và giữ shared lock này đến hết giao tác
=> Các giao tác khác phải chờ đến khi giao
tác này kết thúc nếu muốn cập nhật, thay
đổi giá trị trên đơn vị dữ liệu này .
(Repeatable Read = Read Committed +
Giải quyết Unrepeatable Reads)
Tạo Exclusive Lock trên đơn vị dữ liệu
được ghi, Exclusive Lock được giữ cho đến
hết giao tác.
*/



--						T1										|									T2
/*set transaction isolation level REPEATABLE READ				|
begin transaction												|
																|
--Xem tổng thu nhập của đối tác									|
																|
SELECT SUM(dh.TIENDON)											|
FROM DOITAC dt, CHINHANH cn, DONHANG dh							|
where dt.ID = cn.ID_DOI_TAC										|
and cn.ID = dh.ID_CHI_NHANH										|
and dh.QUATRINH = 'Da giao'										|
group by dt.ID													|
																|
waitfor delay '00:00:05'										|
																|					set transaction isolation level REPEATABLE READ
																|					begin transaction
																|					update DONHANG
																|					set TIENDON = 100000
																|					where MADON = 1
																|					waitfor delay '00:00:05'
																|
																|					rollback
																|
--Xem chi tiết tổng thu nhập của đối tác						|
																|
SELECT cn.ID ,SUM(dh.TIENDON)									|
FROM DOITAC dt, CHINHANH cn, DONHANG dh							|
where dt.ID = cn.ID_DOI_TAC										|
and cn.ID = dh.ID_CHI_NHANH										|
and dh.QUATRINH = 'Da giao'										|
group by cn.ID													|
																|
commit transaction												|
*/








