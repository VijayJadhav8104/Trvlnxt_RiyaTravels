-- =============================================
-- Author:		Hardik
-- Create date: 13.10.2023
-- Description:	
-- =============================================
CREATE PROCEDURE Holiday_GetEmployeeCodeByAgentID
	@AgentID Int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT ISNULL(SalesPersonId,'NA') AS EmployeeNo
	, CustomerCOde AS CustomerCode
	FROM B2BRegistration WHERE FKUserID = @AgentID
END