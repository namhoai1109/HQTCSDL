use HQTCSDL2
go

-- Câu 14: Lost Update
INSERT INTO DONHANG OUTPUT inserted.MADON values (02,01,02,'Chua xac nhan', 'Dang chuan bi', GETDATE(),null, 50000, 20000)

BEGIN TRANSACTION
    -- Kiểm tra trạng thái của đơn hàng
    IF EXISTS (
        SELECT * FROM DONHANG WHERE MADON = 1 AND TRANGTHAI = 'Chua xac nhan'
    )
    BEGIN
        -- Nếu đơn hàng chưa xác nhận, xóa nó
        DELETE FROM DONHANG WHERE MADON = 1
    END
    ELSE
    BEGIN
        -- Nếu đơn hàng đã xác nhận, thông báo lỗi
        PRINT N' --> This order cannot be DELETED, as it has already been CONFIRMED';  
    END
	
COMMIT