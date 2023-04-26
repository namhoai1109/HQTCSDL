use HQTCSDL_DEMO
go

-- Câu 6:  Unrepeatable
BEGIN TRANSACTION
-- Kiểm tra các đơn hàng chưa xác nhận có tồn tại không
	IF NOT EXISTS (SELECT * FROM [dbo].[Order] WITH(UPDLOCK)
			   WHERE [status] = 'pending')
		BEGIN 
			RAISERROR(N'No pending orders', 16, 1)
			ROLLBACK
			RETURN
		END
	UPDATE [dbo].[Order]
	SET [orderPrice] = 75000
	WHERE [id] = 01 AND [status] = 'pending'
	IF @@ROWCOUNT = 0
		BEGIN
			-- Nếu đơn hàng đã xác nhận, thông báo lỗi
			PRINT N' --> This order cannot be UPDATED, as it has already been CONFIRMED';  
			ROLLBACK
			RETURN
		END
COMMIT
