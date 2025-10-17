-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Invoice].[AddUpdateOutstanding_WY]
	@Code varchar(100) = NULL,
	@OutStanding decimal(18,2) = 0,
	@Closing decimal(18,2) = 0
AS
BEGIN
	
	IF EXISTS(select 1 from Invoice.Outstanding_WY where Code = @Code)
	BEGIN
		UPDATE [Invoice].[Outstanding_WY]
		SET Outstanding = @OutStanding,
		Closing = @Closing,
		ModifiedDate = GETDATE()
		WHERE Code = @Code
	END
	ELSE
	BEGIN
		INSERT INTO [Invoice].[Outstanding_WY]
			   ([Code]
			   ,[Outstanding]
			   ,[Closing]
			   ,[ModifiedDate])
		 VALUES
			   (@Code
			   ,@OutStanding
			   ,@Closing
			   ,GETDATE())
	END
	
END
