CREATE PROCEDURE [dbo].[SearchprocessdataAgent] 
	-- Add the parameters for the stored procedure here
	@FROMDate Date= null,
	@ToDate Date= null,
	@paxname varchar(100)='',
	@RiyaPNR varchar(20)='',
	@AirlinePNR varchar(20)='',
	@EmailID varchar(30)='',
	@MobileNo varchar(20)='',
	@Status	varchar(30)=null,
	@Status2 varchar(30)=null,
	@GDSPNR varchar(30)='',
	@OrderID varchar(30)='',
	@Start int=null,
	@Pagesize int=null,
	@RecordCount INT OUTPUT,
	@Userid varchar(10)='',
	@SubUserID int = null
	--@OfficeID VARCHAR(50)=NULL
AS







if (@Status = 'All' )
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
  DROP table  #tempTableA
 SELECT * INTO #tempTableA 
from
	(  
	  select b.pid, ISNULL(b.paxfname,'')+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,a.ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, a.GDSPNR, order_status,
			c.payment_mode, c.getway_name, 
			--CASE WHEN  (b.Iscancelled = 1 and a.IsBooked = 1)  then 'Cancelled' 
			--	 --WHEN  (b.Iscancelled = 0 and b.IsRefunded =0 and a.IsBooked = 1)  then 'Confirmed'
			--	  WHEN  (a.BookingStatus = 1 and b.Iscancelled = 0 and IsRefunded=0)  then 'Confirmed' 	 	
			--	 --WHEN  (b.IsRefunded = 1 and a.IsBooked = 1)  then 'Refunded' 	
			--	 WHEN  (c.order_status='Hold') then 'Hold'
			--	 WHEN  (b.IsRefunded = 1 and a.IsBooked = 1)  then 'Pending' 	
			--	  WHEN  (b.IsRefunded = 1 and a.IsBooked = 1)  then 'Close' 	
			--ELSE
			--	'Failed'
			case when a.BookingStatus=1 then 'Issued Ticket'
			when a.BookingStatus=2 then 'Hold'
			when a.BookingStatus=3 then 'Pending Ticket'
			when a.BookingStatus=4 then 'Cancel'
			when a.BookingStatus=5 then 'Close'
			 ELSE
			'Failed'	 
			END AS [Ticketstatus],
			 c.tracking_id,A.Country --,A.OfficeID
	   FROM tblBookMaster a
	   INNER JOIN tblPassengerBookDetails b
	       ON a.pkId=b.fkBookMaster
	 
	   LEFT JOIN Paymentmaster c
	       ON a.OrderId=c.order_id
	   LEFT JOIN tblBookItenary tbi
	       ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector

	   WHERE (
	          (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		  AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
		  AND ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
	--	  and (a.OfficeID=@OfficeID or @OfficeID is null )
		 -- AND a.isbooked=1
	--	AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)	   
		 AND (a.AgentID = CAST(@Userid AS VARCHAR(50))  or   a.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid))
	   ) p

	  ORDER BY P.booking_date DESC
SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
SELECT * FROM #tempTableA
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY
END

ELSE IF  (Upper(@Status) = Upper('Cancelled') )
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTableC') IS NOT NULL
  DROP table  #tempTableC
SELECT * INTO #tempTableC 
from
	(  
	  select 	  
	        b.pid, ISNULL(b.paxfname,'')+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	       a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,a.ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, a.GDSPNR, 
			b.Iscancelled as order_status,
			c.payment_mode , c.getway_name ,  
			CASE WHEN  (b.Iscancelled = 1)  then 'Cancelled' 
				 WHEN  (b.Iscancelled = 0 and b.IsRefunded =0)  then 'Confirmed' 	
				 WHEN  (b.IsRefunded = 1)  then 'Refunded' 				
			END AS [Ticketstatus],

			tracking_id,a.Country
		--	a.OfficeID
	   FROM tblPassengerBookDetails b
	     INNER JOIN tblBookMaster a 
	       ON b.fkBookMaster = a.pkId
      		LEFT Join Paymentmaster c
	    ON a.OrderId=c.order_id
        LEFT JOIN tblBookItenary tbi
	    ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	  
	   WHERE 
	   ((CONVERT(date,b.CancelledDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		   AND (CONVERT(date,b.CancelledDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
		   AND  ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		  AND a.isbooked=1 
		  and  b.Iscancelled = 1
		  AND a.Country in (select C.CountryCode  from mUserCountryMapping UM
			INNER JOIN mCountry C ON C.ID=UM.CountryId where UserID=@Userid  AND IsActive=1)	
		 --  and (a.OfficeID=@OfficeID or @OfficeID is null )   
		   AND (a.AgentID = CAST(@Userid AS VARCHAR(50))  or   a.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid))
	   ) p

	   ORDER BY P.booking_date DESC
SELECT @RecordCount =@@ROWCOUNT
SELECT * FROM #tempTableC
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END

ELSE IF  ( UPPER(@Status) = UPPER('Refunded'))
BEGIN

IF OBJECT_ID ( 'tempdb..#tempTableR') IS NOT NULL
  DROP table  #tempTableR

 -- Select 'Refunded'

SELECT * INTO #tempTableR
from
	(  
	  select 	  
	        distinct ( a.GDSPNR), b.pid,ISNULL(b.paxfname,'')+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,a.ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, 
			b.Iscancelled,
			
			'' as 'payment_mode', '' as 'getway_name',  
			CASE WHEN  (b.Iscancelled = 1)  then 'Cancelled' 
				 WHEN  (b.Iscancelled = 0 and b.IsRefunded =0)  then 'Confirmed' 	
				 WHEN  (b.IsRefunded = 1)  then 'Refunded' 				
			END AS [Ticketstatus],

			c.tracking_ID as 'tracking_id',a.Country
			--a.OfficeID

	   FROM tblPassengerBookDetails b
	     INNER JOIN tblBookMaster a 
	       ON b.fkBookMaster = a.pkId
      
		LEFT Join Paymentmaster c
	    ON a.OrderId=c.order_id
        LEFT JOIN tblBookItenary tbi
	    ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	  
	   WHERE 
	   ((CONVERT(date,b.RefundedDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		   AND (CONVERT(date,b.RefundedDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
		   AND  ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		  AND   b.IsRefunded = 1  
		--  AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)	
		  -- and (a.OfficeID=@OfficeID or @OfficeID is null )   
		 AND (a.AgentID = CAST(@Userid AS VARCHAR(50))  or   a.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid))
			 ) p

	   ORDER BY P.booking_date DESC

  SELECT @RecordCount =@@ROWCOUNT

  	SELECT * FROM #tempTableR
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END

ELSE IF (@Status = 'Failed' )
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTableF') IS NOT NULL
  DROP table  #tempTableF
 SELECT * INTO #tempTableF 
from
	(  
	  select b.pid, ISNULL(b.paxfname,'')+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,a.ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, a.GDSPNR, 
			order_status,
			c.payment_mode, c.getway_name, 'Failed' AS [Ticketstatus],
			 c.tracking_id,a.Country
			 --a.OfficeID
	   FROM tblBookMaster a
	   INNER JOIN tblPassengerBookDetails b
	       ON a.pkId=b.fkBookMaster
	 
	   LEFT JOIN Paymentmaster c
	       ON a.OrderId=c.order_id
	   LEFT JOIN tblBookItenary tbi
	       ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector

	   WHERE (
	          (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		  AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
		  AND ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		  AND (a.isbooked=0 or a.IsBooked is null)
		--  AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)
		   --and (a.OfficeID=@OfficeID or @OfficeID is null )	   
		   AND (a.AgentID = CAST(@Userid AS VARCHAR(50))  or   a.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid))
	   ) p

	  ORDER BY P.booking_date DESC
SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA
SELECT * FROM #tempTableF
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY
END

ELSE IF  (Upper(@Status) = Upper('Hold'))
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTablHold') IS NOT NULL
  DROP table  #tempTablHold
SELECT * INTO #tempTablHold
from
	(  
	  select 	  
	        b.pid, ISNULL(b.paxfname,'')+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,a.ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, a.GDSPNR, 
			b.Iscancelled as order_status,
			c.payment_mode , c.getway_name , 						
			'Hold' AS [Ticketstatus],

			tracking_id,a.Country
		--	a.OfficeID
	   FROM tblPassengerBookDetails b
	     INNER JOIN tblBookMaster a 
	       ON b.fkBookMaster = a.pkId
      		LEFT Join Paymentmaster c
	    ON a.OrderId=c.order_id
        LEFT JOIN tblBookItenary tbi
	    ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	  
	   WHERE 
	   ((CONVERT(date,b.CancelledDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		   AND (CONVERT(date,b.CancelledDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
		   AND  ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		  AND c.order_status='Hold'
	--	  AND a.isbooked=1 
	--	  and  b.Iscancelled = 1
	--	  AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)	
		 --  and (a.OfficeID=@OfficeID or @OfficeID is null )   
		 AND (a.AgentID = CAST(@Userid AS VARCHAR(50))  or   a.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid))
	   ) p

	   ORDER BY P.booking_date DESC
SELECT @RecordCount =@@ROWCOUNT
SELECT * FROM #tempTablHold
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END



ELSE IF  (Upper(@Status) = Upper('Pending'))
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTablPending') IS NOT NULL
  DROP table  #tempTablPending
SELECT * INTO #tempTablPending
from
	(  
	  select 	  
	        b.pid, ISNULL(b.paxfname,'')+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,a.ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, a.GDSPNR, 
			b.Iscancelled as order_status,
			c.payment_mode , c.getway_name , 						
			'Booked' AS [Ticketstatus],

			tracking_id,a.Country
		--	a.OfficeID
	   FROM tblPassengerBookDetails b
	     INNER JOIN tblBookMaster a 
	       ON b.fkBookMaster = a.pkId
 		LEFT Join Paymentmaster c
	    ON a.OrderId=c.order_id
        LEFT JOIN tblBookItenary tbi
	    ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	  
	   WHERE 
	   ((CONVERT(date,b.CancelledDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		   AND (CONVERT(date,b.CancelledDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
		   AND  ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		  AND c.order_status <> 'Hold'
		  AND a.isbooked=0 
	--	  and  b.Iscancelled = 1
	--	  AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)	
		 --  and (a.OfficeID=@OfficeID or @OfficeID is null )   
		  AND (a.AgentID = CAST(@Userid AS VARCHAR(50))  or   a.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid))
	   ) Q

	   ORDER BY Q.booking_date DESC
SELECT @RecordCount =@@ROWCOUNT
SELECT * FROM #tempTablPending
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END




ELSE IF  (Upper(@Status) = Upper('Closed'))
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTablClose') IS NOT NULL
  DROP table  #tempTablClose
SELECT * INTO #tempTablClose
from
	(  
	  select 	  
	        b.pid, ISNULL(b.paxfname,'')+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,a.ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, a.GDSPNR, 
			b.Iscancelled as order_status,
			c.payment_mode , c.getway_name , 						
			'Close' AS [Ticketstatus],

			tracking_id,a.Country
		--	a.OfficeID
	   FROM tblPassengerBookDetails b
	     INNER JOIN tblBookMaster a 
	       ON b.fkBookMaster = a.pkId
      		LEFT Join Paymentmaster c
	    ON a.OrderId=c.order_id
        LEFT JOIN tblBookItenary tbi
	    ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	  
	   WHERE 
	   ((CONVERT(date,b.CancelledDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		   AND (CONVERT(date,b.CancelledDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
		   AND  ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		  --AND c.order_status <> 'Hold'
		  AND a.isbooked is NULL  
	--	  and  b.Iscancelled = 1
	--	  AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)	
		 --  and (a.OfficeID=@OfficeID or @OfficeID is null )   
		   AND (a.AgentID = CAST(@Userid AS VARCHAR(50))  or   a.AgentID in (select cast (userid as varchar(50)) from AgentLogin where ParentAgentID=@Userid))
	   ) Q

	   ORDER BY Q.booking_date DESC
SELECT @RecordCount =@@ROWCOUNT
SELECT * FROM #tempTablClose
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END




ELSE IF  (Upper(@Status) = Upper('User'))
BEGIN
IF OBJECT_ID ('tempdb..#tempTableUser') IS NOT NULL
  DROP table  #tempTableUser
SELECT * INTO #tempTableUser
from
	(  
	  select 	  
	        b.pid, ISNULL(b.paxfname,'')+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,a.ROE,isnull(a.AgentROE,1) AgentROE,
			a.inserteddate as booking_date, a.GDSPNR, 
			b.Iscancelled as order_status,
			c.payment_mode , c.getway_name , 						
			'Close' AS [Ticketstatus],

			tracking_id,a.Country
		--	a.OfficeID
	   FROM tblPassengerBookDetails b
	     INNER JOIN tblBookMaster a ON b.fkBookMaster = a.pkId
         LEFT Join Paymentmaster c  ON a.OrderId=c.order_id
         LEFT JOIN tblBookItenary tbi  ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
		
	  
	   WHERE 
	   ((CONVERT(date,b.CancelledDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		   AND (CONVERT(date,b.CancelledDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
		   AND  ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  AND ( c.order_id =@OrderID or @OrderID ='' )
		  AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		  AND (a.isbooked is NULL)
		 AND a.AgentID = CAST(@Userid AS VARCHAR(50))  
	   ) Q

	   ORDER BY Q.booking_date DESC
SELECT @RecordCount =@@ROWCOUNT
SELECT * FROM #tempTableUser
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END




ELSE 
BEGIN
IF OBJECT_ID ( 'tempdb..#tempTableA1') IS NOT NULL
DROP table  #tempTableA1 
SELECT * INTO #tempTableA1 
FROM
	( SELECT b.pid,ISNULL(b.paxfname,'')+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	         a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			 a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,a.ROE,isnull(a.AgentROE,1) AgentROE,
			 a.inserteddate as booking_date, a.GDSPNR, 
			 c.order_status,
			 c.payment_mode, c.getway_name,
			CASE WHEN (b.Iscancelled = 1)  THEN 'Cancelled'
				 WHEN (b.Iscancelled = 0 and b.IsRefunded = 0) THEN 'Ticketed'
				 WHEN (b.IsRefunded = 1)  THEN 'Refunded'
			END AS [Ticketstatus],

			 c.tracking_id,a.Country--a.OfficeID
	 FROM tblBookMaster a
	 INNER JOIN tblPassengerBookDetails b
	    ON a.pkId=b.fkBookMaster
	 
	 LEFT JOIN Paymentmaster c
	    ON a.OrderId=c.order_id
	 LEFT JOIN tblBookItenary tbi
	    ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
 WHERE ((CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
		AND ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		AND  (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		AND  (tbi.airlinePNR = @AirlinePNR or @AirlinePNR ='' )
		AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		AND  ( c.order_id =@OrderID or @OrderID ='' )
		AND  ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		AND a.isbooked=1 AND B.Iscancelled = 0 AND B.IsRefunded=0
		--AND a.Country in (select country from UserCountryMapping where UserID=@Userid  AND IsActive=1)	
		AND a.AgentID=CAST(@Userid AS VARCHAR(50))  
	   )p
	ORDER BY  P.booking_date DESC
SELECT @RecordCount =@@ROWCOUNT
SELECT * FROM #tempTableA1
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SearchprocessdataAgent] TO [rt_read]
    AS [dbo];

