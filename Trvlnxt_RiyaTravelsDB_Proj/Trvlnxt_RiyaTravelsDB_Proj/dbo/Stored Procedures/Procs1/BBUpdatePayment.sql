      
      
      
CREATE PROCEDURE [dbo].[BBUpdatePayment]      
      
                             
 @pkId varchar(100) = NULL ,                            
 @CountryName varchar(100) =  NULL ,                                
 @orderId varchar(100) = NULL, -- mm dd yyyy                                    
 @DisplayDiscountRate int  ='0',                            
 @LeaderFirstName Varchar(100) = NULL ,                             
 @LeaderLastName Varchar(100) = NULL ,                              
 @AddrMobileNo Varchar(100) = NULL ,                               
 @AddrEmail  Varchar(100) = NULL ,                               
  @BookingId Varchar(100)  = NULL          
                                                       
AS                                    
BEGIN                                    
        
select HB.pkId,HB.CountryName,HB.orderId,HB.DisplayDiscountRate,HB.LeaderFirstName,HB.LeaderLastName,BR.AddrMobileNo,BR.AddrEmail,HB.MarkupCurrency,BR.country,HB.pkId    
from Hotel_BookMaster HB      
LEFT JOIN B2BRegistration BR ON HB.RiyaAgentID = BR.FKUserID      
where HB.pkId=@Bookingid      
      
  END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[BBUpdatePayment] TO [rt_read]
    AS [dbo];

