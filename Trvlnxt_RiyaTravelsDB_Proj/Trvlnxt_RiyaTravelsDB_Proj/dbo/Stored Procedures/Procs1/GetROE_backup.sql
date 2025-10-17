create PROCEDURE [dbo].[GetROE_backup]
@UserType int,
@countrty varchar(2),
@agentid int
AS

BEGIN
select  R.UserTypeId AS UserType, CM.CountryCode AS Country, C1.Value AS BaseCurrency, C2.Value AS ToCurrency, CO.CategoryValue as Officeid,
C3.Value as vendor,R.ROE,B.FKUserID AS AgentID,IsAllAgency from mROEUpdation R
INNER JOIN mROEAgencyMapping RA ON RA.ROEId=R.ID AND  RA.IsActive=1
INNER JOIN mCountry CM ON CM.ID=R.CountryId
INNER JOIN mCommon C1 ON C1.ID=R.BaseCurrencyId  
INNER JOIN mCommon C2 ON C2.ID=R.ToCurrencyId  
INNER JOIN mCommon C3 ON C3.ID=R.GDSTypeId  
LEFT JOIN tbl_commonmaster CO ON CO.pkid=R.OfficeId
LEFT JOIN B2BRegistration B ON B.PKID=RA.AgencyId
 where R.IsActive=1 AND (RA.AgencyId IN (SELECT PKID FROM B2BREGISTRATION WHERE FKUserID=@agentid) OR IsAllAgency=1)
 and R.UserTypeId=@UserType and CM.CountryCode=@countrty and R.flag=1


 SELECT Currency,OfficeID  FROM tblOwnerCurrency

 END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetROE_backup] TO [rt_read]
    AS [dbo];

