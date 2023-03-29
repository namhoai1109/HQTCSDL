USE HQTCSDL2
GO

-- Truong hop: 4
-- SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
-- Huong giai quyet: Bo cai isolation level read uncommitted, su dung mac dinh cua he quan tri
-- => Lam nhu vay thi transaction se giu khoa ghi toi het giao tac, nhung giao tac khac khi xem hop dong
-- se phai doi cho toi khi giao tac hien tai commit => Ko con dirty read

BEGIN TRANSACTION xacNhanHopDong
	UPDATE HOPDONG
	SET DA_XAC_NHAN = 1, TG_XAC_NHAN = GETDATE(), TG_HET_HIEU_LUC = DATEADD(YEAR, 1, GETDATE())
	WHERE MA_SO_THUE = '8271892819'

WAITFOR DELAY '00:00:07'
ROLLBACK