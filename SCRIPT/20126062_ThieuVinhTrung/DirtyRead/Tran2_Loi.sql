use HQTCSDL_DEMO
go

-- C�u 2 : Dirty Read
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION
	SELECT * FROM [dbo].[Order]
	WHERE [dbo].[Order].[status] = 'confirmed' AND [dbo].[Order].[shipperId] LIKE NULL
COMMIT
