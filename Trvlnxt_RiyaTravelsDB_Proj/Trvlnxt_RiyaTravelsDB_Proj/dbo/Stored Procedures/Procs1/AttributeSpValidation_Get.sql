-- =============================================
-- Author:		Hardik
-- Create date: 10.08.2023
-- Description:	Check Attribute special validation for OBTC
-- =============================================
CREATE PROCEDURE AttributeSpValidation_Get
	@AgentID Int
	,@OUTVAL Int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

    SELECT @OUTVAL = ISNULL(COUNT(FKUserID),0) FROM AttributeSpValidation WHERE FKUserID = @AgentID
END