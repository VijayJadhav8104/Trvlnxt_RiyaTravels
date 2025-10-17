CREATE PROC GetEntityNames
	@Key VARCHAR(MAX)
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT Pkid,EntityName FROM tblEntityMaster 
	Where EntityName LIKE '%'+@Key+'%'
	
END
