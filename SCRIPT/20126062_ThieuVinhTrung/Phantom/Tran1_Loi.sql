use HQTCSDL2
go

/*
		CÂU 10
Phantom: Trong 1 transaction lấy lịch sử đơn hàng và tính tổng thu nhập tháng 
này của tài xế, có 1 đơn hàng mới vừa được hoàn thành → Lịch sử đơn hàng 
không có đơn hàng đó, nhưng tổng thu nhập thì lại có phí của đơn hàng đó.
*/
SELECT * FROM Order

BEGIN TRANSACTION
	-- LẤY LỊCH SỬ ĐƠN HÀNG THÁNG NÀY CỦA TÀI XẾ
	SELECT *
	FROM Order AS o
	WHERE shipperId = 1 AND o.process = 'delivered'
	AND MONTH(o.createdAt) = MONTH(GETDATE())
	WAITFOR DELAY '00:00:05'

	-- Tính tổng thu nhập tháng này của tài xế
	SELECT SUM(o.shippingPrice) 
	FROM Order AS o
	WHERE shipperId = 1 AND o.process = 'delivered' 
	AND MONTH(o.createdAt) = MONTH(GETDATE())

COMMIT