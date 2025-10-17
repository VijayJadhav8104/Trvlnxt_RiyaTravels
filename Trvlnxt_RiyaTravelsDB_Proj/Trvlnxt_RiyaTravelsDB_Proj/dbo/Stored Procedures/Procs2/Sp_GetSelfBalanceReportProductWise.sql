--DECLARE @RecordCount Int
--exec [dbo].[Sp_GetSelfBalanceReportProductWise]  '2023-10-01','2023-10-04','',0,1000,1,'',0,100
CREATE PROCEDURE [dbo].[Sp_GetSelfBalanceReportProductWise]
	@FromDate Date=null,                           
	@ToDate Date=null,                          
	@UserIds Varchar(max)=null,                          
	@Start int=null,                          
	@Pagesize int=null,                          
	@IsPaging bit=null,                  
	@Branch varchar(max)=null,--Jitendra Nakum add branch/Location filter as per today mail 20/09/2022
	@ProductType Int=null,
	@RecordCount INT OUTPUT                          
AS                          
BEGIN
	SET @RecordCount=0

	IF OBJECT_ID ( 'tempdb..#tempTableAir') IS NOT NULL
		DROP table  #tempTableAir                          
	SELECT * INTO #tempTableAir                           
	FROM (
		SELECT DISTINCT 
		(CASE c.CountryCode 
			WHEN 'AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(Varchar(20),ISNULL(b.inserteddate_old,b.inserteddate),120))) -- 1 hour, 29 minutes and 13 seconds
			WHEN 'US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(Varchar(20),ISNULL(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes and 16 seconds
			WHEN 'CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(Varchar(20),ISNULL(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes and 16 seconds
			WHEN 'IN' THEN (DATEADD(SECOND, 0,CONVERT(Varchar(20),isnull(b.inserteddate_old,b.inserteddate),120)))  --- 0 hour, 0 minutes and 0 seconds
		END) AS 'Date & Time',
		c.CountryName as 'Country',
		'' as 'Currency',                        --add column currency on 19-04-23
		'0.00' as 'Credit',
		pm.mer_amount as 'Debit',
		ISNULL(CloseBalance,'0.00') as 'Remaining', 
		CONCAT(u1.UserName,'-',u1.FullName) as 'User id',
		CASE WHEN b.AddUserSelfBalance is not null and b.AddUserSelfBalance>0 
			THEN (SELECT sb.UserName +'-' +sb.FullName FROM  mUser sb WITH(NOLOCK) WHERE CAST(sb.ID as varchar(50))=b.AddUserSelfBalance) else '' end AS 'New User SB',
		b.airName AS 'Airline Name',
		B.riyaPNR AS 'Booking id',
		(SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR',
		B.GDSPNR AS 'CRS PNR',                          
		(SELECT STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s WITH(NOLOCK)
			WHERE s.fkBookMaster = t.fkBookMaster ORDER BY TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber
			from tblPassengerBookDetails t WITH(NOLOCK) WHERE TicketNumber is not null and fkBookMaster=b.pkId
			GROUP BY t.fkBookMaster
		) as 'Ticket No',
		b.OfficeID as 'Vendor id',
		'' AS 'FILE NO',
		CASE WHEN ISNULL(b.OBTCNo,'')!='' THEN b.OBTCNo ELSE (Select top 1 ISNULL(ma.OBTCno,'') AS OBTCno from mAttrributesDetails ma Where ma.OrderID=b.orderId AND ISNULL(ma.OBTCno,'')!='') END AS 'OBT NO',
		'' AS 'Inquiry No',
		'' AS 'Opss remarks',                          
		'' AS 'Accts Remarks',
		u.UserName AS 'Updated by',
		'' AS 'Updated Remarks'                          
		FROM tblBookMaster AS b WITH(NOLOCK)
		INNER JOIN Paymentmaster AS pm WITH(NOLOCK) ON pm.order_id=b.orderId
		INNER JOIN mCountry AS c WITH(NOLOCK) ON b.Country=c.CountryCode
		LEFT JOIN mUser AS u WITH(NOLOCK) ON b.IssueBy=u.ID
		INNER JOIN mUser AS u1 WITH(NOLOCK) ON b.MainAgentId=u1.ID
		LEFT JOIN tblSelfBalance AS sb WITH(NOLOCK) ON b.orderId=sb.BookingRef and sb.TransactionType='Debit'
		--LEFT JOIN mAttrributesDetails ma WITH(NOLOCK) on ma.OrderID=b.orderId

		WHERE pm.payment_mode='Self Balance'
		AND (@FROMDate = '' 
				OR CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(date,@FROMDate))
		AND (@ToDate = '' 
				OR CONVERT(date,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(date, @ToDate))
		AND (@UserIds = ''
				OR b.MainAgentId IN (select Data from sample_split(@UserIds,','))
				OR CAST(b.AddUserSelfBalance AS int) IN (select Data from sample_split(@UserIds,',')))
		AND B.totalFare > 0 
		AND b.IsBooked=1
		AND (@Branch =''
				OR u.LocationID IN (select Data from sample_split(@Branch,',')))
                      
		UNION ALL                        
                      
		SELECT DISTINCT
		(CASE WHEN c.CountryCode ='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes and 13 seconds
			WHEN c.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds
			WHEN c.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds
			WHEN c.CountryCode='IN' THEN (DATEADD(SECOND, 0,CONVERT(varchar(20),isnull(b.ModifiedOn,isnull(b.inserteddate_old,b.inserteddate)),120)))  --- 0 hour, 0 minutes and 0 seconds
		END) AS 'Date & Time',
		c.CountryName AS 'Country',
		'' as 'Currency',                            --add column currency on 19-04-23
		pm.mer_amount AS 'Credit',
		'0.00' AS 'Debit',
		ISNULL(CloseBalance,'0.00') AS 'Remaining',
		u1.UserName AS 'User id',
		CASE WHEN b.AddUserSelfBalance IS NOT NULL AND b.AddUserSelfBalance>0
			 THEN (SELECT sb.UserName +'-' +sb.FullName AS 'New User SB'
					FROM mUser sb WITH(NOLOCK) WHERE b.AddUserSelfBalance=CAST(sb.ID AS Varchar(50)))
			 ELSE '' END AS 'New User SelfBalance',
		b.airName AS 'Airline Name',
		B.riyaPNR AS 'Booking id',
		(SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS 'Airlines PNR',
		B.GDSPNR AS 'CRS PNR',
		(SELECT STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s WITH(NOLOCK)
			WHERE s.fkBookMaster = t.fkBookMaster ORDER BY TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber
			FROM tblPassengerBookDetails t WITH(NOLOCK) WHERE TicketNumber is not null and fkBookMaster=b.pkId
			GROUP BY t.fkBookMaster) AS 'Ticket No',
		b.OfficeID AS 'Vendor id',
		b.FileNo AS 'FILE NO',
		(Select top 1 ISNULL(ma.OBTCno,'') AS OBTCno from mAttrributesDetails ma Where ma.OrderID=b.orderId AND ISNULL(ma.OBTCno,'')!='') AS 'OBT NO',
		b.InquiryNo AS 'Inquiry No',
		b.OpsRemark AS 'Opss remarks',                          
		b.AcctsRemark AS 'Accts Remarks',
		u.UserName AS 'Updated by',
		'' AS 'Updated Remarks'                          
		FROM  tblBookMaster AS b WITH(NOLOCK)
		INNER JOIN Paymentmaster AS pm WITH(NOLOCK) ON pm.order_id=b.orderId                          
		INNER JOIN mCountry AS c WITH(NOLOCK) ON b.Country=c.CountryCode
		LEFT JOIN mUser AS u WITH(NOLOCK) ON b.IssueBy=u.ID
		INNER JOIN mUser AS u1 WITH(NOLOCK) ON b.MainAgentId=u1.ID
		LEFT JOIN tblSelfBalance AS sb WITH(NOLOCK) ON b.orderId=sb.BookingRef --and sb.TransactionType='Credit' commented by asmita
		--LEFT JOIN mAttrributesDetails AS ma WITH(NOLOCK) ON ma.OrderID=b.orderId
		WHERE pm.payment_mode='Self Balance' and b.AgentInvoiceNumber is not null
		AND ((@FROMDate = '') OR (CONVERT(Date,ISNULL(b.ModifiedOn,b.inserteddate_old)) >= CONVERT(date,@FROMDate)))
		AND ((@ToDate = '') OR (CONVERT(Date,ISNULL(b.ModifiedOn,b.inserteddate_old)) <= CONVERT(date, @ToDate)))
		AND ((@UserIds = '') OR  (b.MainAgentId IN (SELECT Data FROM sample_split(@UserIds,','))) OR  (CAST(b.AddUserSelfBalance AS int) IN (select Data from sample_split(@UserIds,','))))
		AND B.totalFare>0   AND b.IsBooked=1 AND sb.TransactionType='Credit'
		AND((@Branch ='') OR (u.LocationID IN (SELECT Data FROM sample_split(@Branch,','))))
                      
		UNION  ALL                         
                      
		SELECT DISTINCT 
		(CASE c.CountryCode WHEN 'AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(Varchar(20),isnull(b.CancelledDate,isnull(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes and 13 seconds
			WHEN 'US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(Varchar(20),ISNULL(b.CancelledDate,ISNULL(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds
			WHEN 'CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(Varchar(20),ISNULL(b.CancelledDate,ISNULL(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes and 16 seconds
			WHEN 'IN' then (DATEADD(SECOND, 0,CONVERT(Varchar(20),ISNULL(b.CancelledDate,ISNULL(b.inserteddate_old,b.inserteddate)),120)))  --- 0 hour, 0 minutes and 0 seconds
		END) AS 'Date & Time',
		c.CountryName AS 'Country',
		'' as 'Currency',                       --add column currency on 19-04-23
		pm.mer_amount  AS 'Credit',
		'0.00'  AS 'Debit',
		'0.00' AS 'Remaining',
		u1.UserName AS 'User id',		
		CASE WHEN b.AddUserSelfBalance IS NOT NULL AND b.AddUserSelfBalance>0 
			THEN (SELECT sb.UserName +'-' +sb.FullName AS 'New User SB'  FROM  mUser sb WHERE b.AddUserSelfBalance =CAST(sb.ID as varchar(50)))
			ELSE '' END AS 'New User SelfBalance',
		b.airName as 'Airline Name',
		B.riyaPNR as 'Booking id',
		(SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR',
		B.GDSPNR AS 'CRS PNR',
		(SELECT
			STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s WITH(NOLOCK)
			WHERE s.fkBookMaster = t.fkBookMaster ORDER BY TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber
			FROM tblPassengerBookDetails t WITH(NOLOCK) WHERE TicketNumber IS NOT NULL AND fkBookMaster=b.pkId
			GROUP BY t.fkBookMaster
		) AS 'Ticket No',
		b.OfficeID AS 'Vendor id',
		b.FileNo AS 'FILE NO',
		(Select top 1 ISNULL(ma.OBTCno,'') AS OBTCno from mAttrributesDetails ma Where ma.OrderID=b.orderId AND ISNULL(ma.OBTCno,'')!='') AS 'OBT NO',
		b.InquiryNo AS 'Inquiry No',
		b.OpsRemark AS 'Opss remarks',
		b.AcctsRemark AS 'Accts Remarks',
		u.UserName AS 'Updated by',
		'' AS 'Updated Remarks'
		FROM tblBookMaster AS b WITH(NOLOCK)
		INNER JOIN Paymentmaster AS pm WITH(NOLOCK) ON pm.order_id=b.orderId
		INNER JOIN mCountry AS c WITH(NOLOCK) ON b.Country=c.CountryCode
		LEFT JOIN mUser AS u WITH(NOLOCK) ON b.IssueBy=u.ID
		INNER JOIN mUser AS u1 WITH(NOLOCK) ON b.MainAgentId=u1.ID
		--LEFT JOIN mAttrributesDetails AS ma WITH(NOLOCK) ON ma.OrderID=b.orderId
		WHERE pm.payment_mode='Self Balance' and (b.BookingStatus=4 or b.BookingStatus=8)
		AND ((@FROMDate = '') or (CONVERT(date,ISNULL(b.CancelledDate,ISNULL(b.inserteddate_old,b.inserteddate))) >= CONVERT(date,@FROMDate)))
		AND ((@ToDate = '') or (CONVERT(date,ISNULL(b.CancelledDate,ISNULL(b.inserteddate_old,b.inserteddate))) <= CONVERT(date, @ToDate)))
		AND ((@UserIds = '') or (b.MainAgentId IN (select Data from sample_split(@UserIds,','))) or  (CAST(b.AddUserSelfBalance AS Int) IN (SELECT Data FROM sample_split(@UserIds,',')))) 
		AND B.totalFare>0    and b.IsBooked=1
		AND((@Branch ='') or (u.LocationID IN (select Data from sample_split(@Branch,','))))

		UNION   ALL

		SELECT DISTINCT
		(CASE c.CountryCode WHEN 'AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(Varchar(20),sb.CreatedOn,120))) -- 1 hour, 29 minutes and 13 seconds
			WHEN 'US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(Varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds
			WHEN 'CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(Varchar(20),sb.CreatedOn,120))) -- 9 hour, 29 minutes and 16 seconds
			WHEN 'IN' THEN (DATEADD(SECOND, 0,CONVERT(Varchar(20),sb.CreatedOn,120)))  --- 0 hour, 0 minutes and 0 seconds
		END) AS 'Date & Time',
		c.CountryName AS 'Country',
		'' as 'Currency',                       --add column currency on 19-04-23
		(CASE WHEN sb.TransactionType='Credit' THEN sb.Amount ELSE 0 END) AS 'Credit',
		(CASE WHEN sb.TransactionType='Debit' THEN sb.Amount ELSE 0 END) AS 'Debit',
		'0.00' AS 'Remaining',
		u.UserName AS 'User id',		
		'' AS 'New User SelfBalance',
		'' AS 'Airline Name',
		'' AS 'Booking id',
		'' AS  'Airlines PNR',
		'' AS 'CRS PNR',
		'' AS 'Ticket No',
		'' AS 'Vendor id',
		'' AS 'FILE NO',
		'' AS 'OBT NO',	
		'' AS 'Inquiry No',
		'' AS 'Opss remarks',
		'' AS 'Accts Remarks',
		u1.UserName AS 'Updated by',
		sb.Remark AS 'Updated Remarks'
		FROM mSelfBalanceCreditDebit AS sb WITH(NOLOCK)
		LEFT JOIN mCountry AS c WITH(NOLOCK) on sb.CountryId=c.ID
		INNER JOIN mUser AS u WITH(NOLOCK) on sb.UserId=u.ID
		INNER JOIN mUser AS u1 WITH(NOLOCK) on sb.CreatedBy=u1.ID
		WHERE ((@FROMDate = '') OR (CONVERT(date,sb.CreatedOn) >= CONVERT(Date,@FROMDate)))
		AND ((@ToDate = '') OR (CONVERT(date,sb.CreatedOn) <= CONVERT(Date, @ToDate)))
		AND ((@UserIds = '') OR (sb.UserId IN (SELECT Data FROM sample_split(@UserIds,','))))
		AND((@Branch ='') OR (u.LocationID IN (SELECT Data FROM sample_split(@Branch,','))))
	) p order by p.[Date & Time] desc                          

	


	IF OBJECT_ID ( 'tempdb..#tempTableHotel') IS NOT NULL
		DROP table  #tempTableHotel
	SELECT * INTO #tempTableHotel
	FROM (  
				
				SELECT
			CONVERT(varchar(20),hb.inserteddate,120) 'Date & Time'
			, al.Country as 'Country'
			, HB.CurrencyCode as 'Currency'                     --add column currency on 19-04-23
			, '0.00'  as 'Credit'
			, TranscationAmount  as 'Debit'       
			--, CONVERT(Varchar,SB.UserID) as 'User ID' --commented on 03-04-2023
			, SB.CloseBalance as 'Remaining'   --add column closebalance on 04-04-23
			,MU.FullName as 'User ID'        --add on 03-04-2023	
			, MU.FullName AS [New User SB]     --change from MU.UserName to MU.FullName on 03-04-23 
			, HB.HotelName AS [Hotel Name]
			, (HB.BookingReference) 'Booking Id'
			, HB.providerConfirmationNumber as 'Hotel PNR'   --change from RiyaPNR to HB.providerConfirmationNumber on 03-04-23 
			, '' AS 'CRS PNR'
			, '' AS 'Ticket No'
			, HB.SupplierName AS 'Vendor id'   --add supplier name on 03-04-23
			, HB.FileNo AS 'FILE NO'
			, HB.OBTCNo 'OBT NO'
			, HB.InquiryNo AS 'Inquiry No'
			, HB.OpsRemark AS 'Opss remarks'
			, HB.AcctsRemark AS 'Accts Remarks'
			, concat(mu.FullName,'-',SB.CreatedOn) 'Updated By'   --add columns closebalance on 04-04-23
			, '' as 'Updated Remark'
			FROM Hotel_BookMaster HB WITH(NOLOCK)
			LEFT JOIN tblSelfBalance AS SB WITH(NOLOCK) ON HB.orderId=SB.BookingRef   
			JOIN AgentLogin AS AL WITH(NOLOCK) ON HB.RiyaAgentID=AL.UserID      
			JOIN mUser AS MU WITH(NOLOCK) ON HB.MainAgentID=Mu.ID       
			WHERE B2BPaymentMode=4
			AND CAST(HB.inserteddate as date) between @FromDate and @ToDate     
		    AND ((@UserIds='') OR HB.MainAgentID IN (select Data from sample_split(@UserIds,',')))
			AND TransactionType='Debit' 
			AND ((@Branch ='') or (mu.LocationID IN (select Data from sample_split(@Branch,','))))

			UNION  
			select                                                                --add columns in all allias on 04-04-23
			CONVERT(Varchar(20),tsb.CreatedOn,120) 'Date & Time'
			, BR.country AS 'Country'
			, HB.CurrencyCode as 'Currency'                      --add column currency on 19-04-23
 			, TranscationAmount AS 'Credit'
			, '0.00'  AS 'Debit'
			, tsb.CloseBalance as 'Remaining'
			, mu.FullName AS 'User ID'			
			, Mu.FullName AS [New User SB]
			, HB.HotelName AS [Hotel Name]
			,  HB.BookingReference  AS  'Booking Id'
			, HB.providerConfirmationNumber AS 'Hotel PNR'
			, '' AS 'CRS PNR'
			, '' AS 'Ticket No'
			, HB.SupplierName AS 'Vendor id'
			, HB.FileNo AS 'FILE NO'
			, HB.OBTCNo AS 'OBT NO'
			, HB.InquiryNo AS 'Inquiry No'
			, HB.OpsRemark AS 'Opss remarks'
			, HB.AcctsRemark AS 'Accts Remarks'
			, concat(mu.FullName,'-',tsb.CreatedOn) AS  'Updated By'
			, '' AS 'Updated Remark'
			FROM tblSelfBalance AS tsb WITH(NOLOCK)                                  --add  joines on 04-04-23 
			left join Hotel_BookMaster HB WITH(NOLOCK) on tsb.BookingRef=Hb.orderId
			left join mUser MU WITH(NOLOCK) on MU.ID=tsb.UserID
			left join B2BRegistration BR WITH(NOLOCK) on HB.RiyaAgentID=BR.FKUserID
            left join mUser MU1 WITH(NOLOCK) on MU1.ID=HB.SuBMainAgentID
			
			--WHERE CAST(tsb.CreatedOn AS Date) BETWEEN @FromDate AND @ToDate  

			WHERE CAST(tsb.CreatedOn AS Date) BETWEEN @FromDate AND @ToDate 
			AND ((@UserIds='') OR UserID IN (SELECT Data FROM sample_split(@UserIds,',')))
			AND ProductType='Hotel'
			AND tsb.TransactionType='Credit'
	) AS p ORDER BY [Date & Time]
		
    IF(@IsPaging=1)
	BEGIN
		SELECT * INTO #tempALL FROM (
		
		SELECT 
		'Air' as Type,
		* FROM #tempTableAir
		WHERE @ProductType=0 OR @ProductType=1

		UNION ALL

		SELECT 
		'Hotel' AS Type,
		* FROM #tempTableHotel
		WHERE @ProductType=0 OR @ProductType=2

		) AS RES
		ORDER BY  [Date & Time] desc

		SELECT @RecordCount = @@ROWCOUNT

		SELECT Format([Date & Time],'dd-MMM-yyyy hh:mm:ss tt') as [Date & Time],* FROM #tempALL t
		ORDER BY t.[Date & Time] desc
		OFFSET @Start * @Pagesize ROWS
		FETCH NEXT @Pagesize ROWS ONLY
	END
	ELSE
	BEGIN
		SELECT Format([Date & Time],'dd-MMM-yyyy hh:mm:ss tt') as [Date & Time1],* FROM ( 
		SELECT 
		'Air' as Type,
		* FROM #tempTableAir 
		WHERE @ProductType=0 OR @ProductType=1
		--ORDER BY [Date & Time] desc
		--if(@ProductType=='')

		UNION ALL

		SELECT 
		'Hotel' AS Type,
		* FROM #tempTableHotel tb
		WHERE @ProductType=0 OR @ProductType=2
		) AS RES ORDER BY [Date & Time] DESC
	END
END
