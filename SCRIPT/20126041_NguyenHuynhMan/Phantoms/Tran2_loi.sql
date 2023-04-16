use HQTCSDL_DEMO
go


--C�u 9 : Phantom

begin transaction
INSERT INTO [dbo].[Order] OUTPUT inserted.id values (02,null,01,GETDATE(),GETDATE(),'pending', 'pending',200000,15000,215000,'82alal1ks21sds1222w')
commit transaction
