CREATE proc [dbo].GetAgentNames_testing --[GetAgentNames_testing] '','satyam','IN,US,CA,AE'                                                                                           ','us'      
@Icust varchar(200),      
@AgencyName varchar(200),      
@Country varchar(50)=null      
AS      
BEGIN      
 if (@Country ='')      
  begin      
       if(@Icust!='')      
        BEGIN      
        SELECT A.userid as PKID,AgencyName,Icast,      
     (case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) + isnull( ' - ' + mb.Name,'') +  isnull( ' - ' + mb.Division,'') as 'DisplayName',      
     a.UserName,       
     NM.Code as 'AgentNationality',      
        NM.Nationality as 'AgentNationalityText',      
     a.BookingCountry as 'AgentCountry',      
     a.Country as 'AgentCountryText'      
           
     FROM B2BRegistration B      
     INNER JOIN AgentLogin A ON A.UserID=B.FKUserID    
  left join mBranch mb on mb.BranchCode=b.BranchCode    
     left join Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode      
     WHERE  A.AgentApproved=1 and UserTypeID is not null      
    END      
    else      
    BEGIN      
      SELECT top 100 A.userid as PKID ,AgencyName,Icast,      
      (case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) + isnull( ' - ' + mb.Name,'') +  isnull( ' - ' + mb.Division,'') as 'DisplayName',  
      a.UserName,A.UserTypeID       
      ,NM.Code as 'AgentNationality'      
      ,NM.Nationality as 'AgentNationalityText',      
      a.BookingCountry as 'AgentCountry',      
      a.Country as 'AgentCountryText'      
            
      FROM B2BRegistration B      
      INNER JOIN AgentLogin A ON A.UserID=B.FKUserID      
   left join mBranch mb on mb.BranchCode=b.BranchCode    
      left join Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode      
      WHERE      
      (AgencyName LIKE '%'+@AgencyName +'%'        
      or  Icast LIKE '%'+@AgencyName +'%' ) AND A.AgentApproved=1  and UserTypeID is not null      
      order by a.InsertedDate desc      
    END      
  end      
 else      
  begin      
   if(@Icust!='')      
       
      BEGIN      
        SELECT A.userid as PKID,AgencyName,Icast,      
     (case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) +  isnull( ' - ' + mb.Name,'') +  isnull( ' - ' + mb.Division,'') as 'DisplayName',      
     a.UserName,A.UserTypeID       
     ,NM.Code as 'AgentNationality'      
      ,NM.Nationality as 'AgentNationalityText',      
      a.BookingCountry as 'AgentCountry',      
      a.Country as 'AgentCountryText'      
      
     FROM B2BRegistration B      
     INNER JOIN AgentLogin A ON A.UserID=B.FKUserID      
  left join mBranch mb on mb.BranchCode=b.BranchCode    
     left join Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode      
     WHERE      
      A.BookingCountry in  ( select DATA from sample_split(@Country,',') )  AND A.AgentApproved=1 and UserTypeID is not null       
   END      
   else      
   BEGIN      
     SELECT top 100 A.userid as PKID ,AgencyName,Icast,      
     (case WHEN A.userTypeID=3 THEN (AgencyName + ' (Marine)- ' +  Icast) ELSE (AgencyName + ' - ' +  Icast)END) + isnull( ' - ' + mb.Name,'') +  isnull( ' - ' + mb.Division,'') as 'DisplayName',      
     a.UserName,A.UserTypeID       
     ,NM.Code as 'AgentNationality'      
        ,NM.Nationality as 'AgentNationalityText',      
     a.BookingCountry as 'AgentCountry',      
     a.Country as 'AgentCountryText'      
      
     FROM B2BRegistration B      
     INNER JOIN AgentLogin A ON A.UserID=B.FKUserID      
  left join mBranch mb on mb.BranchCode=b.BranchCode    
     left join Hotel_Nationality_Master NM on A.BookingCountry=NM.ISOCode      
     WHERE (AgencyName LIKE '%'+@AgencyName +'%' or  Icast LIKE '%'+@AgencyName +'%')       
      AND A.BookingCountry in  ( select DATA from sample_split(@Country,',') )  AND A.AgentApproved=1      
                    AND B.Status=1 and UserTypeID is not null  order by a.InsertedDate desc       
          
   END      
end      
 END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAgentNames_testing] TO [rt_read]
    AS [dbo];

