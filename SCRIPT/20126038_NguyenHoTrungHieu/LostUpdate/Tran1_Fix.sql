USE HQTCSDL2
GO

--Truong hop 16: Lost Update
-- Hướng giải quyết: Sử dụng khóa UPDLOCK khi đọc ghi trên cùng đơn vị dữ liệu
-- => Những thao tác khác khi đọc ghi trên đơn vị dữ liệu này sẽ phải đợi
-- Giao tác đang giữ khóa UPDLOCK sau đó sẽ nâng cấp lên XLOCK và tiến hành update
-- Cuối cùng nhả khóa khi commit giao tác => Giao tác khác có thể xin khóa UPDLOCK và tiến hành
-- update như thường
-- Ko còn Lost Update

BEGIN TRANSACTION datMon
	declare @soLuongDat int
	set @soLuongDat = 1

	--check so luong tuy chon
	-- lay khoa update
		if ((select SOLUONG from TUYCHONMON with (UPDLOCK) where id = 1) < @soLuongDat)
	begin
		raiserror(N'Số lượng không đủ', 16, 1)
		rollback
		return
	end

	waitfor delay '00:00:05'
	update TUYCHONMON
	set SOLUONG = SOLUONG - @soLuongDat
	where ID = 1

	--tao don hang
	--insert chi tiet
COMMIT

--update TUYCHONMON
--set SOLUONG = 1
--where ID = 1