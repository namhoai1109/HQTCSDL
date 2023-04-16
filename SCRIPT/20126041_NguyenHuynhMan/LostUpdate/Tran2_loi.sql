use HQTCSDL_DEMO
go

--C�u 13 : Lost Updated
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
begin transaction
    BEGIN
        UPDATE [dbo].[Order] 
        SET [dbo].[Order].[shipperId] = 2
        WHERE [dbo].[Order].[id] = 2;
    END
COMMIT

