--Câu 9 : Phantom :
/*
Trong 1 transaction tính thu nhập của tháng và các ngày. 
Trong lúc đó khách hàng thêm 1 đơn hàng mới vào tháng hiện tại 
→ Thu nhập của tháng không bằng tổng thu nhập các ngày trong tháng.*/
-- Để khắc phục lỗi, sử dụng câu lệnh: set transaction isolation level SERIALIZABLE

/*
Tạo Shared Lock trên đơn vị dữ liệu được
đọc và giữ shared lock này đến hết giao tác
=> Các giao tác khác phải chờ đến khi giao
tác này kết thúc nếu muốn cập nhật, thay
đổi giá trị trên đơn vị dữ liệu này.

Không cho phép Insert những dòng dữ
liệu thỏa mãn điều kiện thiết lập Shared
Lock (sử dụng Key Range Lock) ==>
Serializable = Repeatable Read + Giải
quyết Phantoms.
Tạo Exclusive Lock trên đơn vị dữ liệu
được ghi, Exclusive Lock được giữ cho đến
hết giao tác.
*/

--								T1							|							T2
/*	set transaction isolation level SERIALIZABLE			|
	begin transaction										|
															|
	--Xem tổng thu nhập của đối tác							|
															|
	SELECT SUM(dh.TIENDON) as DON_THANG2					|
	FROM DOITAC dt, CHINHANH cn, DONHANG dh					|
	where dt.ID = cn.ID_DOI_TAC								|
	AND cn.ID = dh.ID_CHI_NHANH								|
	AND month(dh.TG_TAO) = 2								|
	group by dt.ID											|
	waitfor delay '00:00:10'								|
															|		set transaction isolation level SERIALIZABLE	
															|		begin transaction
															|
															|		INSERT INTO DONHANG 
															|		OUTPUT inserted.MADON 
															|		values (02,01,01,'Xac nhan', 'Dang chuan bi','23/02/2023','03/03/2023',200000,15000)
															|
															|		commit
															|
															|
															|
	--Xem chi tiết tổng thu nhập của đối tác				|
															|	
	SELECT cn.ID , dh.TG_TAO as DON_THANG2, dh.TIENDON		|	
	FROM DOITAC dt, CHINHANH cn, DONHANG dh					|
	where dt.ID = cn.ID_DOI_TAC								|	
	AND cn.ID = dh.ID_CHI_NHANH								|	
	AND month(dh.TG_TAO) = 2								|	
	group by cn.ID, dh.TG_TAO, dh.TIENDON					|		
															|	
	commit transaction										|
*/