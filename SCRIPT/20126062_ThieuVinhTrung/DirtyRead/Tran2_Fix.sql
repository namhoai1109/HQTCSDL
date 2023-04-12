use HQTCSDL_DEMO
go

--Sử dụng UPDLOCK và ROWLOCK trong Transaction 2 
-- cũng đảm bảo rằng chỉ có một tài xế được phép truy cập vào đơn hàng X cùng một lúc.

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION
	SELECT * FROM [dbo].[Order] WITH (UPDLOCK, ROWLOCK)
	WHERE [dbo].[Order].[status] = 'confirmed' AND [dbo].[Order].[shipperId] LIKE NULL
COMMIT


