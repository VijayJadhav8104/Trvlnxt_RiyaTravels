CREATE PROCEDURE [dbo].[getNewUSerIdForSelfBalance] @pkid int  AS  BEGIN  select AddUserSelfBalance as 'NewUserSelfBalance' from tblBookMaster where pkId=@pkid END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getNewUSerIdForSelfBalance] TO [rt_read]
    AS [dbo];

