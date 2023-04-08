use HQTCSDL_DEMO
go

--C�u 13 : Lost Updated
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION;

BEGIN TRY
    -- Attempt to update the row with the new value
    IF EXISTS (
        SELECT * FROM [dbo].[Order] WHERE [dbo].[Order].[id] = 21 AND [dbo].[Order].[shipperId] is null
    )
    BEGIN
        UPDATE [dbo].[Order] 
        SET [dbo].[Order].[shipperId] = '02'
        WHERE [dbo].[Order].[id] = '21';
    END

    -- Check if the update affected any rows
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No rows updated', 16, 1);
    END

    -- Commit the transaction if successful
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Roll back the transaction if an error occurs
    IF XACT_STATE() <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END
    
   
END CATCH
select * from Order
