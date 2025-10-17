-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[UpdatePaymentDetails]
	@IV_NO varchar(100) = NULL,
	@ORDER_ID varchar(100) = NULL,
	@PAYMENT_MODE varchar(100) = NULL,
	@IV_AMT_INR decimal(19,2) = 0,
	@TRAN_AMT decimal(19,2) = 0,
	@CREATED_BY varchar(100) = NULL,
	@Module varchar(50) = NULL,
	@Currency varchar(50) = NULL
AS
BEGIN
	
	INSERT INTO [Invoice].[Payment]
           ([IV_NO]
           ,[ORDER_ID]
           ,[PAYMENT_MODE]
           ,[IV_AMT_INR]
           ,[TRAN_AMT]
           ,[CREATED_BY]
		   ,[Module]
		   ,[Currency])
     VALUES
           (@IV_NO
           ,@ORDER_ID
           ,@PAYMENT_MODE
           ,@IV_AMT_INR
           ,@TRAN_AMT
           ,@CREATED_BY
		   ,@Module
		   ,@Currency)

END
