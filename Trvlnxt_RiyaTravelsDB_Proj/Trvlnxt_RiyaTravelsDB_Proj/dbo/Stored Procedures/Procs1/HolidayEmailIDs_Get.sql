-- =============================================
-- Author:		WS Hardik
-- Create date: 02.01.2024
-- Description:	Get Holiday Email
-- =============================================
CREATE PROCEDURE HolidayEmailIDs_Get
	@Country Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @EmailID Varchar(150)

    SELECT TOP 1 @EmailID = ISNULL(EmailID, '') FROM HolidayEmailIDs WHERE Country = @Country AND IsActive = 1

	SELECT @EmailID
END
