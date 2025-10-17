

CREATE procEDURE [dbo].[sp_GetProfile]
	@UserID bigint
	
AS
BEGIN
	
			select UserID, UserCode, UserName, Password,   FirstName   , LastName, InsertedDate, IsActive, MobileNumber, 
			NewsLetter, Address, City, Country, Pincode, DrivingLicenceNo, HomeNo, Province, BookingCountry, 
			IsB2BAgent, AgentApproved, SessionID, AgentBalance, Title, AlternateEmailID, Address1,CONVERT(VARCHAR(10), DateOfBirth, 101) as DateOfBirth  , 
			PassportNumber, IssuingCountry,CONVERT(VARCHAR(10), PassportExpiryDate, 101)  as PassportExpiryDate , NewsLetters1, NewsLetters2, 
			MiddleName,NickName from UserLogin where Userid=@UserID

END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetProfile] TO [rt_read]
    AS [dbo];

