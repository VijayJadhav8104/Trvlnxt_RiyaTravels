--CheckCityCodeForTF 'DEL','DXB'
CREATE PROC CheckCityCodeForTF
	@FromSector VARCHAR(10) , @ToSector VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @FromIsCityCode INT=0,@ToIsCityCode INT=0

	Select top 1 @FromIsCityCode=ISNULL(IsCityCode,0)
	from tblAirportCity Where CODE=@FromSector

	Select top 1 @ToIsCityCode=ISNULL(IsCityCode,0)
	from tblAirportCity Where CODE=@ToSector

	Select @FromIsCityCode AS FromIsCityCode,@ToIsCityCode AS ToIsCityCode
END
