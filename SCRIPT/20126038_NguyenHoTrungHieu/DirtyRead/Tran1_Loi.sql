USE HQTCSDL_DEMO
GO

--Truong hop: 4
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION confirmContract
	declare @year int
	select @year = [effectTimeInYear] from [dbo].[Contract] WHERE [taxCode] = '8765432'

	UPDATE [dbo].[Contract]
	SET [isConfirmed] = 1, [confirmedAt] = GETDATE(), [expiredAt] = DATEADD(YEAR, @year, GETDATE())
	WHERE [taxCode] = '8765432'

WAITFOR DELAY '00:00:07'

--some error
ROLLBACK

select * from [dbo].[Contract]
