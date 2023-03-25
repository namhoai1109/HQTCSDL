use HQTCSDL2
go

/*CÂU 10	Phantom: Trong 1 transaction lấy lịch sử đơn hàng và tính tổng thu nhập tháng 
	này của tài xế, có 1 đơn hàng mới vừa được hoàn thành → Lịch sử đơn hàng 
	không có đơn hàng đó, nhưng tổng thu nhập thì lại có phí của đơn hàng đó.*/


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
	FROM DONHANG AS DH
	WHERE ID_TAI_XE = 1 AND DH.TRANGTHAI = 'Xac nhan' AND MONTH(DH.TG_TAO) = MONTH(GETDATE())
	WAITFOR DELAY '00:00:05'

	-- Tính tổng thu nhập tháng này của tài xế
	SELECT SUM(DH.TIENSHIP) 
	FROM DONHANG AS DH
	WHERE ID_TAI_XE = 1 AND DH.TRANGTHAI = 'Xac nhan' AND MONTH(DH.TG_TAO) = MONTH(GETDATE())

COMMIT