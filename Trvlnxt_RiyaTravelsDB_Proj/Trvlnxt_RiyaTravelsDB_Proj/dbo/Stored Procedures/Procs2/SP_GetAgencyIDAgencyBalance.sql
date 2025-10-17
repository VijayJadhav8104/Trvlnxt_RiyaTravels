--exec SP_GetAgencyIDAgencyBalance 'cust123456 - Ranjit Travels'

CREATE Procedure SP_GetAgencyIDAgencyBalance
@AgencyCode nvarchar(200)=null
as
begin
select PKID,
convert(varchar(50),AirlineStartDate,106) AirlineStartDate ,
isnull(AirlineCreditday,0) AirlineCreditday,
isnull(HotelCreditDay,0) HotelCreditDay

from B2BRegistration where CustomerCOde=@AgencyCode
end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SP_GetAgencyIDAgencyBalance] TO [rt_read]
    AS [dbo];

