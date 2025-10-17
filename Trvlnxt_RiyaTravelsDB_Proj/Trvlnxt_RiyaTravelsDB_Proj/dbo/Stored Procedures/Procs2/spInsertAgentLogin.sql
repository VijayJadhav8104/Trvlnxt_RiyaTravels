create Procedure [dbo].[spInsertAgentLogin]
@FirstName nvarchar(50)=null,
@KYCEmailID nvarchar(50)=null,
@KYCPassword nvarchar(50)=null,
@BookingCountry nvarchar(10)=null,
@Usercode nvarchar(30)=null,
@MobileNo nvarchar(30)=null, 
@AddressLocation nvarchar(100)=null,  
@City nvarchar(50)=null,
@ZipCode nvarchar(30)=null,
@UserTypeID int=null,
@id int output


as
begin
insert into AgentLogin (UserCode,UserName,Password,FirstName,MobileNumber,Address,City,Pincode,BookingCountry,UserTypeID) values(@Usercode,@KYCEmailID,@KYCPassword,@FirstName,@MobileNo,@AddressLocation,@City,@ZipCode,@BookingCountry,@UserTypeID)
set @id=SCOPE_IDENTITY()
return @id
end



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertAgentLogin] TO [rt_read]
    AS [dbo];

