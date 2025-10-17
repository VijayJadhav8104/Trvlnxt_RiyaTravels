CREATE proc sp_UserVisitorId  
@UserName varchar (50) = null  
As  
BEGIN   
  
select Top 1  visitorId,UserID,* from tblLoginHistory  TH
JOIN  Muser MU ON TH.UserID=MU.ID
where MU.UserName=@UserName and visitorid is not null order by PKID desc   
  
END  

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserVisitorId] TO [rt_read]
    AS [dbo];

