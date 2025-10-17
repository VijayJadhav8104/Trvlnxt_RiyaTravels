CREATE PROCEDURE [dbo].[API_GetROE]
@UserType int,
@countrty varchar(2),
@agentid int
AS

BEGIN
select  R.UserTypeId AS UserType, CM.CountryCode AS Country, 
C1.Value AS BaseCurrency, C2.Value AS ToCurrency, R.OfficeIDText as Officeid,
v.VendorName as vendor,R.ROE,B.FKUserID AS AgentID,IsAllAgency,
r.GDSTypeID,r.vendorid from mROEUpdation R
INNER JOIN mROEAgencyMapping RA ON RA.ROEId=R.ID AND  RA.IsActive=1
INNER JOIN mCountry CM ON CM.ID=R.CountryId
INNER JOIN mCommon C1 ON C1.ID=R.BaseCurrencyId  
INNER JOIN mCommon C2 ON C2.ID=R.ToCurrencyId  
INNER JOIN mVendor v ON v.id=R.vendorid  
LEFT JOIN B2BRegistration B ON B.PKID=RA.AgencyId
 where R.IsActive=1  AND (RA.AgencyId IN (SELECT PKID FROM B2BREGISTRATION WHERE FKUserID=@agentid) OR IsAllAgency=1)
 and R.UserTypeId=@UserType and CM.CountryCode=@countrty and R.flag=1

 SELECT Currency,OfficeID  FROM tblOwnerCurrency

 END

