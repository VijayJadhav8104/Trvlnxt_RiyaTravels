









CREATE proc [dbo].[Insert_Traveller]




@FirstName varchar(150)=null,
@LastName varchar(150)=null,
@MobileNumber varchar(50)=null,
@Address varchar(500)=null,
@City varchar(50)=null,
@Country varchar(50)=null,
@Pincode varchar(50)=null,
@Province varchar(50)=null,
@Title varchar(50)=null,
@AlternateEmailID varchar(50)=null,
@Address1 varchar(50)=null,
@DateOfBirth datetime=null,
@PassportNumber varchar(50)=null,
@IssuingCountry varchar(50)=null,
@PassportExpiryDate datetime=null,
@NewsLetters1 bit=0,
@NewsLetters2 bit=0,
@MiddleName  varchar(150)=null,
@nickname varchar(50)=null,
@UserID int = 0


as
begin




insert into tblTraveller

(
FirstName,
LastName,
MobileNumber,
Address,
City,
Country,
Pincode,
Province,
Title,
AlternateEmailID,
Address1,
DateOfBirth,
PassportNumber,
IssuingCountry,
PassportExpiryDate,
NewsLetters1,
NewsLetters2,
MiddleName,
NickName,
UserID
)

values
(

@FirstName ,
@LastName ,
@MobileNumber ,
@Address ,
@City ,
@Country ,
@Pincode ,
@Province ,
@Title ,
@AlternateEmailID ,
@Address1 ,
CONVERT(DATETIME,@DateOfBirth,104) ,
@PassportNumber ,
@IssuingCountry ,
CONVERT(DATETIME,@PassportExpiryDate,104),
@NewsLetters1 ,
@NewsLetters2 ,
@MiddleName ,
@nickname,
@UserID

)

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Insert_Traveller] TO [rt_read]
    AS [dbo];

