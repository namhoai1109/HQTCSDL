
--Câu 13 : Lost Updated
/*
Một tài xế chọn nhận đơn hàng, nhưng cùng lúc đó một tài xế khác cũng chọn đơn hàng này và lưu trữ vào cơ sở dữ liệu. 
Khi xem lại thông tin đơn hàng, chỉ một trong hai cập nhật tình trạng mới nhất được lưu trữ trong cơ sở dữ liệu, 
gây ra sự cố trong quá trình xử lý đơn hàng.
*/


/*					T1							|					T2
begin transaction								|
												|
update DONHANG									|
set ID_TAI_XE = 01								|
where MADON = 26								|
waitfor delay '00:00:05'						|
												|
												|
												|
												|				begin transaction
												|
												|				update DONHANG
												|				set ID_TAI_XE =02
												|				where MADON = 26
												|
commit											|				commit
												|
												|
*/