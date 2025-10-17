CREATE PROCEDURE [SS].[SP_Insert_BookingMaster_Dummy]                  
  @BookingRefId varchar(50) = null,                  
        @CorrelationId varchar(MAX) = null,                  
        @ProviderConfirmationNumber varchar(50) = null,                  
        @TripStartDate datetime = null,                  
        @TripEndDate datetime = null,                  
        @ChannelId varchar(50) = null,                  
        @accountId varchar(50) = null,                  
        @providerName varchar(50) = null,                  
        @providerId varchar(50) = null,                   
        @ProviderCancellationNumber varchar(50) = null,                  
        @SupplierRate float = null,                  
  @SupplierCurrency varchar(50) = null,                  
        @BookingRate float = null,                  
  @BookingCurrency varchar(50) = null,                  
        @AgentID int = null,                  
        @MainAgentID int = null,                   
  @SubMainAgntId int = null,                  
        @PaymentMode int = null,                  
        @CityName varchar(50) = null,                  
        @PassengerEmail varchar(50) = null,                  
        @PassengerPhone varchar(20) = null,                  
  @AmountBeforePgCommission float = null,                  
  @AmountAfterPgCommision float = null,                  
  @RateId varchar(50) = null,                  
  @RefName varchar(50) = null,                  
  @Email varchar(50) = null,                  
  @OBTCNumber varchar(50) = null,                  
  @Titel varchar(10) = null,                  
  @Name varchar(50) = null,                  
  @Surname varchar(50) = null,                  
  @Age varchar(50) = null,                  
  @CancellationDeadline datetime = null,                  
  @SupplierCancellationDate datetime = null,                  
  @CityCode varchar(50) = null,                  
  @CountryCode varchar(50) = null,                  
  @ROEValue float = null,                  
  @Markup float = null,                  
  @CancellationPolicyText text = null ,            
  @totalPax int=0 ,        
  @TotalServiceCharges float = 0.00,        
  @SupplierChargesper float = 0.00,        
  @ServiceCharges float = 0.00,        
  @FinalROE float = 0.00 ,      
  @SupplierCharges float =0.00,      
  @GSTAmountOnServiceCharges float = 0.00,      
  @GSTOnServiceCharges float = 0.00,      
  @FinalRoeMarkup float = 0.00 ,    
  @SupplierCancellationChargesLocalCurrency float  = 0.00,    
  @SupplierCancellationChargesSupplierCurrency float = 0.00,    
  @AgentCancellationCharges float = 0.00    
        
AS                  
BEGIN                  
 SET NOCOUNT ON;                  
 DECLARE @BookingId INT                   
           
 -- ('35465t')                  
         BEGIN TRY                  
 IF @BookingRefId = ''                   
 BEGIN                  
  SET @BookingRefId = (SELECT TOP 1 BookingRefId FROM [SS].[SS_BookingMaster] WITH(NOLOCK) ORDER BY BookingId DESC)                  
  IF(ISNULL(@BookingRefId,'') = '')                  
   SET @BookingRefId = 'TNS0000001'                  
  ELSE                  
    SET @BookingRefId = 'TNA' + FORMAT(CAST(REPLACE(REPLACE(@BookingRefId, 'TNS', ''), 'TNA', '') AS INT) + 1,'0000000')                 
                  
 END                  
                  
 --INSERT INTO [SS].[SS_BookingMaster]                  
 -- (BookingRefId)                  
                  
 -- VALUES                
 INSERT INTO [SS].[SS_BookingMaster]                  
  (BookingRefId, CorrelationId, ProviderConfirmationNumber, TripStartDate, TripEndDate,                   
   ChannelId, accountId, providerName, providerId, ProviderCancellationNumber,                   
   creationDate, SupplierRate, SupplierCurrency, BookingRate, BookingCurrency, AgentID, MainAgentID, SubMainAgntId,                  
   PaymentMode, CityName, PassengerEmail, PassengerPhone, BookingStatus, AmountBeforePgCommission, AmountAfterPgCommision, RateId, RefName, Email, OBTCNumber, Titel, Name, Surname, Age, CancellationDeadline, SupplierCancellationDate, CityCode, CountryCode      
,                          
 ROEValue, Markup, CancellationPolicyText,totalPax   ,ServiceCharges,TotalServiceCharges,FinalROE,SupplierChargesPer,SupplierCharges,GSTAmountOnServiceCharges,      
  GSTOnServiceCharges,      
  FinalRoeMarkup,SupplierCanxCharges,SupplierCanxAgentChrge)                  
     VALUES                  
                       
  (@BookingRefId, @CorrelationId, @ProviderConfirmationNumber, @TripStartDate, @TripEndDate,               
   @ChannelId, @accountId, @providerName, @providerId, @ProviderCancellationNumber,                   
   GETDATE(), @SupplierRate, @SupplierCurrency, @BookingRate, @BookingCurrency, @AgentID, @MainAgentID, @SubMainAgntId,                  
   @PaymentMode, @CityName, @PassengerEmail, @PassengerPhone, 'In process', @AmountBeforePgCommission, @AmountAfterPgCommision, @RateId, @RefName, @Email, @OBTCNumber, @Titel, @Name, @Surname, @Age, @CancellationDeadline, @SupplierCancellationDate,           
   @CityCode ,             
 @CountryCode, 
 @ROEValue, 
 @Markup, 
 @CancellationPolicyText,
 @totalPax,
 @ServiceCharges,
 @TotalServiceCharges,
 @FinalROE ,
 @SupplierChargesper,
 @SupplierCharges,
 @GSTAmountOnServiceCharges,      
 @GSTOnServiceCharges,      
 @FinalRoeMarkup,
 @SupplierCancellationChargesLocalCurrency, 
 @SupplierCancellationChargesSupplierCurrency
 )                  
   
   
 SET @BookingId  =(select  SCOPE_IDENTITY())                     

  
  
  

 INSERT INTO [SS].[SS_Status_History]                                          
  (BookingId, FkStatusId, CreateDate, CreatedBy, IsActive, MainAgentId)                  
 VALUES                  
  (@BookingId, '10', SYSDATETIME(), @AgentId, 1, @MainAgentid)                     
                                              
 SELECT @BookingId AS BookingId ,@BookingRefId AS BookingRefId 
   END TRY
 BEGIN CATCH

  INSERT INTO [AllAppLogs].[DBO].[tbltrackErrorLog]
  SELECT
  'SightSeeingBookingInsert','SightSeeingInsert',
  CONCAT(ERROR_NUMBER(), '-',ERROR_STATE(),'-',ERROR_SEVERITY(),'-',ERROR_PROCEDURE(),'-',ERROR_LINE() ,'-',ERROR_MESSAGE())
   ,'','',GETDATE(),@CorrelationId
	
 
 END CATCH
END 