
create PROCEDURE [dbo].[SearchprocessdataAgentByStatusNEW2] 
	-- Add the parameters for the stored procedure here
	@FROMDate Date= null,
	@ToDate Date= null,
	@paxname varchar(100)='',
	@RiyaPNR varchar(20)='',
	@AirlinePNR varchar(20)='',
	@EmailID varchar(30)='',
	@MobileNo varchar(20)='',
	@Status varchar(20)='',
	@Status2 varchar(30)=null,
	@GDSPNR varchar(30)='',
	@OrderID varchar(30)='',
	@Start int=null,
	@Pagesize int=null,
	@RecordCount INT OUTPUT,
	@Userid varchar(10)='',
	@SubUserID int = null,
	@ParentID varchar(10)= null
	--@OfficeID VARCHAR(50)=NULL
AS




if(@ParentID is not null)
BEGIN

if (@Status = 99 )
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
  DROP table  #tempTableA
 SELECT * INTO #tempTableA 
from
	(  
	  select  pid, ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR,
			-- a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, a.totalfare,isnull(a.ROE,1) ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, a.GDSPNR, order_status,
			c.payment_mode, c.getway_name, 
			case when a.BookingStatus=1 then 'Confirmed'
			when a.BookingStatus=2 then 'Hold'
			when a.BookingStatus=3 then 'Pending Ticket'
			when a.BookingStatus=4 then 'Cancel'
			when a.BookingStatus=5 then 'Close'
			 ELSE
			'Failed'	 
			END AS [Ticketstatus],

			case when a.BookingStatus=1 then 'Bookticket'
			END AS [Bookticket],
			 c.tracking_id,A.Country
			 
	--		  ,(SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	--AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'
	--,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	--AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'
	,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'

	,	(SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'
	
	,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'') 
	AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'
		
			 from
			 (select * from 
(select pid, paxFName,paxLName,fkBookMaster,
ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN
 from tblPassengerBookDetails --where fkBookMaster in (163822,163833) 
 ) as tblPBD
 where rn =1

 ) as T1 join tblBookMaster 
 a
	   
	       ON a.pkId=t1.fkBookMaster
		   LEFT JOIN tblBookItenary tbi
		   ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
		   LEFT JOIN Paymentmaster c
	       ON a.OrderId=c.order_id

	   WHERE (
		  a.returnFlag = 0	
	      AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		  AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
		  AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		 -- and a.BookingStatus=1 
	--	  and (a.OfficeID=@OfficeID or @OfficeID is null )
		 -- AND a.isbooked=1
	--	AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)
	
			   
		 --AND 
		 --(a.AgentID = CAST(@Userid AS VARCHAR(50))  or   a.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid))
	   ) p

	  ORDER BY P.booking_date DESC
SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
SELECT * FROM #tempTableA
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY
END

ELSE 
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTableA1') IS NOT NULL
DROP table  #tempTableA1 
SELECT * INTO #tempTableA1 
FROM
	( SELECT pid,ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	         a.RiyaPNR, a.airName, tbi.airlinePNR, 
			 --a.frmsector, a.tosector AS tosector, 
			 a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, a.totalfare,isnull(a.ROE,1) ROE,isnull(a.AgentROE,1) AgentROE,
			 a.inserteddate as booking_date, a.GDSPNR, 
			 c.order_status,
			 c.payment_mode, c.getway_name,
			case when a.BookingStatus=1 then 'Confirmed'
			when a.BookingStatus=2 then 'Hold'
			when a.BookingStatus=3 then 'Pending Ticket'
			when a.BookingStatus=4 then 'Cancel'
			when a.BookingStatus=5 then 'Close'
	 
			END AS [Ticketstatus],
			case when a.BookingStatus=1 then 'Bookticket'
			END AS [Bookticket],
			 c.tracking_id,a.Country--a.OfficeID

			 
	--		  ,(SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	--AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'
	--,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	--AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'
	,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'

	,	(SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'

,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'') 
	AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'
	
			 from (select * from 
(select pid, paxFName,paxLName,fkBookMaster,
ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN
 from tblPassengerBookDetails --where fkBookMaster in (163822,163833) 
 ) as tblPBD
 where rn =1
) as T1 join tblBookMaster 
 a
	   
	       ON a.pkId=t1.fkBookMaster
		   LEFT JOIN tblBookItenary tbi
		   ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
		   LEFT JOIN Paymentmaster c
	       ON a.OrderId=c.order_id
		   
		   
		    WHERE (
			a.returnFlag = 0	
	      AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
		AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')
		AND  (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		AND  (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		AND  ( c.order_id =@OrderID or @OrderID ='' )
		AND  ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		--AND a.isbooked=1 AND B.Iscancelled = 0 AND B.IsRefunded=0  avinash commented
		and  a.BookingStatus = @Status
		--AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)	
		--AND a.AgentID=CAST(@Userid AS VARCHAR(50))  
	   )p
	ORDER BY  P.booking_date DESC
SELECT @RecordCount =@@ROWCOUNT
SELECT * FROM #tempTableA1
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END
END

ELSE IF (@ParentID is not null)
BEGIN

if (@Status = 99 )
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTableB') IS NOT NULL
  DROP table  #tempTableB
 SELECT * INTO #tempTableB
from
	(  
	  select  pid, ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR,
			-- a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, a.totalfare,isnull(a.ROE,1) ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, a.GDSPNR, order_status,
			c.payment_mode, c.getway_name, 
			case when a.BookingStatus=1 then 'Confirmed'
			when a.BookingStatus=2 then 'Hold'
			when a.BookingStatus=3 then 'Pending Ticket'
			when a.BookingStatus=4 then 'Cancel'
			when a.BookingStatus=5 then 'Close'
			 ELSE
			'Failed'	 
			END AS [Ticketstatus],

			case when a.BookingStatus=1 then 'Bookticket'
			END AS [Bookticket],
			 c.tracking_id,A.Country
			 
	--		  ,(SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	--AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'
	--,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	--AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'
	,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'

	,	(SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'
	
	,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'') 
	AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'
		
			 from
			 (select * from 
(select pid, paxFName,paxLName,fkBookMaster,
ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN
 from tblPassengerBookDetails --where fkBookMaster in (163822,163833) 
 ) as tblPBD
 where rn =1

 ) as T1 join tblBookMaster 
 a
	   
	       ON a.pkId=t1.fkBookMaster
		   LEFT JOIN tblBookItenary tbi
		   ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
		   LEFT JOIN Paymentmaster c
	       ON a.OrderId=c.order_id

	   WHERE (
		  a.returnFlag = 0	
	      AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		  AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
		  AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		 -- and a.BookingStatus=1 
	--	  and (a.OfficeID=@OfficeID or @OfficeID is null )
		 -- AND a.isbooked=1
	--	AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)
	
			   
		 AND 
		 (a.AgentID = CAST(@Userid AS VARCHAR(50))  or   a.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid))
	   ) p

	  ORDER BY P.booking_date DESC
SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
SELECT * FROM #tempTableB
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY
END

ELSE 
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTableB1') IS NOT NULL
DROP table  #tempTableB1 
SELECT * INTO #tempTableB1 
FROM
	( SELECT pid,ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	         a.RiyaPNR, a.airName, tbi.airlinePNR, 
			 --a.frmsector, a.tosector AS tosector, 
			 a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, a.totalfare,isnull(a.ROE,1) ROE,isnull(a.AgentROE,1) AgentROE,
			 a.inserteddate as booking_date, a.GDSPNR, 
			 c.order_status,
			 c.payment_mode, c.getway_name,
			case when a.BookingStatus=1 then 'Confirmed'
			when a.BookingStatus=2 then 'Hold'
			when a.BookingStatus=3 then 'Pending Ticket'
			when a.BookingStatus=4 then 'Cancel'
			when a.BookingStatus=5 then 'Close'
	 
			END AS [Ticketstatus],
			case when a.BookingStatus=1 then 'Bookticket'
			END AS [Bookticket],
			 c.tracking_id,a.Country--a.OfficeID

			 
	--		  ,(SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	--AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'
	--,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	--AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'
	,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'

	,	(SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') 
	AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'

,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'') 
	AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'
	
			 from (select * from 
(select pid, paxFName,paxLName,fkBookMaster,
ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN
 from tblPassengerBookDetails --where fkBookMaster in (163822,163833) 
 ) as tblPBD
 where rn =1
) as T1 join tblBookMaster 
 a
	   
	       ON a.pkId=t1.fkBookMaster
		   LEFT JOIN tblBookItenary tbi
		   ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
		   LEFT JOIN Paymentmaster c
	       ON a.OrderId=c.order_id
		   
		   
		    WHERE (
			a.returnFlag = 0	
	      AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
		AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')
		AND  (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		AND  (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		AND  ( c.order_id =@OrderID or @OrderID ='' )
		AND  ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		--AND a.isbooked=1 AND B.Iscancelled = 0 AND B.IsRefunded=0  avinash commented
		and  a.BookingStatus = @Status
		AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)	
		AND a.AgentID=CAST(@Userid AS VARCHAR(50))  
	   )p
	ORDER BY  P.booking_date DESC
SELECT @RecordCount =@@ROWCOUNT
SELECT * FROM #tempTableB1
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END
END


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SearchprocessdataAgentByStatusNEW2] TO [rt_read]
    AS [dbo];

