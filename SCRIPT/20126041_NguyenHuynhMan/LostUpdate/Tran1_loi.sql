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
		ORDER o 
		WHERE id = 26 AND shipperId = null
    )
    BEGIN
        UPDATE ORDER 
        SET shipperId = '01'
        WHERE id = '26';
    END

COMMIT