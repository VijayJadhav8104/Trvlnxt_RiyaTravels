

CREATE PROCEDURE [dbo].[sp_InsertUserLogin]
	@UserName varchar(500),
	@Password varchar(300),
	@BookingCountry VARCHAR(2),
	@TokenNo varchar(150)  = null,
	@IsSSOUser bit = null
AS
BEGIN
	IF(NOT EXISTS (SELECT * FROM UserLogin WHERE UserName=@UserName))
	BEGIN
		Declare @ID int 
		INSERT INTO UserLogin(UserName,Password,IsActive,BookingCountry,TokenNo,IsSSOUser,InsertedDate) Values(@UserName,@Password,0,@BookingCountry,@TokenNo,@IsSSOUser,GETDATE())

		set @ID = SCOPE_IDENTITY()

		UPDATE tblBookMaster SET LoginEmailID=@ID WHERE emailId=@UserName AND LoginEmailID IS NULL

		SELECT UserID, FirstName AS Name,IsActive,UserName,BookingCountry,TokenNo  FROM UserLogin WHERE UserName=@UserName

	END
	ELSE
	BEGIN
		SELECT NUll as UserID,Null AS Name,Null as IsActive,Null as UserName,null as BookingCountry  
	END
END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_InsertUserLogin] TO [rt_read]
    AS [dbo];

