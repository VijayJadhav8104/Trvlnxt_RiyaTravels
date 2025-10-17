CREATE PROCEDURE [SS].[SP_Insert_BookingMaster_BACKUP_Ravi]
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
		@Markup float = null
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
			SET @BookingRefId = 'TNS' + FORMAT(CAST(REPLACE(REPLACE(@BookingRefId, 'TNA', ''), 'TNS', '') AS INT) + 1,'0000000')

	END

	--INSERT INTO [SS].[SS_BookingMaster]
	--	(BookingRefId)

	--	VALUES
	--	('35465t')

	INSERT INTO [SS].[SS_BookingMaster]
		(BookingRefId, CorrelationId, ProviderConfirmationNumber, TripStartDate, TripEndDate, 
			ChannelId, accountId, providerName, providerId, ProviderCancellationNumber, 
			creationDate, SupplierRate, SupplierCurrency, BookingRate, BookingCurrency, AgentID, MainAgentID, SubMainAgntId,
			PaymentMode, CityName, PassengerEmail, PassengerPhone, BookingStatus, AmountBeforePgCommission, AmountAfterPgCommision, RateId, RefName, Email, OBTCNumber, Titel, Name, Surname, Age, CancellationDeadline, SupplierCancellationDate, CityCode, CountryCode, ROEValue, Markup)
     VALUES
		(@BookingRefId, @CorrelationId, @ProviderConfirmationNumber, @TripStartDate, @TripEndDate, 
			@ChannelId, @accountId, @providerName, @providerId, @ProviderCancellationNumber, 
			GETDATE(), @SupplierRate, @SupplierCurrency, @BookingRate, @BookingCurrency, @AgentID, @MainAgentID, @SubMainAgntId,
			@PaymentMode, @CityName, @PassengerEmail, @PassengerPhone, 'In process', @AmountBeforePgCommission, @AmountAfterPgCommision, @RateId, @RefName, @Email, @OBTCNumber, @Titel, @Name, @Surname, @Age, @CancellationDeadline, @SupplierCancellationDate, @CityCode, @CountryCode, @ROEValue, @Markup)

	SET @BookingId  =(select  SCOPE_IDENTITY())   

	INSERT INTO [SS].[SS_Status_History]                        
		(BookingId, FkStatusId, CreateDate, CreatedBy, IsActive, MainAgentId)
	VALUES
		(@BookingId, '10', SYSDATETIME(), @AgentId, 1, @MainAgentid)   
	                           
	SELECT @BookingId AS BookingId ,@BookingRefId AS BookingRefId
END
