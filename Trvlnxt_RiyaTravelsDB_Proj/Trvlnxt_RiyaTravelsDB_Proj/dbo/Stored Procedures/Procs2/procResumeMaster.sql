
CREATE PROC [dbo].[procResumeMaster]
@JobId int=NULL,
@Title varchar(50)=NULL,
@FirstName varchar(300)=NULL,
@LastName varchar(300)=NULL,
@Gender varchar(50)=NULL,
@CurrentCompany varchar(800)=NULL,
@NetSalary varchar(800)=NULL,
@GrossSalary varchar(800)=NULL,
@CurrentLocation varchar(800)=NULL,
@PreferredLoc  varchar(800)=NULL,
@ExpectedSal varchar(800)=NULL,
@Resumes nvarchar(max)=NULL,
@Email varchar(max)=NULL,
@Phone varchar(800)=NULL,
@LinkedInURL VARCHAR(MAX)=NULL,
@PortfolioURL VARCHAR(MAX)=NULL,
@COVERINGLETTER VARCHAR(MAX)=NULL
AS
BEGIN
		BEGIN
			INSERT INTO tblResumeMaster
			(
				Id,	
				Title,	
				FirstName,
				LastName,
				Gender,	
				CurrentCompany,
				NetSalary,
				GrossSalary,
				CurrentLocation,
				PreferredLoc,
				ExpectedSal,	
				Resumes,
				FullName,
				Email,
				Phone,				
				LinkedInURL,
				PortfolioURL,
				COVERINGLETTER,
				CreatedDate
			)
			VALUES
			(
				@JobId,
				@Title,	
				@FirstName,
				@LastName,
				@Gender,	
				@CurrentCompany,
				@NetSalary,
				@GrossSalary,
				@CurrentLocation,
				@PreferredLoc,
				@ExpectedSal,	
				@Resumes,
				@FirstName+SPACE(1)+@LastName,
				@Email,
				@Phone,
				@LinkedInURL,
				@PortfolioURL,
				@COVERINGLETTER,
				GETDATE()
			)
		END
END





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[procResumeMaster] TO [rt_read]
    AS [dbo];

