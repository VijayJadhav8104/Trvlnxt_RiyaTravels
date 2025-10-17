-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
CREATE PROCEDURE HotelAllRoomListLog      
       
 @FkBookId int=0,      
 @CityId varchar(200)=null,     
 @CityName varchar(200)=null,      
 @CheckInDate datetime=null,      
 @CheckOutDate datetime=null,      
 @Price varchar(200)=null,      
 @RoomType varchar(200)=null,    
 @Meal varchar(200)=null,    
 @SupplierName varchar(200)=null,     
 @LocalHotelId varchar(200)=null     
      
AS      
BEGIN      
       
 insert into BBHotelRoomListLog (FkBookId,      
         CityId,      
         CityName,      
         CheckInDate,      
         CheckOutDate,      
         Price,      
         RoomType,    
   Meal,    
   SupplierName,  
   LocalHotelId)       
      
         values(@FkBookId,      
         @CityId,      
         @CityName,      
         @CheckInDate,      
         @CheckOutDate,      
         @Price,      
         @RoomType,    
   @Meal,    
   @SupplierName,  
   @LocalHotelId)      
      
      
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[HotelAllRoomListLog] TO [rt_read]
    AS [dbo];

