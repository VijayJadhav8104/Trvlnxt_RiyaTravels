CREATE PROCEDURE[dbo].[GetList_ForAllTab]     
	@ID int=null
	, @UserId INT
	, @UserType varchar(10)=null
	, @MarketPoint varchar(10)=null
	, @AirportType varchar(10)=null
	, @AirlineName varchar(max)=null
	, @Tab varchar(10)=null
	,@TransactionType VARCHAR(100)='All',@CRSType VARCHAR(50)='All'
	,@AvailabilityPCC VARCHAR(200)=''
AS
BEGIN
	IF(@Tab='Markup')
	BEGIN
		SELECT
		M.ID
		, m.UserType
		, m.AgencyNames As [Agent Name]
		, MarketPoint
		, AirportType
		, AirlineType
		, (CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity]
		, (CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity]
		, m.AgentCategory as GroupName
		, m.AvailabilityPCC
		, M.UpdatedDate
		, U.Username
		, m.ValPerRU AS [Private Fare]
		, M.ValPerRP AS [Publish Fare]
		,TransactionType
		,(CASE WHEN CRSType!='' THEN ( SELECT TOP 1 ISNULL(CategoryValue,'') FROM tbl_commonmaster Where pkid=CRSType AND Category='CRS') ELSE 'All' END) AS 'CRSType'
		,M.AvailabilityPCC
		FROM Flight_MarkupType M
		LEFT JOIN mUser u ON U.ID=M.USERID
		WHERE MarketPoint in (select C.CountryCode  from mUserCountryMapping UM
		INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)
		and M.UserType in (select mc.Value from mUserTypeMapping UT
		inner join mCommon mc on mc.ID=UT.UserTypeId where ut.UserId=@UserId and UT.IsActive=1)
		AND ((@UserType = '') or (M.UserType = @UserType))
		AND ((@MarketPoint = '') or (M.MarketPoint = @MarketPoint))
		AND ((@AirportType = '') or (M.AirportType = @AirportType))
		AND (@TransactionType='All' OR M.TransactionType=@TransactionType)
		AND (@CRSType='All' OR M.CRSType=@CRSType)
		AND (@AvailabilityPCC='' OR M.AvailabilityPCC=@AvailabilityPCC)
		AND ((@AirlineName = '') or (M.AirlineType IN (select AirlineType from Flight_MarkupType a
				where EXISTS(select * from sample_split(@AirlineName,',') b
				WHERE Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0))))
				ORDER BY ID DESC
	END  
	ELSE IF(@Tab='ServiceFee')
	BEGIN
		SELECT
		q.UserType
		, q.AgencyNames as [Agent Name]
		, q.MarketPoint
		, q.AirportType
		, q.AirlineType
		, (CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity]
		, (CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity]
		, q.ServiceFee
		, q.GST
		, Value as QuatationValue
		, q.AgentCategory as GroupName
		, q.AvailabilityPCC
		, q.UpdatedDate
		, U.Username
		from tbl_ServiceFee_GST_QuatationDetails q
		LEFT OUTER JOIN mCommon m on q.Quatation=m.ID
		LEFT JOIN mUser u ON U.ID=Q.USERID
		where q.MarketPoint in (select C.CountryCode  from mUserCountryMapping UM
				INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid AND IsActive=1) 
		AND q.UserType in (select mc.Value from mUserTypeMapping UT
				INNER JOIN mCommon mc on mc.ID=UT.UserTypeId  where ut.UserId=@UserId and UT.IsActive=1)
		AND ((@UserType = '') or (q.UserType = @UserType))
		AND ((@MarketPoint = '') or (q.MarketPoint = @MarketPoint))
		AND ((@AirportType = '') or (q.AirportType = @AirportType))
		AND ((@AirlineName = '') or (q.AirlineType IN (select AirlineType from tbl_ServiceFee_GST_QuatationDetails a where EXISTS(select * from sample_split(@AirlineName,',') b     WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0))))
		ORDER BY  q.ID DESC    
	END
	ELSE IF(@Tab='Flat')    
	BEGIN
		SELECT
		f.ID,
		f.UserType,
		MarketPoint,
		AirportType,
		AirlineType,
		Name,
		(CONVERT(varchar, TravelFrom, 105) + ' - ' + CONVERT(varchar, TravelTo, 105)) as [TravelValidity]
		,
		(CONVERT(varchar, SaleFrom, 105) + ' - ' + CONVERT(varchar, SaleTo, 105)) as [SaleValidity],f.GroupType,f.UpdatedDate, U.Username,Remark  
		from Flight_Flat f
		left join mUser u ON U.ID=f.USERID
		where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM
				INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid AND IsActive=1)
		ORDER BY f.ID DESC    
	end    
    
	else if(@Tab='Promo')    
	begin    
		select     
		m.ID
		, MarketPoint
		, AirportType
		, AirlineType
		, BookingType
		, PromoCode
		, TravelValidityFrom
		, TravelValidityTo
		, SaleValidityFrom    
		, SaleValidityTo
		--CASE WHEN BookingType=1 THEN 'Per Pax'  WHEN BookingType=2 THEN 'Per Sector' WHEN BookingType=3    
		-- THEN 'Per Booking' END  AS BT,    
		, (CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity]
		, (CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity]
		, AgentCategory as GroupName
		, M.UpdatedDate
		, U.Username
		, M.UserType
		, m.Remark
		from Flight_PromoCode m
		left join mUser u ON U.ID=M.USERID
		where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM
		INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)
		ORDER BY m.ID desc
	end
	else if(@Tab='Commission')
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
(CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity],    
(CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity],    
M.UpdatedDate, U.Username,M.UserType,m.Remark,m.PricingCode,m.TourCode,m.Endorsementline,FareType,c.CategoryValue as 'CRSType',m.CardMapping1,    
m.IATADiscountType,m.PLBDiscountType,m.MarkupType,m.DropnetCommission,m.LoginId --,PayMode,VirtualCardName as VCN    
    
from Flight_Commission m    
left join mUser u ON U.ID=M.USERID    
left join tbl_commonmaster c on c.pkid=m.CRSType    
    
where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM    
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)    
and m.UserType in (select mc.Value from mUserTypeMapping UT    
 inner join mCommon mc on mc.ID=UT.UserTypeId    
  where ut.UserId=@UserId and UT.IsActive=1)    
 AND ((@UserType = '') or (m.UserType = @UserType))    
 AND ((@MarketPoint = '') or (m.MarketPoint = @MarketPoint))    
 AND ((@AirportType = '') or (m.AirportType = @AirportType))    
 AND ((@AirlineName = '')     
  or     
  (m.AirlineType IN      
  ( select AirlineType from Flight_Commission a where EXISTS(select * from sample_split(@AirlineName,',') b     
   WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)    
  )))    
ORDER BY m.ID desc    
    
end    
    
else if(@Tab='ROE')    
begin     
if(@ID > 0)    
 begin     
  select r.*,u.UserName,(case when r.ModifiedOn is null then r.CreatedOn else r.ModifiedOn end) as 'UpdatedDate'    
  from mAgentROE R    
  left join mUser u ON U.ID=r.CreatedBy where r.ID=@ID and r.IsDeleted=0 and r.IsActive=1    
 end    
 else    
 begin    
  select r.AgencyID,r.AgencyNames,r.Currency,r.ROE,r.ID,r.Country,r.UserType,u.UserName,r.IsActive,    
  (case when r.ModifiedOn is null then r.CreatedOn else r.ModifiedOn end) as 'UpdatedDate'    
  from mAgentROE R    
  left join mUser u ON U.ID=r.CreatedBy    
  where r.Country in (select C.CountryCode  from mUserCountryMapping UM    
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@UserId  AND IsActive=1)    
   and r.IsDeleted=0     
   and r.UserType in (select mc.Value from mUserTypeMapping UT    
 inner join mCommon mc on mc.ID=UT.UserTypeId    
  where ut.UserId=@UserId and UT.IsActive=1)    
 end    
    
end    
    else if(@Tab='Deal')  
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
(CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity],  
(CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity],  
M.UpdatedDate, U.Username,M.UserType,m.Remark,m.PricingCode,m.TourCode,m.Endorsementline,FareType,c.CategoryValue as 'CRSType',m.CardMapping1,  
m.IATADiscountType,m.PLBDiscountType,m.MarkupType,m.DropnetCommission,m.LoginId,PayMode,VirtualCardName as VCN  
  
from FlightCommission m  
left join mUser u ON U.ID=M.USERID  
left join tbl_commonmaster c on c.pkid=m.CRSType  
  
where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM  
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)  
and m.UserType in (select mc.Value from mUserTypeMapping UT  
 inner join mCommon mc on mc.ID=UT.UserTypeId  
  where ut.UserId=@UserId and UT.IsActive=1)  
 AND ((@UserType = '') or (m.UserType = @UserType))  
 AND ((@MarketPoint = '') or (m.MarketPoint = @MarketPoint))  
 AND ((@AirportType = '') or (m.AirportType = @AirportType))  
 AND ((@AirlineName = '')   
  or   
  (m.AirlineType IN    
  ( select AirlineType from Flight_Commission a where EXISTS(select * from sample_split(@AirlineName,',') b   
   WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)  
  )))  
ORDER BY m.ID desc 
    end
end 

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_ForAllTab] TO [rt_read]
    AS [dbo];

