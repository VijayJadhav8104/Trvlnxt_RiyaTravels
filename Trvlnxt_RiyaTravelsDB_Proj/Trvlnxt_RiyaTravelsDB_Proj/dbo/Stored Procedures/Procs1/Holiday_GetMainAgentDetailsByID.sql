-- =============================================
-- Author:		Hardik
-- Create date: 19.09.2023
-- Description:	Get Main Agent Details
-- =============================================
CREATE PROCEDURE Holiday_GetMainAgentDetailsByID
	@MainAgentID Int
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 FullName, MobileNo, EmailID, EmployeeNo FROM mUser WHERE ID = @MainAgentID
END