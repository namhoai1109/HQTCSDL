use HQTCSDL2
go

--Truong hop 12: Phantom
-- Doi tac xoa tuy chon mon
BEGIN TRANSACTION
	delete from TUYCHONMON
	where ID = 1;
COMMIT

-- Nho chay lai database, xoa di tao lai :>
select * from TUYCHONMON
--INSERT INTO CHITIETDONHANG values (1,01,2,100000)