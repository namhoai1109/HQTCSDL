use HQTCSDL
go


--C�u 9 : Phantom
set transaction isolation level SERIALIZABLE
begin transaction

INSERT INTO [dbo].[Order] OUTPUT inserted.id values (02,01,01,'23/02/2023','03/03/2023','confirmed', 'preparing',200000,15000)

commit
