use HQTCSDL2
go

-- Câu 6:  Unrepeatable
BEGIN TRANSACTION
	-- Update đơn hàng
	UPDATE Order o WITH (UPDLOCK)
	SET o.orderPrice = 65000
	WHERE o.id = 01 AND o.status = 'pending'
	IF @@ROWCOUNT = 0
		BEGIN
			-- Nếu đơn hàng đã xác nhận, thông báo lỗi
			PRINT N' --> This order cannot be UPDATED, as it has already been CONFIRMED';  
		END
COMMIT
