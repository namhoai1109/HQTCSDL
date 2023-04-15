use HQTCSDL_DEMO
go

/*
		CÂU 14:
Lost update: Khi khách hàng đặt món và gửi yêu cầu đặt hàng cho đối tác, đối tác 
tiếp nhận yêu cầu và thực hiện xác nhận đơn hàng. Trong khi đang chờ xác nhận 
từ đối tác, khách hàng quyết định hủy đơn hàng và gửi yêu cầu hủy đơn hàng 
cho đối tác, cùng lúc đó đối tác bấm xác nhận đơn → Gây ra sự cố xử lý dữ liệu*/

BEGIN TRANSACTION
    -- Kiểm tra trạng thái của đơn hàng
	BEGIN TRY
		IF EXISTS (
			SELECT * 
			FROM [dbo].[Order] WITH(XLOCK) 
			WHERE [id] = 9 AND [status] = 'pending'
		)

		BEGIN
			WAITFOR DELAY '00:00:05'
			-- Nếu đơn hàng chưa xác nhận, xóa nó
			DELETE FROM [dbo].[Order] 
			WHERE [id] = 9 AND [status] = 'pending'
		END
    END TRY
    BEGIN CATCH
        -- Nếu đơn hàng đã xác nhận, thông báo lỗi
        PRINT N' --> This order cannot be DELETED, 
		as it has already been CONFIRMED';  
		ROLLBACK
    END CATCH
COMMIT 
