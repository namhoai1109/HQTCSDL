
--Câu 13 : Lost Updated
/*
Một tài xế chọn nhận đơn hàng, nhưng cùng lúc đó một tài xế khác cũng chọn đơn hàng này và lưu trữ vào cơ sở dữ liệu. 
Khi xem lại thông tin đơn hàng, chỉ một trong hai cập nhật tình trạng mới nhất được lưu trữ trong cơ sở dữ liệu, 
gây ra sự cố trong quá trình xử lý đơn hàng.
*/

-- Để khắc phục lỗi ở đây, ta có thể xin khóa uplock trên những dataset cần truy cập để
-- Ở đây em chỉ xin uplock trên một hàng mà câu truy vấn quan tâm đến mà không phải lock toàn bảng
-- Để tránh việc các giao tác khác cần truy cập đến dataset khác trong bảng mà không xuất hiện Lost Update
-- Cần thêm một vài dòng code ở tran 2 để khi không truy cập được vào dòng cần update dữ liệu (không được cấp khóa), thì raise error và rollback
-- Thêm câu truy vấn: SET TRANSACTION ISOLATION LEVEL SERIALIZABLE


/*					T1							|					T2
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE	|
begin transaction								|
												|
update DONHANG WITH (UPDLOCK, ROWLOCK)			|
set ID_TAI_XE = 01								|
where MADON = 26								|
waitfor delay '00:00:05'						|
												|
												|
												|				SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
												|				begin transaction
												|
												|				update DONHANG WITH (UPDLOCK, ROWLOCK)
												|				set ID_TAI_XE =02
												|				where MADON = 26
												|
commit											|				commit
												|
												|
*/