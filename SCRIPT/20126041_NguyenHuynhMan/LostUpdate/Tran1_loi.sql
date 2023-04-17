use HQTCSDL_DEMO
go

--Câu 13 : Lost Updated
/*
Một tài xế chọn nhận đơn hàng, nhưng cùng lúc đó một tài xế khác cũng chọn đơn hàng này và lưu trữ vào cơ sở dữ liệu. 
Khi xem lại thông tin đơn hàng, chỉ một trong hai cập nhật tình trạng mới nhất được lưu trữ trong cơ sở dữ liệu, 
gây ra sự cố trong quá trình xử lý đơn hàng.
*/

BEGIN transaction

    IF EXISTS (
        SELECT * FROM 
		[dbo].[Order] 
		WHERE [dbo].[Order].[id] = 2 AND [dbo].[Order].[shipperId] = null
    )
    BEGIN
        UPDATE [dbo].[Order] 
        SET [dbo].[Order].[shipperId] = 1
        WHERE [dbo].[Order].[id] = 2;
    END

COMMIT