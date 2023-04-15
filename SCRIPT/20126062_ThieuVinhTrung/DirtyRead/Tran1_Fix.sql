﻿use HQTCSDL_DEMO
go
/*
CÂU 2
	Dirty Read: Khi một tài xế A bấm nhận đơn hàng X, thì trong danh sách đơn 
	hàng - đơn hàng X đã nhận. Tài xế B khi xem danh sách thì không thấy đơn hàng 
	X, nhưng trong quá trình tài xế A chọn bị lỗi hệ thống và bị rollback → Tài xế B 
	không xem được đơn X
*/
-- Ta có thể sử dụng cơ chế locking để đảm bảo rằng đơn hàng X chỉ được tài xế A đang xử lý truy cập vào

SELECT * FROM [dbo].[Order]

BEGIN TRANSACTION
	UPDATE [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
	SET [shipperId] = 01 , [status] = 'confirmed'
	WHERE [id] = 1
	WAITFOR DELAY '00:00:05'
ROLLBACK
