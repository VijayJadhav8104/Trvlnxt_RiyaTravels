Create Procedure CheckSelfBalanceData
@PKID int
As
Begin
	Select * from tblSelfBalance Where PKID=@PKID
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckSelfBalanceData] TO [rt_read]
    AS [dbo];

