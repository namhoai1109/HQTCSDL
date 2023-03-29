use HQTCSDL
go

--Câu 9 : Phantom :
/*
Trong 1 transaction tính thu nhập của tháng và các ngày. 
Trong lúc đó khách hàng thêm 1 đơn hàng mới vào tháng hiện tại 
→ Thu nhập của tháng không bằng tổng thu nhập các ngày trong tháng.*/

set transaction isolation level SERIALIZABLE
begin transaction  

--Xem tổng thu nhập của đối tác
SELECT SUM(dh.TIENDON) as DON_THANG2
FROM DOITAC dt, CHINHANH cn, DONHANG dh
where dt.ID = cn.ID_DOI_TAC and cn.ID = dh.ID_CHI_NHANH AND month(dh.TG_TAO) = 2
group by dt.ID

waitfor delay '00:00:10'
--Xem chi tiết tổng thu nhập của đối tác
SELECT cn.ID , dh.TG_TAO as DON_THANG2, dh.TIENDON
FROM DOITAC dt, CHINHANH cn, DONHANG dh
where dt.ID = cn.ID_DOI_TAC and cn.ID = dh.ID_CHI_NHANH AND month(dh.TG_TAO) = 2
group by cn.ID, dh.TG_TAO, dh.TIENDON

commit transaction