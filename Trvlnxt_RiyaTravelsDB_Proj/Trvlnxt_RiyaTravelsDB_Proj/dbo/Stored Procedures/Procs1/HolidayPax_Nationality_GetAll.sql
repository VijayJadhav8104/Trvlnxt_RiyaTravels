-- =============================================
-- Author:		Hardik
-- Create date: 13.09.2023
-- Description:	Get Holiday Pax Nationality
-- =============================================
CREATE PROCEDURE HolidayPax_Nationality_GetAll
	
AS
BEGIN
	SET NOCOUNT ON;

    SELECT Nationality_Id, Nationality_Name FROM HolidayPax_Nationality
END