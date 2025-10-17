      
CREATE proc [dbo].[GetAgentListForBulkUpload]      
      
 @icast  varchar(max)    
    
      
as      
begin      
      
Select       
PKID, FKUserID as AgencyID,     
AgencyName+ ' - '+ icast as AgencyName,      
Icast      
from B2BRegistration      
where icast IN (SELECT data FROM sample_Split(@icast, ','));     
      
end 