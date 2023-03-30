use HQTCSDL
go

--Câu 13 : Lost Updated

begin transaction

update DONHANG
set ID_TAI_XE =02
where MADON = 26

commit
