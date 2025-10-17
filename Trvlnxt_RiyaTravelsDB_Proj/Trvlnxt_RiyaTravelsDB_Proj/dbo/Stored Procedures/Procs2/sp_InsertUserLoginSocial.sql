
CREATE PROCEDURE [dbo].[sp_InsertUserLoginSocial]
	@UserName varchar(500),
	@FirstName varchar(300),
	@BookingCountry VARCHAR(2)
AS
BEGIN
	IF(NOT EXISTS (SELECT * FROM UserLogin WHERE UserName=@UserName))
	BEGIN
		INSERT INTO UserLogin(UserName,Password,IsActive,BookingCountry) Values(@UserName,@FirstName,1,@BookingCountry)

		SELECT UserID, FirstName AS Name,IsActive,UserName,BookingCountry  FROM UserLogin WHERE UserName=@UserName
	END
	ELSE
	BEGIN
		SELECT UserID, FirstName AS Name,IsActive,UserName,BookingCountry FROM UserLogin WHERE UserName=@UserName
	END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_InsertUserLoginSocial] TO [rt_read]
    AS [dbo];

