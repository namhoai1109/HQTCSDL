use HQTCSDL_DEMO
go
-- Câu 10 : Phantom
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  --> sử dụng thêm isolation level SERIALIZABLE
BEGIN TRANSACTION
	-- Cập nhật đơn hàng mới
	UPDATE [dbo].[Order]
	SET [process] = 'delivered' WHERE [id] = 3
COMMIT
