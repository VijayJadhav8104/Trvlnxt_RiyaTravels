--exec [dbo].[Sp_GetBookingTrackWeb_Optimize] '2023-06-17 00:00','2023-06-19 23:59','','1,2,3,4,5','IN,US,CA,AE,UK','','','','','','','','','','',''
CREATE PROCEDURE [dbo].[Sp_GetBookingTrackWeb_Optimize]
	@FromDate varchar(50)=NULL,
	@ToDate varchar(50)=NULL,
	@PaymentType varchar(50)=NULL,
	@UserType varchar(max)=NULL,
	@Country varchar(max)=NULL,
	@AgentId int=NULL,
	@SubUserId int=NULL,
	@Status varchar(50)=NULL,
	@ProductType varchar(50)=NULL,
	@BookingType varchar(50)=NULL,
	@AirportType varchar(50)=NULL,
	@Airline varchar(max)=NULL,
	@CRS varchar(50)=NULL,
	@BookingId varchar(50)=NULL,
	@AirlinePnr varchar(50)=NULL,
	@GDSPnr varchar(50)=NULL,
	@Content varchar(50)='',
	@UserId int=0
AS          
BEGIN          
	IF OBJECT_ID ('tempdb..#tempTableA') IS NOT NULL
		DROP table  #tempTableA

	SELECT * INTO #tempTableA FROM
	(           
		SELECT AL.BookingCountry AS 'Country'
				, c.Value AS 'User Type'
				, ISNULL(R.AgencyName,r1.AgencyName) AS 'Agency Name'
				, ISNULL(R.Icast,r1.Icast) AS 'Cust id'
				,CASE WHEN country.CountryCode = 'AE' THEN 
             FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')
             WHEN country.CountryCode = 'US' THEN 
             FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')
             WHEN country.CountryCode = 'CA' THEN 
             FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')
             WHEN country.CountryCode = 'UK' THEN 
             FORMAT(DATEADD(SECOND, -5*60*60 + 30*60, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')
             WHEN country.CountryCode = 'IN' THEN 
             FORMAT(CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate)), 'dd-MMM-yyyy HH:mm:ss')
             END AS 'Booking date & time'
		     , b.orderId AS 'Track ID'
				, (CASE WHEN (b.BookingStatus=1) THEN 'Confirmed'           
						WHEN B.BookingStatus=2 THEN 'Hold'           
						WHEN B.BookingStatus=3 THEN 'Pending'          
						WHEN (B.BookingStatus=9 OR B.BookingStatus=4) THEN 'Cancelled'           
						WHEN B.BookingStatus=0 THEN 'Failed'           
						WHEN B.BookingStatus=5 THEN 'Close'          
						WHEN B.BookingStatus=6 THEN 'To Be Cancelled'          
						WHEN B.BookingStatus=7 THEN 'To Be Reschedule'          
						WHEN B.BookingStatus=10 THEN 'Manual Booking' 
						WHEN (B.BookingStatus=11) THEN 'Cancelled' 
						WHEN (B.BookingStatus=12) THEN 'In-Process' 
						WHEN B.BookingStatus=8 THEN 'Reschedule PNR' END) AS 'Status'
				, B.riyaPNR AS 'Booking id'
				, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airline PNR'
				, B.GDSPNR AS 'CRS PNR'
				, B.TicketIssuanceError AS 'Remarks'
				, (CASE WHEN b.MainAgentId=0 AND AL.ParentAgentID IS NULL AND  BookedBy>0 
							THEN (SELECT  a.UserName + '-' + ISNULL(a.FirstName,'') +' '+ISNULL(a.LastName,'') 
									FROM AgentLogin a WITH(NOLOCK) 
									WHERE a.UserID=b.BookedBy)          
						WHEN b.MainAgentId=0 AND BookedBy=0 
							THEN (SELECT a.UserName + '-' + ISNULL(a.FirstName,'') +' '+ISNULL(a.LastName,'') 
									FROM AgentLogin a WITH(NOLOCK) 
									WHERE CAST(a.UserID AS varchar(50))=b.AgentID)
						WHEN b.MainAgentId>0  AND AL.ParentAgentID IS NULL  
							THEN (SELECT a.UserName + '-' +   a.FullName 
									FROM mUser a WITH(NOLOCK) 
									WHERE a.ID=b.MainAgentId)          
						WHEN b.MainAgentId=0 AND AL.ParentAgentID IS NOT NULL            
							THEN (SELECT r.Icast + ' Sub user : ' + al.UserName + ', Display name : ' + al.FirstName+' '+ISNULL(al.LastName,'')
									FROM tblBookMaster b1 WITH(NOLOCK)
									INNER JOIN agentLogin al WITH(NOLOCK) on CAST(al.UserID AS varchar(50))=b1.AgentID          
									INNER JOIN B2BRegistration r WITH(NOLOCK) on r.FKUserID=al.ParentAgentID          
									WHERE b1.pkId=b.pkId)          
						 ELSE '' 
					END) AS 'User'
				, (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Airport'
				, B.airName+' ('+B.airCode+')' 'Airline name'
				--Jitendra Nakum (02.06.2023) Query optimize for booking track report
				, (SELECT STUFF((SELECT '/' + frmSector+ '-' + toSector FROM tblBookItenary WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS Sector
				, (SELECT STUFF((SELECT '/' + s.airCode+ '-' + flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS 'Flight No'
				, (SELECT STUFF((SELECT '-' + CASE WHEN  CHARINDEX('-',s.cabin) = 0 THEN s.cabin ELSE substring(s.cabin, 1, CHARINDEX('-',s.cabin)-1) END FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'')) AS 'Class Code'
				, (SELECT STUFF((SELECT '/' +(SELECT CONVERT(VARCHAR(12), FORMAT(CONVERT(DATETIME, s.depDate, 0), 'dd-MMM-yyyy')))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Dep Date all'
				, (SELECT STUFF((SELECT '/' +(SELECT CONVERT(VARCHAR(12), FORMAT(CONVERT(DATETIME, s.arrivalDate, 0), 'dd-MMM-yyyy')))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Arrvl Date all'

				--, (SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
				--		AS Sector FROM tblBookItenary t WHERE t.fkBookMaster=b.pkId  GROUP BY t.orderId) AS 'Sector'
				--, (SELECT STUFF((SELECT '/' + s.airCode+ '-' + s.flightNo FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
				--		AS Sector FROM tblBookItenary t WHERE t.fkBookMaster=b.pkId  GROUP BY t.orderId) AS 'Flight No'
				--, (SELECT STUFF((SELECT '-' + CASE WHEN  CHARINDEX('-',s.cabin) = 0 THEN s.cabin ELSE substring(s.cabin, 1, CHARINDEX('-',s.cabin)-1) END
				--		FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')
				--		AS Sector FROM tblBookItenary t WHERE t.fkBookMaster=b.pkId  GROUP BY t.orderId) AS 'Class Code'
				--, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')
				--		AS Sector FROM tblBookItenary t WHERE t.fkBookMaster=b.pkId  GROUP BY t.orderId)AS 'Dep Date all'
				--, (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.arrivalDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')
				--		AS Sector FROM tblBookItenary t WHERE t.fkBookMaster=b.pkId  GROUP BY t.orderId)AS 'Arrvl Date all'
				
				, (SELECT CONVERT(VARCHAR(12), FORMAT(CONVERT(DATETIME, B.depDate), 'dd-MMM-yyyy'))) AS 'Dep Date'
				, (SELECT CONVERT(VARCHAR(12), FORMAT(CONVERT(DATETIME, B.arrivalDate), 'dd-MMM-yyyy'))) AS 'Arrvl Date'
				, (CASE WHEN P.payment_mode='PassThrough' THEN 'Credit Card' ELSE P.payment_mode END) AS 'Payment Mode'
				, country.Currency AS 'Currency'
				, B.MCOAmount AS 'MCO Amount'

				--Jitendra Nakum (02.06.2023) Query optimize for booking track report
				, (SELECT b.TotalHupAmount+ SUM (cast((((bm.totalFare+ISNULL(bm.TotalMarkup,0)+ISNULL(bm.AgentMarkup,0))-ISNULL(bm.TotalDiscount,0))* bm.ROE * bm.AgentROE --+ ISNULL(bm.ServiceFee,0)+ISNULL(bm.GST,0) 
						+ ISNULL(bm.B2BMarkup,0) + ISNULL(bm.BFC,0) ) AS decimal(18,2))) FROM tblBookMaster AS bm WITH(NOLOCK) WHERE bm.pkId = b.pkId) 
						+ (Select ISNULL(SUM(SSR_Amount),0)* b.ROE * b.AgentROE  FROM tblSSRDetails AS ssr WITH(NOLOCK)
						WHERE ssr.fkBookMaster IN (Select pkid FROM tblBookMaster WITH(NOLOCK) WHERE pkId = b.pkId)) AS 'Net fare'
				, (SELECT SUM(cast(((bm.totalFare+ISNULL(bm.TotalMarkup,0)+ISNULL(bm.AgentMarkup,0))* bm.ROE * bm.AgentROE --+ISNULL(bm.ServiceFee,0)+ISNULL(bm.GST,0) 
						+ ISNULL(bm.B2BMarkup,0) + ISNULL(bm.BFC,0)) AS decimal(18,2))) FROM tblBookMaster AS bm WITH(NOLOCK) WHERE bm.pkId = b.pkId)  
						+ (Select ISNULL(SUM(SSR_Amount),0)* b.ROE * b.AgentROE  FROM tblSSRDetails AS ssr WITH(NOLOCK)
						WHERE ssr.fkBookMaster IN (Select pkid FROM tblBookMaster WITH(NOLOCK) WHERE pkId = b.pkId)) AS 'Gross fare'

				--, (SELECT b.TotalHupAmount+ SUM (cast((((bm.totalFare+ISNULL(bm.TotalMarkup,0)+ISNULL(bm.AgentMarkup,0))-ISNULL(bm.TotalDiscount,0))* bm.ROE * bm.AgentROE --+ ISNULL(bm.ServiceFee,0)+ISNULL(bm.GST,0) 
				--		+ ISNULL(bm.B2BMarkup,0) + ISNULL(bm.BFC,0) ) AS decimal(18,2))) FROM tblBookMaster AS bm WHERE bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR) + (Select ISNULL(SUM(SSR_Amount),0)* b.ROE * b.AgentROE  FROM tblSSRDetails AS ssr WHERE ssr.fkBookMaster IN (Select pkid FROM tblBookMaster WHERE GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR)) AS 'Net fare'
				--, (SELECT SUM(cast(((bm.totalFare+ISNULL(bm.TotalMarkup,0)+ISNULL(bm.AgentMarkup,0))* bm.ROE * bm.AgentROE --+ISNULL(bm.ServiceFee,0)+ISNULL(bm.GST,0) 
				--		+ ISNULL(bm.B2BMarkup,0) + ISNULL(bm.BFC,0)) AS decimal(18,2))) FROM tblBookMaster AS bm WHERE bm.GDSPNR = b.GDSPNR AND bm.riyaPNR = b.riyaPNR)  + (Select ISNULL(SUM(SSR_Amount),0)* b.ROE * b.AgentROE  FROM tblSSRDetails AS ssr WHERE ssr.fkBookMaster IN (Select pkid FROM tblBookMaster WHERE GDSPNR = b.GDSPNR AND riyaPNR = b.riyaPNR)) AS 'Gross fare'
				, (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 103) + ' '+ CONVERT(VARCHAR(10),CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 108)) AS 'UpdatedDate'
				, (u.UserName + '-' + u.FullName) AS 'UpdatedbyUser'
				, b.Remarks AS 'UpdatedUserRemarks'
				, (CASE WHEN   b.BookingSource='Web' THEN 'Web'          
						WHEN  b.BookingSource='Retrive PNR' THEN 'Retrive PNR'          
						WHEN  b.BookingSource='Retrive PNR - MultiTST' THEN 'Retrive PNR'          
						WHEN b.BookingSource='Cryptic' THEN 'Cryptic PNR'          
						WHEN b.BookingSource='Retrieve PNR accounting' THEN 'Retrive PNR Accounting'          
						WHEN b.BookingSource='ManualTicketing' THEN 'Manual Booking'   
						WHEN b.BookingSource='Retrive PNR Accounting-TicketNumber' THEN  'Retrive PNR Accounting'
						WHEN b.BookingSource='Retrive PNR Accounting' THEN 'Retrive PNR Accounting'
						WHEN b.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Retrieve PNR accounting - MultiTST' 
						ELSE b.BookingSource
						END) AS 'Booking Mode'
				, b.VendorName AS 'CRS'
				, b.OfficeID AS 'Booking Supplier'
				, b.OfficeID AS 'Ticketing Suppier'
				, ''  AS 'Agent Currency'
				, '' AS 'ROE'
				, b.inserteddate
				, b.orderId
				, b.riyaPNR
				, b.AgentId
				, TFBookingRef AS TFrefNumber
				, TFBookingstatus
		FROM tblBookMaster b WITH(NOLOCK)
		LEFT JOIN agentLogin AL WITH(NOLOCK) ON cast(AL.UserID AS VARCHAR(50))=B.AgentID
		LEFT JOIN mCommon C WITH(NOLOCK) on C.ID=AL.UserTypeID
		LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID
		LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50))=al.ParentAgentID
		LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId
		LEFT JOIN mUser u WITH(NOLOCK) on b.BookingTrackModifiedBy=u.ID
		LEFT JOIN mCountry country WITH(NOLOCK) on b.Country=country.CountryCode
				OUTER APPLY (SELECT top 1 officeid, value FROM mvendorcredential WHERE fieldName = 'COUNTRYCODE' AND officeid = b.officeid and IsActive=1) AS mvc 
		LEFT JOIN mUser mu on b.MainAgentId=mu.ID
		WHERE ((@FROMDate = '') OR (CONVERT(datetime,b.inserteddate_old) >= CONVERT(datetime,@FROMDate)))
 		AND ((@ToDate = '') OR (CONVERT(datetime,b.inserteddate_old) <= CONVERT(datetime, @ToDate)))
 		AND ((@PaymentType = '') OR (@PaymentType='Wallet' AND (p.payment_mode='Check' OR p.payment_mode='Credit')) OR (p.payment_mode=@PaymentType))
		AND ((@UserType = '') OR ( AL.UserTypeID IN  ( SELECT Data FROM sample_split(@UserType,','))))
		AND ((@Country = '') OR (al.BookingCountry IN ( SELECT Data FROM sample_split(@Country,','))))
		AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId AS varchar(50))) OR (al.ParentAgentID=@AgentId))
		AND ((@SubUserId = '') OR  (b.AgentID =cast(@SubUserId AS varchar(50))))
		AND (@Status = '' 
			OR ((@Status = '1') 
				AND (cast(b.BookingStatus as varchar(50))='1' 
					OR cast(b.BookingStatus as varchar(50))='6' 
					OR cast(b.BookingStatus as varchar(50))='4')
				AND ( b.IsBooked=1))
		  OR b.BookingStatus IN (SELECT TRY_CAST(Data AS INT) FROM sample_split(@Status, ',')))	
		--AND ((@Status = '')  
		--	OR ((@Status = '1') 
		--		AND (cast(b.BookingStatus AS varchar(50))='1' 
		--			OR cast(b.BookingStatus AS varchar(50))='6' 
		--			OR cast(b.BookingStatus AS varchar(50))='4')
		--		AND ( b.IsBooked=1))
		--	OR ((@Status != '') AND (cast(b.BookingStatus AS varchar(50))=@Status)))
		--AND ((@Status = '')
		--	OR ((@Status = '1') and (cast(b.BookingStatus AS varchar(50))='1' OR cast(b.BookingStatus AS varchar(50))='6' OR cast(b.BookingStatus AS varchar(50))='4' OR cast(b.BookingStatus AS varchar(50))='11') AND ( b.IsBooked=1))
		--	OR ((@Status = '4') and (cast(b.BookingStatus AS varchar(50))='6' OR cast(b.BookingStatus AS varchar(50))='4' OR cast(b.BookingStatus AS varchar(50))='11') AND ( b.IsBooked=1))
		--	OR ((@Status != '') AND (cast(b.BookingStatus AS varchar(50))=@Status)))
		AND ((@ProductType = '') OR ( @ProductType = 'Airline'))
		AND ((@AirportType = '') OR ((@AirportType = 'Domestic') and (b.CounterCloseTime = 1))
			OR ((@AirportType = 'International') AND (b.CounterCloseTime != 1)))
		AND ((@Airline = '') OR (b.airCode IN  ( SELECT Data FROM sample_split(@Airline,','))))
		AND ((@BookingId = '') OR (b.riyaPNR = @BookingId))
		AND ((@AirlinePnr = '') OR ((SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) = @AirlinePnr))
		AND ((@GDSPnr = '') OR (b.GDSPNR = @GDSPnr))
		AND ((@CRS = '') OR (b.VendorName = @CRS))
		AND ( (@BookingType = '') OR((@BookingType='IBW') AND b.MainAgentId>0 AND (b.BookingSource='Web'))
			OR((@BookingType='IBR') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))
			OR((@BookingType='IBRA') AND b.MainAgentId=0 AND (b.BookingSource='Retrieve PNR accounting'))
			OR((@BookingType='ABW') AND b.MainAgentId=0 AND (b.BookingSource='Web'))
			OR((@BookingType='ABR') AND b.MainAgentId=0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))
			OR((@BookingType='CRYPI') AND b.MainAgentId>0 AND (b.BookingSource='Cryptic'))
			OR((@BookingType='CRYPA') AND b.MainAgentId=0 AND (b.BookingSource='Cryptic'))
			OR((@BookingType='Manual') AND b.MainAgentId>0 AND (b.BookingSource='ManualTicketing'))
			OR((@BookingType='ABRA') AND b.MainAgentId>0 AND (b.BookingSource='Retrieve PNR accounting - MultiTST'))
			--OR (@BookingType='ANCI' AND ISNULL(b.MainAgentId,0)>=0 AND p.ParentOrderId IS NOT NULL)
		)          
		AND b.returnFlag=0    AND b.pkId in (SELECT top 1 pkid FROM tblBookMaster WITH(NOLOCK) WHERE orderid=b.orderId order by pkId asc)      
		AND (@UserId =0 OR mu.ID =@UserId)
    	AND ((@Content = '') OR (@Content = null) OR  ((@Content = 'IN' AND mvc.value = 'IN' AND ISNULL(b.VendorName, '') <> 'Travelfusion') OR (@Content != 'IN' AND (mvc.value != 'IN' OR ISNULL(b.VendorName, '') = 'Travelfusion'))))
		AND b.AgentID!='B2C'
		--order by row_number() over (partition by b.GDSPNR order by b.inserteddate desc)          
	) p          
	order by p.[Booking date & time] desc          
	SELECT * FROM #tempTableA          
	ORDER BY [Booking date & time] desc           
END