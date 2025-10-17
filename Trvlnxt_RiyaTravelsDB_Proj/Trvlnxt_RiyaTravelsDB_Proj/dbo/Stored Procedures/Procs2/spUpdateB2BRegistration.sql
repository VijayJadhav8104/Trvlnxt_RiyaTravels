

CREATE PROC [dbo].[spUpdateB2BRegistration]
@AgencyName varchar(800)=NULL,
@CustomerCOde varchar(800)=NULL,
@Dates datetime,

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
@LegalDOIncorporationRegistr datetime,
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
@UserID int
AS
BEGIN
		DECLARE @Error_msg varchar(max)=null

		BEGIN
			BEGIN TRY
				Update B2BRegistration
				set
					AgencyName = @AgencyName,
					CustomerCOde= @CustomerCOde,
					Dates=@Dates,
					--Address Details
					AddrAccountOpeningRequestFor=@AddrAccountOpeningRequestFor,
					AddrAddressLocation=@AddrAddressLocation,
					AddrCity=@AddrCity,
					AddrState=@AddrState,
					AddrZipOrPostCode=@AddrZipOrPostCode,
					AddrLandlineNo=@AddrLandlineNo,
					AddrMobileNo=@AddrMobileNo,
					AddrFaxTelexNo=@AddrFaxTelexNo,
					AddrEmail=@AddrEmail,
					AddrWebsite=@AddrWebsite,
					AddrPropDirectPartner=@AddrPropDirectPartner,
					AddrContactNo=@AddrContactNo,

					--Residential Address
					ResiAddressLocation= @ResiAddressLocation,
					ResiCity=@ResiCity,
					ResiState=@ResiState,
					ResiZipPostCode=@ResiZipPostCode,

					--Proposed business Items
					ProposBusinessItemsName=@ProposBusinessItemsName,
					ProposBusinessOtherItem=@ProposBusinessOtherItem,
				
					--Legal Information for Canada
					LegalBusinessRegsitrNo=@LegalBusinessRegsitrNo,
					LegalCompNameOnBusinessRegsitr=@LegalCompNameOnBusinessRegsitr,
					LegalGSTORHST=@LegalGSTORHST,
					LegalDOIncorporationRegistr=@LegalDOIncorporationRegistr,
					LegalDOCommencementBusiness=@LegalDOCommencementBusiness,
					LegalDrivingLicens=@LegalDrivingLicens,
					
					----Legal Information for USA
					LegalTaxIDNO=@LegalTaxIDNO,
					LegalNamePrintedOnTaxID=@LegalNamePrintedOnTaxID,
					LegalLicenseNoU=@LegalLicenseNoU ,
					

					--Type of customer --for checbox
					CustomerTypeName=@CustomerTypeName,
					BSPARCCode=@BSPARCCode,
					CustTypeIATANumber=@CustTypeIATANumber,
					CustTypePremises=@CustTypePremises,

					--License Info
					LicenseInfoDoYouRequire=@LicenseInfoDoYouRequire,
					LicIfYesLicensNo=@LicIfYesLicensNo,

					--Bank Details
					BnkDetBankName=@BnkDetBankName,
					BnkDetBankAccNo=@BnkDetBankAccNo,
					BnkDetAccType=@BnkDetAccType,
					BnkDetAddress=@BnkDetAddress,
					country=@country,
					InsertedDate= GETDATE()
				 where  FKUserID = @UserID

			END TRY
			BEGIN CATCH
				SET @Error_msg=ERROR_MESSAGE()
				RAISERROR(@Error_msg,16,1)
			END CATCH
		END
END




GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[spUpdateB2BRegistration] TO [rt_read]
    AS [dbo];

