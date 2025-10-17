CREATE PROCEDURE [GetROE_Multicity] --[GetROE_Multicity] 5,'UK','45961','09/04/2023'
	@UserType int,
	@countrty varchar(2),
	@agentid int,
	@IssueDate DateTime
AS
BEGIN

	SELECT R.UserTypeId AS UserType
	, CM.CountryCode AS Country
	, CAST(mROEHistoryAir.InsertedDate AS DATE) AS D1
	, CAST(@IssueDate AS DATE) AS D2
	, C1.Value AS BaseCurrency
	, C2.Value AS ToCurrency
	, R.OfficeIDText as Officeid
	, v.VendorName as vendor
	, (CASE WHEN CAST(@IssueDate AS DATE) = CAST(GETDATE() AS DATE) THEN R.ROE ELSE CONVERT(numeric(18,6), mROEHistoryAir.NewROE) END) AS ROE
	, B.FKUserID AS AgentID
	, IsAllAgency
	, r.GDSTypeID
	, r.vendorid 
	, R.ID
	FROM mROEUpdation R
	LEFT OUTER JOIN mROEHistoryAir ON mROEHistoryAir.ROEId = R.ID
	INNER JOIN mROEAgencyMapping RA ON RA.ROEId=R.ID AND  RA.IsActive=1
	INNER JOIN mCountry CM ON CM.ID=R.CountryId
	INNER JOIN mCommon C1 ON C1.ID=R.BaseCurrencyId  
	INNER JOIN mCommon C2 ON C2.ID=R.ToCurrencyId  
	INNER JOIN mVendor v ON v.id=R.vendorid  
	LEFT JOIN B2BRegistration B ON B.PKID=RA.AgencyId
 	WHERE R.IsActive=1 
	AND (RA.AgencyId IN (SELECT PKID FROM B2BREGISTRATION WHERE FKUserID=@agentid) OR IsAllAgency=1)
 	AND R.UserTypeId=@UserType and CM.CountryCode=@countrty and R.flag=1
	AND (CAST(mROEHistoryAir.InsertedDate AS DATE) = CAST(@IssueDate AS DATE))

	UNION ALL

	SELECT R.UserTypeId AS UserType
	, CM.CountryCode AS Country
	, CAST(R.CreatedOn AS DATE) AS D1
	, CAST(@IssueDate AS DATE) AS D2
	, C1.Value AS BaseCurrency
	, C2.Value AS ToCurrency
	, R.OfficeIDText as Officeid
	, v.VendorName as vendor
	, R.ROE AS ROE
	, B.FKUserID AS AgentID
	, IsAllAgency
	, r.GDSTypeID
	, r.vendorid 
	, R.ID
	FROM mROEUpdation R
	INNER JOIN mROEAgencyMapping RA ON RA.ROEId=R.ID AND  RA.IsActive=1
	INNER JOIN mCountry CM ON CM.ID=R.CountryId
	INNER JOIN mCommon C1 ON C1.ID=R.BaseCurrencyId  
	INNER JOIN mCommon C2 ON C2.ID=R.ToCurrencyId  
	INNER JOIN mVendor v ON v.id=R.vendorid  
	LEFT JOIN B2BRegistration B ON B.PKID=RA.AgencyId
 	WHERE R.IsActive=1 
	AND (RA.AgencyId IN (SELECT PKID FROM B2BREGISTRATION WHERE FKUserID=@agentid) OR IsAllAgency=1)
 	AND R.UserTypeId=@UserType 
	AND CM.CountryCode=@countrty 
	AND R.flag=1
 	
	SELECT Currency,OfficeID FROM tblOwnerCurrency

 END