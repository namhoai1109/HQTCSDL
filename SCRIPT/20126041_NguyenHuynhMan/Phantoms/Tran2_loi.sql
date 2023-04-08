use HQTCSDL
go


--C�u 9 : Phantom

begin transaction

INSERT INTO Order OUTPUT inserted.id values (02,01,01,'23/02/2023','03/03/2023','confirmed', 'Preparing',200000,15000)

commit
