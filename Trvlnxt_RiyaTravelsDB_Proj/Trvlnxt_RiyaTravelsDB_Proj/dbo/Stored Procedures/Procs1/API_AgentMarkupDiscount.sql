CREATE proc [dbo].[API_AgentMarkupDiscount]      
@Travelfrom datetime,      
@Travelto datetime,      
@Marketpoint varchar(5),      
@AirportType varchar(5),      
@ID int =  null,      
@PromoCode varchar(50)= null,      
@UserType  varchar(10)=null      
      
AS      
BEGIN      
      
 --AgentMarkupDiscount      
 SELECT B.ID as markupID, MarketPoint, AirportType, AirlineType, PaxType, Remark, OnBasic,      
 OnTax, TravelValidityFrom, TravelValidityTo, SaleValidityFrom, SaleValidityTo, B.InsertedDate,      
 GroupType, Name, B.Flag,isnull(C.AgentID,0) as AgentID,A.UserCode,      
 FareTypeRU,CalculationTypeRU,ValPerRU,FareTypeRP,CalculationTypeRP,ValPerRP,RUmaxAmt,RPmaxAmt,      
 DisplayTypeRP,DisplayTypeRU,BookingTypeRP,BookingTypeRU      
 ,B.AgencyId as B2bAgentId,RBD, RBDValue, FareBasis, FareBasisValue, FlightSeries    
 ,FlightSeriesValue, Origin ,OriginValue, Destination ,DestinationValue     
 ,FlightNo ,FlightNoValue, Cabin,faretypem,calculationtypem,valperm,Mmaxamt,displaytypem,bookingtypem    
 ,TransactionType, AvailabilityPCC,(Select top 1 CategoryValue from tbl_commonmaster Where Category='CRS' and pkid = CRSType) as VendorName      
      
 FROM      
 Flight_MarkupType B      
 left join  Agent_Markup C on B.ID = C.MarkupID      
 LEFT JOIN AgentLogin A ON A.UserID=c.AgentID      
 WHERE      
 @TravelFrom >=TravelValidityFrom and @TravelFrom <=TravelValidityTo and      
 @Travelto >=TravelValidityFrom and @Travelto <=TravelValidityTo  AND      
 SaleValidityFrom <=  CONVERT(DATE,GETDATE()) and SaleValidityTo  >= CONVERT(DATE,GETDATE())  AND      
 B.MarketPoint = @Marketpoint       
 AND B.Flag = 1 and B.UserType=@UserType      
 ORDER BY InsertedDate desc    
      
END
