CREATE proc [dbo].[API_InsertBookMaster]                                                               
 @orderId varchar(max)=null                                     
 ,@gdspnr varchar(30) = null                                    
 ,@HoldDate varchar(100) = null                                    
 ,@HoldText varchar(max) = null                                    
 ,@IsNegofare bit=0                                    
 ,@CounterCloseTime int = null                                                              
 ,@frmSector varchar(50)                                                              
 ,@toSector varchar(50)                                                              
 ,@fromAirport varchar(255)                                                              
 ,@toAirport varchar(255)                                                              
 ,@airName varchar(255)                                                              
 ,@operatingCarrier varchar(50) = null                                                              
 ,@airCode varchar(10)=null                                                              
 ,@equipment varchar(100)=null                                                              
 ,@flightNo varchar(10)                                                              
 ,@isReturnJourney bit = 0                                                              
 ,@riyaPNR varchar(12)=null                                                              
 ,@taxDesc varchar(max)=null                                                              
 ,@totalFare Decimal (18,4) = 0                                                             
 ,@totalTax Decimal (18,4) =0                                                              
 ,@basicFare Decimal (18,4) =0                                                              
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
 ,@YrTax decimal(18,4) = 0                                                             
 ,@InTax decimal(18,4) = 0                                                            
 ,@JnTax decimal(18,4) = 0                                                             
 ,@OCTax decimal(18,4) = 0                                                             
 ,@ExtraTax decimal(18,4) = 0                                                              
 ,@YQTax  decimal(18,4) = 0                                                            
 ,@CommissionType int=null                                                              
 ,@ServiceChargeType int=null                                                              
 ,@FlatDiscountType int=null                                                              
 ,@CancellationChargeType int=null                                                              
 ,@FareSellKey varchar (max)=null                                    
 ,@JourneySellKey  varchar (max)=null                                           
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
 ,@RegistrationNumber varchar(255) =null                                                              
 ,@CompanyName varchar(150)=null                                                              
 ,@CAddress varchar(255) =null                                                              
 ,@CState varchar(50) =null                                                              
 ,@CContactNo varchar(50) =null                                                              
 ,@CEmailID varchar(50) =null                                                              
 ,@PromoDiscount Decimal (18,2) =null                                                              
 ,@ROE Decimal (18,10) =null                                                              
 ,@OfficeID varchar(50) =null                                                              
 ,@Country varchar(4) =null                                         
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
 ,@TourCode varchar(50)=null                                                              
 ,@VendorName varchar(50)=null                                                              
 ,@MCOAmount decimal(18,4)=null                                                              
 ,@TotalEarning decimal(18,4)=null                                                             
 ,@MainAgentId int =null                                                              
 ,@BookingStatus smallint=0                                           
 ,@IsBooked smallint=0                                           
 ,@BookedBy Int= null                                                              
 ,@InquiryNo VARCHAR(50) =NULL                                                              
 ,@B2BMarkup decimal(18,4)=0                                                              
 ,@B2bFareType int=0                                                              
 ,@ServiceFee decimal(18,2)=0                                                              
 ,@GSTAmount decimal(18,2)=0                                                              
 ,@BFC decimal(18,2)=0                                                       
 ,@Iata varchar(50)=null                                      
 ,@ReissueCharges decimal(18,2)=0                                                              
 ,@PromoDiscountAmt decimal(18,2)=0                                                       
 ,@AgentCurrency varchar(30)=null                                    
 ,@YMTax decimal(18,2)=0                          
 ,@WOTax decimal(18,2)=0                                                             
 ,@OBTax decimal(18,2)=0              
 ,@RFTax decimal(18,2)=0                                    
 ,@AddUserSelfBalance varchar(50)=null                                                            
 ,@TotalHupAmount decimal(18,4)=null                          
 ,@TicketingPCC varchar(50)=null                                                       
 ,@FlightDuration varchar(50)=null                                                     
 ,@ValidatingCarrier varchar(50) = null                                    
 ,@TotalCarbonEmission varchar(50) = null                                         
 ,@TotalflightLegMileage varchar(20) = null                                        
 ,@TripType varchar(10)=null                                       
 ,@IsMultiTST bit=null                                    
 ,@TransactionId varchar(50)=null                                    
                                 
 ,@VendorCommissionPercent varchar(10) =null                                  
 ,@VendorCommissionText varchar(MAX) =null                               
 ,@APITrackID varchar(MAX) =null                          
 ,@IssueDate varchar(MAX) =null               
               
 ,@TotalVendorServiceFee decimal(18,2)=0               
 ,@VendorServiceFeeOn varchar(50) ='' ,              
 @TFBookingstatus varchar(100)=null,            
 @TicketIssuanceError varchar(MAX)=null,          
 @NetAmount decimal(18,2)=0,          
 @GrossFare decimal(18,2)=0,        
 @ServiceFeeMap decimal(18,2)=0,        
 @ServiceFeeAdditional decimal(18,2)=0,        
@PGMarkup decimal(18,2)=0,        
@Isfakebooking BIT=0,        
@totalLonServiceFee Decimal (18,4) =null,      
@SubBookingSource varchar(50)=null,  
@K7Tax decimal(18,4) = 0,    
@ParentOrderId varchar(max)=null,
@HoldTimeLimitflag varchar(10) = ''
  
      
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
   ,GDSPNR                                    
   ,HoldDate                                    
   ,HoldText                                    
   ,IsNegofare                                    
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
   ,TotalMarkup                  
   ,BookingType                                    
   ,DisplayType                                    
   ,CalculationType                                                               
   ,journey                                                 
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
   ,IsBooked                                
   ,AgentROE                                                    
   ,BookedBy                                                              
   ,InquiryNo                                                              
   ,ServiceFee                                                              
   ,GST                                         
   ,B2BMarkup                                                              
   ,B2bFareType                                                              
   ,BFC,Iata                                                 
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
   ,FlightDuration                                                      
   ,ValidatingCarrier                                            
   ,TotalCarbonEmission                                            
   ,TotalflightLegMileage                                          
   ,TripType                                        
   ,TransactionId                                        
   ,IsMultiTST                                        
                                 
   ,VendorCommissionPercent                                  
   ,VendorCommissionText                            
   ,APITrackID                          
   ,IssueDate              
   ,TotalVendorServiceFee              
   ,VendorServiceFeeOn              
   ,TFBookingstatus              
   ,TFBookingRef            
   ,TicketIssuanceError          
   ,NetAmount          
 ,GrossFare        
   ,ServiceFeeMap        
   ,ServiceFeeAdditional        
   ,PGMarkup        
   ,Isfakebooking        
   ,TotalLonServiceFee      
   ,SubBookingSource    
   ,K7Tax    
   ,ParentOrderID
   ,HoldTimeLimitflag
   )                                           
     VALUES                                                              
   (@TotalTime                                    
   ,@CounterCloseTime                                                              
   ,@orderId                                    
   ,@gdspnr                                    
   ,@HoldDate                                    
,@HoldText                                    
   ,@IsNegofare                                    
   ,@frmSector                                                              
   ,@toSector                                                              
   ,@fromAirport                                                              
   ,@toAirport                                                              
   ,@airName                                                              
   ,@operatingCarrier                                                              
   ,@airCode                                           
   ,@equipment                                         
   , LTRIM(RTRIM(@flightNo))                                                    
   ,@isReturnJourney                                                              
   ,@deptDateTime                                                              
   ,@arrivalDateTime                                                              
   ,@riyaPNR                                                              
   ,@taxDesc                                                              
   ,@totalFare                                      
   ,@totalTax                                                              
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
   , @IATACommission                                                              
   ,@PLBCommission                                                              
 ,@GovtTaxPercent                                                          
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
   ,@TotalMarkup                                    
   ,@BookingType                                    
   ,@DisplayType                                    
   ,@CalculationType                                    
   ,@Journey                                             
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
   ,@IsBooked                                
   ,@AgentROE                                                              
   ,@BookedBy                                                              
   ,@InquiryNo                                    
   ,@ServiceFee                                                              
   ,@GSTAmount                                                              
   ,@B2BMarkup                                       
   ,@B2bFareType                                                              
   ,@BFC                                    
   ,@Iata                                                      
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
   ,@FlightDuration                                                        
   ,@ValidatingCarrier                          
   ,@TotalCarbonEmission                                            
   ,@TotalflightLegMileage                                          
   ,@TripType                                        
   ,@TransactionId                                        
   ,@IsMultiTST                                        
                            
   ,@VendorCommissionPercent                                  
   ,@VendorCommissionText                            
   ,@APITrackID                          
   ,@IssueDate              
   ,@TotalVendorServiceFee              
   ,@VendorServiceFeeOn              
   ,@TFBookingstatus              
   ,@gdspnr            
   ,@TicketIssuanceError          
   ,@NetAmount          
   ,@GrossFare        
   ,@ServiceFeeMap                 
   ,@ServiceFeeAdditional              
   ,@PGMarkup              
   ,@Isfakebooking          
   ,@totalLonServiceFee       
   ,@SubBookingSource     
   ,@K7Tax  
    ,@ParentOrderId
	,@HoldTimeLimitflag
   )                                                              
                                             
        select SCOPE_IDENTITY();                                                   
                                                                 
end 