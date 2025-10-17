-- =============================================
-- Author:		bhavika kawa
-- Description:	TO get Agent ROE
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetAgentROE]
	@ID int=null,
	@UserId int=null
AS
BEGIN
	if(@ID > 0)
	begin 
		select 
		r.*
		--, u.UserName
		, (case when r.ModifiedBy is null then u.UserName else mu.UserName end) UserName
		, (case when r.ModifiedOn is null then r.CreatedOn else r.ModifiedOn end) as 'UpdatedDate'
		from mAgentROE R
		left join mUser u ON u.ID=r.CreatedBy
		left join mUser mu ON mu.ID=r.ModifiedBy
		where r.ID=@ID 
		and r.IsDeleted=0 
		and r.IsActive=1
	end
	else
	begin
		select 
		r.AgencyID
		, r.AgencyNames
		, r.Currency
		, r.ROE
		, r.ID
		, r.Country
		, r.UserType
		--, u.UserName
		, (case when r.ModifiedBy is null then u.UserName else mu.UserName end) AS UserName
		, r.IsActive
		, (case when r.ModifiedOn is null then r.CreatedOn else r.ModifiedOn end) as 'UpdatedDate'
		from mAgentROE R
		left join mUser u ON u.ID=r.CreatedBy
		left join mUser mu ON mu.ID=r.ModifiedBy
		where r.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@UserId  AND IsActive=1)
		and r.IsDeleted=0 
		and r.UserType in (select mc.Value from mUserTypeMapping UT inner join mCommon mc on mc.ID=UT.UserTypeId
			where ut.UserId=@UserId and UT.IsActive=1)
	END
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentROE] TO [rt_read]
    AS [dbo];

