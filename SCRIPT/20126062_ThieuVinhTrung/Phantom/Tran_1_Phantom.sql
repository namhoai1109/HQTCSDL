﻿use HQTCSDL2
go

/*
này của tài xế, có 1 đơn hàng mới vừa được hoàn thành → Lịch sử đơn hàng 
không có đơn hàng đó, nhưng tổng thu nhập thì lại có phí của đơn hàng đó.
	SELECT *
	FROM DONHANG AS DH
	WHERE ID_TAI_XE = 1 AND DH.TRANGTHAI = 'Xac nhan' AND MONTH(DH.TG_TAO) = MONTH(GETDATE())
	FROM DONHANG AS DH
	WHERE ID_TAI_XE = 1 AND DH.TRANGTHAI = 'Xac nhan' AND MONTH(DH.TG_TAO) = MONTH(GETDATE())