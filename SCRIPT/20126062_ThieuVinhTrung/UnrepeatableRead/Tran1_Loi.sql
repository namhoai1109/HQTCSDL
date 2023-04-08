USE HQTCSDL2
GO

/*
CÂU 6
	Unrepeatable: Trong transaction A, khách hàng tạo một đơn hàng với những tùy chọn X,Y,Z. 
	Đối tác thấy đơn hàng mới, thực hiện xác nhận đơn hàng. 
	Trong lúc đơn hàng chưa xác nhận thì khách hàng bỏ bớt món trong đơn hàng của mình 
	nên sau đó đối tác đã xác nhận đơn hàng với số lượng món và giá tiền khác với ban đầu.
*/


BEGIN TRANSACTION
	SELECT *
	FROM Order o
	WHERE o.status = 'pending'

	WAITFOR DELAY '00:00:05'

	UPDATE Order o 
	SET	o.status = 'confirmed'
	WHERE MADON = 01

COMMIT
