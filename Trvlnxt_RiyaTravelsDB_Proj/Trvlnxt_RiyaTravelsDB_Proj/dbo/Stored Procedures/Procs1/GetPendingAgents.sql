
CREATE PROC [dbo].[GetPendingAgents]-- 'tech process',null,'4'
@AgencyName varchar(500)=null,
@Icast varchar(500)=null,
@AddrLandlineNo VARCHAR(800)=NULL,
@Status int=null
AS
BEGIN
		BEGIN
			IF @Status=4
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
				where				
					(AgencyName LIKE @AgencyName+'%' OR @AgencyName is null)
					AND
					(AddrLandlineNo LIKE @AddrLandlineNo OR @AddrLandlineNo IS NULL)
					AND
					(Icast LIKE @Icast+'%' OR @Icast is null)
					order by InsertedDate desc						
				
			END
			ELSE IF (@Status is null and @AgencyName is null and @Icast is null AND @AddrLandlineNo IS NULL)
			BEGIN
					exec GetList_ClientDetails
			END
			ELSE
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
				Status
				FROM B2BRegistration
				where
				(Status=@Status OR @Status IS NULL)
					AND
					(AgencyName LIKE @AgencyName+'%' OR @AgencyName is null)
					AND
					(AddrLandlineNo LIKE @AddrLandlineNo OR @AddrLandlineNo IS NULL)
					AND
					(Icast LIKE @Icast+'%' OR @Icast is null)
					order by InsertedDate desc	
			END
		END
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetPendingAgents] TO [rt_read]
    AS [dbo];

