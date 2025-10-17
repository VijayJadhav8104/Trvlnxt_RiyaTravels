
CREATE PROCEDURE GetOfficeList
@CompanyName VARCHAR(10) = null 
AS	
BEGIN
	SELECT * FROM tblAmadeusOfficeID
	WHERE CrypticCompanyName=@CompanyName
END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetOfficeList] TO [rt_read]
    AS [dbo];

