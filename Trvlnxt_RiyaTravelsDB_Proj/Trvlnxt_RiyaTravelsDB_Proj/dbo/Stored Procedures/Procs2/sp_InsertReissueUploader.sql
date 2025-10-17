CREATE procedure [dbo].[sp_InsertReissueUploader]       
@TopUpCr varchar(20) = ''    
,@IssueDate varchar(100) = ''    
,@CustomerNo varchar(100) = ''    
,@ShiptoCustomerNo varchar(100) = ''    
,@CustomerLocationCode varchar(50) = ''    
,@TicketType varchar(50) = ''    
,@AgentID varchar(20) = ''    
,@PNRNo varchar(20) = ''    
,@AirlineCode varchar(10) = ''    
,@TicketNo varchar(50) = ''    
,@PaxType varchar(20) = ''    
,@FirstName varchar(50) = ''    
,@LastName varchar(50) = ''    
,@CurrencyCode varchar(10) = ''    
,@BasicFare  decimal(18,2) = 0     
,@TaxYR   decimal(18,2) = 0     
,@TaxYQ   decimal(18,2) = 0      
,@TaxIN   decimal(18,2) = 0     
,@TaxK3   decimal(18,2) = 0     
,@TaxAF decimal(18,2) = 0      
,@TaxP2   decimal(18,2) = 0    
,@TaxWO   decimal(18,2) = 0    
,@GBTax   decimal(18,2) = 0   
,@CPTax   decimal(18,2) = 0   
,@UBTax  decimal(18,2) = 0      
,@CMFTax   decimal(18,2) = 0   
,@COMMTax   decimal(18,2) = 0   
,@COMMBFTax   decimal(18,2) = 0    
,@RCSTax decimal(18,2) = 0    
,@RCFTax decimal(18,2) = 0    
,@RFTax decimal(18,2) = 0    
,@TaxXT decimal(18,2) = 0     
,@TaxTotal decimal(18,2) = 0   
,@TaxQ decimal(18,2) = 0   
,@TotalFare decimal(18,2) = 0   
,@NetFare decimal(18,2) = 0     
,@FOP varchar(20) = ''    
,@TourCodeDealCode varchar(50) = ''    
,@PurchaseCurrency varchar(20) = ''    
,@SectorName varchar(max) = ''    
,@FlightNo varchar(max) = ''    
,@Class varchar(max) = ''   
,@DateOfTravel varchar(max) = ''    
,@BookingIdentification varchar(10) = ''    
,@FromCity varchar(20) = ''    
,@ToCity varchar(20) = ''    
,@CardType varchar(50) = ''    
,@IATACode varchar(50) = ''  
,@TravelEndDate varchar(max) = ''   
,@GlobalDimension2Code varchar(50) = ''    
,@PurchExchangeRate varchar(50) = ''     
,@PurchaseCurrency1 varchar(10) = ''    
,@CreatedBy varchar(50) = ''   
as                                            
begin      
      
insert into tblReissueUploaderDetails      
(      
       [TopUpCr]    
      ,[Issue Date]    
      ,[Customer No]    
      ,[Ship-to Customer No]    
      ,[Customer Location Code]        
      ,[Ticket Type]    
      ,[Agent ID]    
      ,[PNR No]    
      ,[Airline Code]          
      ,[Ticket No]    
      ,[Pax Type]    
      ,[First Name]    
      ,[Last Name]    
      ,[Currency Code]    
      ,[Basic Fare]    
      ,[Tax YR]    
      ,[Tax YQ]    
      ,[Tax IN]    
      ,[Tax K3]    
      ,[Tax AF]    
      ,[Tax P2]    
      ,[Tax WO]    
      ,[GB Tax]    
      ,[CP Tax]    
      ,[UB Tax]    
      ,[CMF Tax]    
      ,[COMM Tax]    
      ,[COMMBF Tax]    
      ,[RCS Tax]    
      ,[RCF Tax]    
      ,[RF Tax]    
      ,[Tax XT]    
      ,[Tax Total]    
      ,[Tax Q]    
      ,[Total Fare]         
      ,[Net Fare]    
      ,[FOP]          
      ,[Tour Code/Deal Code]    
      ,[Purchase Currency]          
      ,[Sector Name]    
      ,[Flight No]    
      ,[Class]    
      ,[Date Of Travel]    
      ,[BookingIdentification]    
      ,[FromCity]    
      ,[ToCity]          
      ,[CardType]    
      ,[IATA Code]          
      ,[Travel End Date]         
      ,[Global Dimension 2 Code]         
      ,[Purch Exchange Rate]    
      ,[Purchase Currency1]    
      ,[Created By]     
)      
values      
(      
      @TopUpCr    
 ,@IssueDate    
 ,@CustomerNo    
 ,@ShiptoCustomerNo    
 ,@CustomerLocationCode    
 ,@TicketType    
 ,@AgentID    
 ,@PNRNo    
 ,@AirlineCode    
 ,@TicketNo    
 ,@PaxType    
 ,@FirstName    
 ,@LastName    
 ,@CurrencyCode    
 ,@BasicFare    
 ,@TaxYR    
 ,@TaxYQ    
 ,@TaxIN    
 ,@TaxK3    
 ,@TaxAF    
 ,@TaxP2    
 ,@TaxWO    
 ,@GBTax    
 ,@CPTax    
 ,@UBTax    
 ,@CMFTax    
 ,@COMMTax    
 ,@COMMBFTax    
 ,@RCSTax    
 ,@RCFTax    
 ,@RFTax    
 ,@TaxXT    
 ,@TaxTotal    
 ,@TaxQ    
 ,@TotalFare    
 ,@NetFare    
 ,@FOP   
 ,@TourCodeDealCode  
 ,@PurchaseCurrency    
 ,@SectorName    
 ,@FlightNo    
 ,@Class    
 ,@DateOfTravel    
 ,@BookingIdentification    
 ,@FromCity    
 ,@ToCity    
 ,@CardType    
 ,@IATACode    
 ,@TravelEndDate    
 ,@GlobalDimension2Code    
 ,@PurchExchangeRate    
 ,@PurchaseCurrency1     
 ,@CreatedBy     
 )      
 select SCOPE_IDENTITY();                   
 end      