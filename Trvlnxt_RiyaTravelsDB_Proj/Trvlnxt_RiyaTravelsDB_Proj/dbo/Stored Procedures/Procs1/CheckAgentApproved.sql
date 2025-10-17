


CREATE proc [dbo].[CheckAgentApproved]


as
begin

select 

UserID,
UserCode,
UserName,
Password,
FirstName,
LastName,
UserLogin.InsertedDate,
IsActive,
MobileNumber,
NewsLetter,
Address,
City,
UserLogin.Country,
Pincode,
DrivingLicenceNo,
HomeNo,
Province,
BookingCountry,
IsB2BAgent,
AgentApproved


 from UserLogin
left join B2BRegistration on B2BRegistration.FKUserID = UserLogin.UserID




end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckAgentApproved] TO [rt_read]
    AS [dbo];

