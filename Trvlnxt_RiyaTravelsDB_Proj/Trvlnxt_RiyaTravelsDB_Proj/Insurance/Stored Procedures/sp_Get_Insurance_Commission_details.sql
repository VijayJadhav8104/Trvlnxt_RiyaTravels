 --exec [Insurance].[sp_Get_Insurance_Commission_details] 3    
 CREATE PROCEDURE [Insurance].[sp_Get_Insurance_Commission_details]
 @Id varchar(20)=Null    
 AS     
 BEGIN    
    
 SELECT *,  
    
 --Case when AgentId!='All' then ( select  
 --   distinct    
 --    stuff((  
 --        select ',' + u.AgentId  
 --        from [Cruise].Cruise_Service_AgentMapping u  
 --        where u.ServiceId = @Id  
 --        for xml path('')  
 --    ),1,1,'') as AgentId  
 -- ) else 'All' End AS AgentMappingId,  
  --Case when AgentId!='All' then (select  
  --  distinct    
  --   stuff((  
  --       select ',' + b.AgencyName  
  --       from [Cruise].Cruise_Service_AgentMapping u  
  -- join B2BRegistration b on FKUserID=AgentId  
  --       where u.ServiceId = @Id  
  --       for xml path('')  
  --   ),1,1,'') as AgencyName  

	 case when S.AgentId='ALL' then 'ALL' else (select stuff((select ', ' + b.AgencyName from AgentLogin agt
	left join B2BRegistration b on b.FKUserID=agt.UserID 
	where PATINDEX('%,'+convert(varchar,agt.UserID)+',%',','+S.AgentId+',')>0
	for xml path('')),1,1,'')) end as AgencyName  
 -- from [Cruise].Cruise_Service_AgentMapping) else 'All' End as AgencyName  
  FROM Insurance.tbl_Insurance_Markup_Comm S  
  --join B2BRegistration b  
  WHERE s.PKID=@Id    
    
 END    
