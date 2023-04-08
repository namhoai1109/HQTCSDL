use HQTCSDL_DEMO
go

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE --> Sử dụng thêm SERIALIZABLE
BEGIN TRANSACTION
    -- Kiểm tra trạng thái của đơn hàng
    IF EXISTS (
        SELECT * FROM Order o WHERE o.id = 1 AND o.status = 'pending'
    )
    BEGIN
        -- Nếu đơn hàng chưa xác nhận, xóa nó
        DELETE FROM Order WHERE id = 1
    END
    ELSE
    BEGIN
        -- Nếu đơn hàng đã xác nhận, thông báo lỗi
        PRINT N' --> This order cannot be DELETED, as it has already been CONFIRMED';  
    END
	
COMMIT
