use HQTCSDL_DEMO
go

--Truong hop 12: Phantom
-- Doi tac xoa tuy chon mon
BEGIN TRANSACTION
	delete from [dbo].[DishDetail]
	 where [dishId] = 1 and [name] = 'S'
COMMIT

select * from [dbo].[DishDetail]

-- Run this after transaction
--INSERT INTO [dbo].[DishDetail] ([dishId], [name], [price], [quantity]) OUTPUT inserted.ID values (1, 'S', 30000, 1)