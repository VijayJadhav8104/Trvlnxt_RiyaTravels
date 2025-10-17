

--Proc_GetAgencyMapTokens 33435
CREATE Proc [dbo].[Proc_GetAgencyMapTokens]
@AgentId int=0
AS
BEGIN
	Declare @PKID int
	select @PKID=PKID from B2BRegistration where FKUserID=@AgentId

	select SM.SupplierName,SM.id,SM.RhSupplierId,PM.RateCode,
		ISNULL(hgt.Token,'') AS Token, ISNULL(hgt.BasedOn,'') AS BasedOn, ISNULL(hgt.CountryCode,'') AS CountryCode
	from AgentSupplierProfileMapper PM 
	  left join B2BHotelSupplierMaster SM on PM.SupplierId=SM.Id
	  left join [hotel].HyperGuestTokens hgt on hgt.SupplierId = SM.Id
	where PM.AgentId=@PKID 
	and PM.isActive =1 and SM.Id is not null

	--Select * from [hotel].HyperGuestTokens

END