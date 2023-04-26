﻿use HQTCSDL_DEMO
go

--Câu 9 : Phantom :
/*
Trong 1 transaction tính thu nhập của tháng và các ngày. 
Trong lúc đó khách hàng thêm 1 đơn hàng mới vào tháng hiện tại 
→ Thu nhập của tháng không bằng tổng thu nhập các ngày trong tháng.*/

begin transaction  
set transaction isolation level read uncommitted
--Xem tổng thu nhập của đối tác
SELECT SUM([dbo].[Order].[orderPrice]) as INCOME
FROM [dbo].[Partner], [dbo].[Branch], [dbo].[Order]
where [dbo].[Partner].[ID] = [dbo].[Branch].[partnerId] and [dbo].[Branch].[ID] = [dbo].[Order].[branchId] AND month([dbo].[Order].[createdAt]) = 4
group by [dbo].[Partner].[ID]

waitfor delay '00:00:05'
--Xem chi tiết tổng thu nhập của đối tác
SELECT [dbo].[Branch].[ID] ,  [dbo].[Order].[createdAt] as INCOME,  [dbo].[Order].[orderPrice]
FROM [dbo].[Partner], [dbo].[Branch], [dbo].[Order]
where [dbo].[Partner].[ID] = [dbo].[Branch].[partnerId] and [dbo].[Branch].[ID] = [dbo].[Order].[branchId] AND month([dbo].[Order].[createdAt]) = 4
group by [dbo].[Partner].[ID], [dbo].[Branch].[ID], [dbo].[Order].[createdAt],  [dbo].[Order].[orderPrice]

commit transaction