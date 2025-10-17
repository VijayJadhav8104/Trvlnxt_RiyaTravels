CREATE PROC [dbo].[CMS_CareerMailContent]
@Id int=null
AS
BEGIN
		BEGIN
			IF @Id is not null
			BEGIN
				SELECT 
					J.JobTitle,
					R.FullName,
					R.Phone,
					R.Email,
					r.CurrentLocation,
					r.PreferredLoc,
					R.CurrentCompany,
					R.NetSalary,
					R.GrossSalary,
					R.LinkedInURL,
					R.PortfolioURL

					FROM 
						tblResumeMaster R,CMS_JobListing J
						WHERE 
							R.Id=J.Id
							AND
							R.Id=@Id
			END
		END
END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_CareerMailContent] TO [rt_read]
    AS [dbo];

