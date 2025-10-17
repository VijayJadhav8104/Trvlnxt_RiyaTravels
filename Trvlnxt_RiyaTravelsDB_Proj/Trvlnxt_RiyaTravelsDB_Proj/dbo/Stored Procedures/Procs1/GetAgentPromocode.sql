






CREATE proc [dbo].[GetAgentPromocode]

@Travelfrom datetime,
@Travelto datetime,
@Marketpoint varchar(5),
@AirportType varchar(5),
@ID int =  null,
@PromoCode varchar(50)= null



as
begin



--declare
--@Travelfrom datetime = '4/21/2018 12:00:00 AM',
--@Travelto datetime='4/30/2018 12:00:00 AM',
--@Marketpoint varchar(5)= 'IN',
--@AirportType varchar(5)='D',
--@ID int= 30008,
--@PromoCode varchar(50)= 'PQR123'

if Exists
(
SELECT
A.ID,
MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
[User],
RestrictedUser,
IncludeFlat,
MinFareAmt,
Discount,
PromoCode,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
InsertedDate,
A.Flag

FROM
Flight_PromoCode A
LEFT JOIN Agent_Promocode B ON A.ID = B.PromoID 

WHERE 
(((@TravelFrom between TravelValidityFrom and TravelValidityTo ) OR TravelValidityFrom is null) AND ((@TravelTo between TravelValidityFrom and TravelValidityTo) OR TravelValidityTo is null))
 --AND ((SaleValidityFrom <=  CONVERT(DATE,GETDATE()) OR SaleValidityFrom IS NULL) AND (SaleValidityTo  >= CONVERT(DATE,GETDATE()) OR SaleValidityTo IS NULL)) 
 AND (((CONVERT(DATE,GETDATE()) between SaleValidityFrom and SaleValidityTo ) OR SaleValidityFrom is null) AND ((CONVERT(DATE,GETDATE()) between SaleValidityFrom and SaleValidityTo) OR SaleValidityTo is null))
 AND MarketPoint = @Marketpoint 
 AND AirportType = @AirportType
 AND (B.AgentID = @ID or @ID is null)
 AND promoCode = @PromoCode
 )
 begin
 SELECT
A.ID,
MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
[User],
RestrictedUser,
IncludeFlat,
MinFareAmt,
Discount,
PromoCode,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
InsertedDate,
A.Flag

FROM
Flight_PromoCode A
LEFT JOIN Agent_Promocode B ON A.ID = B.PromoID 

WHERE 
(((@TravelFrom between TravelValidityFrom and TravelValidityTo ) OR TravelValidityFrom is null) AND ((@TravelTo between TravelValidityFrom and TravelValidityTo) OR TravelValidityTo is null))
 --AND ((SaleValidityFrom <=  CONVERT(DATE,GETDATE()) OR SaleValidityFrom IS NULL) AND (SaleValidityTo  >= CONVERT(DATE,GETDATE()) OR SaleValidityTo IS NULL)) 
 AND (((CONVERT(DATE,GETDATE()) between SaleValidityFrom and SaleValidityTo ) OR SaleValidityFrom is null) AND ((CONVERT(DATE,GETDATE()) between SaleValidityFrom and SaleValidityTo) OR SaleValidityTo is null))
 AND MarketPoint = @Marketpoint 
 AND AirportType = @AirportType
 AND (B.AgentID = @ID or @ID is null)
 AND promoCode = @PromoCode
 end
 ELSE
 begin
SELECT
ID,
MarketPoint,
AirportType,
AirlineType,
PaxType,
Remark,
[User],
RestrictedUser,
IncludeFlat,
MinFareAmt,
Discount,
PromoCode,
TravelValidityFrom,
TravelValidityTo,
SaleValidityFrom,
SaleValidityTo,
InsertedDate,
Flag

FROM
Flight_PromoCode 
--LEFT JOIN Agent_Promocode B ON A.ID = B.PromoID 

WHERE 
(((@TravelFrom between TravelValidityFrom and TravelValidityTo ) OR TravelValidityFrom is null) AND ((@TravelTo between TravelValidityFrom and TravelValidityTo) OR TravelValidityTo is null))
 --AND ((SaleValidityFrom <=  CONVERT(DATE,GETDATE()) OR SaleValidityFrom IS NULL) AND (SaleValidityTo  >= CONVERT(DATE,GETDATE()) OR SaleValidityTo IS NULL)) 
 AND (((CONVERT(DATE,GETDATE()) between SaleValidityFrom and SaleValidityTo ) OR SaleValidityFrom is null) AND ((CONVERT(DATE,GETDATE()) between SaleValidityFrom and SaleValidityTo) OR SaleValidityTo is null))
 AND MarketPoint = @Marketpoint 
 AND AirportType = @AirportType
 --AND (B.AgentID = @ID or @ID is null)
 AND promoCode = @PromoCode

 END

 
 SELECT emailId,U.UserName 
 FROM  tblBookMaster B
 LEFT JOIN UserLogin U ON U.UserID=B.LoginEmailID
 WHERE (promoCode = @PromoCode or @PromoCode is null)
 AND IsBooked=1


 
	
 --SELECT taxPercent FROM Taxdetails 
 --WHERE Status = 'A'  

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAgentPromocode] TO [rt_read]
    AS [dbo];

