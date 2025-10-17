              
--execute GetAllSupplierAgentOnMaped 21958       
CREATE PROCEDURE GetAllSupplierAgentOnMaped                          
 -- Add the parameters for the stored procedure here                          
 @AgentId int=0                           
                          
AS                          
BEGIN                          
                           
 Declare @AgentPkID int=0;                          
 set @AgentPkID = (select PKID from B2BRegistration where FKUserID=@AgentId)                          
                          
 select SP.SupplierId,                          
        SP.AgentId,                          
        SP.IsActive,                          
     HS.SupplierName,                          
     HS.Username,                          
     HS.[Password],                      
  HS.RhSupplierId,                   
                  
   case                    
   when HS.PayAtHotel=1  then 'true'                
   else 'false'                    
   END as PayAtHotel,          
             
   case                      
   when  isnull(HS.IsPanRequired,0)=1  then 'true'                
   else 'false'                    
   END as IsPanRequired,        
        
    case                        
   when  isnull(HS.Is_Req_Domestic_Pan,0)=1  then 'true'                  
   else 'false'                      
   END as IsReqDomesticPan,           
             
    case                        
   when  isnull(HS.Is_Req_International_Pan,0)=1  then 'true'                  
   else 'false'                      
   END as IsReqInternationalPan,      
         
   isnull(HS.LastName,'') as LastName,    
       
   isnull(HCM.Value,'') as SupplierCurrency,   
     
   isnull(HS.RateDisplay,'') as RateDisplay  
                           
 from AgentSupplierProfileMapper SP                          
 join B2BHotelSupplierMaster HS on SP.SupplierId=HS.Id and HS.SupplierType='Hotel'                        
  left join mCommon HCM on  HCM.ID=HS.SupplierCurrency and HCM.Category='Currency'                  
 where SP.AgentId=@AgentPkID and SP.IsActive=1 and HS.IsActive=1  and HS.Action=1 and  HS.IsDelete=0                    
                          
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllSupplierAgentOnMaped] TO [rt_read]
    AS [dbo];

