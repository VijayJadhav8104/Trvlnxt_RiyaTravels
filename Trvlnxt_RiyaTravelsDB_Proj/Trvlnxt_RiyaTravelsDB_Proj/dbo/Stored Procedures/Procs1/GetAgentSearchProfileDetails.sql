-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetAgentSearchProfileDetails
	-- Add the parameters for the stored procedure here
	@AgentId int=0,
	@Id int=0,
	@CommandName varchar(50)=''
AS
BEGIN
	
	--select  AM.Id,
	--		AM.AgentId,
	--		BR.Icast+' - '+BR.AgencyName as AgencyName,
	--		AM.ProfileId,
	--		pp.ProfileName,
	--		AM.CreateDate
	--from AgentProfileMapper  AM
	--join B2BRegistration BR on AM.AgentId=BR.PKID
	--join PricingProfile PP on AM.ProfileId=PP.Id
	--where AM.AgentId=@AgentId and AM.IsActive=1
	   

	   if(@CommandName = 'Edit')
	   begin
			select ASPM.Id,
			ASPM.AgentId,
					BR.Icast+' - '+BR.AgencyName as AgencyName,
					ASPM.SupplierId,
					SM.SupplierName,
					ASPM.ProfileId,
					pp.ProfileName,
					ASPM.CancellationHours,
					ASPM.CreateDate,
					ASPM.IsActive

			from AgentSupplierProfileMapper ASPM
			join B2BRegistration BR on ASPM.AgentId=BR.PKID
			join B2BHotelSupplierMaster SM on ASPM.SupplierId=SM.Id
			join PricingProfile PP on ASPM.ProfileId=PP.Id
			where ASPM.Id=@Id and AgentId=@AgentId and ASPM.IsActive=1   
	   end

	   else if(@CommandName != 'Edit')
		begin
			select ASPM.Id,
			ASPM.AgentId,
					BR.Icast+' - '+BR.AgencyName as AgencyName,
					ASPM.SupplierId,
					SM.SupplierName,
					ASPM.ProfileId,
					pp.ProfileName,
					ASPM.CancellationHours,
					ASPM.CreateDate,
					ASPM.IsActive

			from AgentSupplierProfileMapper ASPM
			join B2BRegistration BR on ASPM.AgentId=BR.PKID
			join B2BHotelSupplierMaster SM on ASPM.SupplierId=SM.Id
			join PricingProfile PP on ASPM.ProfileId=PP.Id
			where ASPM.AgentId=@AgentId  and ASPM.IsActive=1   
		end

	

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetAgentSearchProfileDetails] TO [rt_read]
    AS [dbo];

