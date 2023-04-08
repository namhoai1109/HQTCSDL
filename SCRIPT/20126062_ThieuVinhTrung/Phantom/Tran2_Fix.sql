use HQTCSDL2
go
-- Câu 10 : Phantom
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  --> sử dụng thêm isolation level SERIALIZABLE
BEGIN TRANSACTION
	-- Cập nhật đơn hàng mới
	UPDATE [dbo].[Order] SET [dbo].[Order].[process] = 'delivered' WHERE [dbo].[Order].[id] = 11
COMMIT
