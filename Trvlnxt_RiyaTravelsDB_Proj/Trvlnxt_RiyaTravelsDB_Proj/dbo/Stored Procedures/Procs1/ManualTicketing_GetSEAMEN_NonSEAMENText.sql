CREATE PROCEDURE ManualTicketing_GetSEAMEN_NonSEAMENText
	@SeamenType Varchar(15)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT OUName FROM mAgentAttributeMappingOU WHERE Address = @SeamenType
END