CREATE PROCEDURE sp_GetCurrency --1490
@ID int
AS
BEGIN

select ROE,C.Value AS 'BaseCurrency',C1.Value AS Currency,C.OfficeID,C2.Value as VendorType,UserTypeId from mROEUpdation R
INNER JOIN mCommon C ON C.ID=R.BaseCurrencyId
INNER JOIN mCommon C1 ON C1.ID=R.ToCurrencyId
INNER JOIN mCommon C2 ON C2.ID=R.GDSTypeId
INNER JOIN mCountry CO ON CO.ID=R.CountryId
INNER JOIN mROEAgencyMapping RM ON RM.ROEId=R.ID
where R.IsActive=1
and (AgencyId in (select PKID from B2BRegistration where FKUserID=@ID)  or  IsAllAgency=1)
AND 
UserTypeId in (select UserTypeId from agentLogin where UserID=@ID) and 
CO.CountryCode IN (SELECT BookingCountry FROM AgentLogin WHERE userid=@ID)

END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[sp_GetCurrency] TO [rt_read]
    AS [dbo];

