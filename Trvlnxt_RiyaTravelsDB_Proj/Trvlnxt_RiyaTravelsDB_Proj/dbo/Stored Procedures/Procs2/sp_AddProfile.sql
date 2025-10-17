CREATE procEDURE [dbo].[sp_AddProfile]
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
	@Province		varchar(125)=null,
	@Title varchar(20)=null,
	@AlternateEmailID varchar(50)=null,
	@Address1 varchar(50)=null,
	@DateOfBirth datetime=null,
	@PassportNumber varchar(50)=null,
	@IssuingCountry varchar(50)=null,
	@PassportExpiryDate datetime=null,
	@NewsLetters1 bit=null,
	@NewsLetters2 bit=null,
	@MiddleName varchar(50)
AS
BEGIN
	
			UPDATE UserLogin
			SET FirstName=@FirstName, LastName=@LastName,MobileNumber=@MobileNumber,UserCode=@UserCode,
			Address=@Address, City=@City,Country=@Country,Pincode=@Pincode,Province=@Province,
Title=@Title, AlternateEmailID=@AlternateEmailID, Address1=@Address1, DateOfBirth=@DateOfBirth, 
PassportNumber=@PassportNumber, IssuingCountry=@IssuingCountry, PassportExpiryDate=@PassportExpiryDate, 
NewsLetters1=@NewsLetters1, NewsLetters2=@NewsLetters2, MiddleName=@MiddleName

			WHERE UserID=@UserID
		

END






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_AddProfile] TO [rt_read]
    AS [dbo];

