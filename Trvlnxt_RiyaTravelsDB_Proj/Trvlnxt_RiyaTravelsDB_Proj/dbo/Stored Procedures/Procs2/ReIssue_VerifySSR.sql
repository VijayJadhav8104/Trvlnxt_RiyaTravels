CREATE PROCEDURE ReIssue_VerifySSR
	@RiyaPNR Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT SSR_Type 
	FROM tblSSRDetails 
	WHERE fkbookmaster IN (SELECT pkid FROM tblBookMaster WHERE RiyaPNR = @RiyaPNR)
	GROUP BY SSR_Type

END