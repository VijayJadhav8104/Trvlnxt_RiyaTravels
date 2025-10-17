-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <11.05.2023>
-- Description:	<This procedure is used to get all Fare Type By Vendor Name>
-- =============================================
--exec GetFareTypeByVendorName 'Amadeus'
CREATE PROCEDURE [dbo].[GetFareTypeByVendorName]
	@VendorName Varchar(100)
AS
BEGIN
	SELECT 
	ID,
	FareName,
	FareType
	FROM mFareTypeByAirline 
	WHERE Vendor=@VendorName
END