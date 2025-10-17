
-- =============================================
-- Author:		bhavika kawa
-- [Sp_GetVendorBlockDetailsByAgentId] 'IN','Marine','GoAir','Bombm001','22127',''
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetVendorBlockDetailsByAgentId]
	@Country varchar(10),
	@UserType varchar(10),
	@VendorName varchar(50),
	@OfficeId varchar(50),
	@AgencyId varchar(10),
	@AirlineCode varchar(10)
	
AS
BEGIN

	IF(@UserType='MN')
	BEGIN
	set @UserType='Marine'
	END
	ELSE IF(@UserType='HLD')
	BEGIN
	set @UserType='Holiday'
	END

	select bv.* from mBlockVendor bv
	inner join mVendor v on v.ID=bv.VendorId
	inner join mCommon c on c.ID=bv.UserTypeId
	where v.IsActive=1 and v.IsDeleted=0 and bv.IsActive=1
	and (c.Value=@UserType)
	and (bv.Country=@Country)
	and (bv.OfficeId=CASE
         WHEN exists(select * from mBlockVendor where OfficeId=@OfficeId and IsActive=1)  THEN @OfficeId
         ELSE 'All'  END)
	and ((bv.AgencyId=@AgencyId) or (@AgencyId in (SELECT Data FROM sample_split(bv.AgencyId, ','))) or (bv.AgencyName='All'))
	--and ((bv.AirlineCode=@AirlineCode) or (@AirlineCode in (SELECT Data FROM sample_split(bv.AirlineCode, ','))) or (bv.AirlineCode='All'))
	and (UPPER(v.VendorName)=UPPER(@VendorName) OR @VendorName='')  
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetVendorBlockDetailsByAgentId] TO [rt_read]
    AS [dbo];

