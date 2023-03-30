use HQTCSDL2
go

--Sử dụng UPDLOCK và ROWLOCK trong Transaction 2 
-- cũng đảm bảo rằng chỉ có một tài xế được phép truy cập vào đơn hàng X cùng một lúc.

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION
	SELECT * FROM DONHANG WITH (UPDLOCK, ROWLOCK)
	WHERE TRANGTHAI = 'Chua xac nhan'
COMMIT