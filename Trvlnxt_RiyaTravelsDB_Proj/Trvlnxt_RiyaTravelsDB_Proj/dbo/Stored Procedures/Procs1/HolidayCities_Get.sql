-- =============================================
-- Author:		Hardik
-- Create date: 09.08.2023
-- Description:	Get Holiday Cities
-- =============================================
CREATE PROCEDURE HolidayCities_Get
	@City Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT City FROM HolidayCities where City LIKE '%' + @City + '%' AND Country = 'India' 
END