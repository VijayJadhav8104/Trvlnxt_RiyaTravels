  --exec GetSupplierProfileMapList  'Transfer',34715                
CREATE PROCEDURE GetSupplierProfileMapList                               
 -- Add the parameters for the stored procedure here                                
  @SupplierType Varchar(200)=null,            
  @AgencyId int=0           
AS                                
BEGIN                                
                                 
 SELECT PKID, Icast, al.UserID, Icast+' - '+AgencyName as AgencyName                       
 FROM B2BRegistration b   inner join agentLogin al on al.UserID = b.FKUserID                       
 where  AgentApproved=2345556                              
                                
     
         
  --Supplier    
            
  select     
  sm.Id,    
  sm.SupplierName,      
  ''as CancellationHour,            
  SM.SupplierType,          
          
   CASE           
        WHEN sm.IsRateCodeApplicable = 1 THEN 'True'          
        ELSE 'False'          
    END AS 'IsRateCodeApplicable',           
          
 -- sm.IsRateCodeApplicable as 'IsRateCodeApplicable' ,            
 case when SM.SupplierType='Transfer' then TAP.IsActive else  AP.IsActive end IsActive            
  --case when AP.Id is not null then 1 else 0 end as supplierMapped            
  from B2BHotelSupplierMaster sm             
  left join AgentSupplierProfileMapper AP on sm.id =AP.Supplierid and AP.AgentId=@AgencyId      
  left join [TR].[Transfer_AgentSupplierProfileMapper] TAP on SM.Id=TAP.Supplierid and TAP.AgentId=@AgencyId and SM.SupplierType='Transfer'    
    where   (SM.SupplierType = @SupplierType  or @SupplierType  IS NULL)   and SM.IsDelete=0 
	--and SM.IsActive=1 AND SM.[Action]=1      -- as disscussed priti this conditon is removed
                              
    
          
  union all        
        
  select smV.Id,      
  smV.Country AS SupplierName ,      
  ''as CancellationHour,                
 'Visa' as SupplierType,                                   
  Convert(bit,'False') AS 'IsRateCodeApplicable',      
  Convert(bit,APV.IsActive) as   IsActive            
  from Visa.VisaCountry  smv                 
  left join Visa.Visa_AgentSupplierProfileMapper APV     
  on smv.id =APV.Supplierid and APV.AgentId=@AgencyId                  
    where     
 (Smv.SupplierType = @SupplierType  or @SupplierType  IS NULL)           
                                                  
  order by SupplierName asc        
    
    
    
      
    
  --- pricing profile --    
 select Id,ProfileName from PricingProfile where IsActive=1                
               
    
---Ratecode ---    
   Select Id as 'Id'                
  ,SupplierName as 'SupplierName',              
  'Hotel' as 'SupplierType'              
  ,IsRateCodeApplicable as 'IsRateCodeApplicable'                
  from B2BHotelSupplierMaster where IsRateCodeApplicable=1       
        
  union all      
      
  Select      
  Id as 'Id'                
  ,country as 'SupplierName',              
  'Visa' as 'SupplierType'              
  ,Convert(bit,0) as 'IsRateCodeApplicable'                
  from Visa.VisaCountry        
                              
                 
              
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetSupplierProfileMapList] TO [rt_read]
    AS [dbo];

