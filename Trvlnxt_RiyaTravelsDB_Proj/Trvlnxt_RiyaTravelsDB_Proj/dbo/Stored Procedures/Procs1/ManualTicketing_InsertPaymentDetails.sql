CREATE PROCEDURE [dbo].[ManualTicketing_InsertPaymentDetails]
	@order_id varchar(30)
	,@tracking_id varchar(50) = NULL
	,@bank_ref_no varchar(max) = NULL
	,@order_status varchar(30) = NULL
	,@failure_message varchar(max) = NULL
	,@payment_mode varchar(250) = NULL
	,@payment_gatewaymode varchar(50)=null   
	,@card_name varchar(max) = NULL
	,@status_code varchar(10) = NULL
	,@status_message varchar(150) = NULL
	,@currency char(3) = NULL
	,@amount varchar(30) = NULL
	,@billing_name varchar(60) = NULL
	,@billing_address varchar(150) = NULL
	,@billing_city varchar(30) = NULL
	,@billing_state varchar(30) = NULL
	,@billing_zip varchar(15) = NULL
	,@billing_country varchar(50) = NULL
	,@billing_tel varchar(20) = NULL
	,@billing_email varchar(70) = NULL
	,@vault char(1) = NULL
	,@offer_type varchar(9) = NULL
	,@offer_code varchar(30) = NULL
	,@discount_value varchar(30) = NULL
	,@mer_amount varchar(30) = NULL
	,@eci_value varchar(30) = NULL
	,@retry char(1) = NULL
	,@response_code varchar(30) = NULL
	,@riyaPNR varchar(20) = NULL
	,@billing_notes varchar(max) = NULL
	,@getway_name varchar(50) = NULL
	,@type varchar(10)='Flight'
	,@card_number  varchar(50) = NULL
	,@ExpDate varchar(50) = NULL
	,@CVV varchar(50) = NULL
	,@CardType varchar(50) = NULL
	,@Country varchar(50) = NULL
	,@Paymentgateway varchar(50) = NULL
	,@Encardnumber  varchar(max) = NULL
	,@EnExpDate  varchar(max) = NULL
	,@EnCVV  varchar(max) = NULL
	,@AuthCode varchar(50) = NULL
	,@MerchantId varchar(50) = NULL
	,@BankAccountNumber varchar(20) = NULL
	,@AirlinePaymentCardNumber varchar(50) = NULL
	,@AirlinePaymentCardType varchar(50) = NULL
	,@AirlinePaymentCardOwner varchar(50) = NULL
AS
BEGIN

	BEGIN TRY
	BEGIN TRANSACTION
		IF NOT EXISTS(SELECT PKID FROM [Paymentmaster] WHERE order_id=@order_id)
		BEGIN
			DECLARE @MaskCardNumber varchar(50)=''

			IF(@card_number IS NOT NULL OR @card_number!='')
			BEGIN
				SET @MaskCardNumber=('XXXXXXXXXXXX'  + SUBSTRING(@card_number,len(@card_number)-3,len(@card_number)))
			END

			IF(@card_number IS NOT NULL OR @card_number!='') AND (@payment_mode='passThrough')
			BEGIN
				SELECT @card_number=('XXXXXXXXXXXX'  + SUBSTRING(@card_number,len(@card_number)-3,len(@card_number)))
			END

			IF ((@MaskCardNumber IS NULL OR @MaskCardNumber = '') AND UPPER(@payment_mode)='CHECK')
			BEGIN
				SET @MaskCardNumber = 'XXXXXXXXXXXX' + @AirlinePaymentCardNumber
			END

			INSERT INTO [dbo].[Paymentmaster]( [order_id]
			,[tracking_id]
			,[bank_ref_no]
			,[order_status]
			,[failure_message]
			,[payment_mode]   
			,[payment_gatewaymode]
			,[card_name]
			,[status_code]
			,[status_message]
			,[currency]
			,[amount]
			,[billing_name]
			,[billing_address]
			,[billing_city]
			,[billing_state]
			,[billing_zip]
			,[billing_country]
			,[billing_tel]
			,[billing_email]
			,[vault]
			,[offer_type]
			,[offer_code]
			,[discount_value]
			,[mer_amount]
			,[eci_value]
			,[retry]
			,[response_code]
			,[riyaPNR]
			,[billing_notes]
			,[getway_name]  
			,Type
			,Country
			,PaymentGateway
			,CardNumber
			,ExpiryDate
			,CVV
			--,CardType
			,OriginalStatus  
			,EnCardNumber
			,EnExpiryDate
			,EnCVV
			,MaskCardNumber
			,AuthCode   
			,[MerchantId]
			,[BankAccountNo]
			,[AirlinePaymentCardNumber]
			,[AirlinePaymentCardType]
			,[AirlinePaymentCardOwner]
			,CardConfigurationType
			,CardType)
			VALUES (@order_id
			,@tracking_id
			,@bank_ref_no
			,@order_status
			,@failure_message
			,@payment_mode
			,@payment_gatewaymode   
			,@card_name
			,@status_code
			,@status_message
			,@currency
			,@amount
			,@billing_name
			,@billing_address
			,@billing_city
			,@billing_state
			,@billing_zip
			,@billing_country
			,@billing_tel
			,@billing_email
			,@vault
			,@offer_type
			,@offer_code
			,@discount_value
			,@mer_amount
			,@eci_value
			,@retry
			,@response_code
			,@riyaPNR
			,@billing_notes
			,@getway_name
			,@type
			,@Country
			,@Paymentgateway
			,''
			,@ExpDate 
			,@CVV
			--,@CardType 
			,@order_status
			,@Encardnumber
			,@EnExpDate
			,@EnCVV
			,@MaskCardNumber
			,@AuthCode
			,@MerchantId
			,@BankAccountNumber
			,@AirlinePaymentCardNumber
			,(CASE WHEN @AirlinePaymentCardType = '-1' THEN NULL ELSE @AirlinePaymentCardType END)
			,(CASE WHEN @AirlinePaymentCardOwner = '-1' THEN NULL ELSE @AirlinePaymentCardOwner END)
			,(CASE WHEN @AirlinePaymentCardOwner = '-1' THEN NULL ELSE @AirlinePaymentCardOwner END) -- CardConfigurationType
			,(CASE WHEN @AirlinePaymentCardType = '-1' THEN NULL ELSE @AirlinePaymentCardType END)) -- CardType
   
			INSERT INTO [dbo].[Paymentissuance]([Tracking_Id],[Amount],[OrderId],[Status],Type) 
			VALUES(@tracking_id,@amount,@order_id,@order_status,@type)
		END
		ELSE
		BEGIN
			UPDATE Paymentmaster SET order_status =  @order_status WHERE order_id=@order_id
		
			INSERT INTO [dbo].[Paymentissuance]([Tracking_Id],[Amount],[OrderId],[Status],Type) 
			VALUES(@tracking_id,@amount,@order_id,@order_status,@type)
		END
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT, @ErrorState INT;
 
		SELECT @ErrorMessage = ERROR_MESSAGE(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE();

		-- Add Error Log 08.08.2023 by Hardik
		INSERT INTO [AllAppLogs].[dbo].mExceptionDetails (PageName,MethodName,ParameterList,GDSPNR,ExceptionMessage,StackTrace,Details,ExceptionDate)  
		VALUES ('ManualTicketing_InsertPaymentDetails','ManualTicketing_InsertPaymentDetails'
		,'Manual Ticketing',@order_id,@ErrorMessage,CONVERT(VARCHAR(50), @ErrorSeverity),CONVERT(VARCHAR(50), @ErrorState),GETDATE()) 

		RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
	ROLLBACK TRANSACTION
END CATCH
END