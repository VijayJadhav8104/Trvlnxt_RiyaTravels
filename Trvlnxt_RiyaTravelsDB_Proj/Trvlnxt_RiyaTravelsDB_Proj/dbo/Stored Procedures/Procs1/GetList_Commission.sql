CREATE PROCEDURE[dbo].[GetList_Commission]  --4,'','','',''
@UserId INT,
@UserType varchar(10)=null,
@MarketPoint varchar(10)=null,
@AirportType varchar(10)=null,
@AirlineName varchar(max)=null
,@AgentID VARCHAR(50)=''

as
begin

select 

m.ID,
MarketPoint,
AirportType,
AirlineType,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
InsertedDate,
Flag,
cabin,
Origin,

OriginValue,
Destination,
DestinationValue,
FlightSeries,
Commission,
IATADealPercent,
AgencyNames,
AgencyId,
AgentCategory,
PLBDealPercent,
MarkupAmount,
m.PaxType,
m.AvailabilityPCC,m.PNRCreationPCC,m.TicketingPCC,
(CONVERT(varchar, TravelValidityFrom,
 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity],
(CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity],
M.UpdatedDate, U.Username,M.UserType,m.Remark,m.PricingCode,m.TourCode,m.Endorsementline,FareType,c.CategoryValue as 'CRSType',m.CardMapping1,
m.IATADiscountType,m.PLBDiscountType,m.MarkupType,m.DropnetCommission,m.LoginId

from Flight_Commission m
left join mUser u ON U.ID=M.USERID
left join tbl_commonmaster c on c.pkid=m.CRSType

where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)
	and m.UserType in (select mc.Value from mUserTypeMapping UT
 inner join mCommon mc on mc.ID=UT.UserTypeId
  where ut.UserId=@UserId and UT.IsActive=1)
--   and Category='CRS'
 AND ((@UserType = '') or (m.UserType = @UserType))
 AND ((@MarketPoint = '') or (m.MarketPoint = @MarketPoint))
 AND ((@AirportType = '') or (m.AirportType = @AirportType))
AND (@AgentID='' OR m.AgencyId LIKE '%'+@AgentID+'%')
 AND ((@AirlineName = '') 
		or 
		(m.AirlineType IN  
		( select AirlineType from Flight_Commission a where EXISTS(select * from sample_split(@AirlineName,',') b 
			WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)
		)))
ORDER BY m.ID desc

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_Commission] TO [rt_read]
    AS [dbo];

