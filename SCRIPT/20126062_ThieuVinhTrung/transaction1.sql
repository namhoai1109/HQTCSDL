﻿use HQTCSDL2
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
	WHERE MADON = 3
	WAITFOR DELAY '00:00:05'
ROLLBACK  -- Đơn hàng 03 vẫn chưa được cập nhật




/*
		CÂU 6   --> SAI
Unrepeatable: Trong transaction A tính tổng số like HOẶC dislike, khi có 1 transaction 
B thay đổi like thành dislike trước khi transaction A tính dislike → Dữ liệu khi 
transaction A tính like khác khi tính dislike

	-- Đếm số lượng dislike
này của tài xế, có 1 đơn hàng mới vừa được hoàn thành → Lịch sử đơn hàng 
không có đơn hàng đó, nhưng tổng thu nhập thì lại có phí của đơn hàng đó.
	SELECT *
	FROM DONHANG AS DH
	WHERE ID_TAI_XE = 1 AND DH.TRANGTHAI = 'Xac nhan' AND MONTH(DH.TG_TAO) = MONTH(GETDATE())
	FROM DONHANG AS DH
	WHERE ID_TAI_XE = 1 AND DH.TRANGTHAI = 'Xac nhan' AND MONTH(DH.TG_TAO) = MONTH(GETDATE())
		CÂU 14:
Lost update: Khi khách hàng đặt món và gửi yêu cầu đặt hàng cho đối tác, đối tác 
tiếp nhận yêu cầu và thực hiện xác nhận đơn hàng. Trong khi đang chờ xác nhận 
từ đối tác, khách hàng quyết định hủy đơn hàng và gửi yêu cầu hủy đơn hàng 
cho đối tác, cùng lúc đó đối tác bấm xác nhận đơn → Gây ra sự cố xử lý dữ liệu*/
SELECT * FROM DONHANG

BEGIN TRANSACTION
	-- Xem thông tin các đơn hàng chưa xác nhận
	SELECT * 
	FROM DONHANG AS DH
	WHERE DH.TRANGTHAI = 'Chua xac nhan'
	WAITFOR DELAY '00:00:05'

	-- Update trạng thái của đơn hàng "Chưa xác nhận" --> "Xác nhận"
	UPDATE DONHANG 
	SET TRANGTHAI = 'Xac nhan' 
	WHERE MADON = 11 AND TRANGTHAI = 'Chua xac nhan'
		
COMMIT