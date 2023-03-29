﻿use HQTCSDL2
go

--Truong hop 8: Unrepeatable Read
-- Tai xe xac nhan lay don hang
-- Hướng giải quyết: Xin khóa XLOCK trên đơn vị dữ liệu để đọc
-- Những thao tác khác khi cập nhật trên cùng đơn vị dữ liệu này sẽ phải đợi
-- Khi select lại lần 2 dữ liệu ko thay đổi, đảm bảo tính consistency của giao tác
-- Chỉ nhả khóa khi hết giao tác, lúc này các giao tác khác trong hàng đợi có thể tiến hành thực thi
-- Giải quyết được Unrepeatable Read

BEGIN TRANSACTION xacNhanLayDonHang
	declare @idTaiXe int
	set @idTaiXe = 1 --khvd = 2
	declare @idDonHang int
	set @idDonHang = 1 --kvhd = 2

	-- check don hang co thuoc khu vuc hoat dong cua tai xe
	if not exists(select * from DONHANG dh (xlock), CHINHANH cn
	where dh.MADON = @idDonHang
	and dh.TRANGTHAI like N'Xac nhan'
	and dh.ID_CHI_NHANH = cn.ID
	and cn.ID_QUAN_HUYEN = (select ID_HOAT_DONG from TAIXE where ID = @idTaiXe))
	begin
		raiserror(N'Đơn hàng không tồn tại trong khu vực', 16, 1)
		rollback
		return
	end

	waitfor delay '00:00:05'

	update DONHANG
	set ID_TAI_XE = @idTaiXe
	where exists(select * from DONHANG dh, CHINHANH cn 
	where dh.MADON = @idDonHang
	and dh.TRANGTHAI like N'Xac nhan'
	and dh.ID_CHI_NHANH = cn.ID
	and cn.ID_QUAN_HUYEN = (select ID_HOAT_DONG from TAIXE where ID = @idTaiXe))

	if @@ERROR <> NULL
	begin
		rollback
		return
	end
COMMIT