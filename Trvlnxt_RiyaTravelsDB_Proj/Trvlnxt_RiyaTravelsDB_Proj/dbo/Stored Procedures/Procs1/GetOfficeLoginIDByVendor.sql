-- =============================================
-- Author:		<Jitendra Nakum>
-- Create date: <11.05.2023>
-- Description:	<This procedure is used to get all Office/Login Id by Vendor ID>
-- =============================================
--exec [dbo].[GetOfficeLoginIDByVendor] 22
CREATE PROCEDURE [dbo].[GetOfficeLoginIDByVendor]
	@VendorId Bigint
AS
BEGIN
	Declare @OfficeID Varchar(Max)
	SELECT @OfficeID = OfficeId
	FROM mVendor AS ven
	WHERE IsDeleted=0 
	AND ID=@VendorId
	ORDER BY VendorName
	--(select a.value AS OfficeId FROM dbo.[fn_split](ven.OfficeId,',') as a )OfficeId
	SELECT value AS OfficeId from dbo.[fn_split](@OfficeID,',')  AS OfficeId
END