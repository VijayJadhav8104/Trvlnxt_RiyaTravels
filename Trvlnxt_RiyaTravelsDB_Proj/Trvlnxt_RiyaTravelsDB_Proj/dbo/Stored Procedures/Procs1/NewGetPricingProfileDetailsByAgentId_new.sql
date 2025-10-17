      
      
 --  NewGetPricingProfileDetailsByAgentId_new 33435 ,null                           
-- Created By akash while doing APi for ZH api                       
-- Created Date : 14-10-2022              
--=============================================================          
CREATE PROC NewGetPricingProfileDetailsByAgentId_new                         
@AgentId INT  ,   
@BookingDetails varchar(100)=null  
AS                              
BEGIN                              
     declare @UserAgentID int                          
     set @UserAgentID=(select PKID from B2BRegistration where FKUserID=@AgentId)                          
  
 if(@BookingDetails is null)  
 begin  
  
  select PM.AgentId,PM.SupplierId,PM.ProfileId,PM.CancellationHours                      
    -- ,PD.FromRange,PD.ToRange,PD.Amount,PD.PricePercent,PD.FKPricingProfile,PD.RowNo                      
     ,SM.RhSupplierId                      
     ,isnull( PP.Commission,0) as Commission,ISNULL(PP.GST,0) as GST,ISNULL( PP.TDS,0) as TDS                      
     ,sm.SupplierName                
     ,SM.IsGSTRequired                 
     ,SM.IsPanRequired              
     ,SM.ISCCRequired            
     ,SM.Email as 'SupplierMail'          
     ,SM.SupportMailId as 'SupportMails'       
     ,isnull(PM.ServiceCharge,0) as 'ServiceCharge'      
     ,isnull(PM.GSTOnServiceCharge,0) as 'GSTOnServiceCharge'    
   from AgentSupplierProfileMapper PM                       
    left  join PricingProfile PP on PM.ProfileId=PP.Id                      
    --inner join PricingProfileDetails PD on PM.ProfileId=PD.FKPricingProfile                      
    inner join B2BHotelSupplierMaster SM on SM.Id=PM.SupplierId                       
  where PM.AgentId=@UserAgentID                     
  and PM.IsActive=1                     
  --and PD.IsActive=1                    
  and SM.IsActive=1         
  and SM.Action=1      
  and sm.RhSupplierId is not null              
                              
  select FromRange,ToRange,Amount,PricePercent,RowNo,FKPricingProfile from PricingProfileDetails                     
  where FKPricingProfile in (select distinct P.ProfileId from AgentSupplierProfileMapper P where P.AgentId=@UserAgentID                     
  and P.IsActive=1)  
     
 end  
  
 else if (@BookingDetails is not null)    
 begin  
  select PM.AgentId,PM.SupplierId,PM.ProfileId,PM.CancellationHours                      
    -- ,PD.FromRange,PD.ToRange,PD.Amount,PD.PricePercent,PD.FKPricingProfile,PD.RowNo                      
     ,SM.RhSupplierId                      
     ,isnull( PP.Commission,0) as Commission,ISNULL(PP.GST,0) as GST,ISNULL( PP.TDS,0) as TDS                      
     ,sm.SupplierName                
     ,SM.IsGSTRequired                 
     ,SM.IsPanRequired              
     ,SM.ISCCRequired            
     ,SM.Email as 'SupplierMail'          
     ,SM.SupportMailId as 'SupportMails'       
     ,isnull(PM.ServiceCharge,0) as 'ServiceCharge'      
     ,isnull(PM.GSTOnServiceCharge,0) as 'GSTOnServiceCharge'    
   from AgentSupplierProfileMapper PM                       
    left  join PricingProfile PP on PM.ProfileId=PP.Id                      
    --inner join PricingProfileDetails PD on PM.ProfileId=PD.FKPricingProfile                      
    inner join B2BHotelSupplierMaster SM on SM.Id=PM.SupplierId                       
  where PM.AgentId=@UserAgentID                     
  and PM.IsActive=1                     
  --and PD.IsActive=1                    
  --and SM.IsActive=1         
  --and SM.Action=1      
  and sm.RhSupplierId is not null              
                              
  select FromRange,ToRange,Amount,PricePercent,RowNo,FKPricingProfile from PricingProfileDetails                     
  where FKPricingProfile in (select distinct P.ProfileId from AgentSupplierProfileMapper P where P.AgentId=@UserAgentID                     
  and P.IsActive=1)    
     
 end   
  
END 