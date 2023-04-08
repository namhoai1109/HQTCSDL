use HQTCSDL2
go

-- Câu 6:  Unrepeatable
BEGIN TRANSACTION
-- Update đơn hàng
	UPDATE [dbo].[Order] WITH (UPDLOCK)
	SET [dbo].[Order].[orderPrice] = 65000
	WHERE [dbo].[Order].[id] = 01 AND [dbo].[Order].[status] = 'pending'
	IF @@ROWCOUNT = 0
		BEGIN
			-- Nếu đơn hàng đã xác nhận, thông báo lỗi
			PRINT N' --> This order cannot be UPDATED, as it has already been CONFIRMED';  
		END
COMMIT
