CREATE PROC [dbo].[GetJobTitleAndRole]
@Id INT=NULL
AS
BEGIN
		BEGIN
			IF @Id is not null
			BEGIN
				select JobTitle,Location from CMS_JobListing
				where Id=@Id
			END
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetJobTitleAndRole] TO [rt_read]
    AS [dbo];

