
CREATE proc [dbo].[GetRecord_B2BRegistration]

@USERID int

as
begin

--declare @USERID int  = 18

IF EXISTS(select Count(*) from B2BRegistration where FKUserID = @USERID) 
begin
SELECT
PKID,
AgencyName,
CustomerCOde,
Dates,
AddrAccountOpeningRequestFor,
AddrAddressLocation,
AddrCity,
AddrState,
AddrZipOrPostCode,
AddrLandlineNo,
AddrMobileNo,
AddrFaxTelexNo,
AddrEmail,
AddrWebsite,
AddrPropDirectPartner,
AddrContactNo,
ResiAddressLocation,
ResiCity,
ResiState,
ResiZipPostCode,
ProposBusinessItemsName,
ProposBusinessOtherItem,
LegalBusinessRegsitrNo,
LegalCompNameOnBusinessRegsitr,
LegalGSTORHST,
LegalDOIncorporationRegistr,
LegalDOCommencementBusiness,
LegalDrivingLicens,
LegalTaxIDNO,
LegalNamePrintedOnTaxID,
CustomerTypeName,
CustTypeIATANumber,
CustTypePremises,
LicenseInfoDoYouRequire,
LicIfYesLicensNo,
BnkDetBankName,
BnkDetBankAccNo,
BnkDetAccType,
BnkDetAddress,
B.InsertedDate,
B.country,
LegalLicenseNoU,
BSPARCCode,
UpdatedBy,
UpdatedDate,
Icast,
FKUserID,
ISNULL(AL.AgentApproved,0) AS AgentApproved
FROM B2BRegistration B
INNER JOIN AgentLogin AL ON AL.UserID=B.FKUserID
WHERE  FKUserID = @USERID
end

end

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_B2BRegistration] TO [rt_read]
    AS [dbo];

