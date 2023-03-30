use HQTCSDL2
go

-- Câu 6:  Unrepeatable
BEGIN TRANSACTION
-- Update đơn hàng
	UPDATE DONHANG WITH (UPDLOCK)
	SET TIENDON = 65000
	WHERE MADON = 01 AND TRANGTHAI = 'Chua xac nhan'
	IF @@ROWCOUNT = 0
		BEGIN
			-- Nếu đơn hàng đã xác nhận, thông báo lỗi
			PRINT N' --> This order cannot be UPDATED, as it has already been CONFIRMED';  
		END
COMMIT
