-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
 -- GetPaxReCallDetails 'RT12345678'        
-- =============================================    
CREATE PROCEDURE GetPaxReCallDetails    
     
 @OrderId varchar(500)=null    
    
AS    
BEGIN    
     
    
 declare @PkId int=0;      
      
    set @PkId = (select pkId from Hotel_BookMaster where orderId=@OrderId )     
    
 select HP.Salutation,    
  HP.FirstName,    
  HP.LastName,    
  HP.PassengerType,    
  HP.Age,    
  HP.Nationality,    
  HP.ISDCode,    
  HP.Contact,    
  HP.Email,    
  HP.room_fk_id,  
  HB.SpecialRemark,  
  HB.AgentRemark  
     
 from Hotel_Pax_master HP  
 join Hotel_BookMaster HB on HB.pkId=HP.book_fk_id  
 where book_fk_id=@PkId  
   
    
    
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPaxReCallDetails] TO [rt_read]
    AS [dbo];

