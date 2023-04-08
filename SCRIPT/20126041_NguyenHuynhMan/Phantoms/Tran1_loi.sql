use HQTCSDL
go

--Câu 9 : Phantom :
/*
Trong 1 transaction tính thu nhập của tháng và các ngày. 
Trong lúc đó khách hàng thêm 1 đơn hàng mới vào tháng hiện tại 
→ Thu nhập của tháng không bằng tổng thu nhập các ngày trong tháng.*/

set transaction isolation level repeatable read
begin transaction  

--Xem tổng thu nhập của đối tác
SELECT SUM(o.orderPrice) as INCOME_FEB
FROM dbo.Partner pa, Branch br, Order o
where pa.ID = br.partnerId and br.ID = o.branchId AND month(o.createdAt) = 2
group by pa.ID

waitfor delay '00:00:10'
--Xem chi tiết tổng thu nhập của đối tác
SELECT br.ID , o.createdAt as INCOME_FEB, o.orderPrice
FROM dbo.Partner pa, Branch br, Order o
where pa.ID = br.partnerId and br.ID = o.branchId AND month(o.createdAt) = 2
group by pa.ID, o.createdAt, o.orderPrice

commit transaction