


create  proc getB2bMarkup_Mangesh --'8/25/2021 12:50:00 AM','8/25/2021 12:50:00 AM','AE','40027','B2B'
@Travelfrom datetime,
@Travelto datetime,
@Marketpoint varchar(5),
--@AirportType varchar(5),
@AgentID int =  null,
@UserType  varchar(10)=null

AS
begin

SELECT B.ID as markupID, MarketPoint, AirportType, AirlineType, PaxType, Remark, OnBasic,
OnTax, TravelValidityFrom, TravelValidityTo, SaleValidityFrom, SaleValidityTo, B.InsertedDate,
GroupType, Name, B.Flag,isnull(C.AgentID,0) as AgentID,A.UserCode,
FareTypeRU,CalculationTypeRU,ValPerRU,FareTypeRP,CalculationTypeRP,ValPerRP,RUmaxAmt,RPmaxAmt,
DisplayTypeRP,DisplayTypeRU,BookingTypeRP,BookingTypeRU
,B.AgencyId as B2bAgentId,
                           RBD,	RBDValue,	FareBasis,	FareBasisValue,	FlightSeries,	FlightSeriesValue,	Origin	,OriginValue,	Destination	,DestinationValue,
						   	FlightNo	,FlightNoValue,	Cabin,ISNULL(faretypem,0) AS faretypem,ISNULL(calculationtypem,0) AS calculationtypem ,
							ISNULL(valperm,0) AS valperm ,ISNULL(Mmaxamt,0) AS Mmaxamt,
							ISNULL(displaytypem,0) AS displaytypem,ISNULL(bookingtypem,0) AS bookingtypem

FROM
Flight_MarkupType B
left join  Agent_Markup C on B.ID = C.MarkupID
LEFT JOIN AgentLogin A ON A.UserID=c.AgentID
WHERE
  --@TravelFrom >=TravelValidityFrom and @TravelFrom <=TravelValidityTo and
--@Travelto >=TravelValidityFrom and @Travelto <=TravelValidityTo  AND
SaleValidityFrom <=  CONVERT(DATE,GETDATE()) and SaleValidityTo  >= CONVERT(DATE,GETDATE())  AND
  B.MarketPoint = @Marketpoint 
  and ( @AgentID in (select * from SplitString(B.AgencyId,',')) or Name='ALL')
  AND B.Flag = 1   and B.UserType=@UserType
   ORDER BY InsertedDate desc

   end
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[getB2bMarkup_Mangesh] TO [rt_read]
    AS [dbo];

