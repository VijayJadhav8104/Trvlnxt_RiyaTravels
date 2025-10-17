

CREATE proc [dbo].[Update_Promocode]  
  
@ID int,  
@MarketPoint varchar(30),  
@AirportType varchar(50),  
@AirLineCode varchar(max),  
@PaxType varchar(50),  
@User varchar(50),  
@RestrictedUser varchar(50),  
@IncludeFlat varchar(10),  
@MinFareAmt numeric(18,2),  
@Discount numeric(18,2),  
@PromoCode varchar(50),  
@TravelValidity_From datetime,  
@TravelValidity_To datetime,  
@SalesValidity_From datetime,  
@SalesValidity_To datetime,  
@Remark varchar(max),  
@DiscountType varchar(20), 
@DiscountOn int, 
@Cabin varchar(20),  
@Origin bit,  
@Originvalue varchar(max),  
@Destination bit,  
@Destinationvalue varchar(max),  
@FlightSeries bit,  
@FlightSeriesValue varchar(max),  
@MaxAmt numeric(18,2)=0,  
@AirlineExclude VARCHAR(MAX)=NULL,  
@TC_Hyperlink NVARCHAR(200)=NULL,  
@BookingType smallint=null,  
@UserType Varchar(50)=null,  
@AgencyId varchar(MAX)=null,  
@AgentCategory varchar(MAX)=null,  
@AgencyNames varchar(MAX)=null,  
@OriginCountry VARCHAR(MAX)=NULL,  
@DestinationCountry VARCHAR(MAX)=NULL,  
@UserID int  
as  
begin  
  
Update Flight_PromoCode  
set  
  
MarketPoint = @MarketPoint,  
AirportType=@AirportType,  
AirlineType=@AirLineCode,  
PaxType=@PaxType,  
Remark=@Remark,  
[User]=@User,  
RestrictedUser=@RestrictedUser,  
IncludeFlat=@IncludeFlat,  
MinFareAmt=@MinFareAmt,  
Discount=@Discount,  
PromoCode=@PromoCode,  
TravelValidityFrom=@TravelValidity_From,  
TravelValidityTo=DATEADD(s, 86399,@TravelValidity_To),  
SaleValidityFrom=@SalesValidity_From,  
SaleValidityTo=DATEADD(s, 86399,@SalesValidity_To),  
InsertedDate=GETDATE(),  
discounttype=@DiscountType,  
DiscountOn=@DiscountOn,  
cabin=@Cabin,  
Origin=@Origin,  
OriginValue=@Originvalue,  
Destination=@Destination,  
DestinationValue= @Destinationvalue,  
FlightSeries= @FlightSeries,  
FlightSeiresValue= @FlightSeriesValue,  
MaxAmt=@MaxAmt,  
AirlineExclude=@AirlineExclude,  
TC_Hyperlink=@TC_Hyperlink,  
BookingType=@BookingType,  
UserType=@UserType,  
AgencyId=@AgencyId,  
AgentCategory=@AgentCategory,  
AgencyNames=@AgencyNames,  
UserID=@UserID,  
UpdatedDate=GETDATE(),  
OriginCountry=@OriginCountry,  
DestinationCountry=@DestinationCountry  
where ID= @ID  
  
  
end  
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Update_Promocode] TO [rt_read]
    AS [dbo];

