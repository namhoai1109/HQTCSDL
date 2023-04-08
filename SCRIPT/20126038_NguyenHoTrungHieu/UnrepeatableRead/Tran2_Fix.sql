use HQTCSDL_DEMO
go

--Truong hop 8: Unrepeatable Read
-- Doi tac cap nhat lai chi nhanh cua don hang
BEGIN TRANSACTION updateOrder
	declare @orderCode varchar
	set @orderCode = '82alal1ksl1958l11'

	declare @idNewBranch int
	set @idNewBranch = 2 --District: Quan 2

	if (not exists(select * from [dbo].[Order] with (XLOCK) where [orderCode] = '82alal1ksl1958l11'))
	begin
		raiserror(N'Đơn hàng không tồn tại', 16, 1)
		rollback
		return
	end

	if (select [shipperId] from [dbo].[Order] where [orderCode] = '82alal1ksl1958l11') is not null
	begin
		raiserror(N'Đơn hàng đã xác nhận bởi tài xế', 16, 1)
		rollback
		return
	end

	update [dbo].[Order]
	set [branchId] = @idNewBranch
	where [orderCode] = '82alal1ksl1958l11'

COMMIT


--select * from [dbo].[Order]

---- Nho set lai cho madon 1 - ID Chi nhanh = 5 moi lan chay
--update [dbo].[Order]
--set [branchId] = 1, [shipperId] = null
--where [orderCode] = '82alal1ksl1958l11'