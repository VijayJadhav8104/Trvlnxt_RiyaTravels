

CREATE proc [dbo].[GetRecord_Traveller]

@UserID int

as
begin

select 

TravellerID,
Title,
FirstName,
MiddleName,
LastName,
NickName,
AlternateEmailID,
MobileNumber,
Address,
Address1,
City,
Country,
Pincode,
Province,
CONVERT(VARCHAR(10), DateOfBirth, 101) as DateOfBirth ,
PassportNumber,
IssuingCountry,
CONVERT(VARCHAR(10), PassportExpiryDate, 101) as PassportExpiryDate  ,
NewsLetters1,
NewsLetters2,
UserID

 from tblTraveller 
where TravellerID = @UserID



end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_Traveller] TO [rt_read]
    AS [dbo];

