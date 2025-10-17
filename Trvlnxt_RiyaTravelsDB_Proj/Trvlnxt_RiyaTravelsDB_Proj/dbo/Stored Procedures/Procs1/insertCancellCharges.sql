
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[insertCancellCharges]
	-- Add the parameters for the stored procedure here
	@airlineID varchar(20)=null,
	@amount int=null,
	@disID bigint,
	@adminID bigint,
	@opr int = 0,
	@CancellationChargeType int=null
	
AS
BEGIN

	If(@airlineID='All')
		BEGIN
			update [CancellationCharges]	set status='D',[modifiedDate]=getdate(),ModifiedBy=@adminID ;

			INSERT INTO [dbo].[CancellationCharges]([AirCode],[amount],[insert_date],[userId],status,CancellationChargeType)
			select [AirlineCode],@amount ,getdate(),@adminID,'A',@CancellationChargeType from dbo.AirlineCode_Console

			select 3
		END
	ELSE
		BEGIN
			if(@opr=0)	
				BEGIN
					IF NOT EXISTS(SELECT * FROM [CancellationCharges] WHERE [AirCode] = @airlineID  )
						BEGIN
							INSERT INTO [dbo].[CancellationCharges]([AirCode],[amount],[insert_date],[userId],CancellationChargeType)
							VALUES(@airlineID,@amount ,getdate(),@adminID,@CancellationChargeType )

							select 1;
						END
					ELSE
						BEGIN
							UPDATE [dbo].[CancellationCharges]
							SET status = 'D',[modifiedDate]=GETDATE(),ModifiedBy=@adminID
							where [AirCode] = @airlineID


							INSERT INTO [dbo].[CancellationCharges]([AirCode],[amount],[insert_date],[userId],status,CancellationChargeType )
							VALUES (@airlineID, @amount ,getdate(),@adminID,'A',@CancellationChargeType )

							select 1;
						END
				END
			ELSE
				BEGIN
					UPDATE [dbo].[CancellationCharges]
					--SET [AirCode] = @airlineID
					--   ,[amount] = @amount
					set  status='D', [modifiedDate]=getdate(),ModifiedBy = @adminID
					WHERE Pk_Id=@disID

					select 4
				END	
		END
END








GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[insertCancellCharges] TO [rt_read]
    AS [dbo];

