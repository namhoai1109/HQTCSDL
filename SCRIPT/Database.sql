
create database HQTCSDL2
go
use HQTCSDL2
go

create table THANHPHO
(
	ID INT IDENTITY(1,1) not null,
	TEN NVARCHAR(25),
	PRIMARY KEY(ID)
)

create table QUAN
(
	ID INT IDENTITY(1,1) not null,
	TEN NVARCHAR(25),
	ID_THANH_PHO INT,
	PRIMARY KEY(ID)
)
create table DONHANG
(	
	MADON INT IDENTITY(1,1) not null,
	ID_KHACH_HANG INT,
	ID_TAI_XE INT,
	ID_CHI_NHANH INT,
	TRANGTHAI varchar(25),
	QUATRINH varchar(25),
	TG_TAO datetime,
	TG_GIAO datetime,
	TIENDON float,
	TIENSHIP float,
	PRIMARY KEY(MADON)
)
create table TAIXE
(
	ID INT IDENTITY(1,1) not null,
	ID_TAI_KHOAN INT,
	ID_HOAT_DONG INT,
	HOTEN nvarchar(25),
	CMND varchar(25),
	SDT varchar(25),
	BIEN_SO_XE varchar(25),
	EMAIL varchar(25),
	TK_NGAN_HANG varchar(25),
	PRIMARY KEY(ID)
)
create table HOPDONG
(
	ID INT IDENTITY(1,1) not null,
	MA_SO_THUE varchar(25),
	NGUOI_DAI_DIEN nvarchar(25),
	MA_TRUY_CAP varchar(25),
	TK_NGAN_HANG varchar(25),
	TG_TAO datetime,
	DA_XAC_NHAN bit,
	DA_HET_HAN bit,
	TG_XAC_NHAN datetime,
	TG_HET_HIEU_LUC datetime,
	PRIMARY KEY(ID)
)
create table TAIKHOAN
(
	ID INT IDENTITY(1,1) not null,
	USERNAME varchar(25),
	MAT_KHAU varchar(25),
	VAI_TRO varchar(25),
	TRANG_THAI varchar(25),
	PRIMARY KEY(ID)
)
create table KHACHHANG
(
	ID INT IDENTITY(1,1) not null,
	ID_TAI_KHOAN INT,
	HOTEN nvarchar(50) not null,
	DIACHI nvarchar(50) not null,
	SDT varchar(25) not null,
	EMAIL varchar(50) unique,
	PRIMARY KEY(ID)
)

create table CHINHANH
(
	ID INT IDENTITY(1,1) not null,
	ID_DOI_TAC INT,
	ID_QUAN_HUYEN INT,
	STT int,
	DIACHI varchar(25) UNIQUE,
	PRIMARY KEY(ID)
)

create table DOITAC
(
	ID INT IDENTITY(1,1) not null,
	ID_TAI_KHOAN INT,
	ID_HOP_DONG INT,
	EMAIL varchar(25),
	TAIKHOAN_NGAN_HANG varchar(25),
	NG_DAI_DIEN varchar(25),
	STD varchar(25),
	SO_LG_DON_HANG int,
	TEN_CUA_HANG nvarchar(25),
	TINHTRANG varchar(25),
	LOAI_AM_THUC varchar(25),
	PRIMARY KEY(ID)
)
create table DANHGIA
(
	ID_KHACH_HANG INT,
	ID_MON INT,
	MIEU_TA varchar(25),
	THICH_KOTHICH bit,
	PRIMARY KEY(ID_KHACH_HANG, ID_MON)
)


create table MON
(
	ID INT IDENTITY(1,1) not null,
	ID_DOI_TAC INT,
	TEN_MON nvarchar(25),
	MIEU_TA nvarchar(200),
	SOLUONG int,
	TINH_TRANG_MON nvarchar(25),
	RATING float,
	PRIMARY KEY(ID)
)
create table TUYCHONMON
(
	ID INT IDENTITY(1,1) not null,
	ID_MON INT,
	TUY_CHON varchar(25),
	GIA float
	PRIMARY KEY(ID)
)
--ID cuar mỗi tùy chọn phải unique, nhiều tùy chọn cùng 1 món
create table CHITIETDONHANG
(
	MADON INT,
	ID_TUY_CHON INT,
	SO_LUONG int,
	GIA_TIEN float,
	PRIMARY KEY(MADON, ID_TUY_CHON)
)
--set thêm id món để mapping 2 field 


set dateformat dmy

alter table QUAN add
	constraint FK_QUAN_THANHPHO foreign key (ID_THANH_PHO)references THANHPHO (ID)

alter table TAIXE add
	constraint FK_TAIXE_QUAN foreign key (ID_HOAT_DONG) references QUAN(ID),
	constraint FK_TAIXE_TAIKHOAN foreign key(ID_TAI_KHOAN) references TAIKHOAN(ID)


alter table CHINHANH add
	constraint FK_CHINHANH_QUAN foreign key (ID_QUAN_HUYEN) references QUAN(ID),
	constraint FK_CHINHANH_DOITAC foreign key (ID_DOI_TAC) references DOITAC(ID)

alter table KHACHHANG add
	constraint FK_KHACHHANG_TAIKHOAN foreign key(ID_TAI_KHOAN) references TAIKHOAN(ID)

alter table DANHGIA add
	constraint FK_DANHGIA_KHACHHANG foreign key(ID_KHACH_HANG) references KHACHHANG(ID),
	constraint FK_DANHGIA_MON foreign key(ID_MON) references MON(ID)

alter table MON add
	constraint FK_MON_DOITAC foreign key (ID_DOI_TAC) references DOITAC(ID)

alter table DOITAC add
	constraint FK_DOITAC_TAIKHOAN foreign key(ID_TAI_KHOAN) references TAIKHOAN(ID),
	constraint FK_DOITAC_HOPDONG foreign key(ID_HOP_DONG)references HOPDONG(ID)

alter table CHITIETDONHANG add
	constraint FK_CHITIET_DONHANG foreign key (MADON) references DONHANG(MADON),
	constraint FK_CHITIET_TUYCHONMON foreign key(ID_TUY_CHON) references TUYCHONMON(ID)

alter table DONHANG add  
	constraint FK_DONHANG_KHACHHANG foreign key(ID_KHACH_HANG) references KHACHHANG(ID),
	constraint FK_DONHANG_TAIXE foreign key(ID_TAI_XE) references TAIXE(ID),
	constraint FK_DONHANG_CHINHANH foreign key (ID_CHI_NHANH) references CHINHANH(ID)

alter table TUYCHONMON add
	constraint FK_TUYCHON_MON foreign key(ID_MON) references MON(ID)

INSERT INTO THANHPHO(TEN) OUTPUT inserted.ID values(N'Hồ Chí Minh')
INSERT INTO THANHPHO(TEN) OUTPUT inserted.ID values(N'Hà Nội')
INSERT INTO THANHPHO(TEN) OUTPUT inserted.ID values(N'Nha Trang')
INSERT INTO THANHPHO(TEN) OUTPUT inserted.ID values(N'Đà Nẵng')

INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(01,N'Quận 1')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(01,N'Quận 2')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(01,N'Quận 3')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(01,N'Quận 4')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(02,N'Quận Hoàn Kiếm')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(02,N'Quận Đống Đa')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(02,N'Quận Thanh Xuân')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(02,N'Quận Hà Đông')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(03,N'Vĩnh Hòa')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(03,N'Vĩnh Phước')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(03,N'Vĩnh Hải')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(03,N'Vĩnh Thọ')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(04,N'Hải Châu')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(04,N'Cẩm Lệ')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(04,N'Thanh Khê')
INSERT INTO QUAN(ID_THANH_PHO,TEN) OUTPUT inserted.ID values(04,N'Sơn Trà')

INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('taixe1','taixe','taixe','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('taixe2','taixe','taixe','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('taixe3','taixe','taixe','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('khach1','khachhang','khachhang','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('khach2','khachhang','khachhang','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('khach3','khachhang','khachhang','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('doitac1','doitac','doitac','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('doitac2','doitac','doitac','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('doitac3','doitac','doitac','active')

INSERT INTO TAIXE OUTPUT inserted.ID values (01,02,N'Nguyễn Văn A','123123321321','0123456789', '59D657892','nva@gmail.com', '9867986712341234')
INSERT INTO TAIXE OUTPUT inserted.ID values (02,02,N'Nguyễn Văn B','758111928099','0987654321', '59F123456','nvb@gmail.com', '4536728192873024')
INSERT INTO TAIXE OUTPUT inserted.ID values (03,04,N'Nguyễn Văn C','102111928293','0123123421', '59A987654','nvc@gmail.com', '1234897859172101')

INSERT INTO HOPDONG OUTPUT inserted.ID values('8271892819', N'Nguyễn Huỳnh Mẫn', '551717', '9817293085828371', GETDATE(), 0, 0, null, null)
INSERT INTO HOPDONG OUTPUT inserted.ID values('8291829187', N'Nguyễn Hồ Trung Hiếu', '1231223', '4627110829189840', GETDATE(), 0, 0, null, null)
INSERT INTO HOPDONG OUTPUT inserted.ID values('1829908118', N'Thiều Vĩnh Trung', '551718', '40198568920129130', GETDATE(), 0, 0, null, null)

INSERT INTO DOITAC OUTPUT inserted.ID values (07, 01,'abc@gmail.com', '9817293085828371', N'Nguyễn Huỳnh Mẫn', '087691920192', 20, N'CAFE N GO','active','Nuoc')
INSERT INTO DOITAC OUTPUT inserted.ID values (08, 02,'xyz@gmail.com', '4627110829189840', N'Nguyễn Hồ Trung Hiếu', '0777058016', 20, N'GO CAFE','active', 'Nuoc')
INSERT INTO DOITAC OUTPUT inserted.ID values (09, 03,'def@gmail.com', '40198568920129130', N'Thiều Vĩnh Trung', '013458910291', 25, N'3 MIEN','active', 'Thuc An')

INSERT INTO KHACHHANG OUTPUT inserted.ID values (04,N'Tran Thi A', N'400 Điện Biên Phủ, HCM','09810238912','hello@gmail.com')
INSERT INTO KHACHHANG OUTPUT inserted.ID values (05,N'Tran Thi B', N'250 Trần Hưng đạo','09898798798','hello1@gmail.com')
INSERT INTO KHACHHANG OUTPUT inserted.ID values (06,N'Tran Thi C', N'1000 Trường Chinh','09879872231','hello2@gmail.com')

INSERT INTO CHINHANH OUTPUT inserted.ID values (01, 04, 1,'227 Nguyen Van Cu')
INSERT INTO CHINHANH OUTPUT inserted.ID values (01, 01, 2,'210 Tran Hung Dao')
INSERT INTO CHINHANH OUTPUT inserted.ID values (02, 02, 1,'550 Truong Son')
INSERT INTO CHINHANH OUTPUT inserted.ID values (03, 01, 1,'100 Nam Ky Khoi Nghia')

INSERT INTO MON OUTPUT inserted.ID values (01,N'Mì Soba',N'Mì lạnh', 20,'Con hang',null)
INSERT INTO MON OUTPUT inserted.ID values (01,N'Mì gói',N'Mì hảo hảo',20,'Con hang',null)
INSERT INTO MON OUTPUT inserted.ID values (02,N'Mì ramen',N'Mì nước',20,'Con hang',null)
INSERT INTO MON OUTPUT inserted.ID values (02,N'Mì udon',N'Mì nước',20,'Con hang',null)
INSERT INTO MON OUTPUT inserted.ID values (03,N'Yakisoba',N'Mì xào',20,'Con hang',null)
INSERT INTO MON OUTPUT inserted.ID values (03,N'Katsudon',N'Thịt chiên',20,'Con hang',null)

INSERT INTO TUYCHONMON OUTPUT inserted.ID values (01,'Mặc định',50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (01,'Thêm trứng',15000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (01,'Thêm rau',7000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (02,'Mặc định', 50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (02,'Thêm trứng',15000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (02,'Thêm rau',7000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (03,'Mặc định', 50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (03,'Thêm trứng',15000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (03,'Thêm rau',7000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (04,'Mặc định', 50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (04,'Thêm trứng',15000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (04,'Thêm rau',7000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (05,'Mặc định', 50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (05,'Thêm trứng',15000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (05,'Thêm rau',7000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (06,'Mặc định', 50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (06,'Thêm trứng',15000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (06,'Thêm rau',7000)

INSERT INTO DONHANG OUTPUT inserted.MADON values (01,01,01,'Xac nhan', 'Dang chuan bi', GETDATE(),null, 50000, 20000)
INSERT INTO DONHANG OUTPUT inserted.MADON values (02,02,02,'Xac nhan', 'Dang chuan bi', GETDATE(),null, 50000, 25000)	
INSERT INTO DONHANG OUTPUT inserted.MADON values (03,03,03,'Xac nhan', 'Dang chuan bi', GETDATE(),null, 50000, 25000)	

INSERT INTO DANHGIA values (01,01,'Ngon',1)
INSERT INTO DANHGIA values (02,01,'Ngon',1)
INSERT INTO DANHGIA values (03,01,'Ngon',1)
--Tạo thêm danhgia

--sửa lại unique ở id món,tùy chọn
INSERT INTO CHITIETDONHANG values (1,01,2,100000)
INSERT INTO CHITIETDONHANG values (1,02,3,100000)
INSERT INTO CHITIETDONHANG values (1,04,2,100000)
INSERT INTO CHITIETDONHANG values (2,02,2,100000)
INSERT INTO CHITIETDONHANG values (2,05,2,100000)

-- Used for drop the database
--use master 
--go
--alter database HQTCSDL2 set single_user with rollback immediate
--drop database HQTCSDL2