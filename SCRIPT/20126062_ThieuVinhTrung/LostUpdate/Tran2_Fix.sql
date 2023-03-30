use HQTCSDL2
go

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE --> Sử dụng thêm SERIALIZABLE
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
