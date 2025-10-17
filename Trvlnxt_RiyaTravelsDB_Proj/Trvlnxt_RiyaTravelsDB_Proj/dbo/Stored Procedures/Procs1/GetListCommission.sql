  
--GetListCommission 1131,'','','','','','CRS Mapping','','','45328'  
CREATE PROCEDURE[dbo].[GetListCommission]   
@UserId INT,  
@UserType varchar(10)=null,  
@MarketPoint varchar(10)=null,  
@AirportType varchar(10)=null,  
@AirlineName varchar(max)=null  
,@status varchar(100),  
@configuration varchar(100)  
,@CRStype varchar(10)=null     
,@AvailabilityPCC varchar(50)=null    
,@AgentID VARCHAR(50)=''  
  
as  
begin  
  
if(@status='Active' OR @status='')  
begin  
  
select   
M.FLAG,  
m.ID,  
m.MarketPoint,  
m.AirportType,  
m.AirlineType,  
m.TravelValidityFrom,  
m.TravelValidityTo,  
m.SaleValidityFrom,  
m.SaleValidityTo,  
m.InsertedDate,  
m.Flag,  
ISNULL(RBDValue,'') AS RBDValue,  
  ISNULL(FareBasisValue,'') AS FareBasisValue,  
(CASE WHEN m.cabin='Y' THEN 'Economy'  
     WHEN m.Cabin='W Economy' THEN 'Premium Economy'  
     WHEN m.Cabin='F' THEN 'First Class'  
     WHEN m.Cabin='C' THEN 'Business' ELSE 'All' END) AS Cabin,  
m.Origin,  
  
m.OriginValue,  
m.Destination,  
m.DestinationValue,  
m.FlightSeries,  
m.Commission ,  
m.IATADealPercent,  
m.AgencyNames,  
m.AgencyId,  
m.AgentCategory,  
m.PLBDealPercent,  
m.MarkupAmount,  
m.PaxType,  
m.AvailabilityPCC,m.PNRCreationPCC,m.TicketingPCC,  
(CONVERT(varchar, m.TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, m.TravelValidityTo, 105)) as [TravelValidity],  
(CONVERT(varchar, m.SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, m.SaleValidityTo, 105)) as [SaleValidity],  
M.UserType,m.Remark,m.PricingCode,m.TourCode,m.Endorsementline,m.FareType,  
c.CategoryValue as 'CRSType'  
,m.CardMapping1,  
m.IATADiscountType,m.PLBDiscountType,m.MarkupType,m.DropnetCommission,m.LoginId,m.PayMode,m.VirtualCardName as VCN,  
BankName + '[' + MaskCardNumber + ']  [' + CardType + ']' as Text  
,M.InsertedDate,u.UserName as InsertedBy,M.UpdatedDate, --u1.Username   
u1.UserName as UpdatedBy  
,m.NetRemitCode,m.GST,m.TDS,m.GDSCommission,m.GDSDealType,m.GDSDiscountType     
from FlightCommission m  
 left join mCardDetails Cm on  Cm.pkid=m.CardMapping1  
left join mUser u ON U.ID=M.USERID  
left join tbl_commonmaster c on c.pkid=m.CRSType  
--LEFT join FlightCommissionHistory History on m.Id=History.ParentId  
left join mUser u1 ON U1.ID=m.UpdatedBy  
  
where m.MarketPoint in (select C.CountryCode  from mUserCountryMapping UM  
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)  
and m.UserType in (select mc.Value from mUserTypeMapping UT  
 inner join mCommon mc on mc.ID=UT.UserTypeId  
    
  where ut.UserId=@UserId and UT.IsActive=1 )   
  AND ((@status='') OR (m.Flag = 1))  
 AND ((@UserType = '') or (m.UserType = @UserType))  
 AND ((@MarketPoint = '') or (m.MarketPoint = @MarketPoint))  
 AND ((@AirportType = '') or (m.AirportType = @AirportType))  
  AND ((@CRStype = '') or (m.CRSType = @CRStype))      
 AND ((@AvailabilityPCC = '') or (m.AvailabilityPCC = @AvailabilityPCC))     
   AND ((@configuration = '') or (m.ConfigurationType = @configuration))  
   AND ((@AgentID = '') or (m.AgencyId LIKE ','+@AgentID+'%' OR m.AgencyId LIKE ''+@AgentID+'%' OR m.AgencyId LIKE '%,'+@AgentID+',%' OR m.AgencyId LIKE ','+@AgentID+',' OR m.AgencyId LIKE '%'+@AgentID+','))    
 AND ((@AirlineName = '')   
  or   
  (m.AirlineType IN    
  ( select AirlineType from FlightCommission a where EXISTS(select * from sample_split(@AirlineName,',') b   
   WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)  
  )))  
ORDER BY m.ID desc  
end  
else IF(@status='DeActive')  
begin  
PRINT 1;  
select   
M.FLAG,  
M.ConfigurationType,  
m.ID,  
m.MarketPoint,  
m.AirportType,  
m.AirlineType,  
m.TravelValidityFrom,  
m.TravelValidityTo,  
m.SaleValidityFrom,  
m.SaleValidityTo,  
m.InsertedDate,  
m.Flag,  
ISNULL(RBDValue,'') AS RBDValue,  
  ISNULL(FareBasisValue,'') AS FareBasisValue,  
(CASE WHEN m.cabin='Y' THEN 'Economy'  
     WHEN m.Cabin='W Economy' THEN 'Premium Economy'  
     WHEN m.Cabin='F' THEN 'First Class'  
     WHEN m.Cabin='C' THEN 'Business' ELSE 'All' END) AS Cabin,  
m.Origin,  
  
m.OriginValue,  
m.Destination,  
m.DestinationValue,  
m.FlightSeries,  
m.Commission ,  
m.IATADealPercent,  
m.AgencyNames,  
m.AgencyId,  
m.AgentCategory,  
m.PLBDealPercent,  
m.MarkupAmount,  
m.PaxType,  
m.AvailabilityPCC,m.PNRCreationPCC,m.TicketingPCC,  
(CONVERT(varchar, m.TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, m.TravelValidityTo, 105)) as [TravelValidity],  
(CONVERT(varchar, m.SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, m.SaleValidityTo, 105)) as [SaleValidity],  
M.UpdatedDate, U.Username,M.UserType,m.Remark,m.PricingCode,m.TourCode,m.Endorsementline,m.FareType,  
c.CategoryValue as 'CRSType'  
,m.CardMapping1,  
m.IATADiscountType,m.PLBDiscountType,m.MarkupType,m.DropnetCommission,m.LoginId,m.PayMode,m.VirtualCardName as VCN,  
BankName + '[' + MaskCardNumber + ']  [' + CardType + ']' as Text  
,M.InsertedDate,u.UserName as InsertedBy,-- u1.Username   
u1.UserName as UpdatedBy  
,m.NetRemitCode,m.GST,m.TDS  
from  FlightCommission m  
 left join mCardDetails Cm on  Cm.pkid=m.CardMapping1  
left join mUser u ON U.ID=M.USERID  
left join tbl_commonmaster c on c.pkid=m.CRSType  
--INNER join FlightCommissionHistory fc on fc.Id=m.ParentId  
left join mUser u1 ON U1.ID=m.UpdatedBy  
where m.MarketPoint in (select C.CountryCode  from mUserCountryMapping UM  
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)  
and m.UserType in (select mc.Value from mUserTypeMapping UT  
 inner join mCommon mc on mc.ID=UT.UserTypeId  
  where ut.UserId=@UserId and UT.IsActive=1)   
   AND  m.Flag = 0  
 AND ((@UserType = '') or (m.UserType = @UserType))  
 AND ((@MarketPoint = '') or (m.MarketPoint = @MarketPoint))  
 AND ((@AirportType = '') or (m.AirportType = @AirportType))  
  AND ((@CRStype = '') or (m.CRSType = @CRStype))      
 AND ((@AvailabilityPCC = '') or (m.AvailabilityPCC = @AvailabilityPCC))    
   AND ((@configuration = '') or (m.ConfigurationType = @configuration))  
   AND ((@AgentID = '') or (m.AgencyId LIKE ','+@AgentID+'%' OR m.AgencyId LIKE ''+@AgentID+'%' OR m.AgencyId LIKE '%,'+@AgentID+',%' OR m.AgencyId LIKE ','+@AgentID+',' OR m.AgencyId LIKE '%'+@AgentID+','))    
 AND ((@AirlineName = '')   
  or   
  (m.AirlineType IN    
  ( select AirlineType from FlightCommission a where EXISTS(select * from sample_split(@AirlineName,',') b   
   WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)  
  )))  
ORDER BY m.ID desc  
end  
ELSE IF (@status='Delete')  
begin  
select   
History.FLAG,  
History.Action,  
History.ConfigurationType,  
History.ID,  
History.MarketPoint,  
History.AirportType,  
History.AirlineType,  
History.TravelValidityFrom,  
History.TravelValidityTo,  
History.SaleValidityFrom,  
History.SaleValidityTo,  
History.InsertedDate,  
History.Flag,  
ISNULL(RBDValue,'') AS RBDValue,  
  ISNULL(FareBasisValue,'') AS FareBasisValue,  
(CASE WHEN History.cabin='Y' THEN 'Economy'  
     WHEN History.Cabin='W Economy' THEN 'Premium Economy'  
     WHEN History.Cabin='F' THEN 'First Class'  
     WHEN History.Cabin='C' THEN 'Business' ELSE 'All' END) AS Cabin,  
History.Origin,  
  
History.OriginValue,  
History.Destination,  
History.DestinationValue,  
History.FlightSeries,  
History.Commission,  
History.IATADealPercent,  
History.AgencyNames,  
History.AgencyId,  
History.AgentCategory,  
History.PLBDealPercent,  
History.MarkupAmount,  
History.PaxType,  
History.AvailabilityPCC,History.PNRCreationPCC,History.TicketingPCC,  
(CONVERT(varchar, History.TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, History.TravelValidityTo, 105)) as [TravelValidity],  
(CONVERT(varchar, History.SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, History.SaleValidityTo, 105)) as [SaleValidity],  
History.ModifiedOn, U.Username,History.UserType,History.Remark,History.PricingCode,History.TourCode,History.Endorsementline,History.FareType,  
c.CategoryValue as 'CRSType'  
,History.CardMapping1,  
History.IATADiscountType,History.PLBDiscountType,History.MarkupType,History.DropnetCommission,History.LoginId,History.PayMode,History.VirtualCardName as VCN,  
BankName + '[' + MaskCardNumber + ']  [' + CardType + ']' as Text  
,History.InsertedDate,u.UserName as InsertedBy,History.ModifiedOn as 'UpdatedDate', u1.Username as UpdatedBy  
,History.NetRemitCode,History.GST,History.TDS  
from FlightCommissionHistory  History  
--left join FlightCommission m on m.Id=History.ParentId  
 left join mCardDetails Cm on  Cm.pkid=History.CardMapping1  
left join mUser u ON U.ID=History.USERID  
left join tbl_commonmaster c on c.pkid=History.CRSType  
  
left join mUser u1 ON U1.ID=History.ModifiedBy  
where History.MarketPoint in (select C.CountryCode  from mUserCountryMapping UM  
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)  
and History.UserType in (select mc.Value from mUserTypeMapping UT  
 inner join mCommon mc on mc.ID=UT.UserTypeId  
   
  where ut.UserId=@UserId and UT.IsActive=1)   
  
 AND ((@UserType = '') or (History.UserType = @UserType))  
 AND ((@MarketPoint = '') or (History.MarketPoint = @MarketPoint))  
 AND ((@AirportType = '') or (History.AirportType = @AirportType))  
   AND ((@CRStype = '') or (History.CRSType = @CRStype))      
 AND ((@AvailabilityPCC = '') or (History.AvailabilityPCC = @AvailabilityPCC))   
  AND History.Action = 'Delete'  
   AND ((@configuration = '') or (History.ConfigurationType = @configuration))  
  
 AND ((@AirlineName = '')   
  or   
  (History.AirlineType IN    
  ( select AirlineType from FlightCommission a where EXISTS(select * from sample_split(@AirlineName,',') b   
   WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)  
  )))  
ORDER BY History.ID desc  
end  
ELSE IF (@status='Update')  
begin  
select   
History.FLAG,  
History.Action,  
History.ConfigurationType,  
History.ID,  
History.MarketPoint,  
History.AirportType,  
History.AirlineType,  
History.TravelValidityFrom,  
History.TravelValidityTo,  
History.SaleValidityFrom,  
History.SaleValidityTo,  
History.InsertedDate,  
History.Flag,  
ISNULL(RBDValue,'') AS RBDValue,  
  ISNULL(FareBasisValue,'') AS FareBasisValue,  
(CASE WHEN History.cabin='Y' THEN 'Economy'  
     WHEN History.Cabin='W Economy' THEN 'Premium Economy'  
     WHEN History.Cabin='F' THEN 'First Class'  
     WHEN History.Cabin='C' THEN 'Business' ELSE 'All' END) AS Cabin,  
History.Origin,  
  
History.OriginValue,  
History.Destination,  
History.DestinationValue,  
History.FlightSeries,  
History.Commission,  
History.IATADealPercent,  
History.AgencyNames,  
History.AgencyId,  
History.AgentCategory,  
History.PLBDealPercent,  
History.MarkupAmount,  
History.PaxType,  
History.AvailabilityPCC,History.PNRCreationPCC,History.TicketingPCC,  
(CONVERT(varchar, History.TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, History.TravelValidityTo, 105)) as [TravelValidity],  
(CONVERT(varchar, History.SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, History.SaleValidityTo, 105)) as [SaleValidity],  
History.ModifiedOn, U.Username,History.UserType,History.Remark,History.PricingCode,History.TourCode,History.Endorsementline,History.FareType,  
c.CategoryValue as 'CRSType'  
,History.CardMapping1,  
History.IATADiscountType,History.PLBDiscountType,History.MarkupType,History.DropnetCommission,History.LoginId,History.PayMode,History.VirtualCardName as VCN,  
BankName + '[' + MaskCardNumber + ']  [' + CardType + ']' as Text  
,History.InsertedDate,u.UserName as InsertedBy,History.ModifiedOn, u1.Username as UpdatedBy  
,History.NetRemitCode,History.GST,History.TDS  
from FlightCommissionHistory  History  
--left join FlightCommission m on m.Id=History.ParentId  
 left join mCardDetails Cm on  Cm.pkid=History.CardMapping1  
left join mUser u ON U.ID=History.USERID  
left join tbl_commonmaster c on c.pkid=History.CRSType  
  
left join mUser u1 ON U1.ID=History.ModifiedBy  
where History.MarketPoint in (select C.CountryCode  from mUserCountryMapping UM  
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)  
and History.UserType in (select mc.Value from mUserTypeMapping UT  
 inner join mCommon mc on mc.ID=UT.UserTypeId  
   
  where ut.UserId=@UserId and UT.IsActive=1)   
  
 AND ((@UserType = '') or (History.UserType = @UserType))  
 AND ((@MarketPoint = '') or (History.MarketPoint = @MarketPoint))  
 AND ((@AirportType = '') or (History.AirportType = @AirportType))  
   AND ((@CRStype = '') or (History.CRSType = @CRStype))      
 AND ((@AvailabilityPCC = '') or (History.AvailabilityPCC = @AvailabilityPCC))   
  AND History.Action = 'Update'  
   AND ((@configuration = '') or (History.ConfigurationType = @configuration))  
 AND ((@AirlineName = '')   
  or   
  (History.AirlineType IN    
  ( select AirlineType from FlightCommission a where EXISTS(select * from sample_split(@AirlineName,',') b   
   WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)  
  )))  
ORDER BY History.ID desc  
end  
else if(@status='')  
begin  
  
  
select   
M.FLAG,  
m.ID,  
m.MarketPoint,  
m.AirportType,  
m.AirlineType,  
m.TravelValidityFrom,  
m.TravelValidityTo,  
m.SaleValidityFrom,  
m.SaleValidityTo,  
m.InsertedDate,  
m.Flag,  
ISNULL(RBDValue,'') AS RBDValue,  
  ISNULL(FareBasisValue,'') AS FareBasisValue,  
(CASE WHEN m.cabin='Y' THEN 'Economy'  
     WHEN m.Cabin='W Economy' THEN 'Premium Economy'  
     WHEN m.Cabin='F' THEN 'First Class'  
     WHEN m.Cabin='C' THEN 'Business' ELSE 'All' END) AS Cabin,  
m.Origin,  
  
m.OriginValue,  
m.Destination,  
m.DestinationValue,  
m.FlightSeries,  
m.Commission,  
m.IATADealPercent,  
m.AgencyNames,  
m.AgencyId,  
m.AgentCategory,  
m.PLBDealPercent,  
m.MarkupAmount,  
m.PaxType,  
m.AvailabilityPCC,m.PNRCreationPCC,m.TicketingPCC,  
(CONVERT(varchar, m.TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, m.TravelValidityTo, 105)) as [TravelValidity],  
(CONVERT(varchar, m.SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, m.SaleValidityTo, 105)) as [SaleValidity],  
M.UserType,m.Remark,m.PricingCode,m.TourCode,m.Endorsementline,m.FareType,  
c.CategoryValue as 'CRSType'  
,m.CardMapping1,  
m.IATADiscountType,m.PLBDiscountType,m.MarkupType,m.DropnetCommission,m.LoginId,m.PayMode,m.VirtualCardName as VCN,  
BankName + '[' + MaskCardNumber + ']  [' + CardType + ']' as Text  
,M.InsertedDate,u.UserName as InsertedBy,M.UpdatedDate,--u1.Username   
u1.UserName as UpdatedBy  
,m.NetRemitCode,m.GST,m.TDS  
from FlightCommission m  
 left join mCardDetails Cm on  Cm.pkid=m.CardMapping1  
left join mUser u ON U.ID=M.USERID  
left join tbl_commonmaster c on c.pkid=m.CRSType  
--inner join FlightCommissionHistory History on m.Id=History.ParentId  
left join mUser u1 ON U1.ID=m.UpdatedBy  
  
where m.MarketPoint in (select C.CountryCode  from mUserCountryMapping UM  
   INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)  
and m.UserType in (select mc.Value from mUserTypeMapping UT  
 inner join mCommon mc on mc.ID=UT.UserTypeId  
    
  where ut.UserId=@UserId and UT.IsActive=1)   
   
 AND ((@UserType = '') or (m.UserType = @UserType))  
 AND ((@MarketPoint = '') or (m.MarketPoint = @MarketPoint))  
 AND ((@AirportType = '') or (m.AirportType = @AirportType))  
   AND ((@CRStype = '') or (m.CRSType = @CRStype))      
 AND ((@AvailabilityPCC = '') or (m.AvailabilityPCC = @AvailabilityPCC))   
   AND ((@configuration = '') or (m.ConfigurationType = @configuration))  
   AND ((@AgentID = '') or (m.AgencyId LIKE ','+@AgentID+'%' OR m.AgencyId LIKE ''+@AgentID+'%' OR m.AgencyId LIKE '%,'+@AgentID+',%' OR m.AgencyId LIKE ','+@AgentID+',' OR m.AgencyId LIKE '%'+@AgentID+','))    
 AND ((@AirlineName = '')   
  or   
  (m.AirlineType IN    
  ( select AirlineType from FlightCommission a where EXISTS(select * from sample_split(@AirlineName,',') b   
   WHERE  Charindex(',' + b.Data + ',', ',' + a.AirlineType + ',') > 0)  
  )))  
ORDER BY m.ID desc  
  
end  
end  


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetListCommission] TO [rt_read]
    AS [dbo];

