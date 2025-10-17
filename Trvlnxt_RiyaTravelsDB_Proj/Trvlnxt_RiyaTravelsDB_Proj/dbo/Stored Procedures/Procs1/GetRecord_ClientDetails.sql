





CREATE PROC [dbo].[GetRecord_ClientDetails] 
@ID int 
AS
BEGIN
					SELECT

					PKID,
					AgencyName,
					CustomerCOde,
					convert(varchar(50),Dates,106) as Dates ,
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
					convert(varchar(50),LegalDOIncorporationRegistr,106) as LegalDOIncorporationRegistr,
					convert(varchar(
50),LegalDOCommencementBusiness,106) as LegalDOCommencementBusiness,
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
					B.country	,
					LegalLicenseNoU	,
					BSPARCCode	,
					[Icast],
					[FKUserID],
					UserName,
					CreditLimit,
					Status,
				
	SalesPersonName,
					isnull(b.AutoTicketing,0) as AutoTicketing,
					isnull(IssueTicket,0) as IssueTicket,
					AmadeusCrypticCmd,
					SaberCrypticCmd,
					B.Airline,
					B.Hotel,
					B.AirlineStartDate,
					B.AirlineCreditday,
					B.HotelCreditDay

						,b.OpenAccountWith
					,b.PrimaryMarket
					,b.PrimaryMarketCountry
					,b.AdditionalInfo
					,ac.Name as AgencyCRS
					,u.FirstName
					,u.UserName

					FROM B2BRegistration B
					join AgentLogin U
					on
					B.FKUserID=U.UserID
					left join AgencyCRS ac on ac.Id=b.AgentCRSid
					where 
					FKUserID = @ID

END



GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetRecord_ClientDetails] TO [rt_read]
    AS [dbo];

