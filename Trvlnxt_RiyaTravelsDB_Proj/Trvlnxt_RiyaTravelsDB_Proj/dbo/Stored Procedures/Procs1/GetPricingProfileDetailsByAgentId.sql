    
-- execute GetPricingProfileDetailsByAgentId 51354    
    
CREATE PROC GetPricingProfileDetailsByAgentId    
@AgentId INT,    
@SupplierId nvarchar(200)=null    
    
AS    
BEGIN    
  declare @UserAgentID int  
  set @UserAgentID=(select PKID from B2BRegistration where FKUserID=@AgentId)  
   
 SELECT   PP.Commission,PP.GST,PP.TDS,PPD.FromRange    
   ,PPD.ToRange    
   ,PPD.Amount    
   ,PPD.PricePercent    
   ,PPD.FKPricingProfile     
 FROM PricingProfileDetails PPD    
 left join PricingProfile PP on PPD.FKPricingProfile=PP.Id    
 WHERE FKPricingProfile in     
     
 (SELECT ProfileId     
  FROM AgentSupplierProfileMapper a    
  join B2BRegistration BR on a.AgentId=BR.PKID    
  --WHERE BR.PKID=@AgentId and IsActive=1    
  WHERE 
  --BR.FKUserID=@AgentId 
  BR.PKID=@UserAgentID 
  and IsActive=1 
  and a.SupplierId=@SupplierId 
  --- Commented by Altamash. Current Passing Agent Value -- PKID    
              
			  ---- Old Passing Value FKUserID    
  )    
    
 SELECT AgentId,SupplierId,ProfileId,SupplierName     
 FROM AgentSupplierProfileMapper A    
 join B2BHotelSupplierMaster S on S.Id=a.SupplierId    
 join B2BRegistration BR on a.AgentId=BR.PKID    
 --WHERE BR.PKID=@AgentId and A.IsActive=1    
  WHERE
 -- BR.FKUserID=@AgentId
  BR.PKID=@UserAgentID 
  and A.IsActive=1  --- Commented by Altamash. Current Passing Agent Value -- PKID    
              ---- Old Passing Value FKUserID    
    
 --OLD    
 --SELECT FromRange    
 -- ,ToRange    
 -- ,Amount    
 -- ,PricePercent    
 --FROM PricingProfileDetails PPD    
 --INNER JOIN PricingProfile PP ON PP.Id = PPD.FKPricingProfile    
 --INNER JOIN AgentProfileMapper APM ON APM.ProfileId = PP.Id    
 --WHERE PPD.IsActive = 1    
 -- AND APM.IsActive = 1    
 -- AND PP.IsActive = 1    
 -- AND APM.AgentId = @AgentId;    
    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPricingProfileDetailsByAgentId] TO [rt_read]
    AS [dbo];

