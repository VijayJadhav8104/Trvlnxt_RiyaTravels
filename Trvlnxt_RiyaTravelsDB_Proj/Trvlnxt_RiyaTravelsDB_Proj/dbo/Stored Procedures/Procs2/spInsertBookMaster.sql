CREATE proc [dbo].[spInsertBookMaster]                   
            @orderId varchar(30)=null,                  
   @CounterCloseTime int = null                  
           ,@frmSector varchar(50)                  
           ,@toSector varchar(50)                  
           ,@fromAirport varchar(150)                  
           ,@toAirport varchar(150) = ''                  
           ,@airName varchar(150) = ''                  
           ,@operatingCarrier varchar(50) = null                  
           ,@airCode varchar(10)=null                  
           ,@equipment varchar(100)=null                  
           ,@flightNo varchar(10)                  
           ,@isReturnJourney bit                  
           ,@riyaPNR varchar(10)=null                  
           ,@taxDesc varchar(1000)=null                  
           ,@totalFare Decimal (18,4) = null                  
           ,@totalTax Decimal (18,4) =null       
		   ,@totalVendorServiceFee Decimal (18,4) =null    
		   ,@totalLonServiceFee Decimal (18,4) =null                  
           ,@basicFare Decimal (18,4) =null                  
           ,@deptDateTime datetime=null                  
           ,@arrivalDateTime datetime=null                  
           ,@IP varchar(50)=null                  
           ,@TotalDiscount Decimal (18,4)=0                  
           ,@FlatDiscount decimal(18,4)=null                  
           ,@ServiceCharge decimal(18,4)=null                  
           ,@CancellationCharge decimal(18,4)=null                  
           ,@promoCode varchar(50)=null                  
           ,@mobileNo varchar(20)=null                  
           ,@emailId varchar(50)= null                  
     ,@returnFlag bit=0                  
     ,@fromTerminal varchar(20) =null                  
     ,@toTerminal varchar(20)=null                  
     ,@YrTax decimal(18,4),                  
   @InTax decimal(18,4),                  
   @JnTax decimal(18,4),                  
   @OCTax decimal(18,4),                  
   @ExtraTax decimal(18,4),                  
   @YQTax  decimal(18,4),                  
   @CommissionType int=null                  
           ,@ServiceChargeType int=null                  
           ,@FlatDiscountType int=null                  
           ,@CancellationChargeType int=null                  
     ,@FareSellKey varchar (100)=null                  
     ,@JourneySellKey  varchar (100)=null                  
     ,@TotalTime varchar(10) =null                  
     ,@IATACommission Decimal (18,4) =null                  
     ,@PLBCommission Decimal (18,4) =null                  
     ,@GovtTaxPercent decimal(18,4) =null                  
     ,@IsIATAOnBasic bit =null                  
     ,@IsPLBOnBasic int =null                  
     ,@IATAPercent decimal(18,2) =null                  
     ,@PLBPercent decimal(18,2) =null                  
     ,@UserID BIGINT=NULL                  
     ,@UniqueID UNIQUEIDENTIFIER =NULL                  
     ,@BookingSource varchar(50)=null                  
     ,@SessionId varchar(150)=null                  
     ,@LoginEmailID int=null                  
   ,@RegistrationNumber varchar(50) =null                  
   ,@CompanyName varchar(50)=null                  
   ,@CAddress varchar(50) =null                  
   ,@CState varchar(50) =null                  
   ,@CContactNo varchar(50) =null                  
   ,@CEmailID varchar(50) =null                  
   ,@PromoDiscount Decimal (18,2) =null                  
   ,@ROE Decimal (18,10) =null                  
   ,@OfficeID varchar(50) =null                  
   ,@Country varchar(2) =null                  
   ,@AgentID VARCHAR(50)=NULL                  
   ,@AgentDealDiscount  numeric(18,4)= 0                  
   ,@TotalMarkup decimal(18,4)=0                  
   ,@BookingType int=null                  
   ,@DisplayType int=null                  
   ,@CalculationType int=null                  
   ,@Journey char(1)=null                  
   ,@AgentROE decimal(18,10)=1                  
   ,@FareType varchar(50)=null                  
   ,@AgentMarkup decimal(18,4)=null      
   ,@PromocodeBookingType int=NULL                  
   ,@PricingCode varchar(50)=null                  
   ,@TourCode varchar(50)=null,                  
  @VendorName varchar(50)=null,                  
   @MCOAmount decimal(18,4)=null,                  
   @TotalEarning decimal(18,4)=null,                  
    @MainAgentId int =null,                  
   @BookingStatus smallint=null,                  
   @BookedBy Int= null,                  
   @InquiryNo VARCHAR(50) =NULL,                  
   @B2BMarkup decimal(18,4)=0,                  
   @B2bFareType int=0,                  
   @ServiceFee decimal(18,2)=0,                  
   @GSTAmount decimal(18,2)=0,                  
   @BFC decimal(18,2)=0,           
   @Iata varchar(50)=null,                  
   --Newly Added                  
   @ReissueCharges decimal(18,2)=0,                  
   @PromoDiscountAmt decimal(18,2)=0,                  
   @AgentCurrency varchar(30)=null,                  
                  
   @YMTax decimal(18,2)=0,                  
   @WOTax decimal(18,2)=0,                  
   @OBTax decimal(18,2)=0,                  
   @RFTax decimal(18,2)=0,                  
                  
   @AddUserSelfBalance varchar(50)=null  ,              
      @TotalHupAmount decimal(18,4)=null  ,              
   @TicketingPCC varchar(50)=null,          
   @ValidatingCarrier varchar(50) = null,          
     @FlightDuration varchar(50)=null,      
   @TotalCarbonEmission varchar(100) = null,      
 @TotalflightLegMileage varchar(100) = null  ,  
 @TripType varchar(10)=null,    
  @IsMultiTST bit=null,   
   @TransactionId varchar(50)=null,  
   @ServiceFeeMap decimal(18,2)=0,      
   @ServiceFeeAdditional decimal(18,2)=0,
   @PGMarkup decimal(18,2)=0,
    @K7Tax decimal(18,2)=0,
   @Isfakebooking BIT=0
as                  
begin                  
if(@CounterCloseTime=0)                
begin                
 set @CounterCloseTime=(select (case when(count(Code)>1)                
    then 1                
    else 2                
    end) from sectors with(nolock)  where ((ltrim(rtrim(Code)) = @frmSector  or                
   ltrim(rtrim(Code)) = @toSector)  AND [Country code]=@Country))                
end                
INSERT INTO [dbo].[tblBookMaster]                  
           (TotalTime,                  
      CounterCloseTime                  
     ,orderId                  
           ,frmSector                  
           ,toSector                  
           ,fromAirport                  
           ,toAirport                  
           ,airName                  
           ,operatingCarrier                  
           ,airCode                  
           ,equipment                  
           ,flightNo                  
           ,isReturnJourney                  
           ,depDate                  
           ,arrivalDate                  
           ,riyaPNR                  
 ,taxDesc                  
           ,totalFare                  
           ,totalTax     
		   ,TotalVendorServiceFee
		   ,TotalLonServiceFee
           ,basicFare                  
           ,deptTime                  
           ,arrivalTime                  
           ,IP                  
           ,TotalDiscount                  
           ,FlatDiscount                  
           ,ServiceCharge                  
           ,CancellationCharge                  
     ,promoCode                  
           ,mobileNo                  
           ,emailId                  
     ,returnFlag                  
     ,fromTerminal                  
     ,toTerminal                  
     ,YrTax                  
    ,InTax                  
     ,JnTax                  
     ,OCTax                  
     ,ExtraTax                  
     ,YQTax                  
     ,CommissionType                  
     ,ServiceChargeType                  
     ,FlatDiscountType                  
     ,CancellationChargeType                  
     ,FareSellKey                   
     ,JourneySellKey                   
     , IATACommission,                  
     PLBCommission,                  
     GovtTaxPercent                  
     ,IsIATAOnBasic       
     ,IsPLBOnBasic                   
     ,IATAPercent                   
     ,PLBPercent                  
     ,UserID                  
     ,UniqueID                  
     ,BookingSource                  
     ,SessionId                  
     ,LoginEmailID                  
     ,RegistrationNumber                   
   ,CompanyName                   
   ,CAddress                   
   ,CState                   
   ,CContactNo                   
   ,CEmailID                   
   ,PromoDiscount                  
   ,ROE                  
   ,OfficeID                  
   ,Country                  
   ,AgentID                  
   ,AgentDealDiscount                  
   ,TotalMarkup,BookingType,DisplayType,CalculationType                   
   ,journey                  
   --,TrackID                  
   ,FareType                  
   ,AgentMarkup                  
   ,PromocodeBookingType                  
   ,PricingCode                  
   ,TourCode        
   ,VendorName                  
   ,MCOAmount                  
   ,TotalEarning                  
   ,MainAgentId                  
   ,BookingStatus                  
   ,AgentROE                  
   ,BookedBy                  
   ,InquiryNo                  
   ,ServiceFee                  
   ,GST                  
   ,B2BMarkup                  
   ,B2bFareType                  
   ,BFC,Iata                  
   --Newly Added                  
   ,ReissueCharges                  
   ,PromoDiscountTotalAMT                  
   ,AgentCurrency                  
                  
   ,YMTax                  
   ,WOTax                  
   ,OBTax                  
   ,RFTax                  
   ,AddUserSelfBalance               
    ,TotalHupAmount                
   ,TicketingPCC          
   ,ValidatingCarrier          
   ,FlightDuration      
   ,TotalCarbonEmission      
   ,TotalflightLegMileage     
   ,TripType    
   ,TransactionId   
   ,IsMultiTST  
   ,ServiceFeeMap   
   ,ServiceFeeAdditional
   ,PGMarkup
   ,K7Tax
   ,Isfakebooking
      )                  
     VALUES                  
           (@TotalTime,@CounterCloseTime,                  
     @orderId                  
           ,@frmSector                  
           ,@toSector                  
           ,@fromAirport                  
           ,@toAirport                  
           ,@airName                  
           ,@operatingCarrier                  
           ,@airCode                  
           ,@equipment                  
           ,ltrim(rtrim(@flightNo))                  
           ,@isReturnJourney                  
           ,@deptDateTime                  
           ,@arrivalDateTime                  
           ,@riyaPNR                  
           ,@taxDesc                  
           ,@totalFare                  
           ,@totalTax   
		   ,@totalVendorServiceFee
		   ,@totalLonServiceFee
           ,@basicFare                  
           ,@deptDateTime                  
           ,@arrivalDateTime                  
           ,@IP                  
           ,@TotalDiscount                  
           ,@FlatDiscount              
           ,@ServiceCharge                  
           ,@CancellationCharge                  
           ,@promoCode                  
           ,@mobileNo                  
           ,@emailId                  
     ,@returnFlag                  
     ,@fromTerminal                  
     ,@toTerminal                  
     ,@YrTax                  
     ,@InTax                  
     ,@JnTax                  
     ,@OCTax                  
     ,@ExtraTax                  
     ,@YQTax                  
     ,@CommissionType                   
           ,@ServiceChargeType                   
           ,@FlatDiscountType                   
           ,@CancellationChargeType                   
     ,@FareSellKey                   
     ,@JourneySellKey                   
     , @IATACommission,                  
     @PLBCommission,                  
     @GovtTaxPercent                  
     ,@IsIATAOnBasic                   
     ,@IsPLBOnBasic                   
     ,@IATAPercent        
     ,@PLBPercent                  
     ,@UserID                  
     ,@UniqueID                  
     ,@BookingSource                  
     ,@SessionId                  
     ,@LoginEmailID                  
     ,@RegistrationNumber                   
   ,@CompanyName                   
   ,@CAddress                   
   ,@CState                   
   ,@CContactNo                   
   ,@CEmailID                    
   ,@PromoDiscount                  
   ,@ROE                  
   ,@OfficeID                  
   ,@Country                  
   ,@AgentID                  
   ,@AgentDealDiscount                  
   ,@TotalMarkup,@BookingType,@DisplayType,@CalculationType,@Journey                  
   --,@TrackID                  
   ,@FareType                  
   ,@AgentMarkup                  
   ,@PromocodeBookingType                  
   ,@PricingCode                  
,@TourCode                  
   ,@VendorName                  
   ,@MCOAmount                  
   ,@TotalEarning                  
   ,@MainAgentId                  
   ,@BookingStatus                  
   ,@AgentROE                  
   ,@BookedBy                  
   ,@InquiryNo                  
                  
   ,@ServiceFee                  
   ,@GSTAmount                  
   ,@B2BMarkup                  
   ,@B2bFareType,                  
   @BFC,@Iata                  
   --Newly Added                  
   ,@ReissueCharges                  
   ,@PromoDiscountAmt                  
   ,@AgentCurrency                  
                  
   ,@YMTax                  
   ,@WOTax              
   ,@OBTax                  
   ,@RFTax                  
   ,@AddUserSelfBalance               
      ,@TotalHupAmount               
   ,@TicketingPCC          
   ,@ValidatingCarrier          
    ,@FlightDuration      
 ,@TotalCarbonEmission      
   ,@TotalflightLegMileage      
   ,@TripType    
   ,@TransactionId    
   ,@IsMultiTST  
    ,@ServiceFeeMap   
   ,@ServiceFeeAdditional
   ,@PGMarkup
   ,@K7Tax
   ,@Isfakebooking
)                  
                   
  select SCOPE_IDENTITY();                  
                     
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertBookMaster] TO [rt_read]
    AS [dbo];

