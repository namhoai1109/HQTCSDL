use HQTCSDL2
go
-- Câu 10 : Phantom
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  --> sử dụng thêm isolation level SERIALIZABLE
BEGIN TRANSACTION
	-- Cập nhật đơn hàng mới
	UPDATE Order o SET o.process = 'delivered' WHERE o.id = 11
COMMIT
