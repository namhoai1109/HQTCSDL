create database HQTCSDL
go
use HQTCSDL
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
	HOTEN nvarchar(25),
    DIACHI nvarchar(50),
	SDT varchar(25),
	EMAIL varchar(25),
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
	TEN_MON nvarchar(25) UNIQUE,
	MIEU_TA nvarchar(25),
	TINH_TRANG_MON varchar(25),
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

INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('taixe1',123,'taixe','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('taixe2',123,'taixe','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('taixe3',123,'taixe','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('khach1',123,'khachhang','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('khach2',123,'khachhang','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('khach3',123,'khachhang','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('doitac1',123,'doitac','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('doitac2',123,'doitac','active')
INSERT INTO TAIKHOAN OUTPUT inserted.ID values ('doitac3',123,'doitac','active')

INSERT INTO TAIXE OUTPUT inserted.ID values (01,02,N'Nguyễn Văn A',0792020,1,9,'nva@gmail.com',9876543210)
INSERT INTO TAIXE OUTPUT inserted.ID values (02,03,N'Nguyễn Văn B',0792020,2,8,'nvb@gmail.com',9876543211)
INSERT INTO TAIXE OUTPUT inserted.ID values (03,04,N'Nguyễn Văn C',0792020,3,7,'nvc@gmail.com',9876543212)

INSERT INTO HOPDONG OUTPUT inserted.ID values(969696,N'Nguyễn Huỳnh Mẫn',123,123,'01/03/2023',1,0,'02/03/2023','01/05/2023')
INSERT INTO HOPDONG OUTPUT inserted.ID values(878787,N'Nguyễn Huỳnh Mẫn',123,123,'02/03/2023',1,0,'03/03/2023','02/05/2023')
INSERT INTO HOPDONG OUTPUT inserted.ID values(676767,N'Nguyễn Huỳnh Mẫn',123,123,'03/03/2023',1,0,'04/03/2023','03/05/2023')

INSERT INTO DOITAC OUTPUT inserted.ID values (07,01,'abc@gmail.com',98989898,N'Nguyễn Huỳnh Mẫn',908999,10,N'CAFE N GO','active','Nuoc')
INSERT INTO DOITAC OUTPUT inserted.ID values (08,null,'xyz@gmail.com',98989898,N'Nguyễn Huỳnh Mẫn',908999,11,N'CAFE','active','Nuoc')
INSERT INTO DOITAC OUTPUT inserted.ID values (09,null,'def@gmail.com',98989898,N'Nguyễn Huỳnh Mẫn',908999,12,N'Sandwich','active','Thuc An')

INSERT INTO KHACHHANG OUTPUT inserted.ID values (04,N'Tran Thi A', N'227 Nguyễn Văn Cừ',98989898,'hello@gmail.com')
INSERT INTO KHACHHANG OUTPUT inserted.ID values (05,N'Tran Thi B', N'312 Điện Biên Phủ',98989898,'hello1@gmail.com')
INSERT INTO KHACHHANG OUTPUT inserted.ID values (06,N'Tran Thi C', N'123 Võ Thị Sáu',98989898,'hello2@gmail.com')

INSERT INTO CHINHANH OUTPUT inserted.ID values (01,01,1,'227 NVC')
INSERT INTO CHINHANH OUTPUT inserted.ID values (01,01,2,'227 DBP')
INSERT INTO CHINHANH OUTPUT inserted.ID values (01,01,3,'123 XLHN')

INSERT INTO DONHANG OUTPUT inserted.MADON values (01,01,01,'Xac nhan', 'Dang chuan bi','23/02/2023','03/03/2023',200000,15000)
INSERT INTO DONHANG OUTPUT inserted.MADON values (02,02,02,'Xac nhan', 'Dang chuan bi','23/02/2023','03/03/2023',300000,25000)	
INSERT INTO DONHANG OUTPUT inserted.MADON values (03,03,03,'Xac nhan', 'Dang chuan bi','23/02/2023','03/03/2023',400000,35000)	

INSERT INTO MON OUTPUT inserted.ID values (01,N'Mì Soba',N'Mì lạnh','Con hang',5)
INSERT INTO MON OUTPUT inserted.ID values (01,N'Mì gói',N'Mì hảo hảo','Con hang',5)
INSERT INTO MON OUTPUT inserted.ID values (01,N'Mì ramen',N'Mì nước','Con hang',5)
--sửa lại unique ở id đối tác

INSERT INTO DANHGIA values (01,01,'Ngon',1)
INSERT INTO DANHGIA values (02,01,'Ngon',1)
INSERT INTO DANHGIA values (03,01,'Ngon',1)
--Tạo thêm danhgia

INSERT INTO TUYCHONMON OUTPUT inserted.ID values (01,'Them mi',50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (01,'Them trung',50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (01,'Them rau',50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (01,'Khong',0)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (02,'Them mi',50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (02,'Them trung',50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (02,'Them rau',50000)
INSERT INTO TUYCHONMON OUTPUT inserted.ID values (02,'Khong',0)

--sửa lại unique ở id món,tùy chọn

INSERT INTO CHITIETDONHANG values (1,01,2,100000)
INSERT INTO CHITIETDONHANG values (1,02,3,100000)
INSERT INTO CHITIETDONHANG values (1,04,2,100000)
INSERT INTO CHITIETDONHANG values (2,02,2,100000)
INSERT INTO CHITIETDONHANG values (2,05,2,100000)











 --use master 
 --go
 --alter database HQTCSDL set single_user with rollback immediate
 --drop database HQTCSDL