
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateUserLogin]
	@UserID bigint,
	@UserCode varchar(10)= NULL,
	@FirstName varchar(150)= NULL,
	@LastName varchar(150)= NULL,
	@MobileNumber varchar(20)= NULL,
	@Address Varchar(500)= NULL,
	@City Varchar(100)= NULL,
	@Country Varchar(100)= NULL,
	@Pincode varchar(10) =NULL,
	@NewsLetter	tinyint=NULL,
	@Opr int,
	@HomeNo varchar(20)=null,
	@DrivingLicenceNo varchar(20)=null,
	@Province		varchar(125)=null 
AS
BEGIN
	IF(@Opr=1) --Update Personal Info
		BEGIN
			UPDATE UserLogin
			SET FirstName=@FirstName, LastName=@LastName,MobileNumber=@MobileNumber,UserCode=@UserCode,
			Address=@Address, City=@City,Country=@Country,Pincode=@Pincode
			WHERE UserID=@UserID
		END


	

		IF(@Opr=3 or @Opr=5) --Update all data  USA
		BEGIN
			UPDATE UserLogin
			SET FirstName=@FirstName, 
			LastName=@LastName,
			MobileNumber=@MobileNumber,
			HomeNo=@HomeNo,
			DrivingLicenceNo=@DrivingLicenceNo,
			UserCode=@UserCode,
			Address=@Address,
			City=@City,
			Country=@Country,
			Pincode=@Pincode,
			IsActive=1,
			Province = @Province
			WHERE UserID=@UserID
		END

		IF(@Opr=5) --b2b agent insert
		BEGIN
			UPDATE UserLogin
			SET IsB2BAgent=1
			WHERE UserID=@UserID
		END

		IF(@Opr=4)
			BEGIN
			SELECT @NewsLetter=NewsLetter FROM UserLogin WHERE UserID=@UserID
			 IF (@NewsLetter=0)
			 BEGIN
				UPDATE UserLogin
				SET NewsLetter=1
				WHERE UserID=@UserID
			END
		ELSE
			 BEGIN
				UPDATE UserLogin
				SET NewsLetter=0
				WHERE UserID=@UserID
			 END
		END
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_UpdateUserLogin] TO [rt_read]
    AS [dbo];

