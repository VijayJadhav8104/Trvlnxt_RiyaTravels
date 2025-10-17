-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <11.05.2023>
-- Description:	<This procedure is used to get all Fare Type By Vendor Name>
-- =============================================
CREATE PROCEDURE [dbo].[GetFareTypeByVendorName_OfficeID]
	@VendorName Varchar(100)
	,@OfficeID Varchar(100)
AS
BEGIN

	DECLARE @VendorID Int, @FareTypeIDs Varchar(100)

	SELECT @VendorID = ID FROM mVendor 
	WHERE IsActive = 1 
	AND VendorName = @VendorName 
	AND IsDeleted = 0

	SELECT @FareTypeIDs = Value FROM mVendorCredential 
	WHERE OfficeId = @OfficeID
	AND FieldName = 'Fare Type' 
	AND IsActive = 1
	AND VendorId = @VendorID

	SELECT ID,
	FareName,
	FareType
	FROM mFareTypeByAirline WHERE ID IN (SELECT Item FROM SplitString(@FareTypeIDs, ','))

END