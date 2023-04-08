use HQTCSDL_DEMO
go

/*
		CÂU 14:
Lost update: Khi khách hàng đặt món và gửi yêu cầu đặt hàng cho đối tác, đối tác 
tiếp nhận yêu cầu và thực hiện xác nhận đơn hàng. Trong khi đang chờ xác nhận 
từ đối tác, khách hàng quyết định hủy đơn hàng và gửi yêu cầu hủy đơn hàng 
cho đối tác, cùng lúc đó đối tác bấm xác nhận đơn → Gây ra sự cố xử lý dữ liệu*/
SELECT * FROM DONHANG

BEGIN TRANSACTION
	-- Xem thông tin các đơn hàng chưa xác nhận
	SELECT * 
	FROM Order AS o
	WHERE o.status = 'pending'
	WAITFOR DELAY '00:00:05'

	-- Update trạng thái của đơn hàng "Chưa xác nhận" --> "Xác nhận"
	UPDATE Order o
	SET o.status = 'confirmed' 
	WHERE id = 10 AND o.status = 'pending'

		
COMMIT