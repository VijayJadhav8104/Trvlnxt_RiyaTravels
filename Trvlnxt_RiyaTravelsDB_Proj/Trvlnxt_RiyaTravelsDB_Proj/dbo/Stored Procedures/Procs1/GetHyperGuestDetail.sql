


        
  
-- GetHyperGuestDetail 51354,'IN'  
CREATE PROCEDURE [dbo].[GetHyperGuestDetail]        
        
@AgentID int,        
@CountryCode varchar(10) =null      
        
AS        
      
BEGIN    
  
Declare @Token varchar(100)=''  
Declare @RateCode varchar(100)=null  
  
SELECT @Token=Token FROM hotel.HyperGuestTokens where CountryCode=@CountryCode      
      
SELECT @RateCode=RateCode FROM AgentSupplierProfileMapper where AgentId=(select PKID from B2BRegistration where FKUserID=@AgentID) and SupplierId=19     
     
 select @Token as 'Token',@RateCode as 'RateCode'     
  
  
END;   