                                                            
-- NewGetPricingProfileDetailsByAgentId_ApiOut_09012025 33435 ,'IN'                                                   
-- Created By Ketan                                             
-- Created Date : 27-12-2023                                      
--=============================================================                                  
CREATE PROC NewGetPricingProfileDetailsByAgentId_ApiOut_09012025                                             
@AgentId INT  ,                           
@CountryCode VARCHAR(100)=NULL                
AS                                                      
BEGIN                                                      
     DECLARE @UserAgentID INT                                                  
     SET @UserAgentID=(SELECT PKID FROM B2BRegistration WHERE FKUserID=@AgentId)         
        
  SET @CountryCode=(SELECT CASE WHEN @CountryCode !='IN' THEN 'Other than India' ELSE @CountryCode END)      
               
 SELECT PM.AgentId,PM.SupplierId,PM.ProfileId,PM.CancellationHours                                                  
,SM.RhSupplierId,ISNULL( PP.Commission,0) AS Commission,ISNULL(PP.GST,0) AS GST,ISNULL( PP.TDS,0) AS TDS                                              
,sm.SupplierName  ,SM.IsGSTRequired ,SM.IsPanRequired ,SM.ISCCRequired  ,SM.Email AS 'SupplierMail'                                  
,SM.SupportMailId AS 'SupportMails' ,ISNULL(PM.ServiceCharge,0) AS 'ServiceCharge' ,ISNULL(PM.GSTOnServiceCharge,0) AS 'GSTOnServiceCharge'                         
,BR.country AS 'Country',ISNULL(SM.SupplierCharges,0) as 'SupplierCharges' ,ISNULL(SM.VccCharges,0) AS 'VccCharges'        
,SM.Is_Req_Domestic_Pan,SM.Is_Req_International_Pan,SM.PayAtHotel,SM.IsHotelContentAvail            
 FROM AgentSupplierProfileMapper PM                                    
 LEFT  JOIN PricingProfile PP ON PM.ProfileId=PP.Id                                                  
 INNER JOIN B2BHotelSupplierMaster SM ON SM.Id=PM.SupplierId                         
 LEFT JOIN B2BRegistration BR ON PM.AgentId=BR.PKID                        
 WHERE PM.AgentId=@UserAgentID                                             
 AND /*PM.IsActive=1 AND SM.IsActive=1 AND  SM.Action=1 AND*/ sm.RhSupplierId IS NOT NULL AND sm.SupplierType='Hotel'             
 AND SM.Id NOT IN (SELECT sa.SupplierId FROM Hotel_SupplierAgent_Disable sa JOIN Hotel_SupplierCountry_Disable sc ON sa.pkid=sc.fkid              
 WHERE sa.IsActive=1 AND CountryCode=@CountryCode AND AgentId=@AgentId)                                                                    
            
 END 