CREATE proc [dbo].[GetAllRolesBasedOnLoc]
@Loc varchar(800)=null
AS
BEGIN
		BEGIN
			SELECT Id,JobTitle FROM CMS_JobListing WHERE Location=@Loc AND IsActive=1
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAllRolesBasedOnLoc] TO [rt_read]
    AS [dbo];

