



CREATE PROC [dbo].[GetList_ClientDetails_New]
@Status int ,
@FromDate Date=null, 
@ToDate Date=null,
@AgentId int=null,
@RegisterNum varchar(20)=null ,
@UserType int=null,
@Country varchar(10)=null,
@Start int=null,
@Pagesize int=null,
@RecordCount INT OUTPUT
AS
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
	DROP table  #tempTableA
	SELECT * INTO #tempTableA 
	from
	(
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
				) as 'Status',
				comm.Value as 'UserType',
				a.BookingCountry 
				
				FROM B2BRegistration B
				inner join AgentLogin A on A.UserID=B.FKUserID
				inner join mCommon comm on a.UserTypeID=comm.ID

				where  Status =	(CASE @Status WHEN 4 then Status else @Status end) AND FKUserID IS NOT NULL 
				AND ((@FROMDate = '') or (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))
 				AND ((@ToDate = '') or (CONVERT(date,B.inserteddate) <= CONVERT(date, @ToDate)))
				AND ((@AgentId = '') or (FKUserID = @AgentId))
				AND ((@RegisterNum = '') or (AddrLandlineNo = @RegisterNum))
				AND ((@Country='') OR (A.BookingCountry=@Country))
				AND ((@UserType='') OR (A.UserTypeID=@UserType))
			)p
			order by p.InsertedDate desc	
			
		SELECT @RecordCount = @@ROWCOUNT

		SELECT * FROM #tempTableA
		ORDER BY  InsertedDate desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY		
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[GetList_ClientDetails_New] TO [rt_read]
    AS [dbo];

