CREATE PROC [dbo].[InsertJoinUsPartner]
@UserName varchar(500),
@Password varchar(300)=null,
@FirstName varchar(800),
@LastName varchar(800),
@MobileNo varchar(800),
@Address varchar(max)=null,
@City varchar(800)=null,
@Country varchar(800)=null,
@Pincode varchar(800)=null,
@Homeno varchar(800)=null,
@BookingCountry varchar(800),
@Oper int=null,
@SessionID varchar(50)=null,
@Province varchar(50)=null,
@AgentApproved bit,
@AddrEmail varchar(150)=null
AS
BEGIN

	DECLARE @UserID BigInt

	IF(@Oper=0)
	BEGIN
		IF(NOT EXISTS (SELECT UserID FROM AgentLogin WHERE UserName=@UserName))
		BEGIN
			
			INSERT INTO AgentLogin
		(
			UserName,
			Password,
			FirstName,
			LastName,
			InsertedDate,
			IsActive,
			MobileNumber,
			NewsLetter,
			Address,
			City,
			Country,
			Pincode,
			HomeNo,
			BookingCountry,
			IsB2BAgent,
			AgentApproved,
			SessionID,
			Province,
			ResetPwdFlag
		)
		VALUES
		(
			@UserName,
			@Password,
			@FirstName,
			@LastName,
			GETDATE(),
			1,
			@MobileNo,
			1,
			@Address,
			@City,
			@Country,
			@Pincode,
			@HomeNo,
			@BookingCountry,
			1,
			@AgentApproved,
			@SessionID,
			@Province,
			0
		)

			SELECT UserID, FirstName AS Name,IsActive,UserName,BookingCountry  FROM AgentLogin WHERE UserName=@UserName

			--- Update Email Task assign by manasvee and done by hardik - 02.08.2023
			SELECT TOP 1 @UserID = UserID FROM AgentLogin WHERE UserName=@UserName

			UPDATE B2BRegistration SET AddrEmail = @AddrEmail WHERE FKUserID = @UserID

		END
		ELSE
		BEGIN
			SELECT NUll as UserID,Null AS Name,Null as IsActive,Null as UserName,null as BookingCountry  
		END
	END
	ELSE
	BEGIN
		
			UPDATE AgentLogin 
			SET FirstName=@FirstName,LastName=@LastName,MobileNumber=@MobileNo,Address=@Address,City=@City,Country=@Country,Pincode=@Pincode,HomeNo=@Homeno,Province=@Province
			WHERE UserName=@UserName

			--- Update Email Task assign by manasvee and done by hardik - 02.08.2023
			SELECT TOP 1 @UserID = UserID FROM AgentLogin WHERE UserName=@UserName

			UPDATE B2BRegistration SET AddrEmail = @AddrEmail WHERE FKUserID = @UserID
	
	END

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertJoinUsPartner] TO [rt_read]
    AS [dbo];

