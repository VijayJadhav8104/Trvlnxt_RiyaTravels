
-- =============================================
-- Author:		Bhavika kawa
-- Description:	To get vendor fare type from console
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetVendorBlockDetails] 
	@VendorName varchar(20),
	@Country varchar(10),
	@UserType varchar(10),
	@OfficeId varchar(50),
	@Type varchar(20),
	@Userid int=null
AS
BEGIN
	if(@Type='FareType')
	BEGIN
	declare  @ID int
	select @ID=bv.ID from mBlockVendor BV
	join mVendor v on v.ID=BV.VendorId 
	where v.IsActive=1 and IsDeleted=0 and UPPER(v.VendorName)=UPPER(@VendorName) and BV.Country=@Country and bv.UserTypeId=(select ID from mCommon where Value=@UserType)

	select ID,FareName,FareType 
	from mFareTypeByAirline
	where ID in (SELECT Data FROM sample_split((select FareTypeId from mBlockVendor where ID=@ID), ','))
	END
	if(@Type='All')
	BEGIN

	SELECT bv.ID,v.VendorName,c.Value as 'UserType',bv.Country,bv.OfficeId,bv.AirlineCode,bv.ApiIndicator,BlockAvailability,BlockSell,
	BlockBooking,u.UserName as 'CreatedBy',bv.CreatedOn ,u1.UserName as 'ModifiedBy',bv.ModifiedOn 
	from mBlockVendor bv 
	inner join mUser u on bv.CreatedBy = u.ID
	inner join mVendor v on bv.VendorId=v.ID
	inner join mCommon c on bv.UserTypeId=c.ID
	left join mUser u1 on bv.ModifiedBy = u1.ID

	where bv.IsActive=1 and v.IsActive=1 and v.IsDeleted=0
	and bv.UserTypeId in (select UserTypeId  from mUserTypeMapping UM where UserID=@Userid)
	and bv.Country in (select c.CountryCode  from mUserCountryMapping UM  join mCountry c on UM.CountryId=c.ID where UserID=@Userid)
	and (@VendorName='0' or bv.VendorId=@VendorName)	
	and (@Country='0' or bv.Country=@Country)	
	and (@UserType='0' or bv.UserTypeId=@UserType)	
	and (@OfficeId='0' or @OfficeId='ALL' or bv.OfficeId=@OfficeId)
	END
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetVendorBlockDetails] TO [rt_read]
    AS [dbo];

