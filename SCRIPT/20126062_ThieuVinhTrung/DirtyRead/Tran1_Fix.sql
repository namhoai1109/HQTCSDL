use HQTCSDL_DEMO
go
/*
CÂU 2
	Dirty Read: Khi một tài xế A bấm nhận đơn hàng X, thì trong danh sách đơn 
	hàng - đơn hàng X đã nhận. Tài xế B khi xem danh sách thì không thấy đơn hàng 
	X, nhưng trong quá trình tài xế A chọn bị lỗi hệ thống và bị rollback → Tài xế B 
	không xem được đơn X
*/
-- Ta dùng Read Commited để giải quyết tình huống 
/*Tạo Shared Lock trên đơn vị dữ liệu được đọc, Shared Lock được giải phóng ngay
sau khi đọc xong dữ liệu Tạo Exclusive Lock trên đơn vị dữ liệu
được ghi, Exclusive Lock được giữ cho đến hết giao tác*/

SELECT * FROM [dbo].[Order]

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
	IF EXISTS (SELECT * FROM [dbo].[Order]
	WHERE [status] = 'confirmed' AND [id] = 1)
		BEGIN
			UPDATE [dbo].[Order]
			SET [shipperId] = 01, [process] = 'confirmed'
			WHERE [id] = 1 AND [status] = 'confirmed';
	
			WAITFOR DELAY '00:00:05';
			
		END
	ELSE
		BEGIN
			RAISERROR('Order status is not confirmed', 16, 1);
			ROLLBACK
		END
ROLLBACK
