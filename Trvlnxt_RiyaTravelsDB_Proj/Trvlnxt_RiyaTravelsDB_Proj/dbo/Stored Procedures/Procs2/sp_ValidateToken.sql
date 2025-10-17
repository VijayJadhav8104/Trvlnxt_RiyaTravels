CREATE PROCEDURE [dbo].[sp_ValidateToken]

@token VARCHAR(50)

AS
BEGIN

SELECT UserName from mUser where SessionID=@token and isActive=1

SELECT UserName from AgentLogin where SessionID=@token and isActive=1

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_ValidateToken] TO [rt_read]
    AS [dbo];

