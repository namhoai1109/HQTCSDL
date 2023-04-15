use HQTCSDL_DEMO
go

-- Câu 6:  Unrepeatable
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION
	-- Update đơn hàng
	UPDATE [dbo].[Order]
	SET [orderPrice] = 85000
	WHERE [id] = 01 AND [status] = 'pending'
	IF @@ROWCOUNT = 0
		BEGIN
			-- Nếu đơn hàng đã xác nhận, thông báo lỗi
			PRINT N' --> This order cannot be UPDATED, 
			as it has already been CONFIRMED'; 
			ROLLBACK
		END
COMMIT
