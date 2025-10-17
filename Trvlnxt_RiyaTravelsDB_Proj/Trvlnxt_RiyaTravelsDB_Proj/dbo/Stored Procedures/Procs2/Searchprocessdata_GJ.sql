

--declare @p17 int exec [Searchprocessdata_GJ] @fromDate='2017-06-01 00:00:00',
--@ToDate='2017-07-01 00:00:00',@paxname=N'', @RiyaPNR=N'',@AirlinePNR=default, @EmailID=N'',
--@MobileNo=N'', @Status='Cancelled'--, --default,  
--,@Status2=default,
--@GDSPNR=N'', @OrderID=N'', @Start=0, @PageSize=200,@docbit=1, @IsCancelled=0, 
--@IsRefunded=0, @RecordCount=@p17 output
--Select @p17

CREATE PROCEDURE [dbo].[Searchprocessdata_GJ] --'1/1/2017','5/22/2017','','',null,'','',null,null,'','',10,1,'',1
	-- Add the parameters for the stored procedure here
	@FROMDate Date= null,
	@ToDate Date= null,
	@paxname varchar(100)='',
	@RiyaPNR varchar(20)='',
	@AirlinePNR varchar(20)=null,
	@EmailID varchar(30)='',
	@MobileNo varchar(20)='',
	@Status	varchar(30)=null,
	@Status2 varchar(30)=null,
	@GDSPNR varchar(30)='',
	@OrderID varchar(30)='',
	@Start int=null,
	@Pagesize int=null,
	@RecordCount INT OUTPUT,
	@docbit bit=0,
	@Iscancelled bit=0,
	@IsRefunded bit=0

AS
if (@Status = 'All' )
BEGIN

IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL
  DROP table  #tempTableA


SELECT * INTO #tempTableA 
from
	(  
	  select b.pid, b.paxfname+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,
			a.inserteddate as booking_date, a.GDSPNR, ch.RefundAmount, order_status,
			c.payment_mode, c.getway_name,
   --  	   CASE WHEN b.status=1   then 'HX Request' 
			--    WHEN b.status=1  then 'Cancelled' 
			--	WHEN b.status is Null  then 'Confirmed' 
			--	WHEN b.status = 1 THEN 'Cancelled'
			--END AS [status] ,
			CASE WHEN  (b.Iscancelled = 1)  then 'Cancelled' 
				 WHEN  (b.Iscancelled = 0 and b.IsRefunded =0)  then 'Confirmed' 	
				 WHEN  (b.IsRefunded = 1)  then 'Refunded' 				
			END AS [Ticketstatus],
			ch.UpdateDate as refund_date, c.tracking_id
	   FROM tblBookMaster a
	   INNER JOIN tblPassengerBookDetails b
	       ON a.pkId=b.fkBookMaster
	   LEFT JOIN CancellationHistory ch 
	       ON a.OrderId=ch.OrderId
	   LEFT JOIN Paymentmaster c
	       ON a.OrderId=c.order_id
	   LEFT JOIN tblBookItenary tbi
	       ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector

	   WHERE (
	          (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		  AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
		  --AND ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		  --AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		  --AND (tbi.airlinePNR = @AirlinePNR or @AirlinePNR is null )
		  --AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		  --AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		  -- --AND (b.status=@Status or @Status is null)
	 	 -- AND (c.order_status=@Status2 or @Status2 is null )
		  --AND ( c.order_id =@OrderID or @OrderID ='' )
		  --AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
	     -- AND b.Iscancelled=@Iscancelled and b.IsRefunded =@IsRefunded
		 -- AND a.isbooked=1
			   
	   ) p

	  ORDER BY P.booking_date DESC


	SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA


	SELECT * FROM #tempTableA
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END

ELSE IF  (Upper(@Status) = Upper('Cancelled') )
BEGIN


IF OBJECT_ID ( 'tempdb..#tempTableC') IS NOT NULL
  DROP table  #tempTableC


SELECT * INTO #tempTableC 
from
	(  
	  select 	  
	        b.pid, b.paxfname+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,
			a.inserteddate as booking_date, a.GDSPNR, b.RefundAmount, b.Iscancelled as order_status,
			c.payment_mode , c.getway_name ,
   --  	   CASE WHEN b.status=1  then 'HX Request' 
			--    WHEN b.status=1  then 'Cancelled' 
			--	WHEN b.status is Null  then 'Confirmed' 
			--	WHEN b.status = 1 THEN 'Cancelled'
			--END AS [status] ,
			CASE WHEN  (b.Iscancelled = 1)  then 'Cancelled' 
				 WHEN  (b.Iscancelled = 0 and b.IsRefunded =0)  then 'Confirmed' 	
				 WHEN  (b.IsRefunded = 1)  then 'Refunded' 				
			END AS [Ticketstatus],
			ch.UpdateDate as refund_date, 
			c.tracking_id

	   FROM tblPassengerBookDetails b
	     INNER JOIN tblBookMaster a 
	       ON b.fkBookMaster = a.pkId
         Left join CancellationHistory ch
	      ON ch.OrderId = a.orderId
		LEFT Join Paymentmaster c
	    ON a.OrderId=c.order_id
        LEFT JOIN tblBookItenary tbi
	    ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	  
	   WHERE 
	   ((CONVERT(date,b.CancelledDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		   AND (CONVERT(date,b.CancelledDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
		   AND 
		   b.Iscancelled = 1
	   ) p

	   ORDER BY P.booking_date DESC

  SELECT @RecordCount =@@ROWCOUNT

  	SELECT * FROM #tempTableC
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END


ELSE IF  ( UPPER(@Status) = UPPER('Refunded'))
BEGIN

IF OBJECT_ID ( 'tempdb..#tempTableR') IS NOT NULL
  DROP table  #tempTableR

 -- Select 'Refunded'

SELECT * INTO #tempTableR
from
	(  
	  select 	  
	        b.pid, b.paxfname+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	        a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,
			a.inserteddate as booking_date, a.GDSPNR, b.RefundAmount, b.Iscancelled,
			'' as 'payment_mode', '' as 'getway_name', 
   --  	   CASE WHEN b.status=1  then 'HX Request' 
			--    WHEN b.status=1  then 'Cancelled' 
			--	WHEN b.status is Null  then 'Confirmed' 
			--	WHEN b.status = 1 THEN 'Cancelled'
			--END AS [status] ,
			CASE WHEN  (b.Iscancelled = 1)  then 'Cancelled' 
				 WHEN  (b.Iscancelled = 0 and b.IsRefunded =0)  then 'Confirmed' 	
				 WHEN  (b.IsRefunded = 1)  then 'Refunded' 				
			END AS [Ticketstatus],
			'' as refund_date, 
			'' as 'tracking_id'

	   FROM tblPassengerBookDetails b
	     INNER JOIN tblBookMaster a 
	       ON b.fkBookMaster = a.pkId
         Left join CancellationHistory ch
	      ON ch.OrderId = a.orderId
		LEFT Join Paymentmaster c
	    ON a.OrderId=c.order_id
        LEFT JOIN tblBookItenary tbi
	    ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	  
	   WHERE 
	   ((CONVERT(date,b.RefundedDate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		   AND (CONVERT(date,b.RefundedDate) <= (CONVERT(date,@ToDate)) OR @ToDate IS NULL))
		   AND 
		   b.IsRefunded = 1
			 ) p

	   ORDER BY P.booking_date DESC

  SELECT @RecordCount =@@ROWCOUNT

  	SELECT * FROM #tempTableR
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END


ELSE 

BEGIN

IF OBJECT_ID ( 'tempdb..#tempTableA1') IS NOT NULL
  DROP table  #tempTableA1 

  --Select 'Confirmed'

SELECT * INTO #tempTableA1 
FROM
	( SELECT b.pid, b.paxfname+' '+b.paxlname as paxname, a.emailId as email, a.mobileNo as mob,
	         a.RiyaPNR, a.airName, tbi.airlinePNR, a.frmsector, a.tosector AS tosector, 
			 a.depDate AS deptdate, a.arrivaldate AS arrivaldate, a.OrderId, b.totalfare,
			 a.inserteddate as booking_date, a.GDSPNR, ch.RefundAmount, c.order_status,
			 c.payment_mode, c.getway_name,
   --  	   CASE WHEN  b.status=1   THEN 'HX Request' 
			--	WHEN  b.status=1  THEN 'Cancelled'
			--	WHEN  b.status is Null  THEN 'Confirmed'
			--	WHEN  b.status = 1 THEN 'Cancelled'
			--END AS [status],
			CASE WHEN (b.Iscancelled = 1)  THEN 'Cancelled'
				 WHEN (b.Iscancelled = 0 and b.IsRefunded = 0) THEN 'Confirmed'
				 WHEN (b.IsRefunded = 1)  THEN 'Refunded'
			END AS [Ticketstatus],
			ch.UpdateDate as refund_date, c.tracking_id
	 FROM tblBookMaster a
	 INNER JOIN tblPassengerBookDetails b
	    ON a.pkId=b.fkBookMaster
	 LEFT JOIN CancellationHistory ch 
	    ON a.OrderId=ch.OrderId
	 LEFT JOIN Paymentmaster c
	    ON a.OrderId=c.order_id
	 LEFT JOIN tblBookItenary tbi
	    ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector

 WHERE ((CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))
		--AND ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
		--AND  (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
		--AND  (tbi.airlinePNR = @AirlinePNR or @AirlinePNR is null )
		--AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
		--AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
		----AND (b.status=@Status or @Status is null)
	 --	and (c.order_status=@Status2 or @Status2 is null )
		--AND  ( c.order_id =@OrderID or @OrderID ='' )
		--AND  ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
		--AND a.isbooked=1
		AND B.Iscancelled = 0 AND B.IsRefunded=0

	   )p
	ORDER BY  P.booking_date DESC

	SELECT @RecordCount =@@ROWCOUNT

	SELECT * FROM #tempTableA1
	ORDER BY  booking_date 
	OFFSET @Start ROWS
	FETCH NEXT @Pagesize ROWS ONLY

END

	-- Select Only @Pagesize Records
	--SELECT * FROM 
	--(SELECT *,ROW_NUMBER() OVER (ORDER BY booking_date asc, paxname desc) AS RowRank FROM #tempTableA1 )P
	--WHERE   RowRank > @Start AND RowRank <= (@Start + @Pagesize) 





GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Searchprocessdata_GJ] TO [rt_read]
    AS [dbo];

