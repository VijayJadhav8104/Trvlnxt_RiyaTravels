
CREATE PROCEDURE [dbo].[GetGSTData]
@RiyaPNR		VARCHAR(20)
AS BEGIN

	SELECT TOP 1 [RegistrationNumber], [CompanyName], [CAddress], [CState], [CContactNo], [CEmailID] 
	FROM tblBookMaster 
	WHERE riyaPNR = @RiyaPNR


END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetGSTData] TO [rt_read]
    AS [dbo];

