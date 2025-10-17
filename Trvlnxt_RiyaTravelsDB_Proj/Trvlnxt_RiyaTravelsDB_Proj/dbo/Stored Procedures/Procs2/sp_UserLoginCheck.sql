
CREATE PROCEDURE [dbo].[sp_UserLoginCheck]
	@UserName varchar(500),
	@Password varchar(300)=null,
	@opr int,
	@Device VARCHAR(50)=null,
	@IPAddress VARCHAR(50)=null,
	@Browser VARCHAR(50)=null,
	@Country VARCHAR(2)=null
AS
BEGIN
	IF(@opr=1)--Login Check
	BEGIN
		IF(EXISTS(SELECT * FROM UserLogin WHERE UserName=@UserName AND Password=@Password AND (IsB2BAgent!=1 OR IsB2BAgent IS NULL)))
		BEGIN
			--SELECT UserID FROM UserLogin WHERE UserName=@UserName AND Password=@Password;   OLD CODE
			SELECT UserID,UserName,FirstName,LastName,MobileNumber,HomeNo,BookingCountry,
			isnull(IsB2BAgent,0) as IsB2BAgent,isnull(AgentApproved,0) as AgentApproved 
			FROM UserLogin WHERE UserName=@UserName AND Password=@Password;
			
			DECLARE @UserID INT
			SELECT @UserID=UserID FROM UserLogin WHERE UserName=@UserName AND Password=@Password;

			INSERT INTO tblLoginHistory
			(USERID,Device,IPAddress,Browser,Country,Status)
			VALUES (@UserID,@Device,@IPAddress,@Browser,@Country,1)
		END
		ELSE
		BEGIN
			INSERT INTO tblLoginHistory
			(USERID,Device,IPAddress,Browser,Country,Status)
			VALUES (NULL,@Device,@IPAddress,@Browser,@Country,0)
		END
	END
	ELSE IF(@opr=2)--user profile all data
	BEGIN
		IF(EXISTS(SELECT * FROM UserLogin WHERE UserName=@UserName))
		BEGIN
			--SELECT UserID FROM UserLogin WHERE UserName=@UserName;  OLD
			SELECT UserID,UserName,FirstName,LastName,MobileNumber,NewsLetter,HomeNo,BookingCountry,
			Address,City,Country,Pincode,DrivingLicenceNo,Province,
			isnull(IsB2BAgent,0) as IsB2BAgent,isnull(AgentApproved,0) as AgentApproved , IsSSOUser
			 FROM UserLogin WHERE UserName=@UserName;
		END
		ELSE
		BEGIN
			SELECT 0;
		END
	END
	
	
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UserLoginCheck] TO [rt_read]
    AS [dbo];

