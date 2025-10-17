
         
 --exec sp_Get_Cruise_Flat 7        
 CREATE PROCEDURE [Cruise].[sp_Get_Cruise_Discount]            
 @Id varchar(20)=Null        
 AS         
 BEGIN        
        
 SELECT *,    
      
 Case when AgentId!='All' then ( select    
    distinct      
     stuff((    
         select ',' + u.AgentId    
         from [Cruise].Cruise_Discount_AgentMapping u    
         where u.ServiceId = @Id    
         for xml path('')    
     ),1,1,'') as AgentId    
  ) else 'All' End AS AgentMappingId,    
  Case when AgentId!='All' then (select    
    distinct      
     stuff((    
         select ',' + b.AgencyName    
         from [Cruise].Cruise_Discount_AgentMapping u    
   join B2BRegistration b on FKUserID=AgentId    
         where u.ServiceId = @Id    
         for xml path('')    
     ),1,1,'') as AgencyName    
  from [Cruise].Cruise_Discount_AgentMapping) else 'All' End as AgencyName    
  FROM [Cruise].tbl_Cruise_Discount S    
  --join B2BRegistration b    
  WHERE Id=@Id   
    
        
 END 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[Cruise].[sp_Get_Cruise_Discount] TO [rt_read]
    AS [DB_TEST];

