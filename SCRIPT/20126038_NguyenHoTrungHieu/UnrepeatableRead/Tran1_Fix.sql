use HQTCSDL_DEMO
go

--Truong hop 8: Unrepeatable Read
-- Tai xe xac nhan lay don hang
-- Hướng giải quyết: Xin khóa XLOCK trên đơn vị dữ liệu để đọc
-- Những thao tác khác khi cập nhật trên cùng đơn vị dữ liệu này sẽ phải đợi
-- Khi select lại lần 2 dữ liệu ko thay đổi, đảm bảo tính consistency của giao tác
-- Chỉ nhả khóa khi hết giao tác, lúc này các giao tác khác trong hàng đợi có thể tiến hành thực thi
-- Giải quyết được Unrepeatable Read

BEGIN TRANSACTION confirmTakeOrder
	declare @idShipper int
	set @idShipper = 1 --District: Quan 1
	declare @orderCode nvarchar
	set @orderCode = '82alal1ksl1958l11' --District: Quan 1

	-- check don hang co thuoc khu vuc hoat dong cua tai xe
	if not exists(select * from [dbo].[Order] dh with (XLOCK), [dbo].[Branch] cn
	where dh.[orderCode] = '82alal1ksl1958l11' --temporary
	and dh.[status] like 'confirmed'
	and dh.[branchId] = cn.[id]
	and cn.[districtId] = (select [districtId] from [dbo].[Shipper] where [id] = @idShipper))
	begin
		raiserror(N'Đơn hàng không tồn tại trong khu vực', 16, 1)
		rollback
		return
	end

	waitfor delay '00:00:05'

	update [dbo].[Order]
	set [shipperId] = @idShipper
	where exists(select * from [dbo].[Order] dh, [dbo].[Branch] cn
	where dh.[orderCode] = '82alal1ksl1958l11' --temporary
	and dh.[status] like 'confirmed'
	and dh.[branchId] = cn.[id]
	and cn.[districtId] = (select [districtId] from [dbo].[Shipper] where [id] = @idShipper))

	if @@ERROR <> NULL
	begin
		rollback
		return
	end
COMMIT