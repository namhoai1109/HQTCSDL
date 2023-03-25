use HQTCSDL2
go

--Truong hop 8: Unrepeatable Read
-- Doi tac xoa tuy chon mon
BEGIN TRANSACTION
	delete from TUYCHONMON
	where ID = 1;
COMMIT