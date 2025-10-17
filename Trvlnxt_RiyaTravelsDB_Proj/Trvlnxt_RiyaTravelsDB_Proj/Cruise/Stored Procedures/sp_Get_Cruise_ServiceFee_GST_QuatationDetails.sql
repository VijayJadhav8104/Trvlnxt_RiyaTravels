
     
 --exec sp_Get_Cruise_ServiceFee_GST_QuatationDetails 9    
 CREATE PROCEDURE [Cruise].[sp_Get_Cruise_ServiceFee_GST_QuatationDetails]            
 @Id varchar(20)=Null    
 AS     
 BEGIN    
    
 SELECT *,  
    
 Case when AgentId!='All' then ( select  
    distinct    
     stuff((  
         select ',' + u.AgentId  
         from [Cruise].Cruise_Service_AgentMapping u  
         where u.ServiceId = @Id  
         for xml path('')  
     ),1,1,'') as AgentId  
  ) else 'All' End AS AgentMappingId,  
  Case when AgentId!='All' then (select  
    distinct    
     stuff((  
         select ',' + b.AgencyName  
         from [Cruise].Cruise_Service_AgentMapping u  
   join B2BRegistration b on FKUserID=AgentId  
         where u.ServiceId = @Id  
         for xml path('')  
     ),1,1,'') as AgencyName  
  from [Cruise].Cruise_Service_AgentMapping) else 'All' End as AgencyName  
  FROM [Cruise].tbl_Cruise_ServiceFee_GST_QuatationDetails S  
  --join B2BRegistration b  
  WHERE Id=@Id  
  
  
    
 END    
  
  
  

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[sp_Get_Cruise_ServiceFee_GST_QuatationDetails] TO [rt_read]
    AS [DB_TEST];

