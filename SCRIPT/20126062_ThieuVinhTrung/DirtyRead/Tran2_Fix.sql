use HQTCSDL_DEMO
go

-- Ta dùng Read Commited để giải quyết tình huống 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
	SELECT * FROM [dbo].[Order]
	WHERE [status] = 'confirmed' AND [shipperId] IS NULL
COMMIT


