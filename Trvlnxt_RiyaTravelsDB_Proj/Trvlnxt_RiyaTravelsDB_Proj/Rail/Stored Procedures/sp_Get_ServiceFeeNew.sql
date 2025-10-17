           
 --exec [Rail].[sp_Get_ServiceFee] 45          
 CREATE PROCEDURE [Rail].[sp_Get_ServiceFeeNew]                  
 @Id varchar(20)=Null          
 AS           
 BEGIN          
          
 SELECT *,        
          
 Case when AgentId!='All' then ( select        
    distinct          
     stuff((        
         select ',' + u.AgentId        
         from [Rail].[Service_AgentMappingNew] u        
         where u.ServiceId = @Id        
         for xml path('')        
     ),1,1,'') as AgentId        
  ) else 'All' End AS AgentMappingId,        
  Case when AgentId!='All' then (select        
    distinct          
     stuff((        
         select ',' + b.AgencyName        
         from [Rail].[Service_AgentMappingNew] u        
   join B2BRegistration b on FKUserID=AgentId        
         where u.ServiceId = @Id        
         for xml path('')        
     ),1,1,'') as AgencyName        
  from [Rail].[Service_AgentMapping]) else 'All' End as AgencyName     
  --mu.FullName    
  FROM [Rail].[tbl_ServiceFeeNew] S        
  left join rail.Agent_ServiceFee_MapperNew SM on SM.FK_ServiceFeeId = S.Id      
  --left join mUser mu on mu.ID=s.CreatedBy    
  --left join rail.ProductListMaster PM on PM.ProductType = S.ProductType      
  --PM.Fk_SupplierMasterId = S.Fk_SupplierMasterId      
  WHERE s.Id=@Id          
        
          
 END          
        