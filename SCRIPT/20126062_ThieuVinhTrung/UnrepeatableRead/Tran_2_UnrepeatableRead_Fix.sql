﻿use HQTCSDL2
go

-- Không thay đổi gì ở transaction này
BEGIN TRANSACTION
    UPDATE DANHGIA 
    SET THICH_KOTHICH = 0
    WHERE ID_MON = 1 AND ID_KHACH_HANG = 1
COMMIT

