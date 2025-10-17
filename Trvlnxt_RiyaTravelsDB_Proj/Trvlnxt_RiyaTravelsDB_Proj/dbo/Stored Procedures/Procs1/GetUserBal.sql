--===============================================      
--Created by :  Akash      
--Created Date : 03/06/2022      
--Description : To get riya User Bal for Console APi       
-- GetUSerBal 51354,46       
--===============================================      
      
      
      
CREATE Proc GetUserBal      
@RiyaUserid int=0,      
@AgencyID int=0      
      
As       
Begin      
   Declare @CountryCode varchar(30)      
   Declare @CountryId int      
      
      
   select @CountryCode=BookingCountry from  AgentLogin where UserID=@AgencyID      
         
   select @CountryId=Id from mCountry where CountryCode=@CountryCode   
      
   select ISNULL(AgentBalance,0) as USerBalance from mUserCountryMapping where UserId=@RiyaUserid and CountryId=@CountryId      
   select EmailID,MobileNo,AutoTicketing,CancelRequest,SelfBalance from mUser where ID = @RiyaUserid  
      
	    --For Allow Booking  
 select   
--(RiyaUserId=@uid AND @uid is not null ),  
--(FKAgencyId=@uid and @uid is not null)  
--FKAgencyId,RiyaUserId,  
   
 Product,case AllowBooking when 1 then 'true' else 'false' end  as AllowBooking-- 'AllowBooking')  
  
--CONCAT('"', Product,'"' ,case AllowBooking when 1 then ':"true"' else ':"false"' end  ) as AllowBooking-- 'AllowBooking')  
from AgentRights   
where RiyaUserId=@RiyaUserid  
      
End
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetUserBal] TO [rt_read]
    AS [dbo];

