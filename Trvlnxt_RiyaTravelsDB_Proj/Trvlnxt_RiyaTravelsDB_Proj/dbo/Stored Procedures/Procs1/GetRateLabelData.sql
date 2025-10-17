
      --- Created by Shailesh ---        
CREATE proc [dbo].[GetRateLabelData]            
@AgentId int=0,     
@SuppId int=0 ,    
@IsActive bit=0,      
@SupplierType Varchar(200)=null            
    
as             
begin            
            
select            
ARCM.RateCodeId  as 'RateCodeId'        
,ARCM.SupplierId           
--,ARCM.AgentId          
--,ARCM.Createdon       
,HRM.RateCode + '-'+ HRM.Label as 'RateName'      
from Hotel.AgentSupplierRateCodeMapping ARCM left join Hotel_RateCode_Master HRM  on HRM.Id=ARCM.RateCodeId             
WHERE ARCM.AgentId=@AgentId and ARCM.SupplierId=@SuppId 
--and   ARCM.IsActive=1         
                                                  
 --And (SM.SupplierType = @SupplierType  or @SupplierType  IS NULL)             
            
end         
      
