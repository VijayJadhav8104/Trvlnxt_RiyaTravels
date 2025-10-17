-- [AmadeusDetails] 48398 --33435        
CREATE PROCEDURE [dbo].AmadeusDetailsnew              
              
@AgentID int              
--@CountryCode varchar(10) =null            
              
AS              
            
BEGIN          
        
Declare @OfficeID varchar(100)=''        
Declare @RateCodes varchar(MAX)=null
Declare @IsPccRequired bit  
Declare @IsRateCodeRequired bit 
        
--SELECT @Token=Token FROM hotel.HyperGuestTokens where CountryCode=@CountryCode            
            
SELECT @RateCodes=RateCode,@OfficeID=PCC,@IsPccRequired=IsPccRequired,@IsRateCodeRequired=IsRateCodeRequired FROM AgentSupplierProfileMapper where AgentId=(select PKID from B2BRegistration where FKUserID=@AgentID) and SupplierId=17          
           
 select @OfficeID as 'OfficeId',@RateCodes as 'RateCodes',@IsPccRequired as IsPccRequired,@IsRateCodeRequired as IsRateCodeRequired             
        
        
END; 