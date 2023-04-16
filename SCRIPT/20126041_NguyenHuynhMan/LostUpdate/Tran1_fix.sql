use HQTCSDL_DEMO
go

--Câu 13 : Lost Updated
/*
Một tài xế chọn nhận đơn hàng, nhưng cùng lúc đó một tài xế khác cũng chọn đơn hàng này và lưu trữ vào cơ sở dữ liệu. 
Khi xem lại thông tin đơn hàng, chỉ một trong hai cập nhật tình trạng mới nhất được lưu trữ trong cơ sở dữ liệu, 
gây ra sự cố trong quá trình xử lý đơn hàng.
*/
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
begin transaction
    IF EXISTS (
        SELECT * FROM [dbo].[Order] WHERE [dbo].[Order].[id] = 2 
											AND shipperId is null
    )
    BEGIN
        update [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
        set [dbo].[Order].[shipperId] = 1
        where [dbo].[Order].[id] = 2
        waitfor delay '00:00:05'
    END
	ELSE
	 BEGIN
        -- Nếu đơn hàng đã xác nhận, thông báo lỗi
        PRINT N' --> This order cannot be DELETED, as it has already been CONFIRMED'; 
		ROLLBACK
    END
COMMIT

