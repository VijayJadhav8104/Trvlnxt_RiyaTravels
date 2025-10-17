
/****** Object:  StoredProcedure [dbo].[insertCancellCharges]    Script Date: 5/4/2017 5:05:49 PM ******/
CREATE PROCEDURE [dbo].[InsertPseudoCityCode]
	@airlineID varchar(5)=null,
	@PseudoCode varchar(16)=null,
	@opr int = 0,
	@adminID bigint,
	@ID int
AS
BEGIN
	if(@opr=0)
	Begin
		IF NOT EXISTS(SELECT * FROM [PseudoCityCode] WHERE AirlineCode = @airlineID)
			Begin
				INSERT INTO [dbo].[PseudoCityCode]([AirlineCode] ,[PseudoCode],InsertTime,IsActive,userId)
				VALUES(@airlineID, @PseudoCode ,getdate(),1, @adminID)

				SELECT 1;
			End
		else
			Begin
				UPDATE [dbo].[PseudoCityCode]
				SET IsActive = 0, modifiedDate=GETDATE(),ModifiedBy=@adminID
				where AirlineCode = @airlineID

				INSERT INTO [dbo].[PseudoCityCode]([AirlineCode],[PseudoCode],InsertTime,IsActive,userId)
					VALUES(@airlineID, @PseudoCode ,getdate(),1,@adminID)

				SELECT 1;
			End
	End	
	else
		Begin
			UPDATE [dbo].[PseudoCityCode]
			SET IsActive=0 ,modifiedDate=GETDATE(),ModifiedBy=@adminID
			WHERE  PKID= @ID

			SELECT 4
		End
		
END









GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertPseudoCityCode] TO [rt_read]
    AS [dbo];

