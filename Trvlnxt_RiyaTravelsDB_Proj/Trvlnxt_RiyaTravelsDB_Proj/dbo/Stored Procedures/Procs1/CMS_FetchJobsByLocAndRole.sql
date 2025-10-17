CREATE PROC [dbo].[CMS_FetchJobsByLocAndRole]
@Loc varchar(800)=null,
@Role varchar(800)=null
AS
BEGIN
		BEGIN
			SELECT 
				J.Id,
				J.Location,
				J.JobDescription,
				J.JobTitle
			FROM CMS_JobListing J
			where
			(J.Location like '%'+ @Loc +'%' or @Loc is null OR @Loc='')
			 AND
			(J.JobTitle like '%'+ @Role +'%' or @Role is null OR @Role='')
			AND
			J.IsActive=1
		END
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_FetchJobsByLocAndRole] TO [rt_read]
    AS [dbo];

