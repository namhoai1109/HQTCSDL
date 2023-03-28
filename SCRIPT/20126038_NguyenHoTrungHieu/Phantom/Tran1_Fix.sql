use HQTCSDL2
go

--Truong hop 8: Unrepeatable Read
-- Khach hang dat mon
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION datMon
	declare @soLuongDat int
	set @soLuongDat = 1

	--check so luong tuy chon
	-- lay khoa update
	if ((select SOLUONG from TUYCHONMON where id = 1) < @soLuongDat)
	begin
		raiserror(N'Số lượng không đủ', 16, 1)
		rollback
		return
	end

	waitfor delay '00:00:5'

	update TUYCHONMON
	set SOLUONG = SOLUONG - @soLuongDat
	where ID = 1

	if @@ERROR <> null
	begin
		rollback
		return
	end
	
	--tao don hang...
	--insert chi tiet...

COMMIT

--update TUYCHONMON
--set SOLUONG = 1
--where ID = 1