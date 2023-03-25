use HQTCSDL2
go 
--truong hop 11
--thong ke doanh thu
set transaction isolation level serializable 
begin transaction 
	--thong ke doanh thu thang nay
	select sum(TIENDON) from DONHANG where MONTH(TG_TAO) = MONTH(GETDATE())

	waitfor delay '00:00:05'

	--thong ke doanh thu trong ngay hom nay
	select sum(TIENDON) from DONHANG where DAY(TG_TAO) = DAY(GETDATE())
commit