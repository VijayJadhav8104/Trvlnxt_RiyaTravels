
CREATE proc [dbo].[GetJobListing]
@Location varchar(800)=null,
@Role varchar(800)=null
AS
BEGIN
		BEGIN
				IF @Location IS NOT NULL AND @Role IS NOT NULL
				BEGIN
					SELECT JobTitle,Location,JobDescription FROM CMS_JobListing
					WHERE 
						Location=@Location
						AND 
						JobTitle=@Role
				END
		END
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetJobListing] TO [rt_read]
    AS [dbo];

