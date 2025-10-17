--declare @RecordCount int
--exec [dbo].[Sp_GetBookingTrackReport_Optimize_JN] '2023-05-01 00:00:00','2023-06-05 23:59:00','','1,2,3,4,5','IN,US,CA,AE,UK','','','','','','','','','','','',2,100,'A',1,@RecordCount
CREATE PROCEDURE [dbo].[Sp_GetBookingTrackReport_Optimize_JN]
	@FromDate Datetime=null, 
	@ToDate Datetime=null, 
	@PaymentType varchar(50)=null,
	@UserType varchar(max)=null, 
	@Country varchar(max)=null,
	@AgentId int=null,
	@SubUserId int=null,
	@Status varchar(2)=null,
	@ProductType varchar(20)=null,
	@BookingType varchar(20)=null,
	@AirportType varchar(20)=null,
	@Airline varchar(max)=null,
	@CRS varchar(20)=null, 
	@BookingId varchar(50)=null,
	@AirlinePnr varchar(50)=null,
	@GDSPnr varchar(50)=null,
	@Start int=null,
	@Pagesize int=null,
	@JournyType Varchar(50)=null,
	@IsPaging bit=null,
	@RecordCount INT OUTPUT
AS
BEGIN
	--DECLARE @DATA TABLE(
	--	SrNo INT
	--	, [Country] Varchar(50)
	--	, [User Type] Varchar(50)
	--	, [Agency Name] Varchar(100)
	--	, [Cust id] Varchar(50)
	--	, [Booking date & time] Varchar(50)
	--	, [Track ID] Varchar(50)
	--	, [Status] Varchar(50)
	--	, [Booking id] Varchar(20)
	--	, [Airline PNR] Varchar(50)
	--	, [CRS PNR] Varchar(50)
	--	, Remarks Varchar(MAX)
	--	, [User] Varchar(100)
	--	, Airport Varchar(50)
	--	, [Airline name] Varchar(50)
	--	, Sector Varchar(MAX)
	--	, [Flight No] Varchar(MAX)
	--	, [Class Code] Varchar(MAX)
	--	, [Dep Date all] Varchar(MAX)
	--	, [Arrvl Date all] Varchar(MAX)
	--	, [Dep Date] Varchar(50)
	--	, [Arrvl Date] Varchar(50)
	--	, [Payment Mode] Varchar(50)
	--	, Currency Varchar(20)
	--	, [Net fare] Decimal(18,2)
	--	, [Gross fare] Decimal(18,2)
	--	, [MCO Amount] Decimal(18,2)
	--	, [UpdatedDate] Varchar(50)
	--	, [UpdatedbyUser] Varchar(50)
	--	, [UpdatedUserRemarks] Varchar(MAX)
	--	, [Booking Mode] Varchar(100) 
	--	, CRS Varchar(50)
	--	, [Booking Supplier] Varchar(50) 
	--	, [Ticketing Suppier] Varchar(50) 
	--	, [Agent Currency] Varchar(50) 
	--	, ROE Varchar(50)
	--	, TFBookingRef Varchar(50)
	--	, TFBookingstatus Varchar(50)
	--	, [Bank Ref No.] Varchar(50)
	--	, [Order Status] Varchar(50)
	--	, [Failure_Message] Varchar(MAX)
	--	, [PG_Charges] decimal(18,2)
	--	, [bank_ref_no] Varchar(100)
	--	, [Journey_Type] Varchar(20)
	--	, [Fare_Type] Varchar(100)
	--)
	IF(@IsPaging=1)
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY ISNULL(b.inserteddate_old,b.inserteddate) DESC) AS SrNo
		, AL.BookingCountry AS 'Country'
		, c.Value AS 'User Type'
		, ISNULL(R.AgencyName,R1.AgencyName) AS 'Agency Name'
		, ISNULL(R.Icast,R1.Icast) AS 'Cust id'
		, (CASE country.CountryCode 
				WHEN 'AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))) 
   				WHEN 'US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))) 
   				WHEN 'CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))) 
				WHEN 'GB' THEN (DATEADD(SECOND, - 5*60*60 + 30*60, CONVERT(varchar(20), CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)), 120)))
   				WHEN 'IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))
 				END) AS 'Booking date & time'
		, b.orderId AS 'Track ID'
		, (CASE WHEN (b.BookingStatus=1 or b.BookingStatus=6) THEN 'Confirmed' WHEN B.BookingStatus=2 THEN 'Hold' WHEN B.BookingStatus=3 THEN 'Pending'
				WHEN (B.BookingStatus=9 or B.BookingStatus=4) THEN 'Cancelled' WHEN B.BookingStatus=0 THEN 'Failed' WHEN B.BookingStatus=5 THEN 'Close'
				WHEN B.BookingStatus=10 THEN 'Manual Booking' WHEN B.BookingStatus=8 THEN 'Reschedule PNR' WHEN B.BookingStatus=12 THEN 'In-Process' END) AS 'Status'
		, b.riyaPNR AS 'Booking id'
		, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS  'Airline PNR'
		, B.GDSPNR AS 'CRS PNR'
		, B.TicketIssuanceError AS 'Remarks'
		, (CASE 
				WHEN b.MainAgentId=0 AND ParentAgentID is null AND  BookedBy>0 THEN (SELECT  a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a where a.UserID=b.BookedBy)
				WHEN b.MainAgentId=0 AND BookedBy=0 THEN (SELECT a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a WHERE Cast(a.UserID AS varchar(50))=b.AgentID)
				WHEN b.MainAgentId>0  AND ParentAgentID is null  then (SELECT a.UserName + '-' +   a.FullName FROM mUser a WHERE a.ID=b.MainAgentId)
				WHEN b.MainAgentId=0 AND ParentAgentID is not null
				THEN 
					(SELECT r.Icast + ' Sub user : ' + al.UserName + ', Display name : ' + al.FirstName+' '+isnull(al.LastName,'')
						FROM tblBookMaster b1 WITH(NOLOCK)
						INNER JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID as varchar(50))=b1.AgentID
						INNER JOIN B2BRegistration r WITH(NOLOCK) ON r.FKUserID=al.ParentAgentID
						WHERE b1.pkId=b.pkId)
				ELSE '' END) AS 'User'
		, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Airport'
		, B.airName+' ('+B.airCode+')' 'Airline name'
		--Jitendra Nakum (02.06.2023) Query optimize for booking track report
		, (SELECT STUFF((SELECT '/' + frmSector+ '-' + toSector FROM tblBookItenary WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS Sector
		, (SELECT STUFF((SELECT '/' + s.airCode+ '-' + flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS 'Flight No'
		, (SELECT STUFF((SELECT '-' + CASE when  CHARINDEX('-',s.cabin) = 0 then s.cabin else substring(s.cabin, 1, CHARINDEX('-',s.cabin)-1) END FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'')) as 'Class Code'
		, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Dep Date all'
		, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.arrivalDate, 0), 103))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Arrvl Date all'
		, (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.depDate, 0), 103) ) AS 'Dep Date'
		, (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.arrivalDate, 0), 103)) AS 'Arrvl Date'
		, (CASE WHEN P.payment_mode='PassThrough' THEN 'Credit Card' ELSE P.payment_mode END) AS 'Payment Mode'
		, country.Currency as 'Currency'
		, (select SUM (cast(((
				(bm.totalFare+isnull(bm.TotalMarkup,0)+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0)+isnull(bm.BFC,0))
				-isnull(bm.TotalDiscount,0))* bm.ROE + isnull(bm.B2BMarkup,0)) as decimal(18,2)))
				from tblBookMaster as bm WITH(NOLOCK) where bm.pkId = b.pkId) 
				+ ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK) 
				Where ssr.fkBookMaster IN (Select pkid From tblBookMaster where pkId = b.pkId)),0) AS 'Net fare'     
		, (select SUM(cast(((bm.totalFare+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0)+isnull(bm.BFC,0))* bm.ROE + bm.B2BMarkup) as decimal(18,2)))
				From tblBookMaster as bm WITH(NOLOCK) where bm.pkId = b.pkId) +    ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK)
				Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = b.pkId)),0) as 'Gross fare' 
		, B.MCOAmount as 'MCO Amount'
		, CONVERT(VARCHAR(10), CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 103) + ' '+ CONVERT(VARCHAR(10),CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 108) as 'UpdatedDate'
		, (u.UserName + '-' + u.FullName) as 'UpdatedbyUser'
		, b.Remarks as 'UpdatedUserRemarks'
		, (case when b.MainAgentId>=0 AND b.BookingSource='Web' then 'Internal Booking (Web)'
				when b.MainAgentId>=0 AND b.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'
				when b.MainAgentId>=0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Internal Booking Retrive PNR - MultiTST)'
				when b.MainAgentId>=0 AND b.BookingSource='Cryptic' then 'Internal Booking (Cryptic)'
				when b.MainAgentId>=0 AND b.BookingSource='Retrive PNR Accounting' then 'Internal Booking Accounting(Retrive PNR Accounting)'
				when b.MainAgentId=0 AND b.BookingSource='Web' then 'Agent Booking (Web)'
				when b.MainAgentId=0 AND b.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)' 
				when b.MainAgentId=0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Agent Booking (Retrive PNR - MultiTST)' 
				when b.MainAgentId>0 AND b.BookingSource='ManualTicketing' then 'ManualTicketing'
				when b.MainAgentId=0 AND b.BookingSource='Cryptic' then 'Agent Booking (Cryptic)'
				when  b.BookingSource='GDS' then 'TJQ'
				WHEN b.MainAgentId>0 AND b.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
				WHEN b.MainAgentId>0 AND b.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
			end
			) as 'Booking Mode'
		, b.VendorName as 'CRS'
		, b.OfficeID as 'Booking Supplier'
		, b.OfficeID as 'Ticketing Suppier'
		, ''  as 'Agent Currency'
		, '' as 'ROE'
		, TFBookingRef
		, TFBookingstatus  
		, p.bank_ref_no AS [Bank Ref No.]
		, p.order_status AS [Order Status]
		, p.failure_message AS [Failure_Message]
		, pc.TotalCommission As [PG_Charges]
		, P.bank_ref_no AS [bank_ref_no]
		, CASE WHEN ISNULL(TripType,'')='M' THEN 'Multi City' ELSE CASE b.journey WHEN 'O' THEN 'One Way' WHEN 'R' THEN 'Round Trip' WHEN 'M' THEN 'Round Trip Special' END END AS [Journey_Type]
		, b.FareType AS [Fare_Type]
		FROM tblBookMaster AS b
		INNER JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50)) = b.AgentID
		INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID
		LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50)) = b.AgentID
		LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50)) = AL.ParentAgentID
		INNER JOIN mCountry country WITH(NOLOCK) ON b.Country = country.CountryCode
		LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId
		LEFT JOIN mUser u WITH(NOLOCK) ON b.BookingTrackModifiedBy=u.ID
		LEFT JOIN B2BMakepaymentCommission pc WITH(NOLOCK) ON pc.OrderId=b.orderId
		WHERE ((@FROMDate = '') OR (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(datetime,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(datetime, @ToDate)))
 		AND ((@PaymentType = '') OR (@PaymentType='Wallet' AND (p.payment_mode='Check' OR p.payment_mode='Credit')) OR (p.payment_mode=@PaymentType))
		AND ((@UserType = '') OR ( AL.UserTypeID IN ( select Data from sample_split(@UserType,','))))
		AND ((@Country = '') OR (al.BookingCountry IN ( select Data from sample_split(@Country,','))))
		AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId as varchar(50))) or (al.ParentAgentID=@AgentId))
		AND ((@SubUserId = '') OR  (b.AgentID =cast(@SubUserId as varchar(50))))
		AND ((@Status = '')  
		OR ((@Status = '1') AND (cast(b.BookingStatus as varchar(50))='1' OR cast(b.BookingStatus as varchar(50))='6' OR cast(b.BookingStatus as varchar(50))='4') AND ( b.IsBooked=1))
		OR ((@Status != '') AND (cast(b.BookingStatus as varchar(50))=@Status)))
		AND ((@ProductType = '') OR ( @ProductType = 'Airline'))
		AND ((@AirportType = '')  
		OR ((@AirportType = 'Domestic') AND (b.CounterCloseTime = 1)) 
		OR ((@AirportType = 'International') AND (b.CounterCloseTime != 1)))
		AND ((@Airline = '') OR (b.airCode IN  ( select Data from sample_split(@Airline,','))))
		AND ((@BookingId = '') OR (b.riyaPNR = @BookingId))
		AND ((@AirlinePnr = '') OR ((SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) = @AirlinePnr))
		AND ((@GDSPnr = '') OR (b.GDSPNR = @GDSPnr))
		AND ((@CRS = '') OR (b.VendorName = @CRS))
		AND ((@JournyType='TTM' AND ISNULL(b.TripType,'') = 'M') OR (@JournyType='A' OR (b.journey = @JournyType and  B.TripType!='M')))
		AND (
			(@BookingType = '') 
			OR ((@BookingType='IBW') AND b.MainAgentId>0 AND (b.BookingSource='Web'))
			OR ((@BookingType='IBR') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))
			OR ((@BookingType='IBRA') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR Accounting'))
			OR ((@BookingType='ABW') AND b.MainAgentId=0 AND (b.BookingSource='Web'))
			OR ((@BookingType='ABR') AND b.MainAgentId=0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST')) 
			OR ((@BookingType='CRYPI') AND b.MainAgentId>0 AND (b.BookingSource='Cryptic'))
			OR ((@BookingType='CRYPA') AND b.MainAgentId=0 AND (b.BookingSource='Cryptic'))
			OR ((@BookingType='TJQ') AND (b.BookingSource='GDS'))
			OR ((@BookingType='Manual') AND b.MainAgentId>0 AND (b.BookingSource='ManualTicketing'))
			OR (@BookingType='ANCI' AND isnull(b.MainAgentId,0)>=0 AND p.ParentOrderId is not null)
		)
		AND b.returnFlag=0
		AND b.pkId IN (SELECT TOP 1 pkid FROM tblBookMaster WITH(NOLOCK) WHERE orderid=b.orderId ORDER BY pkId ASC)
		ORDER BY ISNULL(b.inserteddate_old,b.inserteddate) DESC
		OFFSET (@Start) * @Pagesize ROWS
		FETCH NEXT @Pagesize ROWS ONLY


		select @recordcount=count(*) from tblbookmaster b with(nolock)
		inner join agentlogin al with(nolock) on cast(al.userid as varchar(50))=b.agentid
		inner join mcommon c with(nolock) on c.id=al.usertypeid
		--left join b2bregistration r with(nolock) on cast(r.fkuserid as varchar(50))=b.agentid
		--left join b2bregistration r1 with(nolock) on cast(r1.fkuserid as varchar(50))=al.parentagentid
		left join paymentmaster p with(nolock) on p.order_id=b.orderid
		left join muser u with(nolock) on b.bookingtrackmodifiedby=u.id
		inner join mcountry country with(nolock) on b.country=country.countrycode
		left join b2bmakepaymentcommission pc with(nolock) on pc.orderid=b.orderid 
		where ((@fromdate = '') or (convert(datetime,isnull(b.inserteddate_old,b.inserteddate)) >= convert(datetime,@fromdate)))
 		and ((@todate = '') or (convert(datetime,isnull(b.inserteddate_old,b.inserteddate)) <= convert(datetime, @todate)))
 		and ((@paymenttype = '') or (@paymenttype='wallet' and (p.payment_mode='check' or p.payment_mode='credit')) or (p.payment_mode=@paymenttype))
		and ((@usertype = '') or ( al.usertypeid in ( select data from sample_split(@usertype,','))))
		and ((@country = '') or (al.bookingcountry in ( select data from sample_split(@country,','))))
		and ((@agentid = '') or  (b.agentid =cast(@agentid as varchar(50))) or (al.parentagentid=@agentid))
		and ((@subuserid = '') or  (b.agentid =cast(@subuserid as varchar(50))))
		and ((@status = '')  
		or ((@status = '1') and (cast(b.bookingstatus as varchar(50))='1' or cast(b.bookingstatus as varchar(50))='6' or cast(b.bookingstatus as varchar(50))='4') and ( b.isbooked=1))
		or ((@status != '') and (cast(b.bookingstatus as varchar(50))=@status)))
		and ((@producttype = '') or ( @producttype = 'airline'))
		and ((@airporttype = '')  
		or ((@airporttype = 'domestic') and (b.counterclosetime = 1)) 
		or ((@airporttype = 'international') and (b.counterclosetime != 1)))
		and ((@airline = '') or (b.aircode in  ( select data from sample_split(@airline,','))))
		and ((@bookingid = '') or (b.riyapnr = @bookingid))
		and ((@airlinepnr = '') or ((select top 1 airlinepnr from tblbookitenary bi where bi.fkbookmaster=b.pkid) = @airlinepnr))
		and ((@gdspnr = '') or (b.gdspnr = @gdspnr))
		and ((@crs = '') or (b.vendorname = @crs))
		and ((@journytype='ttm' and isnull(b.triptype,'') = 'm') or (@journytype='a' or (b.journey = @journytype and  b.triptype!='m')))
		and (
			(@bookingtype = '') 
			or ((@bookingtype='ibw') and b.mainagentid>0 and (b.bookingsource='web'))
			or ((@bookingtype='ibr') and b.mainagentid>0 and (b.bookingsource='retrive pnr' or b.bookingsource='retrive pnr - multitst'))
			or ((@bookingtype='ibra') and b.mainagentid>0 and (b.bookingsource='retrive pnr accounting'))
			or ((@bookingtype='abw') and b.mainagentid=0 and (b.bookingsource='web'))
			or ((@bookingtype='abr') and b.mainagentid=0 and (b.bookingsource='retrive pnr' or b.bookingsource='retrive pnr - multitst')) 
			or ((@bookingtype='crypi') and b.mainagentid>0 and (b.bookingsource='cryptic'))
			or ((@bookingtype='crypa') and b.mainagentid=0 and (b.bookingsource='cryptic'))
			or ((@bookingtype='tjq') and (b.bookingsource='gds'))
			or ((@bookingtype='manual') and b.mainagentid>0 and (b.bookingsource='manualticketing'))
			or (@bookingtype='anci' and isnull(b.mainagentid,0)>=0 and p.parentorderid is not null)
		)
		and b.returnflag=0
		and b.pkid IN (SELECT TOP 1 pkid FROM tblBookMaster WITH(NOLOCK) WHERE orderid=b.orderId ORDER BY pkId ASC)	

		print @RecordCount
	END
	ELSE
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY ISNULL(b.inserteddate_old,b.inserteddate) DESC) AS SrNo
		, AL.BookingCountry AS 'Country'
		, c.Value AS 'User Type'
		, ISNULL(R.AgencyName,R1.AgencyName) AS 'Agency Name'
		, ISNULL(R.Icast,R1.Icast) AS 'Cust id'
		, (CASE country.CountryCode 
				WHEN 'AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))) 
   				WHEN 'US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))) 
   				WHEN 'CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))) 
				WHEN 'GB' THEN (DATEADD(SECOND, - 5*60*60 + 30*60, CONVERT(varchar(20), CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)), 120)))
   				WHEN 'IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))
 				END) AS 'Booking date & time'
		, b.orderId AS 'Track ID'
		, (CASE WHEN (b.BookingStatus=1 or b.BookingStatus=6) THEN 'Confirmed' WHEN B.BookingStatus=2 THEN 'Hold' WHEN B.BookingStatus=3 THEN 'Pending'
				WHEN (B.BookingStatus=9 or B.BookingStatus=4) THEN 'Cancelled' WHEN B.BookingStatus=0 THEN 'Failed' WHEN B.BookingStatus=5 THEN 'Close'
				WHEN B.BookingStatus=10 THEN 'Manual Booking' WHEN B.BookingStatus=8 THEN 'Reschedule PNR' WHEN B.BookingStatus=12 THEN 'In-Process' END) AS 'Status'
		, b.riyaPNR AS 'Booking id'
		, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS  'Airline PNR'
		, B.GDSPNR AS 'CRS PNR'
		, B.TicketIssuanceError AS 'Remarks'
		, (CASE 
				WHEN b.MainAgentId=0 AND ParentAgentID is null AND  BookedBy>0 THEN (SELECT  a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a where a.UserID=b.BookedBy)
				WHEN b.MainAgentId=0 AND BookedBy=0 THEN (SELECT a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a WHERE Cast(a.UserID AS varchar(50))=b.AgentID)
				WHEN b.MainAgentId>0  AND ParentAgentID is null  then (SELECT a.UserName + '-' +   a.FullName FROM mUser a WHERE a.ID=b.MainAgentId)
				WHEN b.MainAgentId=0 AND ParentAgentID is not null
				THEN 
					(SELECT r.Icast + ' Sub user : ' + al.UserName + ', Display name : ' + al.FirstName+' '+isnull(al.LastName,'')
						FROM tblBookMaster b1 WITH(NOLOCK)
						INNER JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID as varchar(50))=b1.AgentID
						INNER JOIN B2BRegistration r WITH(NOLOCK) ON r.FKUserID=al.ParentAgentID
						WHERE b1.pkId=b.pkId)
				ELSE '' END) AS 'User'
		, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Airport'
		, B.airName+' ('+B.airCode+')' 'Airline name'
		--Jitendra Nakum (02.06.2023) Query optimize for booking track report
		, (SELECT STUFF((SELECT '/' + frmSector+ '-' + toSector FROM tblBookItenary WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS Sector
		, (SELECT STUFF((SELECT '/' + s.airCode+ '-' + flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS 'Flight No'
		, (SELECT STUFF((SELECT '-' + CASE when  CHARINDEX('-',s.cabin) = 0 then s.cabin else substring(s.cabin, 1, CHARINDEX('-',s.cabin)-1) END FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'')) as 'Class Code'
		, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Dep Date all'
		, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.arrivalDate, 0), 103))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Arrvl Date all'
		, (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.depDate, 0), 103) ) AS 'Dep Date'
		, (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.arrivalDate, 0), 103)) AS 'Arrvl Date'
		, (CASE WHEN P.payment_mode='PassThrough' THEN 'Credit Card' ELSE P.payment_mode END) AS 'Payment Mode'
		, country.Currency as 'Currency'
		, (select SUM (cast(((
				(bm.totalFare+isnull(bm.TotalMarkup,0)+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0)+isnull(bm.BFC,0))
				-isnull(bm.TotalDiscount,0))* bm.ROE + isnull(bm.B2BMarkup,0)) as decimal(18,2)))
				from tblBookMaster as bm WITH(NOLOCK) where bm.pkId = b.pkId) 
				+ ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK) 
				Where ssr.fkBookMaster IN (Select pkid From tblBookMaster where pkId = b.pkId)),0) AS 'Net fare'     
		, (select SUM(cast(((bm.totalFare+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0)+isnull(bm.BFC,0))* bm.ROE + bm.B2BMarkup) as decimal(18,2)))
				From tblBookMaster as bm WITH(NOLOCK) where bm.pkId = b.pkId) +    ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK)
				Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = b.pkId)),0) as 'Gross fare' 
		, B.MCOAmount as 'MCO Amount'
		, CONVERT(VARCHAR(10), CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 103) + ' '+ CONVERT(VARCHAR(10),CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 108) as 'UpdatedDate'
		, (u.UserName + '-' + u.FullName) as 'UpdatedbyUser'
		, b.Remarks as 'UpdatedUserRemarks'
		, (case when b.MainAgentId>=0 AND b.BookingSource='Web' then 'Internal Booking (Web)'
				when b.MainAgentId>=0 AND b.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'
				when b.MainAgentId>=0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Internal Booking Retrive PNR - MultiTST)'
				when b.MainAgentId>=0 AND b.BookingSource='Cryptic' then 'Internal Booking (Cryptic)'
				when b.MainAgentId>=0 AND b.BookingSource='Retrive PNR Accounting' then 'Internal Booking Accounting(Retrive PNR Accounting)'
				when b.MainAgentId=0 AND b.BookingSource='Web' then 'Agent Booking (Web)'
				when b.MainAgentId=0 AND b.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)' 
				when b.MainAgentId=0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Agent Booking (Retrive PNR - MultiTST)' 
				when b.MainAgentId>0 AND b.BookingSource='ManualTicketing' then 'ManualTicketing'
				when b.MainAgentId=0 AND b.BookingSource='Cryptic' then 'Agent Booking (Cryptic)'
				when  b.BookingSource='GDS' then 'TJQ'
				WHEN b.MainAgentId>0 AND b.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'
				WHEN b.MainAgentId>0 AND b.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'
			end
			) as 'Booking Mode'
		, b.VendorName as 'CRS'
		, b.OfficeID as 'Booking Supplier'
		, b.OfficeID as 'Ticketing Suppier'
		, ''  as 'Agent Currency'
		, '' as 'ROE'
		, TFBookingRef
		, TFBookingstatus  
		, p.bank_ref_no AS [Bank Ref No.]
		, p.order_status AS [Order Status]
		, p.failure_message AS [Failure_Message]
		, pc.TotalCommission As [PG_Charges]
		, P.bank_ref_no AS [bank_ref_no]
		, CASE WHEN ISNULL(TripType,'')='M' THEN 'Multi City' ELSE CASE b.journey WHEN 'O' THEN 'One Way' WHEN 'R' THEN 'Round Trip' WHEN 'M' THEN 'Round Trip Special' END END AS [Journey_Type]
		, b.FareType AS [Fare_Type]
		FROM tblBookMaster AS b
		INNER JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50)) = b.AgentID
		INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID
		LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50)) = b.AgentID
		LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50)) = AL.ParentAgentID
		INNER JOIN mCountry country WITH(NOLOCK) ON b.Country = country.CountryCode
		LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId
		LEFT JOIN mUser u WITH(NOLOCK) ON b.BookingTrackModifiedBy=u.ID
		LEFT JOIN B2BMakepaymentCommission pc WITH(NOLOCK) ON pc.OrderId=b.orderId
		WHERE ((@FROMDate = '') OR (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(datetime,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(datetime, @ToDate)))
 		AND ((@PaymentType = '') OR (@PaymentType='Wallet' AND (p.payment_mode='Check' OR p.payment_mode='Credit')) OR (p.payment_mode=@PaymentType))
		AND ((@UserType = '') OR ( AL.UserTypeID IN ( select Data from sample_split(@UserType,','))))
		AND ((@Country = '') OR (al.BookingCountry IN ( select Data from sample_split(@Country,','))))
		AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId as varchar(50))) or (al.ParentAgentID=@AgentId))
		AND ((@SubUserId = '') OR  (b.AgentID =cast(@SubUserId as varchar(50))))
		AND ((@Status = '')  
		OR ((@Status = '1') AND (cast(b.BookingStatus as varchar(50))='1' OR cast(b.BookingStatus as varchar(50))='6' OR cast(b.BookingStatus as varchar(50))='4') AND ( b.IsBooked=1))
		OR ((@Status != '') AND (cast(b.BookingStatus as varchar(50))=@Status)))
		AND ((@ProductType = '') OR ( @ProductType = 'Airline'))
		AND ((@AirportType = '')  
		OR ((@AirportType = 'Domestic') AND (b.CounterCloseTime = 1)) 
		OR ((@AirportType = 'International') AND (b.CounterCloseTime != 1)))
		AND ((@Airline = '') OR (b.airCode IN  ( select Data from sample_split(@Airline,','))))
		AND ((@BookingId = '') OR (b.riyaPNR = @BookingId))
		AND ((@AirlinePnr = '') OR ((SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) = @AirlinePnr))
		AND ((@GDSPnr = '') OR (b.GDSPNR = @GDSPnr))
		AND ((@CRS = '') OR (b.VendorName = @CRS))
		AND ((@JournyType='TTM' AND ISNULL(b.TripType,'') = 'M') OR (@JournyType='A' OR (b.journey = @JournyType and  B.TripType!='M')))
		AND (
			(@BookingType = '') 
			OR ((@BookingType='IBW') AND b.MainAgentId>0 AND (b.BookingSource='Web'))
			OR ((@BookingType='IBR') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))
			OR ((@BookingType='IBRA') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR Accounting'))
			OR ((@BookingType='ABW') AND b.MainAgentId=0 AND (b.BookingSource='Web'))
			OR ((@BookingType='ABR') AND b.MainAgentId=0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST')) 
			OR ((@BookingType='CRYPI') AND b.MainAgentId>0 AND (b.BookingSource='Cryptic'))
			OR ((@BookingType='CRYPA') AND b.MainAgentId=0 AND (b.BookingSource='Cryptic'))
			OR ((@BookingType='TJQ') AND (b.BookingSource='GDS'))
			OR ((@BookingType='Manual') AND b.MainAgentId>0 AND (b.BookingSource='ManualTicketing'))
			OR (@BookingType='ANCI' AND isnull(b.MainAgentId,0)>=0 AND p.ParentOrderId is not null)
		)
		AND b.returnFlag=0
		AND b.pkId IN (SELECT TOP 1 pkid FROM tblBookMaster WITH(NOLOCK) WHERE orderid=b.orderId ORDER BY pkId ASC)
		ORDER BY ISNULL(b.inserteddate_old,b.inserteddate) DESC
		--OFFSET (@Start) * @Pagesize ROWS
		--FETCH NEXT @Pagesize ROWS ONLY

		SELECT @recordcount = @@ROWCOUNT
	END
END