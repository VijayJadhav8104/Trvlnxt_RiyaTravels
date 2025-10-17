-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[UpdateZatcaPush]
	@Uuid varchar(100),
	@InvoiceNo varchar(100),
	@RequestXML varchar(MAX),
	@SignedXML varchar(MAX),
	@Response varchar(MAX),
	@Hash varchar(MAX),
	@QrCode varchar(MAX),
	@Sequence bigint = 0,
	@Status int = 0,
	@CreatedBy bigint = 0
AS
BEGIN
	
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
	IF EXISTS (SELECT 1 FROM Invoice.ZatcaPushCompareLog WHERE InvoiceNo = @InvoiceNo)
		BEGIN

		  
			UPDATE [Invoice].[ZatcaPushCompareLog]
			   SET [InvoiceNo] = @InvoiceNo
				  ,[Status] = @Status
				  ,[ModifiedDate] = GETDATE()
				  ,[ModifiedBy] = @CreatedBy
			 WHERE InvoiceNo = @InvoiceNo

			 UPDATE [Invoice].[ZatcaPushLog]
				SET [Uuid] = @Uuid
					,[InvoiceNo] = @InvoiceNo
					,[RequestXML] = @RequestXML
					,[SignedXML] = @SignedXML
					,[Response] = @Response
					,[Hash] = @Hash
					,[QrCode] = @QrCode
					,[Sequence] = @Sequence
					,[IsPushed] = @Status
					,[ModifiedDate] = GETDATE()
				WHERE InvoiceNo = @InvoiceNo

		END
	ELSE
		BEGIN

		DECLARE @FK_ID BIGINT;

		INSERT INTO [Invoice].[ZatcaPushCompareLog]
           ([InvoiceNo]
           ,[Status]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[ModifiedDate]
           ,[ModifiedBy])
		 VALUES
			   (@InvoiceNo
			   ,@Status
			   ,GETDATE()
			   ,@CreatedBy
			   ,GETDATE()
			   ,@CreatedBy)

		SELECT @FK_ID = SCOPE_IDENTITY()

		INSERT INTO [Invoice].[ZatcaPushLog]
           ([Fk_Id]
           ,[Uuid]
           ,[InvoiceNo]
           ,[RequestXML]
           ,[SignedXML]
           ,[Response]
           ,[Hash]
		   ,[QrCode]
		   ,[Sequence]
           ,[IsPushed]
           ,[CreatedDate]
           ,[ModifiedDate])
		 VALUES
			   (@FK_ID
			   ,@Uuid
			   ,@InvoiceNo
			   ,@RequestXML
			   ,@SignedXML
			   ,@Response
			   ,@Hash
			   ,@QrCode
			   ,@Sequence
			   ,@Status
			   ,GETDATE()
			   ,GETDATE())

		END
COMMIT TRANSACTION;

END
