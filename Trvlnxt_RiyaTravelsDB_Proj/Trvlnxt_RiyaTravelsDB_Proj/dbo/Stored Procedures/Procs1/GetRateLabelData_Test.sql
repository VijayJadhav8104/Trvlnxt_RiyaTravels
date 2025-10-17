                    
--exec GetRateLabelData '51409','11''Hotel'                    
CREATE proc [dbo].[GetRateLabelData_Test]                      
@AgentId int=0,               
@SuppId int=0 ,              
@IsRateCode bit=0,             
@SupplierType Varchar(200)=null                      
              
as                       
begin                      
       declare @fkuserid int=0;    
    
    select @fkuserid=FKUserID from B2BRegistration where PKID=@AgentId    
        
select                      
 distinct                
rt.Rate as 'RateName'                
from [Hotel].RateLabelNEw rt     
left join B2BHotelSupplierMaster bm  on rt.SupplierId=bm.Id                       
WHERE rt.AgentId=@fkuserid     
and rt.SupplierId=@SuppId    
and bm.IsActive=1     
and bm.IsRateCodeApplicable=1      
and rt.IsActive=1                 
                                                            
 --And (SM.SupplierType = @SupplierType  or @SupplierType  IS NULL)                       
                      
end   