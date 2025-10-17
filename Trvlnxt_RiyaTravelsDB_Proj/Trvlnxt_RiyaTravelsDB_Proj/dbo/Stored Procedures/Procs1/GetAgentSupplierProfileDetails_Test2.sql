              
--exec GetAgentSupplierProfileDetails_Test2 34715,'Transfer'              
              
CREATE PROCEDURE GetAgentSupplierProfileDetails_Test2                                             
 -- Add the parameters for the stored procedure here                                              
--sp_helptext AssignAgentSupplierProfile                                                  
        --  GetAgentSupplierProfileDetails_Test2 2342,'Hotel'                                        
                                      
                                                                  
 -- Add the parameters for the stored procedure here                                                                    
 @AgentId INT=0,                                                        
 @SupplierType Varchar(200)=null                                                        
                                                         
AS                                                                    
BEGIN                                         
declare @country varchar(50)                                      
 set @country=(select country from B2BRegistration where (PKID=@AgentId))                                      
                                      
     
                  
  SELECT ASPM.Id,                                      
   ASPM.AgentId,                                                                    
   BR.Icast+' - '+BR.AgencyName AS AgencyName,               
   ASPM.SupplierId,                                                                    
   SM.SupplierName,                                                 
   ASPM.ProfileId,                                                                    
   pp.ProfileName,                                                                    
   ASPM.CancellationHours,                                           
   ASPM.CreateDate,                                                                    
   ASPM.IsActive,                                                                 
   ASPM.CorporateCode,                                                  
   ASPM.ServicePercent,                                                  
   ASPM.ServiceCharge,           
   ASPM.ServiceChargeAmt,           
   ASPM.GSTOnServiceCharge,                             
   aspm.RateCode,                    
   SM.SupplierType,                                                
   isnull(BR.ShowHotelLogs,0) as 'ShowHotelLogs',                                           
                                         
    isnull(BR.IsPanRequiredForHotel,0) as 'IsPanRequiredForHotel',                                             
   ASPM.PCC,                                          
   ASPM.AgentCurrency,                                          
   ASPM.GstService_charge_onAgent,                                          
   ASPM.Service_charge_onAgent,                                       
    @country    as 'Country',    
 ASPM.IsHold    
                                                                  
 FROM AgentSupplierProfileMapper ASPM                                                                    
 JOIN B2BRegistration BR ON ASPM.AgentId=BR.PKID                                                                    
 LEFT join B2BHotelSupplierMaster SM ON ASPM.SupplierId=SM.Id  and SupplierType in ('Hotel','Activity')                                                                  
 LEFT join PricingProfile PP ON ASPM.ProfileId=PP.Id                      
 --left join Hotel.RateLabelNEW rt on  BR.FKUserID=rt.AgentId                      
                                      
 WHERE ASPM.AgentId=@AgentId -- AND ASPM.IsActive=1                        
 --and SM.IsRateCodeApplicable=1                        
 And (SM.SupplierType = @SupplierType  or @SupplierType  IS NULL)                 
                 
   union all                 
              
    SELECT ASPM.Id,                                      
   ASPM.AgentId,                                              
   BR.Icast+' - '+BR.AgencyName AS AgencyName,                                      
   ASPM.SupplierId,                                                                    
   SM.SupplierName,                                                      
   ASPM.ProfileId,                                                                    
   pp.ProfileName,                                                                    
   ASPM.CancellationHours,                                                              
   ASPM.CreateDate,                                                                    
   ASPM.IsActive,                                                                  
   ASPM.CorporateCode,                                                  
   ASPM.ServicePercent,                                                  
   ASPM.ServiceCharge,          
   ASPM.ServiceChargeAmt,          
   ASPM.GSTOnServiceCharge,                             
   aspm.RateCode,                    
   SM.SupplierType,                                                
   isnull(BR.ShowHotelLogs,0) as 'ShowHotelLogs',                                           
                                         
    isnull(BR.IsPanRequiredForHotel,0) as 'IsPanRequiredForHotel',                                             
   ASPM.PCC,                                          
   ASPM.AgentCurrency,                                          
   ASPM.GstService_charge_onAgent,                                          
   ASPM.Service_charge_onAgent,                                       
    @country    as 'Country',    
 '0' as 'IsHold'    
                                            
 FROM TR.Transfer_AgentSupplierProfileMapper ASPM                                                                    
 JOIN B2BRegistration BR ON ASPM.AgentId=BR.PKID                                   
 LEFT join B2BHotelSupplierMaster SM ON ASPM.SupplierId=SM.Id  and SupplierType= 'Transfer'                                                                  
 LEFT join PricingProfile PP ON ASPM.ProfileId=PP.Id               --left join Hotel.RateLabelNEW rt on  BR.FKUserID=rt.AgentId                      
                                      
 WHERE ASPM.AgentId=@AgentId -- AND ASPM.IsActive=1                        
 --and SM.IsRateCodeApplicable=1                        
 And (SM.SupplierType = @SupplierType  or @SupplierType  IS NULL)                
              
      
--union all                 
              
--    SELECT ASPM.Id,                                      
--   ASPM.AgentId,                                                                    
--   BR.Icast+' - '+BR.AgencyName AS AgencyName,                                                                    
--   ASPM.SupplierId,                                                                    
--   SM.SupplierName,                                                      
--   ASPM.ProfileId,                                                                    
--   pp.ProfileName,                                                                    
--   ASPM.CancellationHours,                                                              
--   ASPM.CreateDate,                                                                    
--   ASPM.IsActive,                                                                  
--   ASPM.CorporateCode,                                                  
--   ASPM.ServicePercent,                                                  
--   ASPM.ServiceCharge,          
--   ASPM.ServiceChargeAmt,          
--   ASPM.GSTOnServiceCharge,                             
--   aspm.RateCode,                    
--   SM.SupplierType,                                                
--   isnull(BR.ShowHotelLogs,0) as 'ShowHotelLogs',                                           
                                         
--    isnull(BR.IsPanRequiredForHotel,0) as 'IsPanRequiredForHotel',                                             
--   ASPM.PCC,                            
--   ASPM.AgentCurrency,                                          
--   ASPM.GstService_charge_onAgent,                                          
--   ASPM.Service_charge_onAgent,                          
--    @country    as 'Country',    
-- '0' as 'IsHold'    
                                                                  
-- FROM Cruise.Cruise_AgentSupplierProfileMapper ASPM                                                                    
-- JOIN B2BRegistration BR ON ASPM.AgentId=BR.PKID                                   
-- LEFT join B2BHotelSupplierMaster SM ON ASPM.SupplierId=SM.Id  and SupplierType= 'Cruise'                                                                  
-- LEFT join PricingProfile PP ON ASPM.ProfileId=PP.Id               --left join Hotel.RateLabelNEW rt on  BR.FKUserID=rt.AgentId                                                      
-- WHERE ASPM.AgentId=@AgentId -- AND ASPM.IsActive=1                        
-- --and SM.IsRateCodeApplicable=1                        
-- And (SM.SupplierType = @SupplierType  or @SupplierType  IS NULL)       
              
 union all                  
                  
 SELECT ASPM.Id,                                          
   ASPM.AgentId,               
   BR.Icast+' - '+BR.AgencyName AS AgencyName,                                                                        
   ASPM.SupplierId,                                                                        
   SM.Country,                                                          
   ASPM.ProfileId,                                                                        
   pp.ProfileName,                                                                        
   ASPM.CancellationHours,                                                                  
   ASPM.CreateDate,              
   ASPM.IsActive,                                                                      
   ASPM.CorporateCode,                                                      
   ASPM.ServicePercent,                                                      
   ASPM.ServiceCharge,           
   0.00 as ServiceChargeAmt,           
   ASPM.GSTOnServiceCharge,                                 
   aspm.RateCode,                        
   'Visa' as SupplierType,                                                    
   '0' as 'ShowHotelLogs',                                               
                                             
    '0'  as 'IsPanRequiredForHotel',                                                 
   ASPM.PCC,                                              
   ASPM.AgentCurrency,                                              
   ASPM.GstService_charge_onAgent,                                              
   ASPM.Service_charge_onAgent,                                           
    @country    as 'Country',    
 '0' as 'IsHold'    
                                                                      
 FROM [Visa].[Visa_AgentSupplierProfileMapper] ASPM                                                                        
 JOIN B2BRegistration BR ON ASPM.AgentId=BR.PKID                                                                        
 LEFT join Visa.VisaCountry SM ON ASPM.SupplierId=SM.Id                                                                        
 LEFT join PricingProfile PP ON ASPM.ProfileId=PP.Id                          
 --left join Hotel.RateLabelNEW rt on  BR.FKUserID=rt.AgentId                          
                                          
 WHERE ASPM.AgentId=@AgentId -- AND ASPM.IsActive=1                            
 And ('Visa' = @SupplierType  or @SupplierType  IS NULL)                
                
                
                
   --select top 1                                                                  
  --CONCAT(UPPER(SUBSTRING(mu.UserName,1,1)),LOWER(SUBSTRING(mu.UserName,2,len(mu.UserName)))) as 'UserName',        
  --CONCAT(UPPER(SUBSTRING(mu.UserName,1,1)),LOWER(SUBSTRING(mu.UserName,2,len(mu.UserName)))) as 'UserName'          
  --from hotel.HotelAgentSupplierMappingUpdation ASU                                                                   
  --join mUser MU on ASU.UpdatedBy=MU.id                                                                   
  --where AgentId=@AgentId         
  --And ASU.Isactive=1  order by ASU.ID desc                         
           
    SELECT TOP 1          
    ISNULL(MU.UserName, MUU.UserName) AS UserName,        
 --  ISNULL(ASU.ModifiedOn, ASU.CreatedOn) AS CreatedDate        
   FORMAT(CAST(ISNULL(ASU.ModifiedOn, ASU.CreatedOn) AS datetime), 'dd MMM yyyy HH:mm:ss') AS CreatedDate        
FROM HistorySuppAgentProfileMapper ASU        
LEFT JOIN mUser MU ON ASU.ModifiedBy = MU.ID        
LEFT JOIN mUser MUU ON ASU.CreatedBy = MUU.ID        
WHERE ASU.AgentId = @AgentId        
ORDER BY ASU.Id DESC;        
                     
                   
                
                                          
 --set @country=(select country from B2BRegistration where (PKID=@AgentId))                                      
 select                                        
 case when  @country='INDIA' then 'INR'                                        
  when  @country='USA' then 'USD'                                        
  when  @country='CANADA' then 'CAD'                                        
  when  @country='UAE' then 'AED'                             
  when  @country='UNITED KINGDOM' then 'GBP'                                        
  else 'NA'                                        
  end as 'Country'                                  
                          
                       
                                                  
 Select Id as 'SupplierId'                              
  ,SupplierName as 'SupplierName'              
  ,IsRateCodeApplicable as 'IsRateCode'                              
  from B2BHotelSupplierMaster where IsRateCodeApplicable=1                   
  union all                  
  Select Id as 'SupplierId'                              
  ,Country as 'SupplierName'                              
  ,0 as 'IsRateCode'                              
  from Visa.VisaCountry                   
                
END 