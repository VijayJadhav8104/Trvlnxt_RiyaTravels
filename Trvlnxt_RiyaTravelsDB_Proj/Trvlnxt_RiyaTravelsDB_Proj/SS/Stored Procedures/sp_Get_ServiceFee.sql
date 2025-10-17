       
 --exec sp_Get_Cruise_ServiceFee_GST_QuatationDetails 9      
 CREATE PROCEDURE [SS].[sp_Get_ServiceFee]             
 @Id varchar(20)=Null      
 AS       
 BEGIN      
      
 SELECT *,    
      
 Case when AgentId!='All' then ( select    
    distinct      
     stuff((    
         select ',' + u.AgentId    
         from [SS].[tbl_Service_AgentMapping] u    
         where u.ServiceId = @Id    
         for xml path('')    
     ),1,1,'') as AgentId    
  ) else 'All' End AS AgentMappingId,    
  Case when AgentId!='All' then (select    
    distinct      
     stuff((    
         select ',' + b.AgencyName    
         from [SS].[tbl_Service_AgentMapping] u    
   join B2BRegistration b on FKUserID=AgentId    
         where u.ServiceId = @Id    
         for xml path('')    
     ),1,1,'') as AgencyName    
  from [SS].[tbl_Service_AgentMapping]) else 'All' End as AgencyName    
  FROM [SS].[tbl_SS_ServiceFee]  S    
  --join B2BRegistration b    
  WHERE Id=@Id      
    
      
 END      
    
    
GO
GRANT VIEW DEFINITION
    ON OBJECT::[SS].[sp_Get_ServiceFee] TO [rt_read]
    AS [DB_TEST];

