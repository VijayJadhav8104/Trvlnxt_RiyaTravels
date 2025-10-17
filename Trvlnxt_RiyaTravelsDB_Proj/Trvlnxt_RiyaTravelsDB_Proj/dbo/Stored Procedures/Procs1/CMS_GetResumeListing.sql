
CREATE Proc [dbo].[CMS_GetResumeListing]
@OperationType VARCHAR(50)=NULL,
@Id  INT=NULL,
@FromDate DATETIME=NULL,
@ToDate DATETIME=NULL,
@FullName VARCHAR(800)=NULL,
@Phone VARCHAR(800)=NULL,
@CurrentLoc VARCHAR(800)=NULL,
@PreferredLoc VARCHAR(800)=NULL
AS
BEGIN
		BEGIN
			IF @OperationType='Select'
			BEGIN
					SELECT 
					R.Id,
					R.FullName,
					R.Email,
					R.Phone,
					R.CurrentCompany,
					R.CurrentLocation,
					R.PreferredLoc,
					R.Gender,
					R.COVERINGLETTER,
					R.Resumes,
					J.JobTitle,R.CreatedDate
					FROM tblResumeMaster R
					INNER JOIN 
					CMS_JobListing J
					ON 
						R.Id=J.Id
					ORDER BY R.Id DESC
			END

			IF @OperationType='SelectById'
			BEGIN
					SELECT 
					R.Id,
					R.FullName,
					R.Email,
					R.Phone,
					R.CurrentCompany,
					R.CurrentLocation,
					R.PreferredLoc,
					R.Gender,
					R.COVERINGLETTER,
					R.Resumes
						FROM tblResumeMaster R
						INNER JOIN 
						CMS_JobListing J
						ON 
							R.Id=J.Id
							where
							R.Id=@Id

			END

			IF @OperationType='Search'
			BEGIN
				SELECT 
					R.Id,
					R.FullName,
					R.Email,
					R.Phone,
					R.CurrentCompany,
					R.CurrentLocation,
					R.PreferredLoc,
					R.Gender,
					R.COVERINGLETTER,
					R.Resumes,
					J.JobTitle,R.CreatedDate
					FROM tblResumeMaster R
					INNER JOIN 
					CMS_JobListing J
					ON 
						R.Id=J.Id
					WHERE
					(
						(CONVERT(date,R.CreatedDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL)
						AND 
						(CONVERT(date,r.CreatedDate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL)
					)
					AND
					(R.FullName like '%'+ @FullName +'%' or @FullName is null OR @FullName='')
					AND
					(R.Phone=@Phone or @Phone is null OR @Phone='')
					AND
					(R.CurrentLocation like '%'+ @CurrentLoc +'%' or @CurrentLoc is null or @CurrentLoc='')
					AND
					(R.PreferredLoc like '%'+ @PreferredLoc +'%' or @PreferredLoc is null or @PreferredLoc='')
			END
		END
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[CMS_GetResumeListing] TO [rt_read]
    AS [dbo];

