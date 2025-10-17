
-- =============================================
-- Author:		<JD>
-- Create date: <24.08.2023>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAgentDetailForOBTC]
	@RiyaPNR NVarchar(50)
	, @OUTVAL Int OUTPUT
AS
BEGIN	
    
	DECLARE @AgentID INT, @Country Varchar(50), @FKUserID Int, @UserTypeID Int

	--Get Agent ID BY RiyaPNR
	SELECT @AgentID = AgentID
	FROM tblBookMaster WITH (NOLOCK)
	WHERE riyaPNR = @RiyaPNR

	--Get Agent Country By Agent ID
	SELECT @Country = country 
	FROM B2BRegistration WITH (NOLOCK)
	WHERE FKUserID = @AgentID

	--Get FKUserID By AGent ID
	SELECT @FKUserID = ISNULL(COUNT(FKUserID),0) 
	FROM AttributeSpValidation WITH (NOLOCK) 
	WHERE FKUserID = @AgentID

	--Get UserTypeID BY Agent ID
	SELECT @UserTypeID = UserTypeID
	FROM AgentLogin  WITH (NOLOCK)
	WHERE UserID = @AgentID

	SET @OUTVAL = 0

	IF((@UserTypeID = 4 AND @Country = 'IN') OR @FKUserID > 0)
	BEGIN
		SET @OUTVAL = 1
	END
END
