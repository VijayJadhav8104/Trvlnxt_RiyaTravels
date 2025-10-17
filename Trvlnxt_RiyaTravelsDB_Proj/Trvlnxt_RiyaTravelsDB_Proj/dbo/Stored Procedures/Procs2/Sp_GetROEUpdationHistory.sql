-- =============================================
-- Author:		Bhavika kawa
-- Create date: 14/07/2020
-- Description:	Get ROE History
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetROEUpdationHistory]
	@Type varchar(50),
	@FromDate   datetime,
	@ToDate		datetime,
	@Start int=null,
	@Pagesize int=null,
	@Userid int=null,
	@RecordCount INT OUTPUT
AS
BEGIN
IF(@Type='ROE')
BEGIN
	IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
	DROP table  #tempTableA
	SELECT * INTO #tempTableA 
	from
	(  
	select updation.ID,updation.Action,ROE,comm1.Value as UserType,updation.UserTypeId,comm2.Value as Product,comm3.Value as BaseCurrency,comm4.Value as ToCurrency,
			comm5.Value as GDSType,country.CountryName as Country ,tblComm.CategoryValue as OfficeId ,
			updation.AirLineId,updation.IsAllAirline,updation.AgencyId,updation.IsAllAgency,muser.UserName as ModifiedBy,updation.ModifiedOn,updation.CountryId,updation.StateId,
			updation.BranchId,updation.FLag
	from mROEUpdationHistory updation
	left join mCommon comm1 on updation.UserTypeId=comm1.ID
	left join mCommon comm2  on updation.ProductId=comm2.ID
	left join mCommon comm3  on updation.BaseCurrencyId=comm3.ID
	left join mCommon comm4  on updation.ToCurrencyId=comm4.ID
	left join mCommon comm5  on updation.GDSTypeId=comm5.ID
	left join mCountry country on updation.CountryId=country.ID
	--left join AirlinesName airline on updation.AirLineId=airline.ID
	left join tbl_commonmaster tblComm on updation.OfficeId=tblComm.pkid
	inner join mUser muser on muser.ID=updation.ModifiedBy

	where  CONVERT(date,updation.ModifiedOn) >= CONVERT(date,@FromDate)  
		and CONVERT(date,updation.ModifiedOn) <= CONVERT(date,@ToDate)
		 ) p 
	order by p.ModifiedOn desc

		SELECT @RecordCount = @@ROWCOUNT

		SELECT * FROM #tempTableA
		ORDER BY  ModifiedOn desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY

	END

ELSE IF(@Type='USER')
BEGIN
	IF OBJECT_ID ( 'tempdb..#tempTableB') IS NOT NULL
	DROP table  #tempTableB
	SELECT * INTO #tempTableB 
	from
	(  
	select History.ID, Action,History.FullName,History.UserName,History.MobileNo,History.EmailID,Location.LocationName,
	Dept.DepartmentName,History.CountryID,History.EmployeeNo,R.RoleName,History.UserTypeID,History.AgentBalance,
	mUser.UserName as 'ModifiedBy',History.ModifiedOn,History.AutoTicketing,History.SelfBalance,History.CancelRequest,
	History.GhostTrack
	from mUserHistory History
	inner join mLocation Location on Location.ID=History.LocationID
	inner join mDepartment Dept on Dept.ID=History.DepartmentID
	inner join mRole r on r.ID=History.RoleID
	--inner join mCommon comm on comm.ID=History.UserTypeID
	inner join mUser muser on muser.ID=History.ModifiedBy

	where  CONVERT(date,History.ModifiedOn) >= CONVERT(date,@FromDate)  
		and CONVERT(date,History.ModifiedOn) <= CONVERT(date,@ToDate)
		 ) p 
	order by p.ModifiedOn desc

		SELECT @RecordCount = @@ROWCOUNT

		SELECT * FROM #tempTableB
		ORDER BY  ModifiedOn desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY

END

ELSE IF(@Type='Commission')
BEGIN
	IF OBJECT_ID ( 'tempdb..#tempTableC') IS NOT NULL
	DROP table  #tempTableC
	SELECT * INTO #tempTableC 
	from
	( 
	select 
	History.ID,
	History.Action,
	History.TravelValidityFrom,
	History.TravelValidityTo,
	History.SaleValidityFrom,
	History.SaleValidityTo,
	History.Flag,
	History.cabin,
	History.Origin,
	History.OriginValue,
	History.Destination,
	History.DestinationValue,
	History.FlightSeries,
	History.Commission,
	History.IATADealPercent,
	History.AgencyNames,
	History.PLBDealPercent,
	History.MarkupAmount,
	History.PaxType,
	History.AvailabilityPCC,History.PNRCreationPCC,History.TicketingPCC,
	(CONVERT(varchar, History.TravelValidityFrom, 105) + ' - ' + CONVERT(varchar, History.TravelValidityTo, 105)) as [TravelValidity],
	(CONVERT(varchar, History.SaleValidityFrom, 105) + ' - ' + CONVERT(varchar, History.SaleValidityTo, 105)) as [SaleValidity],
	History.ModifiedOn,History.Remark,History.PricingCode,History.TourCode,History.Endorsementline,History.FareType,History.CardMapping1,
	History.IATADiscountType,History.PLBDiscountType,History.MarkupType,History.DropnetCommission,

	u.UserName as 'ModifiedUN',comm.UserType,comm.MarketPoint,comm.AirportType,comm.AirlineType,
	comm.AgentCategory,c.CategoryValue as 'CRSTypeValue',History.LoginId
	from Flight_CommissionHistory History
	inner join Flight_Commission comm on comm.Id=History.ParentId
	left join mUser u ON U.ID=History.ModifiedBy
	left join tbl_commonmaster c on c.pkid=History.CRSType

	where  CONVERT(date,History.ModifiedOn) >= CONVERT(date,@FromDate)  
		and CONVERT(date,History.ModifiedOn) <= CONVERT(date,@ToDate)
		 ) p 
	order by p.ModifiedOn desc

		SELECT @RecordCount = @@ROWCOUNT

		SELECT * FROM #tempTableC
		ORDER BY  ModifiedOn desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY

END

ELSE IF(@Type='CardMaster')
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTablecard') IS NOT NULL
	DROP table  #tempTablecard
	SELECT * INTO #tempTablecard 
	from
	(  
	select History.Action,History.BankName,History.CardType,History.CardNumber,History.ExpiryDate,History.MarketPoint,
	History.UserType,U.UserName as 'ModifiedBy',History.ModifiedOn 
	from mCardMasterHistory as History
	inner JOIN mUser U on U.ID=History.ModifiedBy

	where  CONVERT(date,History.ModifiedOn) >= CONVERT(date,@FromDate)  
		and CONVERT(date,History.ModifiedOn) <= CONVERT(date,@ToDate)
		 ) p 
	order by p.ModifiedOn desc

		SELECT @RecordCount = @@ROWCOUNT

		SELECT * FROM #tempTablecard
		ORDER BY  ModifiedOn desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY

END
ELSE IF(@Type='CardDetails')
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTablecardDetails') IS NOT NULL
	DROP table  #tempTablecardDetails
	SELECT * INTO #tempTablecardDetails 
	from
	(  
	select History.Action,History.BankName,History.CardType,History.CardNumber,History.ExpiryDate,History.MarketPoint,
	History.UserType,U.UserName as 'ModifiedBy',History.ModifiedOn 
	from mCardDetailsHistory as History
	inner JOIN mUser U on U.ID=History.ModifiedBy

	where  CONVERT(date,History.ModifiedOn) >= CONVERT(date,@FromDate)  
		and CONVERT(date,History.ModifiedOn) <= CONVERT(date,@ToDate)
		 ) p 
	order by p.ModifiedOn desc

		SELECT @RecordCount = @@ROWCOUNT

		SELECT * FROM #tempTablecardDetails
		ORDER BY  ModifiedOn desc
		OFFSET @Start ROWS
		FETCH NEXT @Pagesize ROWS ONLY

END
ELSE IF(@Type='VendorCredential')  
BEGIN  
 IF OBJECT_ID ( 'tempdb..#tempTablev') IS NOT NULL  
 DROP table  #tempTablev  
 SELECT * INTO #tempTablev   
 from  
 (    
 select history.ID,History.VendorID,vendor.VendorName,History.OfficeId,History.Field,History.Value,History.FareType,History.ApiIndicator,  
 OidName,Vendorcode,Billingusertype,Erpcountry,Iatanumber,CountryHistoryId,  
  U.UserName as 'ModifiedBy',History.ModifiedOn   
  from mVendorCredentialHistory as History  
  inner join mVendor vendor on vendor.ID=History.VendorID  
  inner JOIN mUser U on U.ID=History.ModifiedBy  
  
 where  CONVERT(date,History.ModifiedOn) >= CONVERT(date,@FromDate)    
  and CONVERT(date,History.ModifiedOn) <= CONVERT(date,@ToDate)  
   ) p   
 order by p.ModifiedOn desc  
  
  SELECT @RecordCount = @@ROWCOUNT  
  
  SELECT * FROM #tempTablev  
  ORDER BY  ModifiedOn desc  
  OFFSET @Start ROWS  
  FETCH NEXT @Pagesize ROWS ONLY  
  
 END  

END

GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetROEUpdationHistory] TO [rt_read]
    AS [dbo];

