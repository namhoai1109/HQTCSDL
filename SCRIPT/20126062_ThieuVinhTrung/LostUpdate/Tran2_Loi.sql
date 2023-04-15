use HQTCSDL_DEMO
go

-- Câu 14: Lost Update

BEGIN TRANSACTION
    -- Kiểm tra trạng thái của đơn hàng
    IF EXISTS (
        SELECT * FROM [dbo].[Order] WHERE [id] = 1 AND [status] = 'pending'
    )
    BEGIN
        -- Nếu đơn hàng chưa xác nhận, xóa nó
        DELETE FROM [dbo].[Order] WHERE [id] = 1
    END
    ELSE
    BEGIN
        -- Nếu đơn hàng đã xác nhận, thông báo lỗi
        PRINT N' --> This order cannot be DELETED, as it has already been CONFIRMED';  
    END
COMMIT