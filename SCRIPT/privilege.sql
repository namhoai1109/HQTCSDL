--SCRIPT CHO BÁO CÁO
use HQTCSDL_DEMO
go

--Tạo role
CREATE ROLE CUSTOMER
CREATE ROLE SHIPPER
CREATE ROLE PRO_ADMIN
CREATE ROLE PRO_PARTNER
CREATE ROLE STAFF

--Tạo user minh họa
CREATE LOGIN MAN1
WITH PASSWORD = '123';
CREATE LOGIN MAN2
WITH PASSWORD = '123';
CREATE LOGIN MAN3
WITH PASSWORD = '123';
CREATE LOGIN MAN4
WITH PASSWORD = '123';
CREATE LOGIN MAN5
WITH PASSWORD = '123';

GO
EXEC sp_addrolemember STAFF, MAN1;
EXEC sp_addrolemember SHIPPER, MAN2;
EXEC sp_addrolemember PRO_ADMIN, MAN3;
EXEC sp_addrolemember PRO_PARTNER, MAN4;
EXEC sp_addrolemember CUSTOMER, MAN5;


--Gán accessAdmin cho role admin
ALTER ROLE db_accessadmin ADD MEMBER MAN3;
go
--Tạo view
--View trên bảng hợp đồng
CREATE VIEW VIEW_CONTRACT 
AS
SELECT *
FROM [dbo].[CONTRACT]
go

--View trên bảng đơn hàng
CREATE VIEW VIEW_ORDER 
AS
SELECT *
FROM [dbo].[ORDER] o, [dbo].[DISTRICT] d ,[dbo].[BRANCH] b, [dbo].[SHIPPER] s
WHERE o.[branchId] = b.[id] and b.[districtId] = d.[id] and s.[districtId] = d.[id]
go

--View trên bảng tài xế
CREATE VIEW SHIPPER_INFO
as
SELECT *
FROM [dbo].[SHIPPER]
Where [ID] = @SHIPPER_ID
go

--Phân quyền tài xế

GRANT UPDATE ON [dbo].[SHIPPER](DISTRICTID) TO SHIPPER;					-- Thay đổi khu vực hoạt động
GRANT UPDATE ON ACCOUNT(PASSWORD) TO SHIPPER;			--Đổi mật khẩu
GRANT UPDATE ON [dbo].[ORDER](PROCESS) TO SHIPPER;		--Thay đổi quá trình vận chuyển đơn hàng
GRANT UPDATE ON [dbo].[SHIPPER] TO SHIPPER;					--Update thông tin (info) của tài xế
GRANT INSERT ON [dbo].[SHIPPER] TO SHIPPER;					--Tạo mới tài khoản

--Phân quyền khách hàng

GRANT DELETE ON [dbo].[ORDER] TO CUSTOMER;				--Xóa đơn hàng khi chưa được đối tác xác nhận
GRANT SELECT ON [dbo].[ORDER] TO CUSTOMER;				--Xem đơn hàng của mình
GRANT INSERT ON [dbo].[ORDER] TO CUSTOMER;				--Đặt đơn hàng mới
GRANT ALL ON [dbo].[CUSTOMER] TO CUSTOMER;				--Quản lý info của mình
GRANT INSERT ON [dbo].[ACCOUNT] TO CUSTOMER;				--Tạo mới tài khoản
GRANT UPDATE ON [dbo].[ACCOUNT](USERNAME) TO CUSTOMER;		--Update account
GRANT UPDATE ON [dbo].[ACCOUNT](PASSWORD) TO CUSTOMER;		--Update account
GRANT ALL ON [dbo].[RATING] TO CUSTOMER;					--Tạo, chỉnh sửa đánh giá món

--Phân quyền đối tác

GRANT SELECT,INSERT,UPDATE ON [dbo].[PARTNER] TO PRO_PARTNER;	--Tạo mới, chỉnh sửa, xóa thông tin của chính đối tác cũng như các chi nhánh có liên quan
GRANT INSERT ON [dbo].[ACCOUNT] TO PRO_PARTNER;					--Tạo mới tài khoản
GRANT UPDATE ON [dbo].[ACCOUNT](USERNAME) TO PRO_PARTNER;		--Update account
GRANT UPDATE ON [dbo].[ACCOUNT](PASSWORD) TO PRO_PARTNER;			--Update account
GRANT ALL ON [dbo].[BRANCH] TO PRO_PARTNER;					--Có mọi quyền trên chi nhánh của chính mình
GRANT ALL ON [dbo].[DISH] TO PRO_PARTNER;							--Có mọi quyền trên danh sách món của chính mình
GRANT ALL ON [dbo].[DISHDETAIL] TO PRO_PARTNER;                     --Có mọi quyền trên tùy chọn món của chính mình

--Gán quyền trên các view

GRANT ALL PRIVILEGES ON [dbo].[CONTRACT] TO STAFF			--Gán privileges trên từng view
GRANT ALL PRIVILEGES ON VIEW_CONTRACT TO PRO_PARTNER		--Gán privileges trên từng view
GRANT ALL PRIVILEGES ON VIEW_ORDER TO SHIPPER		--Gán privileges trên từng view
GRANT ALL PRIVILEGES ON SHIPPER_INFO TO SHIPPER			--Gán privileges trên từng view
