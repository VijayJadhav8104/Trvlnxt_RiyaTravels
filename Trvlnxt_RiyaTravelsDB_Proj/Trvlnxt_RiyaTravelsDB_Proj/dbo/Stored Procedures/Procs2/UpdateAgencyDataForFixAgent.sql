CREATE PROC UpdateAgencyDataForFixAgent
	@lstAgencyID VARCHAR(MAX),@lstAgencyName VARCHAR(MAX)
AS
BEGIN
	UPDATE Flight_MarkupType SET AgencyId=AgencyId+@lstAgencyID,
	AgencyNames=AgencyNames+','+@lstAgencyName
	where id=281
END