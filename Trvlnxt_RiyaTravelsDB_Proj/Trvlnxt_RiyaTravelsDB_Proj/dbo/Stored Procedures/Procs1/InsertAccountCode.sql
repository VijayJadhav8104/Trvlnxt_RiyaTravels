
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertAccountCode]
	@airlineID varchar(20)=null,
	@AccountName varchar(20)=null,
	@opr int = 0,
	@adminID int,
	@ID int
AS
BEGIN
	IF(@opr=0)
	BEGIN
		IF NOT EXISTS(SELECT * FROM [AccountCode] WHERE AirCode = @airlineID)
			BEGIN
				INSERT INTO [dbo].[AccountCode](AirCode ,AccountName,InsertedDate,InsertedBy,Status)
				VALUES(@airlineID, @AccountName ,getdate(),@adminID,1 )

				SELECT 1;
			END
		ELSE
			BEGIN
				UPDATE [dbo].[AccountCode]
				SET Status = 0, modifiedDate=GETDATE(),ModifiedBy=@adminID
				WHERE AirCode = @airlineID


				INSERT INTO [dbo].[AccountCode](AirCode,AccountName,InsertedDate,InsertedBy,Status)
				VALUES(@airlineID, @AccountName ,getdate(),@adminID,1)

				SELECT 1;
			END
	END	
	ELSE
		BEGIN
			UPDATE [dbo].[AccountCode]
			SET Status=0,ModifiedDate=GETDATE(),ModifiedBy=@adminID
			WHERE  AccountID= @ID

			SELECT 2
		END
		
END









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertAccountCode] TO [rt_read]
    AS [dbo];

