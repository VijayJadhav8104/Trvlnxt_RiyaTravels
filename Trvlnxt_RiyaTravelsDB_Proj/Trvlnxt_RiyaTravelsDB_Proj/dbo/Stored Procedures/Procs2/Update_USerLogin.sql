









CREATE proc [dbo].[Update_USerLogin]


@UserID int,
@UserCode varchar(10)=null,
@FirstName varchar(150)=null,
@LastName varchar(150)=null,
@MobileNumber varchar(50)=null,
@Address varchar(500)=null,
@City varchar(50)=null,
@Country varchar(50)=null,
@Pincode varchar(50)=null,
@NewsLetter tinyint =0,
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
@option int,
@Password varchar(50)=null,
@UserName varchar(100)=null,
@nickname varchar(50)=null


as
begin



--declare

--@UserID int=10048,
--@UserCode varchar(10)=null,
--@FirstName varchar(150)=null,
--@LastName varchar(150)=null,
--@MobileNumber varchar(50)=null,
--@Address varchar(500)=null,
--@City varchar(50)=null,
--@Country varchar(50)=null,
--@Pincode varchar(50)=null,
----@NewsLetter tinyint = 0,
--@Province varchar(50)=null,
--@Title varchar(50)=null,
--@AlternateEmailID varchar(50)=null,
--@Address1 varchar(50)=null,
--@DateOfBirth datetime=null,
--@PassportNumber varchar(50)=null,
--@IssuingCountry varchar(50)=null,
--@PassportExpiryDate datetime=null,
----@NewsLetters1 bit=0,
----@NewsLetters2 bit=0,
--@MiddleName  varchar(150)=null,
--@option int=2,
--@Password varchar(50)='mnmnmnmnmn123',
--@UserName varchar(100)='mayuri123456@gmail.com'


if(@option = 1)
begin



Update UserLogin
set 

UserCode=@UserCode,
FirstName=@FirstName,
LastName=@LastName,
InsertedDate=GETDATE(),
MobileNumber=@MobileNumber,
NewsLetter=@NewsLetter,
Address=@Address,
City=@City,
Country=@Country,
Pincode=@Pincode,
Province=@Province,

Title=@Title,
AlternateEmailID=@AlternateEmailID,
Address1=@Address1,
DateOfBirth=@DateOfBirth,
PassportNumber=@PassportNumber,
IssuingCountry=@IssuingCountry,
PassportExpiryDate=@PassportExpiryDate,
NewsLetters1=@NewsLetters1,
NewsLetters2=@NewsLetters2,
MiddleName=@MiddleName,
NickName=@nickname


where UserID=@UserID
select 1
end

else
begin


declare @Pwd varchar(50)
select @Pwd = Password  from UserLogin  where UserID=@UserID



if(@Pwd= @Password)
begin


--print 123
update UserLogin
set UserName=@UserName
where UserID=@UserID

end
end
end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_USerLogin] TO [rt_read]
    AS [dbo];

