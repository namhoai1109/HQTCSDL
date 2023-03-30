use HQTCSDL
go


--Câu 9 : Phantom
set transaction isolation level SERIALIZABLE
begin transaction

INSERT INTO DONHANG OUTPUT inserted.MADON values (02,01,01,'Xac nhan', 'Dang chuan bi','23/02/2023','03/03/2023',200000,15000)

commit
