CREATE PROCEDURE [dbo].[GetAgentNames]           
@Icust varchar(200) = null,          
@AgencyName varchar(max)='AllAgencies',          
@Country varchar(50) = null,          
@IsMultipleAgent Int=null --Jitendra Nakum if 1 then return all record for enter customer code wise          
AS                  
BEGIN         
 IF(@AgencyName = 'AllAgencies' AND @Country !='')          
 BEGIN          
   SELECT A.userid as PKID ,AgencyName,Icast,            
   (case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) as 'DisplayName',            
   a.UserName,A.UserTypeID   ,ISNULL(NM.Code,0) as 'AgentNationality',                  
   ISNULL(NM.Nationality,'')as 'AgentNationalityText',  a.BookingCountry as 'AgentCountry',            
   a.Country as 'AgentCountryText' , ISNULL(A.GroupId,0)  as GroupId            
   FROM B2BRegistration B            
   INNER JOIN AgentLogin A ON A.UserID=B.FKUserID            
   LEFT JOIN Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode            
   WHERE A.BookingCountry in  (select DATA from sample_split(@Country,','))  
   AND A.AgentApproved=1            
   --AND B.Status=1       
   and UserTypeID is not null  order by a.InsertedDate desc             
 END          
 ELSE IF(@IsMultipleAgent=1)          
 BEGIN          
  SELECT top 100 A.userid as PKID ,AgencyName,Icast,                  
  (case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) + isnull( ' - ' + B.AddrCity,'')as 'DisplayName',                  
  a.UserName,A.UserTypeID                   
  ,ISNULL(NM.Code,0) as 'AgentNationality'                  
  ,ISNULL(NM.Nationality,'') as 'AgentNationalityText',                  
  a.BookingCountry as 'AgentCountry',                  
  a.Country as 'AgentCountryText',          
  ISNULL(A.GroupId,0)  as GroupId           
  FROM B2BRegistration B                  
  INNER JOIN AgentLogin A ON A.UserID=B.FKUserID                  
  left join Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode                  
  WHERE          
  (          
   Icast in (select DATA from sample_split(@AgencyName,','))          
  )          
   AND A.BookingCountry IN (select DATA from sample_split(@Country,','))            
  AND A.AgentApproved=1                  
  --AND B.Status=1           
  AND UserTypeID IS NOT NULL            
  order by a.InsertedDate desc          
 END          
 ELSE          
 BEGIN          
  IF(@Country ='')          
  BEGIN          
    IF(@Icust!='')          
         BEGIN                  
       SELECT A.userid as PKID,AgencyName,Icast,                  
    (case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) + isnull( ' - ' + B.AddrCity,'') as 'DisplayName',                  
    a.UserName,                   
    ISNULL(NM.Code,0) as 'AgentNationality',                  
    ISNULL(NM.Nationality,'')as 'AgentNationalityText',                  
    a.BookingCountry as 'AgentCountry',                  
    a.Country as 'AgentCountryText',          
    ISNULL(A.GroupId,0)  as GroupId           
    FROM B2BRegistration B                  
    INNER JOIN AgentLogin A ON A.UserID=B.FKUserID                
    --left join mBranch mb on mb.BranchCode=b.BranchCode   AND MB.Division='RTT'             
    left join Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode                  
    WHERE  
	A.AgentApproved=1 and
	UserTypeID is not null                  
   END                  
   else                  
   BEGIN                  
    SELECT top 100 A.userid as PKID ,AgencyName,Icast,                  
    (case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END)  + isnull( ' - ' + B.AddrCity,'') as 'DisplayName',              
    a.UserName,A.UserTypeID                   
    ,ISNULL(NM.Code,0) as 'AgentNationality'                  
    ,ISNULL(NM.Nationality,'') as 'AgentNationalityText',               
    a.BookingCountry as 'AgentCountry',                  
    a.Country as 'AgentCountryText'             
    , ISNULL(A.GroupId,0) as GroupId           
    FROM B2BRegistration B                  
    INNER JOIN AgentLogin A ON A.UserID=B.FKUserID           
    -- left join mBranch mb on mb.BranchCode=b.BranchCode                
    left join Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode                  
    WHERE                  
    (AgencyName LIKE '%'+@AgencyName +'%'                    
    or  Icast LIKE '%'+@AgencyName +'%'          
    or  Icast in (select DATA from sample_split(@AgencyName,','))) 
	AND A.AgentApproved=1  
	and UserTypeID is not null                  
    order by a.InsertedDate desc                  
   END                  
  END                  
  ELSE                  
  BEGIN                  
      IF(@Icust!='')                  
     BEGIN          
PRINT 'XYZ'      
       SELECT A.userid as PKID,AgencyName            
    --,Icast                
    ,REPLACE(Icast,' ','') as 'Icast'            
    ,(case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  REPLACE(Icast,' ',''))             
    ELSE (AgencyName + ' - ' +  REPLACE(Icast,' ',''))END) + isnull( ' - ' + B.AddrCity,'') as 'DisplayName',                  
    a.UserName,A.UserTypeID                   
    ,ISNULL(NM.Code,0) as 'AgentNationality'                  
    ,ISNULL(NM.Nationality,'') as 'AgentNationalityText',                  
    a.BookingCountry as 'AgentCountry',                  
    a.Country as 'AgentCountryText'              
    , ISNULL(A.GroupId,0)  as GroupId           
                  
    FROM B2BRegistration B                  
    INNER JOIN AgentLogin A ON A.UserID=B.FKUserID                  
    -- left join mBranch mb on mb.BranchCode=b.BranchCode                
    left join Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode                  
    WHERE A.BookingCountry in  ( select DATA from sample_split(@Country,',') )           
    AND A.AgentApproved=1 
	and UserTypeID is not null                   
   END                  
   else                  
   BEGIN         
   PRINT 'ABC'      
    SELECT top 100 A.userid as PKID ,AgencyName,Icast,                  
    (case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) + isnull( ' - ' + B.AddrCity,'')as 'DisplayName',                  
    a.UserName,A.UserTypeID                   
    ,ISNULL(NM.Code,0) as 'AgentNationality'                  
    ,ISNULL(NM.Nationality,'') as 'AgentNationalityText',                  
    a.BookingCountry as 'AgentCountry',                  
    a.Country as 'AgentCountryText',          
    ISNULL(A.GroupId,0)  as GroupId           
    FROM B2BRegistration B                  
    INNER JOIN AgentLogin A ON A.UserID=B.FKUserID                  
    -- left join mBranch mb on mb.BranchCode=b.BranchCode                
    left join Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode                  
    WHERE          
    (          
     Icast +' - '+AgencyName in (select DATA from sample_split(@AgencyName,','))          
     or          
     (          
      AgencyName LIKE '%'+@AgencyName +'%'                    
      or  Icast LIKE '%'+@AgencyName +'%'          
      or  Icast in (select DATA from sample_split(@AgencyName,','))          
      or  AgencyName in (select DATA from sample_split(@AgencyName,','))          
     )          
    )          
     --(          
     -- AgencyName LIKE '%'+@AgencyName +'%'           
     -- or  Icast LIKE '%'+@AgencyName +'%'           
     -- or Icast in (select DATA from sample_split(@AgencyName,','))          
     -- or (Icast +' - ' +AgencyName) in (select DATA from sample_split(@AgencyName,','))          
     --)          
     AND A.BookingCountry in  ( select DATA from sample_split(@Country,',') )    
AND A.AgentApproved =1                 
    --AND B.Status=1       
 and UserTypeID is not null            
--order by a.InsertedDate desc                   
   END                  
  end          
 END          
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAgentNames] TO [rt_read]
    AS [dbo];

