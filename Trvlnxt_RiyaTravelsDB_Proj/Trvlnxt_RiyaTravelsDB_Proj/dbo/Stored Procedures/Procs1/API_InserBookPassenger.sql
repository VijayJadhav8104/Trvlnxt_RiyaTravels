CREATE proc [dbo].[API_InserBookPassenger]                                        
	@fkBookMaster bigint                                        
	,@paxFName varchar(50)=null                                      
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
	,@ticketNum varchar(max)=null                      
	,@ticketNumber varchar(max)=null                      
	,@baggage varchar(30)=null                      
	,@paxType varchar(50)   =null                                      
	,@totalFare decimal(18,4)=0                                        
	,@basicFare decimal(18,4)=0                                        
	,@totalTax decimal(18,4) =0                                       
	,@YQ money=0                                        
	,@serviceCharge money =0                                       
	,@CancellationCharge money =0                                       
	,@isReturn bit = 0                                    
	,@YrTax decimal(18,2)=0                                        
	,@InTax decimal(18,2)=0                                        
	,@JnTax decimal(18,2)=0                                        
	,@OCTax decimal(18,2)=0                                       
	,@ExtraTax decimal(18,2)=0                                       
	,@DiscriptionTax varchar(1000)=null                                        
	,@CommissionType int=null                                        
	,@ServiceChargeType int=null                                        
	,@FlatDiscountType int=null                                        
	,@CancellationChargeType int=null                                        
	,@IATACommission decimal(18,2)=null                                        
	,@PLBCommission decimal(18,2)=null                                        
	,@GovtTaxPercent decimal(18,2)=null                                        
	,@IsIATAOnBasic bit=null                                        
	,@IsPLBOnBasic int=null                                        
	,@IATAPercent decimal(18,2)=null                                        
	,@PLBPercent decimal(18,2)=null                                        
	,@Markup decimal (18,2)=null                                        
	,@FMCommission decimal(18,2)=null                                        
	,@DropnetCommission decimal(18,2)=null                                        
	,@MCOAmount decimal(18,2)=NULL                                        
	,@B2BMarkup decimal(18,4)=0                                        
	,@ServiceFee decimal(18,2)=0                                        
	,@GSTAmount decimal(18,2)=0                                        
	,@McoTicketNumber varchar(270)=null                                        
	,@BFC int=0                            
	,@reScheduleCharge decimal(18,2)=0                                        
	,@SupplierPenalty decimal(18,2)=0                                        
	,@RescheduleMarkup decimal(18,2)=0                                        
	,@CDCNumber varchar(50)=null                                        
	,@BaggageFare Decimal (18,4) =null                      
	,@YMTax decimal(18,2)=0                                        
	,@WOTax decimal(18,2)=0                                       
	,@OBTax decimal(18,2)=0                                       
	,@RFTax decimal(18,2)=0                      
	,@HupAmount  decimal(18,0)=NULL                                      
	,@mobileNo varchar(50)=null           
	,@emailId varchar(50)=null                                   
	,@NationaltyCode varchar(20)=null              
	,@PassportIssueCountryCode varchar(20)=null                               
	,@FrequentFlyNo varchar(50)=null                 
	,@Cabinbaggage varchar(max)=null                            
	,@managementfees int = 0               
	,@VendorServiceFee decimal(18,2)=0             
	,@BarCode varchar(max)=null             
               
	,@TCSTaxAmount decimal(18,2)=0               
	,@TDSOnIATACommission  decimal(18,2)=NULL                 
	,@TDSOnPLBCommission  decimal(18,2)=NULL                 
	,@GSTOnPLBCommission  decimal(18,2)=NULL              
	,@PanNumber varchar(20)=''              
	,@PanCardValidation varchar(100)=''               
	,@NameAsOnPAN varchar(100)=''              
	,@MarkOn varchar(20)=null               
	,@LonServiceFee decimal(18,4) =0          
	,@K7Tax decimal(18,2)=0         
	,@AirlineFee decimal(18,2)=0        
	,@AirlineGST decimal(18,2)=0      
	,@OPID bigint = 0    
	,@MarkupOnTaxFare decimal(18,2)=0  
	,@ParentB2BMarkup decimal(18,2)=0
	,@RefundAmount decimal(18,2)=0   
                        
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
   ,ticketNum                      
   ,ticketNumber                      
   ,paxType                                        
   ,totalFare                                        
   ,[basicFare]                                        
   ,[totalTax]                                        
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
   ,PLBPercent                      
   ,Markup                      
   ,passissue                      
   ,FMCommission                      
   ,DropnetCommission,                                       
   MCOAmount                                         
   ,B2BMarkup                      
   ,ServiceFee                      
   ,GST                      
   ,MCOTicketNo                      
   ,BFC                      
   ,Profession                      
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
   ,VendorServiceFee           
   ,BarCode              
                 
,TDSonIATA                
,TDSonPLB               
,GSTonPLB                
,PanNumber                
,PanCardValidation              
,MarkOn               
,LonServiceFee           
,K7Tax        
,AirlineFee        
,AirlineGST       
,OPID     
,MarkupOnTaxFare  
,ParentB2BMarkup
,RefundAmount
                        
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
   ,@ticketNum                      
   ,@ticketNumber                      
   ,@paxType                                        
   ,@totalFare                                        
   ,@basicFare                                         
   ,@totalTax                                         
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
   ,@IATACommission                                        
   ,@PLBCommission                                        
   ,@GovtTaxPercent                                         
   ,@IsIATAOnBasic                  
   ,@IsPLBOnBasic                                         
   ,@IATAPercent                                         
   ,@PLBPercent                      
   ,@Markup                      
   ,@passIssue                      
   ,@FMCommission                      
   ,@DropnetCommission                                         
   ,@MCOAmount                                        
   ,@B2BMarkup                                        
   ,@ServiceFee                      
   ,@GSTAmount                      
   ,@McoTicketNumber                                        
   ,@BFC                     
   ,replace(@paxProfession,'ID-','')                      
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
   ,@VendorServiceFee              
   ,@BarCode            
               
,@TDSOnIATACommission                
,@TDSOnPLBCommission               
,@GSTOnPLBCommission                  
,@PanNumber                
,@PanCardValidation                
,@MarkOn                
,@LonServiceFee            
,@K7Tax        
,@AirlineFee        
,@AirlineGST      
,@OPID     
,@MarkupOnTaxFare  
,@ParentB2BMarkup
,@RefundAmount
           
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