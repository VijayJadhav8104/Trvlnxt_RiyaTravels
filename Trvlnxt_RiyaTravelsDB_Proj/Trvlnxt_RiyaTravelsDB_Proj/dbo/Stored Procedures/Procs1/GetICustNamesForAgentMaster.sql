--sp_helpText GetICustNamesForAgentMaster  'isacgeorge.ate@ategroup.org',567          
            
CREATE Procedure GetICustNamesForAgentMaster        
@Key varchar(200),            
@UserID INT             
AS             
BEGIN                
SELECT             
top 100 PKID,             
Icast,            
al.UserID,            
AgencyName,            
al.UserTypeID            
FROM B2BRegistration b              
 inner join agentLogin al on al.UserID=b.FKUserID              
 where (icast like '%' + @Key+ '%' or AgencyName like '%'+@Key+'%' or AddrEmail like '%'+@Key+'%')  AND             
 AL.BookingCountry IN (SELECT C.CountryCode FROM mUserCountryMapping CM              
 INNER JOIN mCountry C ON C.ID=CM.CountryId  WHERE  USERID=@UserID)                
END 


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetICustNamesForAgentMaster] TO [rt_read]
    AS [dbo];

