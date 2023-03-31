use HQTCSDL
go

--Câu 13 : Lost Updated
/*
Một tài xế chọn nhận đơn hàng, nhưng cùng lúc đó một tài xế khác cũng chọn đơn hàng này và lưu trữ vào cơ sở dữ liệu. 
Khi xem lại thông tin đơn hàng, chỉ một trong hai cập nhật tình trạng mới nhất được lưu trữ trong cơ sở dữ liệu, 
gây ra sự cố trong quá trình xử lý đơn hàng.
*/

begin transaction
    IF EXISTS (
        SELECT * 
		FROM DONHANG 
		WHERE MADON = 26 AND ID_TAI_XE = null
    )
    BEGIN
        UPDATE DONHANG 
        SET ID_TAI_XE = '01'
        WHERE MADON = '26';
    END
commit