use HQTCSDL
go

--Câu 5 : Unrepeatable read : Khi đối tác xem tổng thu nhập của mình trên tất cả chi nhánh 
--(mang tính realtime, kể cả những đơn hàng chưa được xác nhận). 
--Sau đó có một đơn hàng được cập nhật đơn giá (tăng hoặc giảm). 
--Tiếp theo đối tác muốn vào một chi nhánh để xem tổng thu nhập của một chi nhánh cụ thể 
--thì thấy tổng thu nhập của chi nhánh đó đã được thay đổi so với lần kiểm tra trên tất cả chi nhánh của đối tác.

set transaction isolation level REPEATABLE READ
begin transaction  
--Xem tổng thu nhập của đối tác
SELECT SUM([dbo].[Order].[orderPrice])
FROM [dbo].[Partner], [dbo].[Branch], [dbo].[Order]
where [dbo].[Partner].[id] = [dbo].[Branch].[partnerId] and [dbo].[Branch].[ID] = [dbo].[Order].[branchId] 
group by [dbo].[Partner].[id]

waitfor delay '00:00:05'
--Xem chi tiết tổng thu nhập của đối tác
--Chỉ xem những đơn hàng đã được giao
SELECT [dbo].[Branch].[id] ,SUM([dbo].[Order].[orderPrice])
FROM [dbo].[Partner], [dbo].[Branch], [dbo].[Order]
where  [dbo].[Partner].[id] = [dbo].[Branch].[partnerId] and [dbo].[Branch].[ID] = [dbo].[Order].[branchId] and [dbo].[Order].[process] = 'delivered'
group by [dbo].[Branch].[id]

commit transaction