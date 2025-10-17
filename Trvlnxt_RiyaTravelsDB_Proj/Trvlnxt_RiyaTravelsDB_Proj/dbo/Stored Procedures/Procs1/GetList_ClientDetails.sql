
CREATE PROC [dbo].[GetList_ClientDetails]
AS
BEGIN
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
				InsertedDate,
				country,
				LegalLicenseNoU,
				BSPARCCode,
				UpdatedBy,
				UpdatedDate,
				Icast,
				FKUserID,
				CreditLimit,
				(CASE 
					when 
						Status=0 
							THEN 
								'Pending' 
				   when 
						Status=1 
							THEN 
								'Approved' 
				  when 
						Status=2 
							THEN 
								'Rejected' 
				 when 
						Status=3
							THEN 
								'Blocked' 
				End
				) as 'Status'
				FROM B2BRegistration
			order by InsertedDate desc

			
SELECT InsertedDate, username,(FirstName + ' ' + LastName) as Name, MobileNumber,Address,City,
			Country,Pincode,Province FROM AgentLogin where userid not in (select FKUserID from B2BRegistration)
			and ParentAgentID is null and AgentApproved=0
			order by InsertedDate desc

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_ClientDetails] TO [rt_read]
    AS [dbo];

