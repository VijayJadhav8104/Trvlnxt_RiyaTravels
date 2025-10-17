  
--===========================================================================================================================================  
-- Date : 19 Feb 2025   
-- Use : To Get room info  of a booking by Pkid which is eligible for the LFS.  
-- Author : Akash Singh  
-- Exec HOTEL.LFS_GetRoomInfo 67612    
--===========================================================================================================================================  
  
CREATE Proc HOTEL.LFS_GetRoomInfo  --67612    
@Pkid int=0    
AS    
BEGIN    
       
   SELECT    
   book_fk_id as pkid,    
   RoomTypeDescription as RoomDesc,    
   NumberOfRoom,    
   numOfAdults, 
   isnull(numOfChildren,0) as numOfChildren,
   RoomMealBasis    
   from Hotel_Room_master where book_fk_id=@Pkid     
    
END 