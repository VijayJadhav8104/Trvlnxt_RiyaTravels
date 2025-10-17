CREATE PROCEDURE [Rail].[CheckAgentAccess]
	@AgencyID INT = NULL
AS
BEGIN
	IF EXISTS (
			SELECT TOP 1 *
			FROM dbo.mAgentMapping
			WHERE AgentID = @AgencyID
				AND MenuID = (
					SELECT TOP 1 Id
					FROM mMenu
					WHERE MenuName = 'Rail'
						AND Module = 'trvlnxt'
						AND isActive = 1
					)
			)
	BEGIN
		SELECT 1 as Access;
	END
	ELSE
	BEGIN
		SELECT 0 as Access;
	END
END
