CREATE procEDURE [dbo].[sp_TravellersDetails] --1
	@UserID bigint
	
AS
BEGIN
	
			select TravellerID, Title, FirstName, MiddleName, LastName, NickName, AlternateEmailID, MobileNumber, 
			Address, Address1, City, Country, Pincode, Province, DateOfBirth, PassportNumber, IssuingCountry, 
			PassportExpiryDate, NewsLetters1, NewsLetters2, UserID from  tblTraveller
			where Userid=@UserID

			select UserID, UserCode, UserName, Password, FirstName, LastName, InsertedDate, IsActive, MobileNumber, 
			NewsLetter, Address, City, Country, Pincode, DrivingLicenceNo, HomeNo, Province, BookingCountry, 
			IsB2BAgent, AgentApproved, SessionID, AgentBalance, Title, AlternateEmailID, Address1, DateOfBirth, 
			PassportNumber, IssuingCountry, PassportExpiryDate, NewsLetters1, NewsLetters2, 
			MiddleName,NickName from UserLogin where Userid=@UserID


END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_TravellersDetails] TO [rt_read]
    AS [dbo];

