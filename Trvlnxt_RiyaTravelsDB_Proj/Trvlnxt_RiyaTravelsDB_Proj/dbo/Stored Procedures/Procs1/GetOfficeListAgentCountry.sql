

CREATE PROCEDURE GetOfficeListAgentCountry
@CompanyName VARCHAR(10) = null ,
@OfficeId varchar(20)
AS	
BEGIN
	SELECT * FROM tblAmadeusOfficeID
	WHERE CrypticCompanyName=@CompanyName and OfficeID=@OfficeId
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetOfficeListAgentCountry] TO [rt_read]
    AS [dbo];

