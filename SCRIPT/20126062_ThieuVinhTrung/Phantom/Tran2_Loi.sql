use HQTCSDL2
go

-- Câu 10 : Phantom
BEGIN TRANSACTION
	-- Cập nhật đơn hàng mới
	UPDATE DONHANG SET TRANGTHAI = 'Xac nhan' WHERE MADON = 4
COMMIT
