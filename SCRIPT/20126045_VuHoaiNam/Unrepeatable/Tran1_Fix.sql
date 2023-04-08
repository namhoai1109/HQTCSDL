use HQTCSDL_DEMO
go 
--truong hop 7
--khach hang tao don hang
set transaction isolation level repeatable read  
begin transaction 
	--doc du lieu tu bang de hien thi cho nguoi dung
	select * from [dbo].[Dish] where [partnerId] = 1
	select * from [dbo].[DishDetail] dishDetail join [dbo].[Dish] dish 
	on dishDetail.[dishId] = dish.[id] and dish.[partnerId] = 1

	--khach hang chon mon
	waitfor delay '00:00:10'
	--he thong tinh tong bill
	select sum([price]) from [dbo].[DishDetail] where ([id] = 3 or [id] = 2) and [dishId] = 1
commit

