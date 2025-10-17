-- =============================================
-- Author:		Bhavika kawa
-- Create date: 24/04/2020
-- Description:	To get ROE Data
-- [Sp_GetROEUpdation] 'ROE' 
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetROEUpdation_bk] 
	@Type varchar(10)=null,
	@Userid int,
	@CountryId int,
	@UserTypeId int,
	@GDSTypeId int,
	@OfficeId varchar(100)
AS
BEGIN
	if(@Type='ROE')
	BEGIN
	select updation.ID,ROE,comm1.Value as UserType,updation.UserTypeId,comm2.Value as Product,comm3.Value as BaseCurrency,comm4.Value as ToCurrency,
			comm5.Value as GDSType,country.CountryName as Country ,airline._NAME as AirLine
			,updation.OfficeIdText as OfficeId ,
			muser.UserName as ModifiedBy,updation.ModifiedOn,muser1.UserName as CreatedBy ,updation.CreatedOn,
			updation.Flag
	from mROEUpdation updation
	left join mCommon comm1 on updation.UserTypeId=comm1.ID
	left join mCommon comm2  on updation.ProductId=comm2.ID
	left join mCommon comm3  on updation.BaseCurrencyId=comm3.ID
	left join mCommon comm4  on updation.ToCurrencyId=comm4.ID
	left join mCommon comm5  on updation.GDSTypeId=comm5.ID
	left join mCountry country on updation.CountryId=country.ID
	left join AirlinesName airline on updation.AirLineId=airline.ID
	--left join tbl_commonmaster tblComm on updation.OfficeId=tblComm.pkid
	left join mUser muser on muser.ID=updation.ModifiedBy
	inner join mUser muser1 on muser1.ID=updation.CreatedBy

	where updation.IsActive=1
	and updation.UserTypeId in (select UserTypeId  from mUserTypeMapping UM where UserID=@Userid)
	and updation.CountryId in (select CountryId  from mUserCountryMapping UM where UserID=@Userid)

	END
	ELSE IF (@Type='Filter')
	BEGIN
	select updation.ID,ROE,comm1.Value as UserType,updation.UserTypeId,comm2.Value as Product,comm3.Value as BaseCurrency,comm4.Value as ToCurrency,
			comm5.Value as GDSType,country.CountryName as Country ,airline._NAME as AirLine
			,updation.OfficeIdText as OfficeId ,
			muser.UserName as ModifiedBy,updation.ModifiedOn,muser1.UserName as CreatedBy ,updation.CreatedOn,
			updation.Flag
	from mROEUpdation updation
	left join mCommon comm1 on updation.UserTypeId=comm1.ID
	left join mCommon comm2  on updation.ProductId=comm2.ID
	left join mCommon comm3  on updation.BaseCurrencyId=comm3.ID
	left join mCommon comm4  on updation.ToCurrencyId=comm4.ID
	left join mCommon comm5  on updation.GDSTypeId=comm5.ID
	left join mCountry country on updation.CountryId=country.ID
	left join AirlinesName airline on updation.AirLineId=airline.ID
	--left join tbl_commonmaster tblComm on updation.OfficeId=tblComm.pkid
	left join mUser muser on muser.ID=updation.ModifiedBy
	inner join mUser muser1 on muser1.ID=updation.CreatedBy
	where updation.IsActive=1  
	 AND ((@CountryId = 0) or  (updation.CountryId=@CountryId))
	 AND ((@UserTypeId = 0) or  (updation.UserTypeId=@UserTypeId))
	 AND ((@GDSTypeId = 0) or  (updation.VendorId=@GDSTypeId))
	 AND ((@OfficeId = '') or  (updation.OfficeIdText=@OfficeId))
	END
	ELSE
	BEGIN
	select updation.ID,updation.Action,ROE,comm1.Value as UserType,updation.UserTypeId,comm2.Value as Product,comm3.Value as BaseCurrency,comm4.Value as ToCurrency,
			comm5.Value as GDSType,country.CountryName as Country 
			,updation.OfficeIdText as OfficeId ,
			updation.AirLineId,updation.IsAllAirline,updation.AgencyId,updation.IsAllAgency,muser.UserName as ModifiedBy,updation.ModifiedOn,updation.CountryId,
			updation.Flag
	from mROEUpdationHistory updation
	left join mCommon comm1 on updation.UserTypeId=comm1.ID
	left join mCommon comm2  on updation.ProductId=comm2.ID
	left join mCommon comm3  on updation.BaseCurrencyId=comm3.ID
	left join mCommon comm4  on updation.ToCurrencyId=comm4.ID
	left join mCommon comm5  on updation.GDSTypeId=comm5.ID
	left join mCountry country on updation.CountryId=country.ID
	--left join AirlinesName airline on updation.AirLineId=airline.ID
	--left join tbl_commonmaster tblComm on updation.OfficeId=tblComm.pkid
	inner join mUser muser on muser.ID=updation.ModifiedBy

	where updation.UserTypeId in (select UserTypeId  from mUserTypeMapping UM where UserID=@Userid)
	and updation.CountryId in (select CountryId  from mUserCountryMapping UM where UserID=@Userid)
	order by updation.ModifiedOn desc

	END

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetROEUpdation_bk] TO [rt_read]
    AS [dbo];

