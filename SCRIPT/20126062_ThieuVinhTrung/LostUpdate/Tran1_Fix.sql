use HQTCSDL2
go

/*
CÂU 14:
	Lost update: Khi khách hàng đặt món và gửi yêu cầu đặt hàng cho đối tác, đối tác 
	tiếp nhận yêu cầu và thực hiện xác nhận đơn hàng. Trong khi đang chờ xác nhận 
	từ đối tác, khách hàng quyết định hủy đơn hàng và gửi yêu cầu hủy đơn hàng 
	cho đối tác, cùng lúc đó đối tác bấm xác nhận đơn → Gây ra sự cố xử lý dữ liệu
*/


/*
	Giải quyết:
		+ Dùng SERIALIZABLE cho cả 2 transaction
		+ Dùng thêm WITH(UPDLOCK) để đảm bảo rằng chỉ có 1 transaction được cập nhật đơn hàng đó
*/
select * from DONHANG

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRANSACTION
	-- Xem thông tin các đơn hàng chưa xác nhận
	SELECT *
	FROM DONHANG AS DH
	WHERE DH.TRANGTHAI = 'Chua xac nhan'
	WAITFOR DELAY '00:00:05'

	-- Update trạng thái của đơn hàng 
	UPDATE DONHANG WITH (UPDLOCK, ROWLOCK)
	SET TRANGTHAI = 'Xac nhan' 
	WHERE MADON = 14 AND TRANGTHAI = 'Chua xac nhan'

COMMIT	
