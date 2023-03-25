use HQTCSDL2
go

/*
CÂU 6
	Unrepeatable: Trong transaction A tính tổng số like/dislike, khi có 1 transaction 
	B thay đổi like thành dislike trước khi transaction A tính dislike → Dữ liệu khi 
	transaction A tính like khác khi tính dislike
*/

-- Giải quyết: Dùng READ COMMITTED
/*
Tại sao dùng READ COMMITTED mà không dùng REPEATABLE READ
	Nếu ta sử dụng REPEATABLE READ isolation level thì đảm bảo không xảy ra lỗi này. 
	Tuy nhiên, đôi khi việc sử dụng REPEATABLE READ có thể gây ra lỗi khác là Phantom. 
	Vì vậy, tùy vào bài toán cụ thể mà chúng ta sẽ lựa chọn isolation level phù hợp để đảm bảo tính đúng đắn 
	của dữ liệu mà không gây ra các lỗi không mong muốn.

	Trong trường hợp này, nếu sử dụng READ COMMITTED thì vẫn có thể giải quyết được vấn đề unrepeatable read 
	bằng cách đọc và giữ các lock trên các dòng dữ liệu được đọc để tránh bị update trong thời gian đọc. 
	Và đồng thời, nó có thể giảm thiểu khả năng xảy ra phantom read, vì nó cho phép các giao dịch cùng đọc 
	cùng một dòng dữ liệu.
*/

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  -- Dùng READ COMMITTED
BEGIN TRANSACTION
	SELECT *
	FROM DONHANG
	WHERE TRANGTHAI = 'Chua xac nhan'

	WAITFOR DELAY '00:00:05'

	UPDATE DONHANG
	SET	TRANGTHAI = 'Xac nhan'
	WHERE MADON = 01
COMMIT