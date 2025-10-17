-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE BBHotelSBReversalStatusUpdate  
   
 @Id int=0,  
 @BookingRefrence varchar(200)  
AS  
BEGIN  
   
 update Hotel_BookMaster set SB_ReversalStatus=1   
 where pkId=@Id   
 and BookingReference=@BookingRefrence  
  
END  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[BBHotelSBReversalStatusUpdate] TO [rt_read]
    AS [dbo];

