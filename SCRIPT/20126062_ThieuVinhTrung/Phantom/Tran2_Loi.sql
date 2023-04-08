use HQTCSDL2
go

-- Câu 10 : Phantom
BEGIN TRANSACTION
	-- Cập nhật đơn hàng mới
	UPDATE Order o SET o.process = 'delivered' WHERE id = 11
COMMIT
