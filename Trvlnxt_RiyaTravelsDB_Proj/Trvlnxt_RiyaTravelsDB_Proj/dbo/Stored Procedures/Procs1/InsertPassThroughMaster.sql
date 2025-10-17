
CREATE proc [dbo].[InsertPassThroughMaster]
@OperationType varchar(50),
@Id int=null,
@AirlineName varchar(200)=null,
@Percentage nvarchar(max)=null,
@FairType varchar(800)=null,
@Status int out
AS
BEGIN
		SET @Status=0

		BEGIN
			IF @OperationType='Create'
			BEGIN
				INSERT INTO PassThroughMaster
				(
					AirlineName,
					Percentage,
					FairType,
					CreatedDate
				)
				VALUES
				(
					@AirlineName,
					@Percentage,
					@FairType,
					GETDATE()
				)

				SET @Status=1
			END

			IF @OperationType='Update'
			BEGIN
				IF EXISTS(SELECT Id FROM PassThroughMaster WHERE Id=@Id)
				BEGIN
					UPDATE PassThroughMaster
					SET
						AirlineName=@AirlineName,
						Percentage=@Percentage,
						FairType=@FairType
					WHERE
						Id=@Id

					SET @Status=1
				END
				ELSE
				BEGIN
					SET @Status=0
				END
			END

			IF @OperationType='Delete'
			BEGIN
				IF EXISTS(SELECT Id FROM PassThroughMaster WHERE Id=@Id)
				BEGIN
					DELETE FROM PassThroughMaster					
					WHERE
						Id=@Id

					SET @Status=1
				END
				ELSE
				BEGIN
					SET @Status=0
				END
			END
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[InsertPassThroughMaster] TO [rt_read]
    AS [dbo];

