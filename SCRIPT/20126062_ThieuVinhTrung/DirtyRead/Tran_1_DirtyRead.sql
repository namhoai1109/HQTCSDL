use HQTCSDL2
go
/*
		CÂU 2
Dirty Read: Khi một tài xế A bấm nhận đơn hàng X, thì trong danh sách đơn 
hàng - đơn hàng X đã nhận. Tài xế B khi xem danh sách thì không thấy đơn hàng 
X, nhưng trong quá trình tài xế A chọn bị lỗi hệ thống và bị rollback → Tài xế B 
không xem được đơn X
*/

-- INSERT INTO DONHANG OUTPUT inserted.MADON values (03,null,03,'Chua xac nhan', 'Dang chuan bi', GETDATE(),null, 50000, 25000)
-- SELECT * FROM DONHANG

BEGIN TRANSACTION
	UPDATE DONHANG
	SET ID_TAI_XE = 01 , TRANGTHAI = 'Xac nhan'
	WHERE MADON=4
	WAITFOR DELAY '00:00:05'
ROLLBACK