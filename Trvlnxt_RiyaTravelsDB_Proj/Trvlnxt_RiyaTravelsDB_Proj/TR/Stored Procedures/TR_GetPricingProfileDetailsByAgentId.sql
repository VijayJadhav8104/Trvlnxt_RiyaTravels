    
                                  
-- Created By Reshma                                 
-- Created Date : 27-12-2024                 
--[TR].TR_GetPricingProfileDetailsByAgentId 51379        
--=============================================================                      
CREATE PROC [TR].[TR_GetPricingProfileDetailsByAgentId]             
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
  ,isnull(SM.SupplierCharges,0) as 'SupplierCharges'            
  ,isnull(SM.VccCharges,0) as 'VccCharges'          
  ,isnull(SM.Commission_Net,0) as 'CommissionType'    
  ,isnull(SM.Is_Req_Domestic_Pan,0) as 'IsReqDomesticPan'    
  ,isnull(SM.Is_Req_International_Pan,0) as 'IsReqInternationalPan'   
   from [TR].Transfer_AgentSupplierProfileMapper PM                                   
    left  join PricingProfile PP on PM.ProfileId=PP.Id                                  
    --inner join PricingProfileDetails PD on PM.ProfileId=PD.FKPricingProfile                                  
    inner join B2BHotelSupplierMaster SM on SM.Id=PM.SupplierId                                   
  where PM.AgentId=@UserAgentID                                 
  and PM.IsActive=1                                 
  --and PD.IsActive=1                                
  and SM.IsActive=1                     
  and SM.Action=1                  
  and sm.RhSupplierId is not null            
  and sm.SupplierType='Transfer'          
                                          
  select FromRange,ToRange,Amount,PricePercent,RowNo,FKPricingProfile from PricingProfileDetails                                 
  where FKPricingProfile in (select distinct P.ProfileId from [TR].Transfer_AgentSupplierProfileMapper P where P.AgentId=@UserAgentID                                 
  and P.IsActive=1)              
               
  print 1               
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
  ,isnull(SM.SupplierCharges,0) as 'SupplierCharges'            
  ,isnull(SM.VccCharges,0) as 'VccCharges'        
  ,isnull(SM.Is_Req_Domestic_Pan,0) as 'IsReqDomesticPan'    
  ,isnull(SM.Is_Req_International_Pan,0) as 'IsReqInternationalPan'   
  ,PM.CancellationHours      
   from [TR].Transfer_AgentSupplierProfileMapper PM                              
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
  where FKPricingProfile in (select distinct P.ProfileId from [TR].Transfer_AgentSupplierProfileMapper P where P.AgentId=@UserAgentID                                 
  and P.IsActive=1)                
               
   print 2              
 end               
              
END 