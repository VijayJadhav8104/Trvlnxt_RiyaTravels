-- [AmadeusDetails] 48398 --33435          
CREATE PROCEDURE [dbo].[AmadeusDetails_bkp]                
                
@AgentID int                
--@CountryCode varchar(10) =null              
                
AS                
              
BEGIN            
          
Declare @OfficeID varchar(100)=''          
Declare @RateCodes varchar(MAX)=null          
          
--SELECT @Token=Token FROM hotel.HyperGuestTokens where CountryCode=@CountryCode              
              
SELECT @RateCodes=RateCode,@OfficeID=PCC FROM AgentSupplierProfileMapper where AgentId=(select PKID from B2BRegistration where FKUserID=@AgentID) and SupplierId=17            
             
 select @OfficeID as 'OfficeId',@RateCodes as 'RateCodes'             
          
          
END; 