--EXEC CheckPromoCode '11/15/2021','11/15/2021','US'
CREATE proc [dbo].[CheckPromoCode] --[dbo].[CheckPromoCode] '6/17/2019','6/17/2019','IN',null
@Travelfrom datetime=null,
@Travelto datetime=null,
@Marketpoint varchar(5),
@PromoCode varchar(50)=NULL

AS
BEGIN
if @PromoCode is not null
begin
	SELECT 1,AirportType,AirlineType,[User],IncludeFlat,MinFareAmt,Discount,DiscountOn,
	discounttype,cabin,Origin,OriginValue,Destination,DestinationValue,
	FlightSeries,FlightSeiresValue,MaxAmt,AirlineExclude,RestrictedUser,PromoCode,Remark,TC_Hyperlink,BookingType
	FROM Flight_PromoCode A
	WHERE 
	(((CONVERT(DATE,@TravelFrom) between TravelValidityFrom and TravelValidityTo ) OR TravelValidityFrom is null) AND
	((CONVERT(DATE,@TravelTo) between TravelValidityFrom and TravelValidityTo) OR TravelValidityTo is null))
	AND ((SaleValidityFrom <=  CONVERT(DATE,GETDATE()) OR SaleValidityFrom IS NULL) 
	AND (SaleValidityTo  >= CONVERT(DATE,GETDATE()) OR SaleValidityTo IS NULL)) 
	AND MarketPoint = @Marketpoint and PromoCode=@PromoCode
	 AND A.Flag = 1 order by InsertedDate desc

	 select emailId,U.UserName from  tblBookMaster B
	left JOIN UserLogin U ON U.UserID=B.LoginEmailID
	where promoCode =@PromoCode
	AND IsBooked=1
	end
else
begin
SELECT 2,AirportType,AirlineType,[User],IncludeFlat,MinFareAmt,Discount,DiscountOn,
	discounttype,cabin,Origin,OriginValue,Destination,DestinationValue,
	FlightSeries,FlightSeiresValue,MaxAmt,AirlineExclude,RestrictedUser,PromoCode,Remark,TC_Hyperlink,BookingType
	FROM Flight_PromoCode A
	WHERE 
	(((CONVERT(DATE,@TravelFrom) between TravelValidityFrom and TravelValidityTo ) OR TravelValidityFrom is null) AND
	((CONVERT(DATE,@TravelTo) between TravelValidityFrom and TravelValidityTo) OR TravelValidityTo is null))
	AND ((SaleValidityFrom <=  CONVERT(DATE,GETDATE()) OR SaleValidityFrom IS NULL) 
	AND (SaleValidityTo  >= CONVERT(DATE,GETDATE()) OR SaleValidityTo IS NULL)) 
	AND MarketPoint = @Marketpoint --and PromoCode=@PromoCode
	 AND A.Flag = 1 order by InsertedDate desc
End
 END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CheckPromoCode] TO [rt_read]
    AS [dbo];

