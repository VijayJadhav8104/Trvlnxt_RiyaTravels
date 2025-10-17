
CREATE PROC [dbo].[CMS_JobCRUD]
@OperationType VARCHAR(50)=NULL,
@Id INT =NULL,
@JobTitile NVARCHAR(MAX)=NULL,
@Location VARCHAR(MAX)=NULL,
@JobDescription NVARCHAR(MAX)=NULL,
@CreatedBy VARCHAR(800)=NULL,
@UpdatedBy VARCHAR(800)=NULL,
@IsActive BIT=NULL,
@Status int=null out
AS
BEGIN
		SET @Status=0

		BEGIN
			IF @OperationType='Select'
			BEGIN
				SELECT Id,
					   JobTitle,
					   Location,
					   JobDescription 
					FROM CMS_JobListing 
						where IsActive=1
			END

			IF @OperationType='SelectById'
			BEGIN
				SELECT Id,
					   JobTitle,
					   Location,
					   JobDescription 
					FROM CMS_JobListing 
						where IsActive=1
							AND 
								Id=@Id
			END

			IF @OperationType='Create'
			BEGIN
				INSERT INTO CMS_JobListing
				(
					JobTitle,
					Location,
					JobDescription,
					CreatedBy,
					CreatedDate,
					IsActive
				)
				VALUES
				(
					@JobTitile,
					@Location,
					@JobDescription,
					@CreatedBy,
					GETDATE(),
					1
				)
				SET @Status=1
			END

			IF @OperationType='Update'
			BEGIN
				IF EXISTS(SELECT Id FROM CMS_JobListing WHERE Id=@Id)
				BEGIN
					UPDATE CMS_JobListing
					SET
						JobTitle=@JobTitile,
						Location=@Location,
						JobDescription=@JobDescription,
						UpdatedDate=GETDATE(),
						UpdatedBy=@UpdatedBy
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
				IF EXISTS(SELECT Id FROM CMS_JobListing WHERE Id=@Id)
				BEGIN
					UPDATE CMS_JobListing
					SET
						IsActive=0
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
    ON OBJECT::[dbo].[CMS_JobCRUD] TO [rt_read]
    AS [dbo];

