CREATE PROCEDURE [dbo].[Sp_GetPassengerProfile] -- '9967198413','','',''      
	@ContactNo nvarchar(30)=null,  
	@Email nvarchar(30)=null,
	@CHILD varchar(20)=null,
	@INFANT varchar(20)=null,
	@CountryCode varchar(20)=null
AS  
BEGIN

	IF (@CountryCode IS NOT NULL AND @CountryCode != '')
	BEGIN
		SET @CountryCode = LTRIM(@CountryCode)
	END

	IF (@ContactNo!='' and @Email!='')
	begin    
		SELECT DISTINCT    
		PaxType ,      
		UPPER(PaxFname) AS PaxFname,      
		UPPER(PaxLname) AS PaxLname,      
		UPPER(PassportNum) AS PassportNum,     
		convert(varchar(12),PassExp,106) AS PassExp,      
		CONVERT(VARCHAR,(CONVERT(DATE,DateOfBirth,106)),106) AS DateOfBirth,      
		Title,      
		Nationality,      
		PassportIssueCountry,
		Gender,      
		ContactNo,      
		Email,      
		PassportIssueCountryCode,      
		NationaltyCode      
		from mPassengerProfile 
		WHERE ((ContactNo = @ContactNo OR ContactNo = ('+' + @CountryCode + '-' + @ContactNo)) and Email=@Email ) 
		and (PaxType=@CHILD or PaxType=@INFANT or PaxType='ADULT')

		UNION 

		select   DISTINCT    
		PaxType ,      
		UPPER(PaxFname) AS PaxFname,      
		UPPER(PaxLname) AS PaxLname,      
		UPPER(PassportNum) AS PassportNum,     
		convert(varchar(12),PassExp,106) AS PassExp,      
		CONVERT(VARCHAR,(CONVERT(DATE,DateOfBirth,106)),106) AS DateOfBirth,      
		Title,      
		Nationality,      
		PassportIssueCountry,
		Gender,      
		ContactNo,      
		Email,      
		PassportIssueCountryCode,      
		NationaltyCode      
		from mPassengerProfile 
		WHERE(ContactNo = @ContactNo 
         OR ContactNo = (CASE WHEN @CountryCode IS NULL THEN '' ELSE '+' + @CountryCode + '-' + @ContactNo END))
         AND (PaxType = @CHILD OR PaxType = @INFANT OR PaxType = 'ADULT')
          
	    AND NOT EXISTS (
        -- Check if the first query returns any row
        SELECT 1
        FROM mPassengerProfile
        WHERE 
            (ContactNo = @ContactNo 
             OR ContactNo = (CASE WHEN @CountryCode IS NULL THEN '' ELSE '+' + @CountryCode + '-' + @ContactNo END))
            AND Email = @Email
            AND (PaxType = @CHILD OR PaxType = @INFANT OR PaxType = 'ADULT')) 

			
		UNION 

		select   DISTINCT    
		PaxType ,      
		UPPER(PaxFname) AS PaxFname,      
		UPPER(PaxLname) AS PaxLname,      
		UPPER(PassportNum) AS PassportNum,     
		convert(varchar(12),PassExp,106) AS PassExp,      
		CONVERT(VARCHAR,(CONVERT(DATE,DateOfBirth,106)),106) AS DateOfBirth,      
		Title,      
		Nationality,      
		PassportIssueCountry,
		Gender,      
		ContactNo,      
		Email,      
		PassportIssueCountryCode,      
		NationaltyCode      
		from mPassengerProfile 
		WHERE   Email = @Email
        AND (PaxType = @CHILD OR PaxType = @INFANT OR PaxType = 'ADULT')
	    AND NOT EXISTS (
        -- Check if the first query returns any row
        SELECT 1
        FROM mPassengerProfile
        WHERE 
            (ContactNo = @ContactNo 
             OR ContactNo = (CASE WHEN @CountryCode IS NULL THEN '' ELSE '+' + @CountryCode + '-' + @ContactNo END))
            AND Email = @Email
            AND (PaxType = @CHILD OR PaxType = @INFANT OR PaxType = 'ADULT')) 

	end    
	else    
	begin     
		SELECT DISTINCT    
		PaxType,      
		UPPER(PaxFname) AS PaxFname,      
		UPPER(PaxLname) AS PaxLname,      
		UPPER(PassportNum) AS PassportNum,      
		convert(varchar(12),PassExp,106) AS PassExp,      
		CONVERT(VARCHAR,(CONVERT(DATE,DateOfBirth,106)),106) AS DateOfBirth,      
		Title,      
		Nationality,      
		PassportIssueCountry,
		Gender,      
		ContactNo,      
		Email,      
		PassportIssueCountryCode,      
		NationaltyCode      
		from mPassengerProfile 
		where (ContactNo = @ContactNo OR ContactNo = '+' + @CountryCode + '-' + @ContactNo OR @ContactNo = '')
		and ( Email=@Email or @Email='' ) 
		and (PaxType=@CHILD or PaxType=@INFANT or PaxType='ADULT')      
	END    
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetPassengerProfile] TO [rt_read]
    AS [dbo];

