CREATE PROCEDURE [dbo].[GetConfigurationCardNumber]                 
 @MarketPoint varchar(10),                       
 @UserType  varchar(10),                       
 @MaskCardNumber varchar(50)        
AS BEGIN              
                         
select Configuration From mcarddetails where UserType = @UserType and [Status] = 1  
and MarketPoint = @MarketPoint  
and MaskCardNumber Like '%'+@MaskCardNumber+'%'  
  
end