      
CREATE PROCEDURE [TR].[RiyaTravels_TR_BookingMaster_Insert_2]                                  
(                                                            
	@CorrelationId varchar(max) =null,                                  
	@ProviderConfirmationNumber varchar(50) =null,                                  
	@TripStartDate datetime =null,                                  
	@TripStartTime  varchar(100) =null,                                  
	@TripEndDate datetime =null,                                  
	@PickupLocation varchar(100) =null,                                  
	@DropOffLocation varchar(100) =null,                                  
	@RoundTrip int =null,                                  
	@ChannelId varchar(50) =null,                                  
	@accountId varchar(50) =null,                                  
	@providerName varchar(50) =null,                                  
	@providerId varchar(50) =null,                                  
	@ProviderCancellationNumber varchar(50) =null,                                     
	@modifiedDate datetime =null,                                  
	@SupplierRate decimal(10,2) =null,                                  
	@SupplierCurrency varchar(50) =null,                                  
	@BookingRate float =null,                                  
	@BookingCurrency varchar(50) =null,                                  
	@AgentID int =null,                                  
	@MainAgentID int =null,                                  
	@SubMainAgntId int =null,                                  
	@PaymentMode int =null,                                  
	@CityName varchar(50) =null,                                  
	@Cust_Id varchar(50) =null,                                  
	@BookingStatus varchar(50) =null,                                     
	@AmountBeforePgCommission float =null,                                  
	@AmountAfterPgCommision float =null,                                      
	@PGStatus varchar(50)=null,                                  
	@VoucherUrl varchar(max) =null,                                            
	@ReversalStatus bit =null,                                  
	@MakePaymentReversalFlag varchar(200) =null,                                  
	@MakePaymentReversalStatus varchar(200) =null,                                  
	@MakePaymentReversalMessage varchar(max) =null,                                  
	@CancellationDate datetime =null,   
	@Dest_CancellationDateTime DATETIME =null,
	@EstimatedTime varchar(50) =null,                                  
	@CategoryVehicleType varchar(50) =null,                                  
	@Remark varchar(500) =null,                                  
	@CancellationDeadline datetime =null,                                  
	@SupplierCancellationDate datetime =null,                                  
	@CityCode varchar(50) =null,                                  
	@CountryCode varchar(50) =null,                                  
	@ROEValue float =null,                                  
	@Markup varchar(50) =null,                                    
	@AgentCanxCharges decimal(18,2) =null,                                  
	@SupplierCanxCharges decimal(18,2) =null,                    
	@CancellationRemark varchar(400) =null,                                  
	@CancellationPolicyText text =null,                                   
	@SupplierCanxAgentChrge decimal(18,2) =null,                                  
	@PostCancellationCharges varchar(100) =null,                                  
	@FinalROE float =null,                                  
	@ServiceCharges float =null,                                  
	@TotalServiceCharges float =null,                                  
	@SupplierChargesPer float =null,                                  
	@SupplierCharges float =null,                  
	@PricingProfile float=null,                
	@ServiceCharge decimal =null,                
	@SupplierCharge decimal =null,                
	@GSTServiceCharge decimal =null,                
	@ModeOfCancellation varchar(50) =null,                                  
	@CancelledBy varchar(50) =null,                                  
	@GSTAmountOnServiceCharges float =null,                                  
	@GSTOnServiceCharges float =null,                                  
	@FinalRoeMarkup varchar(50) =null,                                  
	@FileNo varchar(50) =null,                                  
	@OBTCNo varchar(50) =null,                                  
	@InquiryNo varchar(50) =null,                  
	@AccRemark varchar(50) =null,                                  
	@OpsRemark varchar(50) =null,                                
	@TotalAdult int =null,                                  
	@TotalChildren int =null,                                  
	@ProviderContactNumber varchar(20) =null,                    
	@BillingSettledBy varchar(50) =null,                                  
	@CorporatePANVerificatioStatus varchar(50) =null,                                  
	@DocumentURL varchar(max) =null,                                 
	@FlightCode varchar(500) =null,                                  
	@SpecialRequests varchar(500) =null,                       
	@FlightArrivalTime varchar(500) =null,                                
	@PickupInfo varchar(max) =null,                             
	@Refundable bit =null ,                          
	@Luggage int =null,                          
	@TotalLuggage int =null,                     
	@AgentDiscountPrice decimal(10,2) =null,                    
	@AgentCurrencyCode varchar(50) =null,                    
	@AgentROE varchar(50) =null,                    
	@AgentFinalROE varchar(50) =null,                    
	@ROEMarkup varchar(50) =null,                  
	@SupplierDiscountPrice decimal(10,2) =null,                   
	@SupplierToInrRoe varchar(50) =null,                   
	@SupplierToFinalRoe varchar(50) =null,                   
	@RoeMarkupInr varchar(50) =null,                   
	@CommissionPercent decimal(10,2)=0,                    
	@CommissionAmount decimal(10,2) =0,          
	@AgentServiceFee decimal(18, 2) = 0,          
	@AgentServiceFeeRealTime decimal(18, 2) = 0,        
	@RiyaUserRealTimeServiceFee decimal(18, 2) = 0,        
	@GSTOnRiyaUsereRealTimeServiceFee decimal(18, 2) = 0,        
                      
	--BookedCar parameters                                  
	@Carcode varchar(50) =null,                                  
	@CarName varchar(500) =null,                                  
	@CarDesc text =null,                                  
	@PricingPackageType varchar(50) =null,                                  
	@SessionId varchar(50) =null,                                 
	@CarDetailJson text =null,                           
	@VehicleImage varchar(100),                 
                  
	--PAX/Passengers Details                                    
	@Titel varchar(10) = null,                                  
	@Name varchar(50) = null,                                  
	@Surname varchar(50) = null,                                  
	@Age varchar(50) = null,                                  
	@Type varchar(50) = null,                                  
	@PancardNo varchar(50) = null,                                  
	@PassportNumber varchar(50) = null,                                  
	@DateOfBirth datetime = null,                                  
	@PassportIssueDate datetime = null,                                  
	@PassportExpirationDate datetime = null,                                  
	@Nationality varchar(500) = null,                                  
	@IssuingCountry int = null,                                  
	@PanCardName varchar(50) = null,             
	@TotalPax int = 0,                                
	@Contact varchar(50) = null,                                
	@Email varchar(50) = null,                              
	@NationalityValue int = null,                              
	@NationalityCode int = null,                            
	@Distance numeric(10,3) = null,                            
	@EndTrip date = null,              
	@ChildSeat int = 0,              
	@Children1Age int = 0,              
	@Children2Age int = 0,            
	@ChildAge varchar(max) = '',      
	@ClientIP varchar(100) = '',    
	@AgentToInrRoe varchar(50) = null,    
	@AgentToInrFinalRoe varchar(50) = null,    
	@InrToSupplierRoe varchar(50) =null,                   
	@InrToSupplierFinalRoe varchar(50) =null ,
	@mustCheckPickupTime BIT=0,
	@CheckPickupURL  NVARCHAR(200) =null,
	@hoursBeforeConsulting INT=0,
	@SupplierEmergencyNumber  NVARCHAR(20)=null
  )                                                
AS                                  
BEGIN                                          
    BEGIN TRANSACTION;                                                          
    BEGIN TRY                                   
  -- INSERT TR_BookingMaster INSERT                                  
  DECLARE @BookingNumber varchar(max)                                  
  DECLARE @BookingRefId varchar(max)                                   
  SET @BookingRefId =  CAST(NEXT VALUE FOR UniqueNumberSeqTransfer as varchar)                                      
  SET @BookingRefId='TNC'+RIGHT(REPLICATE('0', 7) + CAST(@BookingRefId AS NVARCHAR(50)), 7)                                            
  DECLARE @IBookingdentity INT;                                  
        INSERT INTO [TR].[TR_BookingMaster]                              
           (                                  
			[BookingRefId]                                  
			,[CorrelationId]                                  
			,[ProviderConfirmationNumber]                                  
			,[TripStartDate]                                  
			,[TripStartTime]                                  
			,[TripEndDate]                                  
			,[PickupLocation]                                  
			,[DropOffLocation]                                  
			,[RoundTrip]                                  
			,[ChannelId]                                  
			,[accountId]                                  
			,[providerName]                                  
			,[providerId]                                  
			,[ProviderCancellationNumber]                                  
			,[creationDate]                                  
			,[modifiedDate]                                  
			,[SupplierRate]                                  
			,[SupplierCurrency]                                  
			,[BookingRate]                                  
			,[BookingCurrency]                                  
			,[AgentID]                                  
			,[MainAgentID]                                  
			,[SubMainAgntId]                                  
			,[PaymentMode]                                  
			,[CityName]                                     
			,[Cust_Id]                                  
			,[BookingStatus]                                        
			,[AmountBeforePgCommission]                                  
			,[AmountAfterPgCommision]                                       
			,[PGStatus]                                  
			,[VoucherUrl]                                        
			,[ReversalStatus]                                  
			,[MakePaymentReversalFlag]                                  
			,[MakePaymentReversalStatus]                                  
			,[MakePaymentReversalMessage]                                  
			,[CancellationDate]                                      
			,[EstimatedTime]                                  
			,[CategoryVehicleType]                                  
			,[Remark]                                  
			,[CancellationDeadline]                                  
			,[SupplierCancellationDate]                                  
			,[CityCode]                                  
			,[CountryCode]                                  
			,[ROEValue]                                  
			,[Markup]                                       
			,[AgentCanxCharges]                 
			,[PricingProfile]                                  
			,[ServiceCharge]                                       
			,[SupplierCharge]                                  
			,[GSTServiceCharge]                
			,[SupplierCanxCharges]                 
			,[CancellationRemark]                                  
			,[CancellationPolicyText]                                
			,[SupplierCanxAgentChrge]                                  
			,[PostCancellationCharges]                                  
			,[FinalROE]                                  
			,[ServiceCharges]                                  
			,[TotalServiceCharges]                                  
			,[SupplierChargesPer]                                   
			,[SupplierCharges]                                  
			,[ModeOfCancellation]                                  
			,[CancelledBy]                                  
			,[GSTAmountOnServiceCharges]                                  
			,[GSTOnServiceCharges]                                  
			,[FinalRoeMarkup]                                  
			,[FileNo]                                  
			,[OBTCNo]                                  
			,[InquiryNo]                                  
			,[AccRemark]                                  
			,[OpsRemark]                                 
			,[TotalAdult]                                  
			,[TotalChildren]                                  
			,[ProviderContactNumber]                                 
			,[BillingSettledBy]                                  
			,[CorporatePANVerificatioStatus]                                  
			,[DocumentURL]                                       
			,[FlightCode]                                  
			,[SpecialRequests]                                  
			,[FlightArrivalTime]                              
			,[PickInfo]                          
			,[Refundable]                     
			,[AgentDiscountPrice]                    
			,[AgentCurrencyCode]                    
			,[AgentROE]                    
			,[AgentFinalROE]                    
			,[ROEMarkup]                   
			,[SupplierDiscountPrice]                  
			,[SupplierToInrRoe]                  
			,[SupplierToFinalRoe]                  
			,[RoeMarkupInr]                  
			,[CommissionPercent]                    
			,[CommissionAmount]              
			,[ChildSeat]              
			,[Children1Age]              
			,[Children2Age]              
			,[ChildAge]        
			,[AgentServiceFee]        
			,[AgentServiceFeeRealTime]        
			,[RiyaUserRealTimeServiceFee]        
			,[GSTOnRiyaUsereRealTimeServiceFee]       
			,[ClientIP]      
			,[AgentToInrRoe]    
			,[AgentToInrFinalRoe]    
			,[InrToSupplierRoe]    
			,[InrToSupplierFinalRoe] 
			,[mustCheckPickupTime]
			,[CheckPickupURL]
			,[hoursBeforeConsulting]
			,[SupplierEmergencyNumber]
			,[Dest_CancellationDateTime]
			)                                 
  VALUES                                  
           (                                  
			@BookingRefId,                                  
			@CorrelationId,                                  
			@ProviderConfirmationNumber,                                  
			@TripStartDate,                                  
			@TripStartTime,                                  
			@TripEndDate,                                  
			@PickupLocation,                                  
			@DropOffLocation,                                  
			@RoundTrip,                                  
			@ChannelId,                                  
			@accountId,                                  
			@providerName,                                  
			@providerId,                                 
			@ProviderCancellationNumber,                                  
			getdate(),                                  
			@modifiedDate,                                  
			@SupplierRate,                                  
			@SupplierCurrency,                                  
			@BookingRate,                                  
			@BookingCurrency,                          
			@AgentID,                                  
			@MainAgentID,                                  
			@SubMainAgntId,                                  
			@PaymentMode,                                  
			@CityName,                                     
			@Cust_Id,                                  
			@BookingStatus,                                
			@AmountBeforePgCommission,                                  
			@AmountAfterPgCommision,                                  
			@PGStatus,                                  
			@VoucherUrl,                                  
			@ReversalStatus,                                  
			@MakePaymentReversalFlag,                                  
			@MakePaymentReversalStatus,                                  
			@MakePaymentReversalMessage,                                 
			@CancellationDate,                                  
			@EstimatedTime,                                  
			@CategoryVehicleType,                                  
			@Remark,                                  
			@CancellationDeadline,            
			@SupplierCancellationDate,                                  
			@CityCode,                                  
			@CountryCode,                                  
			@ROEValue,                                  
			@Markup,                                
			@AgentCanxCharges,                 
			@PricingProfile ,                
			@ServiceCharge ,                
			@SupplierCharge ,                
			@GSTServiceCharge,                
			@SupplierCanxCharges,                  
			@CancellationRemark,                                  
			@CancellationPolicyText,                                  
			@SupplierCanxAgentChrge,                                  
			@PostCancellationCharges,                                  
			@FinalROE,                                  
			@ServiceCharges,                                  
			@TotalServiceCharges,                                  
			@SupplierChargesPer,                                  
			@SupplierCharges,                                  
			@ModeOfCancellation,                                  
			@CancelledBy,                                  
			@GSTAmountOnServiceCharges,                           
			@GSTOnServiceCharges,                                  
			@FinalRoeMarkup,                                  
			@FileNo,                                  
			@OBTCNo,                                  
			@InquiryNo,                                  
			@AccRemark,                                  
			@OpsRemark,                                
			@TotalAdult,                                  
			@TotalChildren,                                  
			@ProviderContactNumber,                                  
			@BillingSettledBy,                                  
			@CorporatePANVerificatioStatus,                                  
			@DocumentURL,                                  
			@FlightCode,                                  
			@SpecialRequests,                                  
			@FlightArrivalTime,                              
			@PickupInfo ,                          
			@Refundable,                     
			@AgentDiscountPrice,                    
			@AgentCurrencyCode,                    
			@AgentROE,                    
			@AgentFinalROE,                    
			@ROEMarkup,                   
			@SupplierDiscountPrice,                   
			@SupplierToInrRoe ,                   
			@SupplierToFinalRoe,                   
			@RoeMarkupInr ,                   
			@CommissionPercent,                    
			@CommissionAmount,              
			@ChildSeat,              
			@Children1Age,              
			@Children2Age,              
			@ChildAge,        
			@AgentServiceFee,        
			@AgentServiceFeeRealTime,        
			@RiyaUserRealTimeServiceFee,        
			@GSTOnRiyaUsereRealTimeServiceFee,      
			@ClientIP,    
			@AgentToInrRoe,    
			@AgentToInrFinalRoe,    
			@InrToSupplierRoe,    
			@InrToSupplierFinalRoe,
			@mustCheckPickupTime,
			@CheckPickupURL,
			@hoursBeforeConsulting ,
			@SupplierEmergencyNumber,
			@Dest_CancellationDateTime
          )                                                             
        SET @IBookingdentity = SCOPE_IDENTITY();                                                                
        IF @IBookingdentity IS NOT NULL AND @IBookingdentity != 0                                  
        BEGIN                                  
  -- INSERT TR_BookedCars INSERT WITH REFERENCE TO BookingId                                  
  DECLARE @IdentityCarId INT;                           
  INSERT INTO [TR].[TR_BookedCars]                                  
           (                                  
      [BookingId]                                  
     ,[Carcode]                          
     ,[CarName]                                  
     ,[CarDesc]                                  
     ,[BookingStatus]                                  
     ,[PricingPackageType]                                  
     ,[SessionId]                                         
     ,[CarDetailJson]                            
     ,[Distance]                          
        ,[VehicleImage]                          
        ,[Luggage]                          
        ,[TotalLuggage]                          
           )                                  
        VALUES                                  
           (                                  
     @IBookingdentity,                                  
     @Carcode,                               
     @CarName,                              
     @CarDesc,                                  
     @BookingStatus,                                  
     @PricingPackageType,                                  
     @SessionId,                                  
     @CarDetailJson,                            
     @Distance,                          
     @VehicleImage,                          
     @Luggage,                          
     @TotalLuggage                          
           )                                                   
  SET @IdentityCarId = SCOPE_IDENTITY();                                                    
  -- INSERT TR_PaxDetails INSERT WITH REFERENCE TO BookingId & CarId                                  
  DECLARE @IdentityPaxDetailsId INT;                                  
  INSERT INTO [TR].[TR_PaxDetails]                                  
           (                                  
      [CarId]                                  
     ,[BookingId]                                  
     ,[Titel]                                  
     ,[Name]                                  
     ,[Surname]                                  
     ,[Age]                                  
     ,[Type]                                  
     ,[PancardNo]                                  
     ,[PassportNumber]                                  
     ,[DateOfBirth]                                  
     ,[PassportIssueDate]                                  
     ,[PassportExpirationDate]                                  
     ,[Nationality]                                  
     ,[IssuingCountry]                                      
     ,[TotalPax]                                  
     ,[PanCardName]                                
     ,[Contact]                                
     ,[Email]                              
     ,[NationalityValue]                              
     ,[NationalityCode]                            
    )                                  
        VALUES                                  
          (                                  
     @IdentityCarId,                                  
     @IBookingdentity,                                  
     @Titel,                 
     @Name,                                  
     @Surname,                                  
     @Age,                                  
     @Type,                                  
     @PancardNo,                                  
     @PassportNumber,                                  
     @DateOfBirth,                                  
     @PassportIssueDate,                                  
     @PassportExpirationDate,                                  
     @Nationality,                                  
     @IssuingCountry,                                     
     @TotalPax,                                  
     @PanCardName,                                
     @Contact,                                
     @Email,                              
     @NationalityValue,                              
     @NationalityCode                            
    )                                                    
        Select BookingRefId,AgentID,BookingId from [TR].[TR_BookingMaster]  where BookingRefId = @BookingRefId                          
  and AgentID = @AgentID;                                              
        END                                          
        -- Commit the transaction if everything is successful                                 
        COMMIT TRANSACTION;                                  
    END TRY                                  
    BEGIN CATCH                 ROLLBACK TRANSACTION;                                     
        THROW;                                  
    END CATCH                                  
END;