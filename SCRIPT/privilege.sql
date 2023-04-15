--SCRIPT CHO BÁO CÁO
use HQTCSDL_DEMO

--Tạo role
CREATE ROLE NHANVIEN
CREATE ROLE TAIXE
CREATE ROLE QUANTRI_ADMIN
CREATE ROLE DOITAC

--Tạo user minh họa
CREATE LOGIN MAN1
WITH PASSWORD = '123';
CREATE LOGIN MAN2
WITH PASSWORD = '123';
CREATE LOGIN MAN3
WITH PASSWORD = '123';
CREATE LOGIN MAN4
WITH PASSWORD = '123';

GO
EXEC sp_addrolemember NHANVIEN, MAN1;
EXEC sp_addrolemember TAIXE, MAN2;
EXEC sp_addrolemember QUANTRI_ADMIN, MAN3;
EXEC sp_addrolemember DOITAC, MAN4;

--Gán accessAdmin cho role admin
ALTER ROLE db_accessadmin ADD MEMBER MAN3;
go
--Tạo view
--View trên bảng hợp đồng
CREATE VIEW HOPDONG_view 
AS
SELECT *
FROM HOPDONG
go

--View trên bảng đơn hàng
CREATE VIEW DONHANG_view 
AS
SELECT *
FROM DON_HANG dh, QUAN q ,CHI_NHANH cn, TAI_XE tx
WHERE dh.IDCHINHANH = cn.ID and cn.DIACHI = q.ID and tx.DIACHI = q.ID
go

--View trên bảng tài xế
CREATE VIEW INFO_TX
as
SELECT *
FROM TAIXE
Where TAIXE.ID = @TAIXE_ID
go

--Phân quyền tài xế

GRANT UPDATE ON QUAN (id) TO TAIXE;					-- Thay đổi khu vực hoạt động
GRANT UPDATE ON ACCOUNT(matkhau) TO TAIXE;			--Đổi mật khẩu
GRANT UPDATE ON DON_HANG(quatrinh) TO TAIXE;		--Thay đổi quá trình vận chuyển đơn hàng
GRANT UPDATE ON TAI_XE TO TAIXE;					--Update thông tin (info) của tài xế
GRANT INSERT ON TAI_XE TO TAIXE;					--Tạo mới tài khoản

--Phân quyền khách hàng

GRANT DELETE ON DON_HANG TO KHACHHANG;				--Xóa đơn hàng khi chưa được đối tác xác nhận
GRANT SELECT ON DON_HANG TO KHACHHANG;				--Xem đơn hàng của mình
GRANT INSERT ON DON_HANG TO KHACHHANG;				--Đặt đơn hàng mới
GRANT ALL ON KHACH_HANG TO KHACHHANG;				--Quản lý info của mình
GRANT INSERT ON ACCOUNT TO KHACHHANG;				--Tạo mới tài khoản
GRANT UPDATE ON ACCOUNT(USERNAME) TO KHACHHANG;		--Update account
GRANT UPDATE ON ACCOUNT(MATKHAU) TO KHACHHANG;		--Update account
GRANT ALL ON DANHGIA TO KHACHHANG;					--Tạo, chỉnh sửa đánh giá món

--Phân quyền đối tác

GRANT SELECT,INSERT,UPDATE ON DOI_TAC TO DOITAC;	--Tạo mới, chỉnh sửa, xóa thông tin của chính đối tác cũng như các chi nhánh có liên quan
GRANT INSERT ON ACCOUNT TO DOITAC;					--Tạo mới tài khoản
GRANT UPDATE ON ACCOUNT(USERNAME) TO DOITAC;		--Update account
GRANT UPDATE ON ACCOUNT(MATKHAU) TO DOITAC;			--Update account
GRANT ALL ON CHI_NHANH TO DOITAC;					--Có mọi quyền trên chi nhánh của chính mình
GRANT ALL ON MON TO DOITAC;							--Có mọi quyền trên danh sách món của chính mình
GRANT ALL ON TUY_CHON_MON TO DOITAC;				--Có mọi quyền trên tùy chọn món của chính mình

--Gán quyền trên các view

GRANT ALL PRIVILEGES ON HOPDONG TO NHANVIEN			--Gán privileges trên từng view
GRANT ALL PRIVILEGES ON HOPDONG_view TO DOITAC		--Gán privileges trên từng view
GRANT ALL PRIVILEGES ON DONHANG_view TO TAIXE		--Gán privileges trên từng view
GRANT ALL PRIVILEGES ON INFO_TX TO TAIXE			--Gán privileges trên từng view
