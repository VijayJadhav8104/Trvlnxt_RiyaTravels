
CREATE procedure [dbo].[Get_AgentList]


as
begin




select
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
InsertedDate,
country,
LegalLicenseNoU,
BSPARCCode,
UpdatedBy,
UpdatedDate,
Icast,
FKUserID ,
0 as Flag




from B2BRegistration

end


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_AgentList] TO [rt_read]
    AS [dbo];

