





CREATE proc [dbo].[GetList_AgentListSearch]

@USerID int

AS 
BEGIN

--select * from AgentLogin order by UserName asc

--DECLARE @userTypeId BIGINT;
--SET @userTypeId = 28;
WITH tblChild AS
(
    SELECT *
        FROM AgentLogin WHERE ParentAgentID = @USerID
    UNION ALL
    SELECT AgentLogin.* FROM AgentLogin  JOIN tblChild  ON AgentLogin.ParentAgentID = tblChild.UserID
)
SELECT *
    FROM tblChild
OPTION(MAXRECURSION 32767)


END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_AgentListSearch] TO [rt_read]
    AS [dbo];

