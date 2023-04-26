use HQTCSDL_DEMO
go
/*
		CÂU 2
Dirty Read: Khi một tài xế A bấm nhận đơn hàng X, thì trong danh sách đơn 
hàng - đơn hàng X đã nhận. Tài xế B khi xem danh sách thì không thấy đơn hàng 
X, nhưng trong quá trình tài xế A chọn bị lỗi hệ thống và bị rollback → Tài xế B 
không xem được đơn X
*/

SELECT * FROM [dbo].[Order]

BEGIN TRANSACTION
	IF EXISTS (SELECT * FROM [dbo].[Order] WHERE [status] = 'confirmed')
		BEGIN
			RAISERROR(N'No orders to look for',16,1)
			ROLLBACK
			RETURN    
		END

	WAITFOR DELAY '00:00:05'
	
	UPDATE [dbo].[Order]
	SET [shipperId] = 01, [process] = 'confirmed'
	WHERE [id] = 1 AND [status] = 'confirmed';
	WAITFOR DELAY '00:00:05';

	IF @@ERROR <> NULL
		BEGIN
			ROLLBACK
			RETURN
		END

COMMIT

