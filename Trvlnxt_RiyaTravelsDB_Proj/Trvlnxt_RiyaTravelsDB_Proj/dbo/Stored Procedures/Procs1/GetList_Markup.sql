CREATE PROCEDURE[dbo].[GetList_Markup]   
@UserId INT, @UserType varchar(10)=null, @MarketPoint varchar(10)=null, @AirportType varchar(10)=null, @AirlineName varchar(max)=null  
,@AgentID VARCHAR(50)='',@TransactionType VARCHAR(100)='All',@CRSType VARCHAR(50)='All'
,@AvailabilityPCC VARCHAR(200)=''
as  
begin  
  
 select  
 M.ID,MarketPoint,AirportType,AirlineType,PaxType,Remark,OnBasic,OnTax,TravelValidityFrom,TravelValidityTo,  
 SaleValidityFrom,SaleValidityTo,InsertedDate,GroupType,Name,Flag,FareTypeRU,CalculationTypeRU,ValPerRU,  
 FareTypeRP,CalculationTypeRP,ValPerRP,RUmaxAmt,RPmaxAmt,  
 (CONVERT(varchar, TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, TravelValidityTo, 105)) as [TravelValidity],  
(CONVERT(varchar, SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, SaleValidityTo, 105)) as [SaleValidity],  
M.UpdatedDate, U.Username,M.UserType,AgentCategory ,M.ValPerRU,M.ValPerRP,
m.AgencyNames AS [AgentName],m.AvailabilityPCC,TransactionType,
 (CASE WHEN CRSType!='' THEN ( SELECT TOP 1 ISNULL(CategoryValue,'') FROM tbl_commonmaster Where pkid=CRSType AND Category='CRS') ELSE 'All' END) AS 'CRSType'
 from Flight_MarkupType M  
left join mUser u ON U.ID=M.USERID  
 where MarketPoint in (select C.CountryCode  from mUserCountryMapping UM  
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1) and m.UserType in (select mc.Value from mUserTypeMapping UT  
 inner join mCommon mc on mc.ID=UT.UserTypeId  
 where ut.UserId=@UserId and UT.IsActive=1)  
 AND ((@UserType = '') or (M.UserType = @UserType))  
 AND ((@MarketPoint = '') or (M.MarketPoint = @MarketPoint))  
 AND ((@AirportType = '') or (M.AirportType = @AirportType)) 
 AND (@AgentID='' OR M.AgencyId LIKE '%'+@AgentID+'%')
 AND (@TransactionType='All' OR M.TransactionType=@TransactionType)
 AND (@CRSType='All' OR M.CRSType=@CRSType)
 AND (@AvailabilityPCC='' OR M.AvailabilityPCC=@AvailabilityPCC)
 AND ((@AirlineName = '')    or    (M.AirlineType IN     ( select AirlineType from Flight_MarkupType a where EXISTS(select * from sample_split(@AirlineName,',') b     WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)   )))  
 ORDER BY ID DESC  
  
end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_Markup] TO [rt_read]
    AS [dbo];

