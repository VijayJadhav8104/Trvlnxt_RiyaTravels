

CREATE Proc [dbo].[FetchActionAccess]
@UserID INT,
@MenuID INT
AS BEGIN
	
	SELECT ACTIONID,TA.MENUID,USERID,T.ActionName FROM tblActionAccess TA
	INNER JOIN tblAction T ON T.PKID=TA.ActionID 
	WHERE TA.IsActive=1 and ta.UserID=@UserID AND TA.MenuID=@MenuID

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[FetchActionAccess] TO [rt_read]
    AS [dbo];

