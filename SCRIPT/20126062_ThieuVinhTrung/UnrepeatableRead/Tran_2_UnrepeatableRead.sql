use HQTCSDL2
go

-- Câu 6:  Unrepeatable
-- Không cần thay đổi
BEGIN TRANSACTION		
	-- Update đơn hàng
	UPDATE DONHANG
	SET TIENDON = 40000
	WHERE ID_KHACH_HANG = 01

COMMIT
