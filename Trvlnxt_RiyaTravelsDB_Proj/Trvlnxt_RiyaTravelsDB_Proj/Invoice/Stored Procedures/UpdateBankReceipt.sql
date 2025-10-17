-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[UpdateBankReceipt]
	@OrderId varchar(100),
	@Amount decimal(19,2) = 0,
	@Currency varchar(50),
    @BankRefId varchar(100),
    @Url varchar(max),
	@ApprovedBy bigint = 0,
    @Status varchar(max),
    @Module varchar(100),
    @CreatedBy bigint,
    @ModifiedBy bigint,
    @ModifiedDate datetime,
	@Id bigint = 0
AS
BEGIN
	
	IF @Id > 0
	BEGIN
		
		UPDATE [Invoice].[BankReceipts]
		SET [Status] = @Status,
		ApprovedBy = @ApprovedBy,
		ModifiedBy = @ModifiedBy
		WHERE Id = @Id

	END
	ELSE
	BEGIN
		
		INSERT INTO [Invoice].[BankReceipts]
           ([OrderId]
		   ,[Amount]
		   ,[Currency]
           ,[BankRefId]
           ,[Url]
		   ,[ApprovedBy]
           ,[Status]
           ,[Module]
           ,[CreatedBy]
           ,[ModifiedBy]
           ,[ModifiedDate])
     VALUES
           (@OrderId
		   ,@Amount
		   ,@Currency
           ,@BankRefId
           ,@Url
		   ,@ApprovedBy
           ,@Status
           ,@Module
           ,@CreatedBy
           ,@ModifiedBy
           ,@ModifiedDate)

	END
	
END
