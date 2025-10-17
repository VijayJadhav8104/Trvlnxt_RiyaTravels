

CREATE PROCEDURE [dbo].[sp_UserLoginAgent_paging]
	@ParentAgentID int=null,
	@Start int=null,
	@Pagesize int=null,
	@RecordCount INT OUTPUT
AS
BEGIN
	IF(EXISTS(SELECT * FROM AgentLogin WHERE ParentAgentID=@ParentAgentID AND IsB2BAgent=1))
	BEGIN
		SELECT UserID,UserName,FirstName,LastName,MobileNumber,IsActive,InsertedDate into #temp1
		FROM AgentLogin
		WHERE ParentAgentID=@ParentAgentID;

		 SELECT @RecordCount =@@ROWCOUNT

         SELECT * FROM #temp1 order by InsertedDate desc
	     OFFSET @Start ROWS
	     FETCH NEXT @Pagesize ROWS ONLY
	     END
	ELSE
	BEGIN
		SELECT 0;
	END
END











GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserLoginAgent_paging] TO [rt_read]
    AS [dbo];

