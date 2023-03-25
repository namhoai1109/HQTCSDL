use HQTCSDL2
go

--Truong hop 8: Unrepeatable Read
-- Doi tac cap nhat lai chi nhanh cua don hang
BEGIN TRANSACTION capNhatDonHang
	declare @idDonHang int
	set @idDonHang = 1

	declare @idChiNhanhMoi int
	set @idChiNhanhMoi = 1 -- id quan huyen = 4

	if (not exists(select * from DONHANG where MADON = @idDonHang))
	begin
		raiserror(N'Đơn hàng không tồn tại', 16, 1)
		rollback
		return
	end

	if (select ID_TAI_XE from DONHANG where MADON = @idDonHang) <> null
	begin
		raiserror(N'Đơn hàng đã xác nhận bởi tài xế', 16, 1)
		rollback
		return
	end

	update DONHANG
	set ID_CHI_NHANH = @idChiNhanhMoi
	where MADON = @idDonHang

COMMIT

-- Nho set lai cho madon 1 - ID Chi nhanh = 5 moi lan chay
--update DONHANG
--set ID_CHI_NHANH = 5, ID_TAI_XE = null
--where MADON = 1