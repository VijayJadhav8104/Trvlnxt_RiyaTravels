
CREATE PROCEDURE [dbo].[Searchprocessdata_BAK03072017] --'1/1/2017','5/22/2017','','',null,'','',null,null,'','',10,1,'',1
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
if (@Status <> '' )
BEGIN

IF OBJECT_ID('tempdb..#tempTableA') IS NOT NULL
DROP table #tempTableA

select * into #tempTableA from
	( select b.pid,b.paxfname+' '+b.paxlname as paxname,a.emailId as email,a.mobileNo as mob,a.RiyaPNR,a.airName,tbi.airlinePNR  ,
	
			 a.frmsector,a.tosector AS tosector,a.depDate AS deptdate,a.arrivaldate AS arrivaldate,
			a.OrderId,b.totalfare,a.inserteddate as booking_date,a.GDSPNR,ch.RefundAmount,order_status,
			c.payment_mode,c.getway_name,
     	   CASE WHEN  b.status=1   then 'HX Request' 
					  WHEN    b.status=1  then 'Cancelled' 
					  WHEN   b.status is Null  then 'Confirmed' 
					  WHEN   b.status = 1 THEN 'Cancelled'
					 END AS [status]
					 ,
					 CASE WHEN  (b.Iscancelled = 1)  then 'Cancelled' 
					  WHEN   (b.Iscancelled = 0 and b.IsRefunded =0)  then 'Confirmed' 	
					  WHEN   (b.IsRefunded = 1)  then 'Refunded' 				
					 END AS [Ticketstatus]
					 ,ch.UpdateDate as refund_date,c.tracking_id
	 from tblBookMaster a
	 inner join tblPassengerBookDetails b
	 on a.pkId=b.fkBookMaster
	  left join CancellationHistory ch on a.OrderId=ch.OrderId
	 left join Paymentmaster c
	 on a.OrderId=c.order_id
	 	 left join tblBookItenary tbi
	 on a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	 where ((CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		AND (CONVERT(date,a.inserteddate) <=(CONVERT(date, @ToDate)) OR @ToDate IS NULL))
				AND ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
				 AND  (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
				 AND  (tbi.airlinePNR = @AirlinePNR or @AirlinePNR is null )
				 AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
				 AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
				 --AND (b.status=@Status or @Status is null)
	 			 and (c.order_status=@Status2 or @Status2 is null )
				 AND  ( c.order_id =@OrderID or @OrderID ='' )
				AND  ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
				and Iscancelled=@Iscancelled and b.IsRefunded =@IsRefunded
				and a.isbooked=1
			     )p
		 ORDER BY 
				P.booking_date DESC


	SELECT @RecordCount = COUNT(*) FROM #tempTableA

	-- Select Only @Pagesize Records
	SELECT * FROM (SELECT *,ROW_NUMBER() OVER (ORDER BY booking_date asc,paxname desc) AS RowRank FROM #tempTableA )P
	WHERE   RowRank > @Start AND RowRank <= (@Start + @Pagesize) 
	ORDER BY  RowRank 

	
end
else
begin

IF OBJECT_ID('tempdb..#tempTableA1') IS NOT NULL
DROP table #tempTableA1

select * into #tempTableA1 from
	( select b.pid,b.paxfname+' '+b.paxlname as paxname,a.emailId as email,a.mobileNo as mob,a.RiyaPNR,a.airName,tbi.airlinePNR  ,
	
			 a.frmsector,a.tosector AS tosector,a.depDate AS deptdate,a.arrivaldate AS arrivaldate,
			a.OrderId,b.totalfare,a.inserteddate as booking_date,a.GDSPNR,ch.RefundAmount,order_status,
			c.payment_mode,c.getway_name,
     	   CASE WHEN  b.status=1   then 'HX Request' 
					  WHEN    b.status=1  then 'Cancelled' 
					  WHEN   b.status is Null  then 'Confirmed' 
					  WHEN   b.status = 1 THEN 'Cancelled'
					 END AS [status]
					 ,
					 CASE WHEN  (b.Iscancelled = 1)  then 'Cancelled' 
					  WHEN   (b.Iscancelled = 0 and b.IsRefunded =0)  then 'Confirmed' 	
					  WHEN   (b.IsRefunded = 1)  then 'Refunded' 				
					 END AS [Ticketstatus]
					 ,ch.UpdateDate as refund_date,c.tracking_id
	 from tblBookMaster a
	 inner join tblPassengerBookDetails b
	 on a.pkId=b.fkBookMaster
	  left join CancellationHistory ch on a.OrderId=ch.OrderId
	 left join Paymentmaster c
	 on a.OrderId=c.order_id
	 	 left join tblBookItenary tbi
	 on a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector
	 where ((CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL) 
		AND (CONVERT(date,a.inserteddate) <=(CONVERT(date, @ToDate)) OR @ToDate IS NULL))
				AND ( b.paxfname+' '+b.paxlname  like '%'+ @paxname +'%' or @paxname = '')
				 AND  (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )
				 AND  (tbi.airlinePNR = @AirlinePNR or @AirlinePNR is null )
				 AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')
				 AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')
				 --AND (b.status=@Status or @Status is null)
	 			 and (c.order_status=@Status2 or @Status2 is null )
				 AND  ( c.order_id =@OrderID or @OrderID ='' )
				AND  ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )
				and a.isbooked=1
				   )p
		 ORDER BY 
				P.booking_date DESC


	SELECT @RecordCount = COUNT(*) FROM #tempTableA1

	-- Select Only @Pagesize Records
	SELECT * FROM (SELECT *,ROW_NUMBER() OVER (ORDER BY booking_date asc, paxname desc) AS RowRank FROM #tempTableA1 )P
	WHERE   RowRank > @Start AND RowRank <= (@Start + @Pagesize) 
	ORDER BY  RowRank 

end






GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Searchprocessdata_BAK03072017] TO [rt_read]
    AS [dbo];

