-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetSupplierProfileMappingDetails
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
	--select  AP.Id,
	--BR.AgencyName as AgencyName, 
	--PP.ProfileName as ProfileName,
	--AP.CreateDate as CreateDate,
	--ASM.SupplierId,
	--BSM.SupplierName
			
	--from AgentProfileMapper AP
	--left join B2BRegistration BR on AP.AgentId=BR.PKID
	--left join PricingProfile PP on AP.ProfileId = PP.Id
	--left join AgentSupplierProfileMapper ASM on ASM.AgentId=AP.AgentId
	--left join B2BHotelSupplierMaster BSM on ASM.SupplierId=BSM.Id
 --   where AP.IsActive=1
	
	select  AP.Id,
			BR.PKID as AgentId,
			BR.AgencyName, 
			PP.ProfileName,
			AP.CreateDate,
			BR.PKID
			
	from AgentProfileMapper AP
	left join B2BRegistration BR on AP.AgentId=BR.PKID
	left join PricingProfile PP on AP.ProfileId = PP.Id
	--left join B2BHotelSupplierMaster BS on AP.Id=BS.SupplierName
    where AP.IsActive=1

	SELECT
		BSM.SupplierName
	FROM 
    AgentSupplierProfileMapper ASM
	left join B2BHotelSupplierMaster BSM on ASM.SupplierId=BSM.Id

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetSupplierProfileMappingDetails] TO [rt_read]
    AS [dbo];

