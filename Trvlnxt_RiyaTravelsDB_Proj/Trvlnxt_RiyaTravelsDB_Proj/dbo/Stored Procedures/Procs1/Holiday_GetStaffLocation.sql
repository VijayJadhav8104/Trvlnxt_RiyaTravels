CREATE PROCEDURE Holiday_GetStaffLocation
	@UserName Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 mLocation.LocationCode 
	FROM mUser 
	LEFT OUTER JOIN mLocation ON mLocation.ID = LocationID
	WHERE mUser.UserName = @UserName

END
