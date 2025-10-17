CREATE proc [dbo].[GetRecords_FlightFlatNew]  
@Travelfrom datetime,  
@Travelto datetime,  
@Marketpoint varchar(5),  
@AirportType varchar(5),  
@ID int =  null,  
@PromoCode varchar(50)= null,  
@UserType  varchar(10)=null  
  
AS  
BEGIN  
  
--declare  
--@Travelfrom datetime = '5/31/2018 12:00:00 AM',  
--@Travelto datetime='5/31/2018 12:00:00 AM',  
--@Marketpoint varchar(5)= 'CA',  
--@AirportType varchar(5)='I',  
--@ID int= null,  
--@PromoCode varchar(50)= null  
  
---- Flat  
  
SELECT B.ID,MarketPoint,AirportType,AirlineType,PaxType,A.Min,A.Max,A.Discount,Origin,  
OriginValue,Destination,DestinationValue,Flightseries,FlightseriesValue,cabin,  
GroupType, isnull(C.AgentID,0) as AgentID,AL.UserCode ,B.AirlineExclude FROM Flight_Flat B  
INNER JOIN FlightFlat_Drec A ON A.FKID = B.ID  
left join  Agent_Flat C on B.ID = C.FlatD  
LEFT JOIN AgentLogin AL ON Al.userid=c.AgentID  
WHERE  
 (((@TravelFrom between TravelFrom and TravelTo ) OR TravelFrom is null) AND ((@TravelTo between TravelFrom and TravelTo) OR TravelTo is null))  
 AND ((SaleFrom <=  CONVERT(DATE,GETDATE()) OR SaleFrom IS NULL) AND (SaleTo  >= CONVERT(DATE,GETDATE()) OR SaleTo IS NULL))   
 AND B.MarketPoint = @Marketpoint   
 AND B.AirportType = @AirportType   
 and B.Flag=1  
 ORDER BY B.Inserteddate desc  
 ------------------------------------  
   
 ---- Deal  
  
  
SELECT  
A.ID,  
MarketPoint,  
AirportType,  
AirlineType,  
PaxType,  
Remark,  
DealType,  
DealValue,  
SOTO,  
TravelValidityFrom,  
TravelValidityTo,  
SaleValidityFrom,  
SaleValidityTo,  
RBD,  
RBDValue,  
FareBasis,  
FareBasisValue,  
FlightSeries,  
FlightSeriesValue,  
Origin,  
OriginValue,  
Destination,  
DestinationValue,  
InsertedDate,  
GroupType,  
Name,  
--A.Flag,  
A.Flag,  
--A.AgentID,  
--A.DealID,  
--A.InsertedBy,  
IATA_DealType,  
IATA_DealValue  
  
FROM Flight_Deal A  
LEFT JOIN Agent_Deal B on A.ID = B.AgentID  
  
  
  
WHERE  
  
  
(((@TravelFrom between  TravelValidityFrom and TravelValidityTo ) OR TravelValidityFrom is null) AND ((@TravelTo between TravelValidityFrom and TravelValidityTo) OR TravelValidityTo is null))  
 AND (((CONVERT(DATE,GETDATE()) between  SaleValidityFrom and SaleValidityTo ) OR SaleValidityFrom is null) AND ((CONVERT(DATE,GETDATE()) between SaleValidityFrom and SaleValidityTo) OR SaleValidityTo is null))  
 AND A.MarketPoint = @Marketpoint   
 AND A.AirportType = @AirportType  
  AND A.Flag = 1  
  
-------------------------------------  
  
  
---- MARKUP  
SELECT B.ID as markupID, MarketPoint, AirportType, AirlineType, PaxType, Remark, OnBasic,  
OnTax, TravelValidityFrom, TravelValidityTo, SaleValidityFrom, SaleValidityTo, B.InsertedDate,  
GroupType, Name, B.Flag,isnull(C.AgentID,0) as AgentID,A.UserCode,  
FareTypeRU,CalculationTypeRU,ValPerRU,FareTypeRP,CalculationTypeRP,ValPerRP,RUmaxAmt,RPmaxAmt,  
DisplayTypeRP,DisplayTypeRU,BookingTypeRP,BookingTypeRU  
,B.AgencyId as B2bAgentId,  
                           RBD, RBDValue, FareBasis, FareBasisValue, FlightSeries, FlightSeriesValue, Origin ,OriginValue, Destination ,DestinationValue,  
          FlightNo ,FlightNoValue, Cabin,ISNULL(faretypem,0) AS faretypem,ISNULL(calculationtypem,0) AS calculationtypem ,  
       ISNULL(valperm,0) AS valperm ,ISNULL(Mmaxamt,0) AS Mmaxamt,  
       ISNULL(displaytypem,0) AS displaytypem,ISNULL(bookingtypem,0) AS bookingtypem,
	   --New added in 25-10-2021  
TransactionType, AvailabilityPCC ,ISNULL(D.CategoryValue,'All') AS CategoryValue
  
FROM  
Flight_MarkupType B  
left join  Agent_Markup C on B.ID = C.MarkupID  
LEFT JOIN AgentLogin A ON A.UserID=c.AgentID  
LEFT JOIN tbl_commonmaster D ON (D.pkid= B.CRSType AND D.Category='CRS')
WHERE  
  @TravelFrom >=TravelValidityFrom and @TravelFrom <=TravelValidityTo and  
@Travelto >=TravelValidityFrom and @Travelto <=TravelValidityTo  AND  
SaleValidityFrom <=  CONVERT(DATE,GETDATE()) and SaleValidityTo  >= CONVERT(DATE,GETDATE())  AND  
  B.MarketPoint = @Marketpoint   
  AND B.Flag = 1 and B.UserType=@UserType  
   ORDER BY InsertedDate desc  
  
  SELECT '' as emailId,'' as UserName
 --SELECT emailId,U.UserName   
 --FROM  tblBookMaster B  
 --LEFT JOIN UserLogin U ON U.UserID=B.LoginEmailID  
 --WHERE (promoCode = @PromoCode or @PromoCode is null)  
 --AND IsBooked=1  
   
 SELECT taxPercent FROM Taxdetails   
 WHERE Status = 'A'  
  
  
  
   
     
  
  
END  
  
  
  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecords_FlightFlatNew] TO [rt_read]
    AS [dbo];

