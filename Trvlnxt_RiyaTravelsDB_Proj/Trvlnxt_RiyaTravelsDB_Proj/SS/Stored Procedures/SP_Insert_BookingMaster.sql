CREATE PROCEDURE [SS].[SP_Insert_BookingMaster]                                        
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
@RiyaSubUserId int = null,              
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
@FinalRoeMarkup varchar(50) = null ,                          
@SupplierCancellationChargesLocalCurrency float  = 0.00,                          
@SupplierCancellationChargesSupplierCurrency float = 0.00,                          
@AgentCancellationCharges float = 0.00,              
@BookingSource varchar(50) = null,              
@TotalAdult int=0,              
@TotalChildren int=0,              
@ProviderContactNumber varchar(20) = null,        
@LocalProviderName varchar(20) = null,       
@BillingSettledBy varchar(20) = null,      
@DocumentUrl varchar(Max) = null,      
@CorporatePANVerificatioStatus varchar(20) = null,  
@ClientIP varchar(100) = '',
@AdditionalBillingSettledBy varchar(50) = ''
AS                                        
BEGIN           
 SET NOCOUNT ON;                                        
 DECLARE @BookingId INT                                                     
 IF @BookingRefId = ''                                         
 BEGIN                     
 SET @BookingRefId = (SELECT TOP 1 BookingRefId FROM [SS].[SS_BookingMaster] WITH(NOLOCK) ORDER BY BookingId DESC)                                        
 IF(ISNULL(@BookingRefId,'') = '')                                        
  SET @BookingRefId = 'TNS0000001'                                        
 ELSE                                      
  SET @BookingRefId = 'TNA' + FORMAT(CAST(REPLACE(REPLACE(@BookingRefId, 'TNS', ''), 'TNA', '') AS INT) + 1,'0000000')                                                                  
 END                                                                            
 INSERT INTO [SS].[SS_BookingMaster]                                        
 (  
  BookingRefId, CorrelationId, ProviderConfirmationNumber, TripStartDate, TripEndDate, ChannelId,   
  accountId, providerName, providerId, ProviderCancellationNumber, creationDate, SupplierRate,   
  SupplierCurrency, BookingRate, BookingCurrency, AgentID, MainAgentID, SubMainAgntId, RiyaSubUserId,                                       
  PaymentMode, CityName, PassengerEmail, PassengerPhone, BookingStatus, AmountBeforePgCommission,   
  AmountAfterPgCommision, RateId, RefName, Email, OBTCNumber, Titel, Name, Surname, Age, CancellationDeadline,   
  SupplierCancellationDate, CityCode, CountryCode, ROEValue, Markup, CancellationPolicyText, totalPax,  
  ServiceCharges, TotalServiceCharges, FinalROE, SupplierChargesPer, SupplierCharges, GSTAmountOnServiceCharges,                            
  GSTOnServiceCharges, FinalRoeMarkup, SupplierCanxCharges, SupplierCanxAgentChrge, AgentCanxCharges,  
  BookingSource, TotalAdult, TotalChildren, ProviderContactNumber, LocalProviderName, BillingSettledBy,  
  DocumentUrl, CorporatePANVerificatioStatus, ClientIP, AdditionalBillingSettledBy  
 )                                        
    VALUES                                        
                                             
  (@BookingRefId, @CorrelationId, @ProviderConfirmationNumber, @TripStartDate, @TripEndDate,                                     
   @ChannelId, @accountId, @providerName, @providerId, @ProviderCancellationNumber,                                         
   GETDATE(), @SupplierRate, @SupplierCurrency, @BookingRate, @BookingCurrency, @AgentID, @MainAgentID, @SubMainAgntId, @RiyaSubUserId,                                       
   @PaymentMode, @CityName, @PassengerEmail, @PassengerPhone, 'In Process', @AmountBeforePgCommission, @AmountAfterPgCommision, @RateId, @RefName, @Email, @OBTCNumber, @Titel, @Name, @Surname, @Age, @CancellationDeadline, @SupplierCancellationDate,      
   
    
      
        
          
            
                         
   @CityCode ,                                   
 @CountryCode, @ROEValue, @Markup, @CancellationPolicyText,@totalPax,@ServiceCharges, @TotalServiceCharges,@FinalROE ,@SupplierChargesper,@SupplierCharges,@GSTAmountOnServiceCharges,                            
  @GSTOnServiceCharges,                            
  @FinalRoeMarkup,@SupplierCancellationChargesLocalCurrency, @SupplierCancellationChargesSupplierCurrency,@AgentCancellationCharges,@BookingSource,@TotalAdult,@TotalChildren,@ProviderContactNumber,@LocalProviderName,@BillingSettledBy,@DocumentUrl,@CorporatePANVerificatioStatus,@ClientIP, @AdditionalBillingSettledBy)                         
                   
                         
                         
 SET @BookingId  =(select  SCOPE_IDENTITY())                                           
       
                        
                        
                        
                      
 INSERT INTO [SS].[SS_Status_History]                                                                
  (BookingId, FkStatusId, CreateDate, CreatedBy, IsActive, MainAgentId)                                        
 VALUES     
  (@BookingId, '10', SYSDATETIME(), @AgentId, 1, @MainAgentid)                                           
                                                                    
 SELECT @BookingId AS BookingId ,@BookingRefId AS BookingRefId                       
                      
                   
END 