               
-- NewGetPricingProfileDetailsByAgentId_ApiOut_RU 46999 ,'IN'                     
-- NewGetPricingProfileDetailsByAgentId_ApiOut_RU 46999 ,'IN','US'          
-- Created By Ketan                                                         
-- Created Date : 06-02-2025                                                  
--=============================================================                                              
CREATE PROC NewGetPricingProfileDetailsByAgentId_ApiOut_RU                                                         
@AgentId INT  ,                                       
@CountryCode VARCHAR(100)=NULL,        
@Nationality VARCHAR(100)=NULL        
AS                                                                  
BEGIN                                                                  
     DECLARE @UserAgentID INT              
  DECLARE @DestinationCode VARCHAR(100)           
  DECLARE @SupplierCurrency INT  
  
     SET @UserAgentID=(SELECT PKID FROM B2BRegistration WHERE FKUserID=@AgentId)          
  SET @DestinationCode=@CountryCode      
  SELECT @SupplierCurrency=ID FROM mCommon where Category='currency' AND Value='INR'  
                  
  SET @CountryCode=(SELECT CASE WHEN @CountryCode !='IN' THEN 'Other than India' ELSE @CountryCode END)                
 IF (@Nationality='IN' OR @Nationality IS NULL OR @Nationality='Indian')        
 BEGIN        
  IF (@DestinationCode='RU')          
  BEGIN          
  --PRINT @DestinationCode          
  --PRINT 1     
  --PRINT @SupplierCurrency    
    SELECT PM.AgentId,PM.SupplierId,PM.CancellationHours ,SM.RhSupplierId, SM.SupplierCurrency,                                                     
    SM.SupplierName,SM.Is_Req_Domestic_Pan,SM.Is_Req_International_Pan,SM.PayAtHotel,SM.IsHotelContentAvail                      
    FROM AgentSupplierProfileMapper PM                                                
    LEFT  JOIN PricingProfile PP ON PM.ProfileId=PP.Id                                                              
    INNER JOIN B2BHotelSupplierMaster SM ON SM.Id=PM.SupplierId                                     
    LEFT JOIN B2BRegistration BR ON PM.AgentId=BR.PKID                                    
    WHERE PM.AgentId=@UserAgentID AND SM.SupplierName='RateHawk'                                                        
    AND PM.IsActive=1 AND SM.IsActive=1 AND SM.Action=1 AND sm.RhSupplierId IS NOT NULL AND sm.SupplierType='Hotel'                         
    AND SM.Id NOT IN (SELECT sa.SupplierId FROM Hotel_SupplierAgent_Disable sa JOIN Hotel_SupplierCountry_Disable sc ON sa.pkid=sc.fkid                          
    WHERE sa.IsActive=1 AND CountryCode=@CountryCode AND AgentId=@AgentId)                                                                                 
  END            
  ELSE          
  BEGIN        
  --PRINT @DestinationCode          
  --PRINT 2     
  --PRINT @SupplierCurrency  
    SELECT PM.AgentId,PM.SupplierId,PM.CancellationHours ,SM.RhSupplierId, SM.SupplierCurrency,                                                       
    SM.SupplierName,SM.Is_Req_Domestic_Pan,SM.Is_Req_International_Pan,SM.PayAtHotel,SM.IsHotelContentAvail                       
    FROM AgentSupplierProfileMapper PM                                                
    LEFT  JOIN PricingProfile PP ON PM.ProfileId=PP.Id                                                              
    INNER JOIN B2BHotelSupplierMaster SM ON SM.Id=PM.SupplierId                                     
    LEFT JOIN B2BRegistration BR ON PM.AgentId=BR.PKID                                    
    WHERE PM.AgentId=@UserAgentID                                                         
    AND PM.IsActive=1 AND SM.IsActive=1 AND SM.Action=1 AND sm.RhSupplierId IS NOT NULL AND sm.SupplierType='Hotel'                         
    AND SM.Id NOT IN (SELECT sa.SupplierId FROM Hotel_SupplierAgent_Disable sa JOIN Hotel_SupplierCountry_Disable sc ON sa.pkid=sc.fkid                          
    WHERE sa.IsActive=1 AND CountryCode=@CountryCode AND AgentId=@AgentId)           
      END        
 END         
 ELSE        
 BEGIN        
 IF (@DestinationCode='RU')          
  BEGIN          
  --PRINT @DestinationCode          
  --PRINT 1     
  --PRINT @SupplierCurrency  
    SELECT PM.AgentId,PM.SupplierId,PM.CancellationHours ,SM.RhSupplierId,  SM.SupplierCurrency,                                                      
    SM.SupplierName,SM.Is_Req_Domestic_Pan,SM.Is_Req_International_Pan,SM.PayAtHotel,SM.IsHotelContentAvail                      
    FROM AgentSupplierProfileMapper PM                      
    LEFT  JOIN PricingProfile PP ON PM.ProfileId=PP.Id                                                              
    INNER JOIN B2BHotelSupplierMaster SM ON SM.Id=PM.SupplierId                                     
    LEFT JOIN B2BRegistration BR ON PM.AgentId=BR.PKID                                    
    WHERE PM.AgentId=@UserAgentID AND SM.SupplierName='RateHawk' AND SM.SupplierCurrency=@SupplierCurrency                                                       
    AND PM.IsActive=1 AND SM.IsActive=1 AND SM.Action=1 AND sm.RhSupplierId IS NOT NULL AND sm.SupplierType='Hotel'                         
    AND SM.Id NOT IN (SELECT sa.SupplierId FROM Hotel_SupplierAgent_Disable sa JOIN Hotel_SupplierCountry_Disable sc ON sa.pkid=sc.fkid                          
    WHERE sa.IsActive=1 AND CountryCode=@CountryCode AND AgentId=@AgentId)                                                                                 
  END            
  ELSE          
  BEGIN        
  --PRINT @DestinationCode          
  --PRINT 2          
  --PRINT @SupplierCurrency  
    SELECT PM.AgentId,PM.SupplierId,PM.CancellationHours ,SM.RhSupplierId, SM.SupplierCurrency,                                                       
    SM.SupplierName,SM.Is_Req_Domestic_Pan,SM.Is_Req_International_Pan,SM.PayAtHotel,SM.IsHotelContentAvail                       
    FROM AgentSupplierProfileMapper PM                                                
    LEFT  JOIN PricingProfile PP ON PM.ProfileId=PP.Id                                                              
    INNER JOIN B2BHotelSupplierMaster SM ON SM.Id=PM.SupplierId                                     
    LEFT JOIN B2BRegistration BR ON PM.AgentId=BR.PKID                                    
    WHERE PM.AgentId=@UserAgentID AND SM.SupplierCurrency=@SupplierCurrency                                                      
    AND PM.IsActive=1 AND SM.IsActive=1 AND SM.Action=1 AND sm.RhSupplierId IS NOT NULL AND sm.SupplierType='Hotel'                         
    AND SM.Id NOT IN (SELECT sa.SupplierId FROM Hotel_SupplierAgent_Disable sa JOIN Hotel_SupplierCountry_Disable sc ON sa.pkid=sc.fkid                          
    WHERE sa.IsActive=1 AND CountryCode=@CountryCode AND AgentId=@AgentId)           
      END        
 END        
END 