﻿use HQTCSDL_DEMO
go
-- Câu 1: Dirty read : Khi khách hàng A đặt 1 món X thì số lượng món X giảm xuống 1 và hết hàng, 
-- thì cùng lúc đó khách hàng B không đọc được món mà khách hàng A vừa chọn. 
-- Nhưng sau đó, giao dịch của đơn hàng khách A bị lỗi → rollback. 
-- Làm cho khách B đọc sai dữ liệu.
-- Không cần fix vì isolation level default của database là read committed 

<<<<<<< Updated upstream
begin transaction  
Update [dbo].[Dish]
set [status] = 'unavailable'
where [name] Like N'Yakisoba'
waitfor delay '00:00:05'
rollback transaction
=======
begin transaction
set transaction isolation level read uncommitted
IF EXISTS (
        SELECT * FROM 
		[dbo].[Dish] 
		WHERE [dbo].[Dish].[name] = N'Yakisoba'  AND [dbo].[Dish].[status] = 'available'
    )
	BEGIN
		update [dbo].[Dish]
		set [status] = 'unavailable'
		where [name] Like N'Yakisoba' 
		-- Do some work to create an Order with Yakisoba
		waitfor delay '00:00:05'
	
		-- The client change their opion, dont want to order any more
		-- Delete the previous Order and update the Dish back to the original status
		update [dbo].[Dish]
		set [status] = 'available'
		where [name] Like N'Yakisoba'
	END
	IF @@ERROR <> null
	begin
		raiserror(N'Cập nhật không thành công', 16, 1)
		rollback
		return
	end
commit

--SELECT * FROM [dbo].[Order]
>>>>>>> Stashed changes
