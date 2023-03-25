use HQTCSDL2
go

--Truong hop: 4
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
--Bo cai isolation level read uncommitted, su dung mac dinh cua he quan tri
BEGIN TRANSACTION xemHopDong
	SELECT * FROM HOPDONG
COMMIT