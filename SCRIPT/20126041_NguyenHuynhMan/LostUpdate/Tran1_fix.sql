use HQTCSDL
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
        SELECT * FROM dbo.DONHANG WHERE  ID_TAI_XE is null
    )
    BEGIN
        update DONHANG WITH (UPDLOCK, ROWLOCK)
        set ID_TAI_XE =01
        where MADON = 21
        waitfor delay '00:00:05'
    END
	ELSE
	 BEGIN
        -- Nếu đơn hàng đã xác nhận, thông báo lỗi
        PRINT N' --> This order cannot be DELETED, as it has already been CONFIRMED';  
    END

commit