      
                
                
 --  NewGetPricingProfileDetailsByAgentId_ApiOut 46999 ,'IN'                                     
-- Created By Ketan                               
-- Created Date : 27-12-2023                        
--=============================================================                    
CREATE PROC NewGetPricingProfileDetailsByAgentId_ApiOut_Bkp                               
@AgentId INT  ,             
@CountryCode varchar(10)=null  
AS                                        
BEGIN                                        
     declare @UserAgentID int                                    
     set @UserAgentID=(select PKID from B2BRegistration where FKUserID=@AgentId)                                    
            
            
  IF (@CountryCode!='IN')  
  BEGIN  
 select PM.AgentId,PM.SupplierId,PM.ProfileId,PM.CancellationHours                                    
     ,SM.RhSupplierId,isnull( PP.Commission,0) as Commission,ISNULL(PP.GST,0) as GST,ISNULL( PP.TDS,0) as TDS                                
     ,sm.SupplierName  ,SM.IsGSTRequired ,SM.IsPanRequired ,SM.ISCCRequired  ,SM.Email as 'SupplierMail'                    
     ,SM.SupportMailId as 'SupportMails' ,isnull(PM.ServiceCharge,0) as 'ServiceCharge' ,isnull(PM.GSTOnServiceCharge,0) as 'GSTOnServiceCharge'           
     ,BR.country as 'Country',isnull(SM.SupplierCharges,0) as 'SupplierCharges' ,isnull(SM.VccCharges,0) as 'VccCharges'                    
 from AgentSupplierProfileMapper PM                      
    left  join PricingProfile PP on PM.ProfileId=PP.Id                                    
    inner join B2BHotelSupplierMaster SM on SM.Id=PM.SupplierId           
 left join B2BRegistration BR on PM.AgentId=BR.PKID          
 where PM.AgentId=@UserAgentID                               
 and PM.IsActive=1 and SM.IsActive=1 and SM.Action=1 and sm.RhSupplierId is not null and sm.SupplierType='Hotel'    
   
 select FromRange,ToRange,Amount,PricePercent,RowNo,FKPricingProfile from PricingProfileDetails                               
 where FKPricingProfile in (select distinct P.ProfileId from AgentSupplierProfileMapper P where P.AgentId=@UserAgentID and P.IsActive=1)     
  END  
  ELSE  
    
  BEGIN  
 select PM.AgentId,PM.SupplierId,PM.ProfileId,PM.CancellationHours                                    
     ,SM.RhSupplierId,isnull( PP.Commission,0) as Commission,ISNULL(PP.GST,0) as GST,ISNULL( PP.TDS,0) as TDS                                
     ,sm.SupplierName  ,SM.IsGSTRequired ,SM.IsPanRequired ,SM.ISCCRequired  ,SM.Email as 'SupplierMail'                    
     ,SM.SupportMailId as 'SupportMails' ,isnull(PM.ServiceCharge,0) as 'ServiceCharge' ,isnull(PM.GSTOnServiceCharge,0) as 'GSTOnServiceCharge'           
     ,BR.country as 'Country',isnull(SM.SupplierCharges,0) as 'SupplierCharges' ,isnull(SM.VccCharges,0) as 'VccCharges'                    
 from AgentSupplierProfileMapper PM                      
    left  join PricingProfile PP on PM.ProfileId=PP.Id                                    
    inner join B2BHotelSupplierMaster SM on SM.Id=PM.SupplierId           
 left join B2BRegistration BR on PM.AgentId=BR.PKID          
 where PM.AgentId=@UserAgentID                               
 and PM.IsActive=1 and SM.IsActive=1 and SM.Action=1 and sm.RhSupplierId is not null and sm.SupplierType='Hotel'   
 AND SM.Id NOT IN (SELECT SupplierId FROM tblSupplierAgent WHERE IsActive=1)  
  end  
                                 
END              
    
    