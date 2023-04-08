use HQTCSDL_DEMO
go

--C�u 13 : Lost Updated

begin transaction

update ORDER
set shipperId =02
where id = 26

commit
