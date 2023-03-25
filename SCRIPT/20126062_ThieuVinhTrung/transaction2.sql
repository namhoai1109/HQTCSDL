use HQTCSDL2
go

-- Câu 2 : Dirty Read
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION
	SELECT * FROM DONHANG
	WHERE TRANGTHAI = 'Chua xac nhan'
COMMIT



-- Câu 6:  Unrepeatable
BEGIN TRANSACTION
	UPDATE DANHGIA 
	SET THICH_KOTHICH = 0
	WHERE ID_MON = 1 AND ID_KHACH_HANG = 1
COMMIT	



-- Câu 10 : Phantom
BEGIN TRANSACTION
	-- Cập nhật đơn hàng mới
	UPDATE DONHANG SET TRANGTHAI = 'Xac nhan' WHERE MADON = 11
COMMIT



-- Câu 14: Lost Update
INSERT INTO DONHANG OUTPUT inserted.MADON values (02,01,02,'Chua xac nhan', 'Dang chuan bi', GETDATE(),null, 50000, 20000)

BEGIN TRANSACTION
    -- Kiểm tra trạng thái của đơn hàng
    IF EXISTS (
        SELECT * FROM DONHANG WHERE MADON = 14 AND TRANGTHAI = 'Chua xac nhan'
    )
    BEGIN
        -- Nếu đơn hàng chưa xác nhận, xóa nó
        DELETE FROM DONHANG WHERE MADON = 14
    END
    ELSE
    BEGIN
        -- Nếu đơn hàng đã xác nhận, thông báo lỗi
        PRINT N' --> This order cannot be DELETED, as it has already been CONFIRMED';  
    END
	
COMMIT