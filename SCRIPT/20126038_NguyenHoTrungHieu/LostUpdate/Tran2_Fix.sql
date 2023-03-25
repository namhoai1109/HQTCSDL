USE HQTCSDL2
GO

BEGIN TRANSACTION datMon
	declare @soLuongDat int
	set @soLuongDat = 1

	--check so luong tuy chon
	if ((select SOLUONG from TUYCHONMON with (UPDLOCK) where id = 1) < @soLuongDat)
	begin
		raiserror(N'Số lượng không đủ', 16, 1)
		rollback
		return
	end

	update TUYCHONMON
	set SOLUONG = SOLUONG - @soLuongDat
	where ID = 1

	--tao don hang
	--insert chi tiet
COMMIT