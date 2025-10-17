CREATE PROCEDURE [dbo].[getNewUserIdForSelfBalanceByPnr] @pnr varchar(50)  AS  BEGIN  select AddUserSelfBalance as 'NewUserSelfBalance' from tblBookMaster where riyaPNR=@pnr END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getNewUserIdForSelfBalanceByPnr] TO [rt_read]
    AS [dbo];

