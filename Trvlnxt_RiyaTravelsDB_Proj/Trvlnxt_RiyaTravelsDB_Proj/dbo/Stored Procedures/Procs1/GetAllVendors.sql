-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <11.05.2023>
-- Description:	<This procedure is used to get all vendor>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllVendors]
AS
BEGIN
	SELECT ID
	,VendorName
	FROM mVendor 
	WHERE IsDeleted = 0 AND IsActive = 1
	ORDER BY VendorName 
END