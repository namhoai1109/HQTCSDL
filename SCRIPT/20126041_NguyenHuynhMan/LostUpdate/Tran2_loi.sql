use HQTCSDL_DEMO
go

--C�u 13 : Lost Updated
<<<<<<< Updated upstream
=======
begin transaction
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    BEGIN
        UPDATE [dbo].[Order] 
        SET [dbo].[Order].[shipperId] = 2
        WHERE [dbo].[Order].[id] = 2;
    END
COMMIT
>>>>>>> Stashed changes

begin transaction

update [dbo].[Order]
set [dbo].[Order].[shipperId] = 2
where [dbo].[Order].[id] = 2

commit
