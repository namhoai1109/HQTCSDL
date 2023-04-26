use HQTCSDL_DEMO
go

BEGIN TRANSACTION
	-- Xem thông tin các đơn hàng chưa xác nhận
	IF EXISTS(SELECT * FROM [dbo].[Order] WITH(UPDLOCK)
			  WHERE [id] = 9 AND [status] = 'pending' )
		BEGIN
			UPDATE [dbo].[Order]
			SET [status] = 'confirmed' 
			WHERE [id] =9 AND [status] = 'pending'
		END
	ELSE
		BEGIN
			RAISERROR('Order status is confirmed', 16, 1);
			ROLLBACK
		END		
COMMIT