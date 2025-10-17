CREATE PROCEDURE [dbo].[RTTBilling_InsertPaymentDetails]
	@order_id varchar(30)
	,@order_status varchar(30) = NULL
	,@payment_mode varchar(250) = NULL
	,@currency char(3) = NULL
	,@amount varchar(30) = NULL
	,@mer_amount varchar(30) = NULL
	,@type varchar(10)='Flight'
AS
BEGIN

	BEGIN TRY
	BEGIN TRANSACTION
		IF NOT EXISTS(SELECT PKID FROM [Paymentmaster] WHERE order_id=@order_id)
		BEGIN
			INSERT INTO [dbo].[Paymentmaster]( [order_id]
			,[order_status]
			,[payment_mode]
			,[currency]
			,[amount]
			,[mer_amount]
			,Type
			,OriginalStatus )
			VALUES (@order_id
			,@order_status
			,@payment_mode
			,@currency
			,@amount
			,@mer_amount
			,@type
			,@order_status)
   
			INSERT INTO [dbo].[Paymentissuance]([Tracking_Id],[Amount],[OrderId],[Status],Type) 
			VALUES(NULL,@amount,@order_id,@order_status,@type)
		END
		ELSE
		BEGIN
			UPDATE Paymentmaster SET order_status =  @order_status WHERE order_id=@order_id
		
			INSERT INTO [dbo].[Paymentissuance]([Tracking_Id],[Amount],[OrderId],[Status],Type) 
			VALUES(NULL,@amount,@order_id,@order_status,@type)
		END
	COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000),@ErrorSeverity INT, @ErrorState INT;
 
		SELECT @ErrorMessage = ERROR_MESSAGE(),
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE();
		RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
	ROLLBACK TRANSACTION
END CATCH
END