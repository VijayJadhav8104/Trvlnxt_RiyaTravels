CREATE proc [dbo].[spGetLocAndRoleAndDescr]
AS
BEGIN
		BEGIN
			SELECT Distinct Location FROM CMS_JobListing where IsActive=1 --for location				
			select Distinct Id,Jobtitle FROM CMS_JobListing where IsActive=1-- for Job role

			SELECT 
				Id,
				Location,
				JobDescription,
				JobTitle 			
				FROM 
				CMS_JobListing where IsActive=1 --for listing	
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spGetLocAndRoleAndDescr] TO [rt_read]
    AS [dbo];

