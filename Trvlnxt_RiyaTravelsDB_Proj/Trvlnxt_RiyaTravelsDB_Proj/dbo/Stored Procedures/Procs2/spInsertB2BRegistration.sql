

CREATE PROC [dbo].[spInsertB2BRegistration]
@AgencyName varchar(800)=NULL,
@CustomerCOde varchar(800)=NULL,
@Dates datetime=null,

	--Address Details
@AddrAccountOpeningRequestFor varchar(800)=NULL,
@AddrAddressLocation varchar(800)=NULL,
@AddrCity varchar(800)=NULL,
@AddrState varchar(800)=NULL,
@AddrZipOrPostCode varchar(800)=NULL,
@AddrLandlineNo varchar(max)=NULL,
@AddrMobileNo varchar(max)=NULL,
@AddrFaxTelexNo varchar(max)=NULL,
@AddrEmail varchar(max)=NULL,
@AddrWebsite varchar(max)=NULL,
@AddrPropDirectPartner varchar(max)=NULL,
@AddrContactNo varchar(max)=NULL,

	--Residential Address
@ResiAddressLocation varchar(max)=NULL,
@ResiCity varchar(max)=NULL,
@ResiState varchar(max)=NULL,
@ResiZipPostCode varchar(max)=NULL,

	--Proposed business Items
@ProposBusinessItemsName Varchar(800)=NULL,
@ProposBusinessOtherItem varchar(max)=NULL,

--Legal Information for Canada
@LegalBusinessRegsitrNo varchar(max)=NULL,
@LegalCompNameOnBusinessRegsitr varchar(max)=NULL,
@LegalGSTORHST varchar(800)=NULL,
@LegalDOIncorporationRegistr datetime=null,
@LegalDOCommencementBusiness datetime=null,
@LegalDrivingLicens varchar(max)=NULL,

	----Legal Information for USA
@LegalTaxIDNO varchar(max)=NULL,
@LegalNamePrintedOnTaxID varchar(max)=NULL,
@LegalLicenseNoU varchar(800)=NULL,

	--Type of customer --for checbox
@CustomerTypeName Varchar(800)=NULL,
@BSPARCCode varchar(800)=NULL,
@CustTypeIATANumber varchar(max)=NULL,
@CustTypePremises varchar(max)=NULL,

	--License Info
@LicenseInfoDoYouRequire varchar(max)=NULL,
@LicIfYesLicensNo varchar(max)=NULL,

	--Bank Details
@BnkDetBankName varchar(800)=NULL,
@BnkDetBankAccNo nvarchar(200)=NULL,
@BnkDetAccType varchar(800)=NULL,
@BnkDetAddress varchar(800)=NULL,
@country varchar(500)=NULL,
@UserID int=null,
@FKUserID int=null,

 @PANNumber varchar(10)=null,
 @PANName Varchar(100)=null,
 @UploadPANPath Varchar(100)=null,
 @GSTRegistered Varchar(10)=null,
 @GSTINRegisteredUploadPath Varchar(1000)=null,
 @CompanyRegistrationDocPath Varchar(1000)=null,

 --New fields
  @OpenAccountWith Varchar(100)=null,
   @PrimaryMarket Varchar(100)=null,
    @AdditionalInfo Varchar(100)=null,
	 @AgentCRSid Varchar(50)=null,
 @PrimaryMarketCountry Varchar(500)=null
AS
BEGIN
		DECLARE @Error_msg varchar(max)=null

		BEGIN
			BEGIN TRY
				INSERT INTO B2BRegistration
				(
					AgencyName,
					CustomerCOde,
					Dates,

					--Address Details
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

					--Residential Address
					ResiAddressLocation,
					ResiCity,
					ResiState,
					ResiZipPostCode,

					--Proposed business Items
					ProposBusinessItemsName,
					ProposBusinessOtherItem,

					--Legal Information for Canada
					LegalBusinessRegsitrNo,
					LegalCompNameOnBusinessRegsitr,
					LegalGSTORHST,
					LegalDOIncorporationRegistr,
					LegalDOCommencementBusiness,
					LegalDrivingLicens,

					----Legal Information for USA
					LegalTaxIDNO,
					LegalNamePrintedOnTaxID,
					LegalLicenseNoU ,

					--Type of customer --for checbox
					CustomerTypeName,
					BSPARCCode,
					CustTypeIATANumber,
					CustTypePremises,

					--License Info
					LicenseInfoDoYouRequire,
					LicIfYesLicensNo,

					--Bank Details
					BnkDetBankName,
					BnkDetBankAccNo,
					BnkDetAccType,
					BnkDetAddress,
					country,
					InsertedDate,
					FKUserID,
					CreditLimit,
					Status,
					PANNumber,
					PANName,
					PANPath,
					GSTRegistered,
					GSTINRegisteredUploadPath,
					CompanyRegistrationDocPath

					,OpenAccountWith
					,PrimaryMarket
					,AdditionalInfo
					,AgentCRSid
					,PrimaryMarketCountry
				)
				VALUES
				(
					@AgencyName,
					@CustomerCOde,
					@Dates,

					--Address Details
					@AddrAccountOpeningRequestFor,
					@AddrAddressLocation,
					@AddrCity,
					@AddrState,
					@AddrZipOrPostCode,
					@AddrLandlineNo,
					@AddrMobileNo,
					@AddrFaxTelexNo,
					@AddrEmail,
					@AddrWebsite,
					@AddrPropDirectPartner,
					@AddrContactNo,

					--Residential Address
					@ResiAddressLocation,
					@ResiCity,
					@ResiState,
					@ResiZipPostCode,

					--Proposed business Items
					@ProposBusinessItemsName,
					@ProposBusinessOtherItem,

					--Legal Information for Canada
					@LegalBusinessRegsitrNo,
					@LegalCompNameOnBusinessRegsitr,
					@LegalGSTORHST,
					@LegalDOIncorporationRegistr,
					@LegalDOCommencementBusiness,
					@LegalDrivingLicens,

					----Legal Information for USA
					@LegalTaxIDNO,
					@LegalNamePrintedOnTaxID,
					@LegalLicenseNoU,
					--Type of customer --for checbox
					@CustomerTypeName,
					@BSPARCCode,
					@CustTypeIATANumber,
					@CustTypePremises,

					--License Info
					@LicenseInfoDoYouRequire,
					@LicIfYesLicensNo,

					--Bank Details
					@BnkDetBankName,
					@BnkDetBankAccNo,
					@BnkDetAccType,
					@BnkDetAddress,
					@country,
					GETDATE(),
				    @FKUserID,
					0,
					0
					,@PANNumber
					,@PANName
					,@UploadPANPath
					,@GSTRegistered
					,@GSTINRegisteredUploadPath
					,@CompanyRegistrationDocPath

					 ,@OpenAccountWith
					 ,@PrimaryMarket 
					 ,@AdditionalInfo
					 ,@AgentCRSid 
					 ,@PrimaryMarketCountry 
				)


			END TRY
			BEGIN CATCH
				SET @Error_msg=ERROR_MESSAGE()
				RAISERROR(@Error_msg,16,1)
			END CATCH
		END
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spInsertB2BRegistration] TO [rt_read]
    AS [dbo];

