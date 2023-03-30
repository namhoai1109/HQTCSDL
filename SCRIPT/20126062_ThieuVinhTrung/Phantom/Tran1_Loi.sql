use HQTCSDL2
go

/*
		CÂU 10
Phantom: Trong 1 transaction lấy lịch sử đơn hàng và tính tổng thu nhập tháng 
này của tài xế, có 1 đơn hàng mới vừa được hoàn thành → Lịch sử đơn hàng 
không có đơn hàng đó, nhưng tổng thu nhập thì lại có phí của đơn hàng đó.
*/
SELECT * FROM DONHANG

BEGIN TRANSACTION
	-- LẤY LỊCH SỬ ĐƠN HÀNG THÁNG NÀY CỦA TÀI XẾ
	SELECT *
	FROM DONHANG AS DH
	WHERE ID_TAI_XE = 1 AND DH.TRANGTHAI = 'Xac nhan'
	AND MONTH(DH.TG_TAO) = MONTH(GETDATE())
	WAITFOR DELAY '00:00:05'

	-- Tính tổng thu nhập tháng này của tài xế
	SELECT SUM(DH.TIENSHIP) 
	FROM DONHANG AS DH
	WHERE ID_TAI_XE = 1 AND DH.TRANGTHAI = 'Xac nhan' 
	AND MONTH(DH.TG_TAO) = MONTH(GETDATE())

COMMIT