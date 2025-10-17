CREATE procedure [dbo].[insert_hotel_room]    
@NumberOfRoom varchar(10),    
@book_fk_id bigint,    
@room_class_id varchar(30),    
@roomtype varchar(100) ,   
@OrderId varchar(50)=null  
as    
begin    
    
declare @room_fk_id bigint;    
    
INSERT INTO [dbo].[Hotel_Room_master]    
           ([NumberOfRoom],[book_fk_id],[inserteddate],[room_class_id],[RoomTypeDescription],[OrderId])VALUES    
           (@NumberOfRoom ,@book_fk_id ,getdate(), @room_class_id,@roomtype  ,@OrderId )      
         select   SCOPE_IDENTITY()    
     end    
    
    
    
    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insert_hotel_room] TO [rt_read]
    AS [dbo];

