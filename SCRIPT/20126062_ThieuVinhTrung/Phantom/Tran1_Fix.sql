use HQTCSDL2
go

/*
CÂU 10
	Phantom: Trong 1 transaction lấy lịch sử đơn hàng và tính tổng thu nhập tháng 
	này của tài xế, có 1 đơn hàng mới vừa được hoàn thành → Lịch sử đơn hàng 
	không có đơn hàng đó, nhưng tổng thu nhập thì lại có phí của đơn hàng đó.
*/


/*
SERIALIZABLE
	Tạo Shared Lock trên đơn vị dữ liệu được đọc và giữ shared lock này đến hết giao tác
	=> Các giao tác khác phải chờ đến khi giao tác này kết thúc nếu muốn cập nhật, thay
	đổi giá trị trên đơn vị dữ liệu này.

	Ưu điểm		: Giải quyết Phantom
	Khuyết điểm : Phải chờ nếu đơn vị dữ liệu cần đọc đang được giữ khoá ghi (xlock)
*/

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  --> sử dụng isolation level SERIALIZABLE
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