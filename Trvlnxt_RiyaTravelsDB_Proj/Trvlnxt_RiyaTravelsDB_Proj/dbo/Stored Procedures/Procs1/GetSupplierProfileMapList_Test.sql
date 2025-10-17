  --exec GetSupplierProfileMapList_Test  'Hotel',21960        
CREATE PROCEDURE GetSupplierProfileMapList_Test                       
 -- Add the parameters for the stored procedure here                        
  @SupplierType Varchar(200)=null,    
  @AgencyId int=0   
AS                        
BEGIN                        
                         
 SELECT PKID, Icast, al.UserID, Icast+' - '+AgencyName as AgencyName               
 FROM B2BRegistration b   inner join agentLogin al on al.UserID = b.FKUserID               
 where  AgentApproved=2345556                      
                        
 --select PKID,AgencyName from B2BRegistration where AgencyName <> '' order by AgencyName asc                        
                        
  --select sm.Id,sm.SupplierName,''as CancellationHour,SM.SupplierType,sm.IsRateCodeApplicable as 'IsRateCodeApplicable'        
  --from B2BHotelSupplierMaster sm               
  --where   (SM.SupplierType = @SupplierType  or @SupplierType  IS NULL)      
      
    
    
    
  select sm.Id,sm.SupplierName,''as CancellationHour,    
  SM.SupplierType,  
  
   CASE   
        WHEN sm.IsRateCodeApplicable = 1 THEN 'True'  
        ELSE 'False'  
    END AS 'IsRateCodeApplicable',   
  
 -- sm.IsRateCodeApplicable as 'IsRateCodeApplicable' ,    
  AP.IsActive    
  --case when AP.Id is not null then 1 else 0 end as supplierMapped    
  from B2BHotelSupplierMaster sm     
  left join AgentSupplierProfileMapper AP on sm.id =AP.Supplierid and AP.AgentId=@AgencyId      
    where   (SM.SupplierType = @SupplierType  or @SupplierType  IS NULL)   and SM.IsDelete=0
                      
 -- and  sm.IsActive=1        this commted after disccussed with faizan sir on 16 jan 24          
 --and sm.Action=1                        
  order by SupplierName asc                        
                        
 select Id,ProfileName from PricingProfile where IsActive=1        
       
   Select Id as 'Id'        
  ,SupplierName as 'SupplierName',      
  'Hotel' as 'SupplierType'      
  ,IsRateCodeApplicable as 'IsRateCodeApplicable'        
  from B2BHotelSupplierMaster where IsRateCodeApplicable=1        
                      
         
      
END 