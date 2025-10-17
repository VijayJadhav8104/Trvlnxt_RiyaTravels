CREATE proc [dbo].[GetList_ServiceFee_GST_Quatation]
@UserId INT,
@UserType varchar(10)=null,
@MarketPoint varchar(10)=null,
@AirportType varchar(10)=null,
@AirlineName varchar(max)=null,
@AgentID VARCHAR(50)=''
as
begin


select q.*,Value as QuatationValue,
(CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity],
(CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity],
q.UpdatedDate, U.Username,
q.AgencyNames As [AgentName]
 from tbl_ServiceFee_GST_QuatationDetails q

left outer join mCommon m on q.Quatation=m.ID
left join mUser u ON U.ID=Q.USERID

where q.MarketPoint in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)
	and q.UserType in (select mc.Value from mUserTypeMapping UT
 inner join mCommon mc on mc.ID=UT.UserTypeId
  where ut.UserId=@UserId and UT.IsActive=1)
 AND ((@UserType = '') or (q.UserType = @UserType))
 AND ((@MarketPoint = '') or (q.MarketPoint = @MarketPoint))
 AND ((@AirportType = '') or (q.AirportType = @AirportType))
 AND (@AgentID='' OR q.AgencyId LIKE '%'+@AgentID+'%')
 AND ((@AirlineName = '') 
		or 
		(
q.AirlineType IN  
		( select AirlineType from tbl_ServiceFee_GST_QuatationDetails a where EXISTS(select * from sample_split(@AirlineName,',') b 
			WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)
		)))
ORDER BY  q.ID DESC

end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_ServiceFee_GST_Quatation] TO [rt_read]
    AS [dbo];

