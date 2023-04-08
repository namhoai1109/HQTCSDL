use HQTCSDL_DEMO
go
--Truong hop 3
--khach hang xem so luong mon
set transaction isolation level read committed
begin transaction
	select [quantity] from [DishDetail] where [dishId] = 2
commit