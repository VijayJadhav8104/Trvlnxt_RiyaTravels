--declare @RecordCount int
--exec [dbo].[Sp_GetBookingTrackReport1] '2023-05-01','2023-05-31','','1,2,3,4,5','IN,US,CA,AE,UK','','','','','','','','','','','',0,100,'A',@RecordCount
CREATE PROCEDURE [dbo].[Sp_GetBookingTrackReport1]
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
	@RecordCount INT OUTPUT
AS
BEGIN
	IF OBJECT_ID ('tempdb..#tempTableA') IS NOT NULL
		DROP TABLE #tempTableA
	SELECT * INTO #tempTableA 
	FROM
	( 
		SELECT --top 1 with ties
	  	AL.BookingCountry AS 'Country'
		, c.Value AS 'User Type'
		, ISNULL(R.AgencyName,r1.AgencyName) AS 'Agency Name'
		, ISNULL(R.Icast,r1.Icast) AS 'Cust id'
		--CONVERT(DATETIME, isnull(b.inserteddate_old,b.inserteddate))  AS 'Booking date & time',
		, CASE country.CountryCode 
			WHEN 'AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))) 
   			WHEN 'US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))) 
   			WHEN 'CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))) 
			WHEN 'UK' THEN (DATEADD(SECOND, - 5*60*60 + 30*60, CONVERT(varchar(20), CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)), 120)))
   			WHEN 'IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)),120))
 			END AS 'Booking date & time'
		, b.orderId AS 'Track ID'
		, (CASE WHEN (b.BookingStatus=1 or b.BookingStatus=6) THEN 'Confirmed' WHEN B.BookingStatus=2 THEN 'Hold' WHEN B.BookingStatus=3 THEN 'Pending'
			WHEN (B.BookingStatus=9 or B.BookingStatus=4) THEN 'Cancelled' WHEN B.BookingStatus=0 THEN 'Failed' WHEN B.BookingStatus=5 THEN 'Close'
			WHEN B.BookingStatus=10 THEN 'Manual Booking' WHEN B.BookingStatus=8 THEN 'Reschedule PNR' WHEN B.BookingStatus=12 THEN 'In-Process' END) AS 'Status'
		, B.riyaPNR AS 'Booking id'
		, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  'Airline PNR'
		, B.GDSPNR AS 'CRS PNR'
		, B.TicketIssuanceError AS 'Remarks'
		, (CASE --when b.MainAgentId>0  AND @BookingType='Manual'  then (select a.UserName + '-' +   a.FirstName + isnull(a.LastName,'')  from agentLogin a where a.UserID=b.MainAgentId)
				WHEN b.MainAgentId=0 AND ParentAgentID is null AND  BookedBy>0 THEN (SELECT  a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a where a.UserID=b.BookedBy)
				WHEN b.MainAgentId=0 AND BookedBy=0 THEN (SELECT a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a WHERE CAST(a.UserID as varchar(50))=b.AgentID)
				WHEN b.MainAgentId>0  AND ParentAgentID is null  then (SELECT a.UserName + '-' +   a.FullName FROM mUser a WHERE a.ID=b.MainAgentId)
				WHEN b.MainAgentId=0 AND ParentAgentID is not null
				THEN (SELECT r.Icast + ' Sub user : ' + al.UserName + ', Display name : ' + al.FirstName+' '+isnull(al.LastName,'')
			FROM tblBookMaster b1
			INNER JOIN agentLogin al ON cast(al.UserID as varchar(50))=b1.AgentID
			INNER JOIN B2BRegistration r ON r.FKUserID=al.ParentAgentID
			WHERE b1.pkId=b.pkId)
			ELSE '' END
			) AS 'User'
		, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Airport'
		, B.airName+' ('+B.airCode+')' 'Airline name'
		, (SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
				AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId) as 'Sector'
		, (SELECT STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
				AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId) as 'Flight No'
		, (SELECT STUFF((SELECT '-' + CASE when  CHARINDEX('-',s.cabin) = 0 then s.cabin else substring(s.cabin, 1, CHARINDEX('-',s.cabin)-1) END 
				FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
				AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId) as 'Class Code'

		--(SELECT STUFF((SELECT '-' + CONVERT(VARCHAR(10), CONVERT(DATETIME, B.depDate, 0), 103) FROM tblBookMaster s
		-- WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
		--AS 'Dep Date' FROM tblBookMaster t where t.orderId=b.orderId  GROUP BY t.orderId) as 'Dep Date',
		--(SELECT STUFF((SELECT '-' + CONVERT(VARCHAR(10), CONVERT(DATETIME, B.arrivalDate, 0), 103) FROM tblBookMaster s
		-- WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
		--AS 'Arrvl Date' FROM tblBookMaster t where t.orderId=b.orderId  GROUP BY t.orderId) as 'Arrvl Date',
		, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
				AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)AS 'Dep Date all'
		, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.arrivalDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
				AS Sector FROM tblBookItenary t where t.fkBookMaster=b.pkId  GROUP BY t.orderId)AS 'Arrvl Date all'
		, (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.depDate, 0), 103) ) AS 'Dep Date'
		, (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.arrivalDate, 0), 103)) AS 'Arrvl Date'
		, (CASE WHEN P.payment_mode='PassThrough' THEN 'Credit Card' ELSE P.payment_mode END) AS 'Payment Mode'
		, country.Currency as 'Currency'

		--commented by bhavika AND added sum of gross fare AND net fare
		--convert(varchar,isnull( cast((((B.totalFare+B.TotalMarkup+B.MCOAmount+B.B2BMarkup+b.AgentMarkup)-B.TotalDiscount)* b.ROE) as decimal(18,2)) ,0)) AS 'Net fare',
		--cast(((b.totalFare+B.B2BMarkup+isnull(b.MCOAmount,0) + +isnull(b.AgentMarkup,0))* b.ROE) as decimal(18,2)) as 'Gross fare',
		--(select SUM (cast((((bm.totalFare+isnull(bm.TotalMarkup,0)+isnull(bm.MCOAmount,0)+isnull(bm.B2BMarkup,0)+isnull(bm.AgentMarkup,0))-isnull(bm.TotalDiscount,0))* bm.ROE) as decimal(18,2))) from tblBookMaster as bm where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR) AS 'Net fare' ,
		--(select SUM(cast(((bm.totalFare+bm.B2BMarkup+isnull(bm.MCOAmount,0) + +isnull(bm.AgentMarkup,0))* bm.ROE) as decimal(18,2))) From tblBookMaster as bm where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR) as 'Gross fare',
		--(Select SUM(SSR_Amount) from tblSSRDetails as ssr Where ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR)) as SSRAmount_Meal_Baggage,

		-- added by asmita
		, (select SUM (cast((((bm.totalFare+isnull(bm.TotalMarkup,0)+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0))-isnull(bm.TotalDiscount,0))* bm.ROE + isnull(bm.B2BMarkup,0)) as decimal(18,2))) from tblBookMaster as bm where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR
				= b.riyaPNR) +   ISNULL( (Select SUM(SSR_Amount) from tblSSRDetails as ssr Where ssr.fkBookMaster IN (Select pkid From tblBookMaster where GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR)),0) AS 'Net fare'     
		, (select SUM(cast(((bm.totalFare+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0))* bm.ROE + bm.B2BMarkup) as decimal(18,2)))
				From tblBookMaster as bm where bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR) +    ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr
				Where ssr.fkBookMaster IN (Select pkid From tblBookMaster where --GDSPNR = b.GDSPNR AND 
				riyaPNR = b.riyaPNR)),0) as 'Gross fare' 
		--- end 
		, B.MCOAmount as 'MCO Amount'
		, (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 103) + ' '+ CONVERT(VARCHAR(10),CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 108)) as 'UpdatedDate'
		, (u.UserName + '-' + u.FullName) as 'UpdatedbyUser'
		, b.Remarks as 'UpdatedUserRemarks'
		, (case when b.MainAgentId>=0 AND b.BookingSource='Web' then 'Internal Booking (Web)'
				when b.MainAgentId>=0 AND b.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'
				when b.MainAgentId>=0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Internal Booking Retrive PNR - MultiTST)'
				when b.MainAgentId>=0 AND b.BookingSource='Cryptic' then 'Internal Booking (Cryptic)'
				--when b.MainAgentId>=0 AND b.BookingSource='Retrieve PNR accounting' then 'Internal Booking (Retrive PNR Accounting)' --by asmita
				--when b.MainAgentId>=0 AND b.BookingSource='Retrieve PNR accounting - MultiTST' then 'Internal Booking Accounting(Retrive PNR Accounting)'
				when b.MainAgentId>=0 AND b.BookingSource='Retrive PNR Accounting' then 'Internal Booking Accounting(Retrive PNR Accounting)'
				when b.MainAgentId=0 AND b.BookingSource='Web' then 'Agent Booking (Web)'
				when b.MainAgentId=0 AND b.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)' 
				when b.MainAgentId=0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Agent Booking (Retrive PNR - MultiTST)' 
				--added by afifa
				when b.MainAgentId>0 AND b.BookingSource='ManualTicketing' then 'ManualTicketing'
				when b.MainAgentId=0 AND b.BookingSource='Cryptic' then 'Agent Booking (Cryptic)'
				when  b.BookingSource='GDS' then 'TJQ'
			end
			) as 'Booking Mode'
		, b.VendorName as 'CRS'
		, b.OfficeID as 'Booking Supplier'
		, b.OfficeID as 'Ticketing Suppier'
		--(case when isnull(al.NewCurrency,0) !=0 then 
		--	(select com.Value from mCommon com where com.ID=al.NewCurrency) else '' end) as 'Agent Currency',
		, ''  as 'Agent Currency'
		, ('') as 'ROE'
		, TFBookingRef
		, TFBookingstatus  
		, p.bank_ref_no AS [Bank Ref No.]
		, p.order_status AS [Order Status]
		, p.failure_message AS [Failure_Message]
		, pc.TotalCommission As [PG_Charges]
		, P.bank_ref_no AS [bank_ref_no]
		, CASE WHEN ISNULL(TripType,'')='M' THEN 'Multi City' ELSE CASE b.journey WHEN 'O' THEN 'One Way' WHEN 'R' THEN 'Round Trip' WHEN 'M' THEN 'Round Trip Special' END END AS [Journey_Type]
		, b.FareType AS [Fare_Type]
	FROM tblBookMaster b
	INNER JOIN agentLogin AL ON cast(AL.UserID AS VARCHAR(50))=B.AgentID
	INNER JOIN mCommon C on C.ID=AL.UserTypeID
	LEFT JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID
	LEFT JOIN B2BRegistration R1 ON CAST(R1.FKUserID AS VARCHAR(50))=al.ParentAgentID
	LEFT JOIN Paymentmaster P ON P.order_id=B.orderId
	LEFT JOIN mUser u ON b.BookingTrackModifiedBy=u.ID
	INNER JOIN mCountry country ON b.Country=country.CountryCode
    LEFT JOIN B2BMakepaymentCommission pc ON pc.OrderId=b.orderId --AND ProductType='Air'
	--inner join tblPassengerBookDetails pb on pb.fkBookMaster=b.pkId
	--INNER JOIN mCommon CS ON CS.ID=B.BookingStatus
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
		 --AND ((@JournyType='TTM' AND ISNULL(b.TripType,'') = 'M') OR (@JournyType='A' OR b.journey = @JournyType))
		 AND ((@JournyType='TTM' AND ISNULL(b.TripType,'') = 'M') OR (@JournyType='A' OR (b.journey = @JournyType and  B.TripType!='M')))
		 AND (
				(@BookingType = '') 
				OR ((@BookingType='IBW') AND b.MainAgentId>0 AND (b.BookingSource='Web'))
				OR ((@BookingType='IBR') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))
				-- or((@BookingType='IBRA') AND b.MainAgentId>0 AND (b.BookingSource='Retrieve PNR accounting - MultiTST'))
				OR ((@BookingType='IBRA') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR Accounting'))
				OR ((@BookingType='ABW') AND b.MainAgentId=0 AND (b.BookingSource='Web'))
				OR ((@BookingType='ABR') AND b.MainAgentId=0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST')) 
				OR ((@BookingType='CRYPI') AND b.MainAgentId>0 AND (b.BookingSource='Cryptic'))
				OR ((@BookingType='CRYPA') AND b.MainAgentId=0 AND (b.BookingSource='Cryptic'))
				OR ((@BookingType='TJQ') AND (b.BookingSource='GDS'))
				--added by afifa
				OR ((@BookingType='Manual') AND b.MainAgentId>0 AND (b.BookingSource='ManualTicketing'))
				OR (@BookingType='ANCI' AND isnull(b.MainAgentId,0)>=0 AND p.ParentOrderId IS NOT NULL)
			)
			AND b.returnFlag=0
			AND b.pkId IN (SELECT TOP 1 pkid FROM tblBookMaster WHERE orderid=b.orderId ORDER BY pkId ASC)
			--order by row_number() over (partition by b.GDSPNR order by b.inserteddate desc)
	) p
	ORDER BY p.[Booking date & time] DESC
	
	SELECT @RecordCount = @@ROWCOUNT

	SELECT * FROM #tempTableA
	ORDER BY [Booking date & time] DESC
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetBookingTrackReport1] TO [rt_read]
    AS [dbo];

