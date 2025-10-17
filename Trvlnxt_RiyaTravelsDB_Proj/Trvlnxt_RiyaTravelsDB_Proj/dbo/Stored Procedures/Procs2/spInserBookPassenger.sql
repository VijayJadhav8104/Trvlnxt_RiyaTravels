CREATE proc [dbo].[spInserBookPassenger]              
            @fkBookMaster bigint              
           ,@paxFName varchar(50)              
           ,@paxLName varchar(50)=null              
     ,@paxProfession varchar(50)=null              
           ,@passportNum varchar(30)=null              
           ,@passIssue date=null              
     ,@passexp date=null              
     ,@passPortIssueCountry varchar(100)=null              
           ,@status bit=0              
           ,@title varchar(10)=null              
           ,@dateOfBirth datetime=null              
           ,@nationality varchar(50)=null              
           ,@gender varchar(20)=null              
           --,@ticketNum varchar(30)=null              
           ,@baggage varchar(30)=null              
     --,@YQ varchar(50)              
     ,@paxType varchar(50)              
     ,@totalFare decimal(18,4)=0              
     ,@basicFare decimal(18,4)=0              
     ,@totalTax decimal(18,4) =0      
	 ,@totalVendorServiceFee decimal(18,4) =0 
	 ,@totalLonServiceFee decimal(18,4) =0               
     ,@YQ money=0              
     ,@serviceCharge money =0             
     ,@CancellationCharge money =0             
     ,@isReturn bit,              
      @YrTax decimal(18,2)=0,              
   @InTax decimal(18,2)=0,              
   @JnTax decimal(18,2)=0,              
   @OCTax decimal(18,2)=0,              
   @ExtraTax decimal(18,2)=0,              
   @DiscriptionTax varchar(1000)=null,              
   @CommissionType int=null              
           ,@ServiceChargeType int=null              
           ,@FlatDiscountType int=null              
           ,@CancellationChargeType int=null              
      ,@IATACommission decimal(18,2)=null              
     ,@PLBCommission decimal(18,2)=null              
      ,@GovtTaxPercent decimal(18,2)=null              
    ,@IsIATAOnBasic bit=null              
     ,@IsPLBOnBasic int=null              
     ,@IATAPercent decimal(18,2)=null              
     ,@PLBPercent decimal(18,2)=null,              
     @Markup decimal (18,2)=null,              
     @FMCommission decimal(18,2)=null,              
     @DropnetCommission decimal(18,2)=null,              
     @MCOAmount decimal(18,2)=NULL,              
     @B2BMarkup decimal(18,4)=0,              
     @ServiceFee decimal(18,2)=0,              
   @GSTAmount decimal(18,2)=0,              
   @McoTicketNumber varchar(270)=null,              
   @BFC int=0,              
   --Added on 10-06-2021              
   @ticketNum  varchar(200)=null,              
   @reScheduleCharge decimal(18,2)=0,              
   @SupplierPenalty decimal(18,2)=0,              
   @RescheduleMarkup decimal(18,2)=0,              
   @CDCNumber varchar(50)=null,              
   @BaggageFare Decimal (18,4) =null,              
              
   @YMTax decimal(18,2)=0,              
   @WOTax decimal(18,2)=0,              
   @OBTax decimal(18,2)=0,              
   @RFTax decimal(18,2)=0 ,             
              
     @HupAmount  decimal(18,0)=NULL,            
       @mobileNo varchar(50)=null,                
   @emailId varchar(50)=null    ,            
   @NationaltyCode varchar(20)=null,            
   @PassportIssueCountryCode varchar(20)=null ,      
   @FrequentFlyNo varchar(50)=null,   
    @TDSOnIATACommission  decimal(18,2)=NULL, 
   @TDSOnPLBCommission  decimal(18,2)=NULL, 
   @GSTOnPLBCommission  decimal(18,2)=NULL,
     @Cabinbaggage varchar(max)=null,  
  @managementfees int = 0  ,
  @PanNumber varchar(20)=''
    ,@PanCardValidation varchar(100)=''  
	,@K7Tax decimal(18,2)=0
	,@MarkOn varchar(20)=null  
AS              
BEGIN              
      set @passPortIssueCountry= (select top 1 country from Country with(nolock) where A1 = @PassportIssueCountryCode)            
 set @nationality= (select top 1 country from Country with(nolock) where A1 = @NationaltyCode)            
        
INSERT INTO [dbo].[tblPassengerBookDetails]              
           (fkBookMaster              
           ,paxFName              
           ,paxLName              
           ,passportNum              
           ,passexp              
           ,[status]              
           ,title              
           ,dateOfBirth              
           ,nationality              
           ,gender                  
           ,paxType              
     ,totalFare              
     ,[basicFare]              
     ,[totalTax]      
	 ,VendorServiceFee
	 ,LonServiceFee
     ,YQ              
     ,[baggage]              
     ,[passportIssueCountry]              
     ,isReturn              
     ,serviceCharge              
      ,CancellationCharge              
     ,YrTax              
     ,InTax              
     ,JnTax              
     ,OCTax              
     ,ExtraTax              
     ,DiscriptionTax              
     ,CommissionType              
           ,ServiceChargeType              
           ,FlatDiscountType              
           ,CancellationChargeType              
       , IATACommission,              
     PLBCommission,              
     GovtTaxPercent              
      ,IsIATAOnBasic               
     ,IsPLBOnBasic               
     ,IATAPercent               
     ,PLBPercent,Markup,passissue,FMCommission,DropnetCommission,              
     MCOAmount               
     ,B2BMarkup,ServiceFee,GST,MCOTicketNo,BFC,Profession              
      --New Added              
     ,ticketNum                   
     ,reScheduleCharge              
     ,SupplierPenalty              
     ,RescheduleMarkup              
     ,CDCNumber              
     ,BaggageFare              
              
     ,YMTax              
   ,WOTax              
   ,OBTax              
   ,RFTax              
   ,HupAmount      
   ,FrequentFlyNo      
   ,Cabinbaggage  
   ,managementfees  
   ,TDSonIATA
   ,TDSonPLB
   ,GSTonPLB
    ,MarkOn
     ,PanNumber
	 ,PanCardValidation
	 ,K7Tax
     )              
     --End              
     VALUES              
           (              
      @fkBookMaster              
           ,UPPER(@paxFName)                
           ,UPPER(@paxLName)              
           ,@passportNum           
           ,@passexp              
           ,@status              
           ,@title              
           ,@dateOfBirth              
           ,@nationality              
           ,@gender              
           ,@paxType              
     ,@totalFare              
     ,@basicFare               
     ,@totalTax        
	 ,@totalVendorServiceFee
	 ,@totalLonServiceFee
     ,@YQ              
     ,@baggage              
     ,@passPortIssueCountry              
     ,@isReturn              
     ,@serviceCharge              
    ,@CancellationCharge              
     ,@YrTax              
     ,@InTax              
     ,@JnTax              
     ,@OCTax              
     ,@ExtraTax              
     ,@DiscriptionTax              
     ,@CommissionType               
           ,@ServiceChargeType               
           ,@FlatDiscountType               
           ,@CancellationChargeType               
    , @IATACommission,              
     @PLBCommission,              
     @GovtTaxPercent               
      ,@IsIATAOnBasic               
     ,@IsPLBOnBasic               
     ,@IATAPercent               
     ,@PLBPercent,@Markup,@passIssue,@FMCommission,@DropnetCommission               
     ,@MCOAmount              
     ,@B2BMarkup              
     ,@ServiceFee,@GSTAmount,@McoTicketNumber              
     ,@BFC,replace(@paxProfession,'ID-','')                   
     --New added               
     ,@ticketNum              
     ,@reScheduleCharge              
     ,@SupplierPenalty              
     ,@RescheduleMarkup              
     ,@CDCNumber              
     ,@BaggageFare              
              
     ,@YMTax              
   ,@WOTax              
   ,@OBTax              
   ,@RFTax           
   ,@HupAmount        
  ,@FrequentFlyNo        
    ,@Cabinbaggage    
 ,@managementfees  
  ,@TDSOnIATACommission
 ,@TDSOnPLBCommission
 ,@GSTOnPLBCommission
 ,@MarkOn
 ,@PanNumber
 ,@PanCardValidation
 ,@K7Tax
     --End              
     )              
select SCOPE_IDENTITY();              
              
   --mPassengerProfile table              
if @mobileNo is not null and @emailId is not null             
begin              
 insert into mPassengerProfile           
 values(          
 @paxType,          
 @paxFName,          
 @paxLName,          
 @passportNum,          
 @passPortIssueCountry,          
 @passexp,          
 @title,          
 @dateOfBirth,          
 @nationality,                
 @gender,          
 @mobileNo,          
 @emailId,      
 GETDATE(),          
 @PassportIssueCountryCode,          
 @NationaltyCode)                 
end          
end 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInserBookPassenger] TO [rt_read]
    AS [dbo];

