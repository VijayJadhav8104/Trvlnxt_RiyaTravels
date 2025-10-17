-- =============================================
-- Author:		WS Hardik
-- Create date: 03.11.2022
-- Description:	Get Product Class by Airline
-- =============================================
CREATE PROCEDURE [dbo].[AirlineProductClass_GetByAirline]
	@Airline Varchar(5)
	,@ProductClass Varchar(5)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 ProductClassCombition FROM AirlineProductClass 
	WHERE Airline = @Airline 
	AND ProductClass = @ProductClass

END
