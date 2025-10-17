 --exec [SearchprocessdataAgentByStatusNEW1] '2022-05-02','2022-05-06','','','','','',99,99,'','',0,150,4,22127,0,2,''  
        
CREATE PROCEDURE [dbo].[SearchprocessdataAgentByStatusNEW1]              
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
 @ParentID int= null,          
 @Airline varchar(max)=''      
 ,@Currency nvarchar(20)=''      
 --@OfficeID VARCHAR(50)=NULL 
 --Added BY JD
 ,@MainAgentId Int = NULL,
  @AgentID Int = NULL

AS              
              
--Below statement if AgentID is ZERO           
Declare @NewsUserID as Varchar(10)  , @TillDate DateTime        
set @NewsUserID = (Case when @Userid=0 then '' else CAST(@Userid as varchar(10)) END )          
--select @NewsUserID as NEWUSERID01            
  
  -- IF MAIN AGENT ID = 0 AND AGENT ID > 0 
	IF(@MainAgentId = 0 AND @AgentID <= 0)
	BEGIN		
		SELECT @RecordCount = 0
		Return;
	END

	SELECT @TillDate = TillDate FROM tblBlockTransaction WHERE AgentId = @AgentID

	IF(@TillDate IS NOT NULL AND (@TillDate >= @FROMDate AND @TillDate >= @ToDate))
	BEGIN
		SET @RecordCount = 0
		Return;
	END
	
	IF(@TillDate IS NOT NULL AND @TillDate >= @FROMDate)
	BEGIN
		SET @FROMDate = DATEADD(DAY, 1, @TillDate)
	END
	--END

if(@ParentID is not null)              
BEGIN              
              
              
if (@Status = 99 )              
BEGIN              
IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL              
  DROP table  #tempTableA              
 SELECT * INTO #tempTableA               
from              
 ( select distinct pid,RemarkCancellation as [Operation Remark],RemarkCancellation2 as [Refund Remark], ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob, a.returnFlag,              
         a.RiyaPNR, a.airName, BR.AgencyName ,BR.Icast, tbi.airlinePNR,   
   CASE WHEN a.MainAgentId>0 then mu.UserName else br1.Icast end BookedBy,  
   -- a.frmsector, a.tosector AS tosector,               
   a.deptTime AS deptdate, a.arrivalTime AS arrivaldate, a.OrderId,   
   ((select Isnull(SUM(totalfare + isnull(MCOAmount,0) 
   --+ ISNULL(ServiceFee,0) + ISNULL(GST,0) 
   + isnull(BFC,0) +isnull(TotalHupAmount,0)),0) from tblBookMaster(nolock) where riyaPNR=a.RiyaPNR)   
  -- (a.totalfare + isnull(a.MCOAmount,0) + ISNULL(A.ServiceFee,0) + ISNULL(A.GST,0) + isnull(a.BFC,0)+isnull(a.TotalHupAmount,0)+  
   --+(select Isnull(SUM(SSR_Amount),0) from tblSSRDetails ssr inner join tblBookMaster tbm on ssr.fkBookMaster=tbm.pkId where tbm.riyaPNR=a.RiyaPNR)  
   )   
   as totalfare,  
   isnull(a.ROE,1) ROE,isnull(a.AgentROE,1) AgentROE,isnull(a.B2BMarkup,0) B2BMarkup,isnull(a.AgentMarkup,0) Markup,              
   a.inserteddate as booking_date, a.GDSPNR, order_status,              
   c.payment_mode, c.getway_name,               
   case when a.BookingStatus=1 then 'Confirmed'              
   when a.BookingStatus=2 then 'Hold'              
   when a.BookingStatus=3 then 'Pending Ticket'              
   when a.BookingStatus=4 then 'Cancel'              
   when a.BookingStatus=5 then 'Close'          
 when a.BookingStatus=6 then 'To Be Cancelled'          
 when a.BookingStatus=7 then 'To Be Rescheduled'          
 when a.BookingStatus=8 then 'Rescheduled'          
 when a.BookingStatus=0 then 'Failed'      
  when a.BookingStatus=11 then 'Cancel'    
    ELSE              
   'Failed'                
   END AS [Ticketstatus],              
              
   case when a.BookingStatus=1 then 'Bookticket'              
   END AS [Bookticket],              
   a.BookingSource,              
    c.tracking_id,A.Country,c.currency              
                  
     ,(SELECT STUFF((SELECT '/' + s           
              
.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'              
 ,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s              
              
.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'              
              
 ,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'              
              
 , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'              
               
 ,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s               
              
WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')               
 AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'              
              
--,airlinePNR =(SELECT STUFF((SELECT '/' + s.airlinePNR  FROM tblBookItenary s               
--WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')               
-- AS AllPax FROM tblBookItenary t where t.fkBookMaster=a.pkId  and t.frmSector=a.frmSector  GROUP BY t.fkBookMaster,airlinePNR)              
               
                 
    from (select * from (select pid,RemarkCancellation,RemarkCancellation2, paxFName,paxLName,fkBookMaster,              
    ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN from tblPassengerBookDetails  )               
    as tblPBD where rn =1 ) as T1 join tblBookMaster  a              
                  
        ON a.pkId=t1.fkBookMaster              
 LEFT JOIN tblBookItenary tbi ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector              
 LEFT JOIN Paymentmaster c ON a.OrderId=c.order_id      
 --    LEFT JOIN tblSSRDetails SSR ON SSR.fkBookMaster=A.pkId      
 INNER JOIN AgentLogin AL on AL.UserID=a.AgentID           
 INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID   
  left JOIN mUser MU ON MU.ID = A.BookedBy  
   left JOIN B2BRegistration BR1 ON a.BookedBy = BR1.FKUserID  
              
    WHERE (              
    a.returnFlag = 0  and a.AgentID!='B2C'            
       AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL)               
    AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))              
    AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')              
    AND ((@RiyaPNR = '') or (a.riyaPNR = @riyaPNR) or (a.GDSPNR = @riyaPNR) or (tbi.airlinePNR = @RiyaPNR) )               
 --AND (airlinePNR =@AirlinePNR or @AirlinePNR ='' )           
 --AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )           
    AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')              
    AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')              
    AND ( c.order_id =@OrderID or @OrderID ='' )          
  -- and a.BookingStatus=1               
  --  and (a.OfficeID=@OfficeID or @OfficeID is null )              
   -- AND a.isbooked=1              
  --AND a.Country in (select country from UserCountryMapping where UserID=ISNULL(@Userid,@ParentID)  AND IsActive=1)          
  AND (a.AgentID = CAST(@NewsUserID AS VARCHAR(10)) or @NewsUserID = '')                 
   AND a.Country in (SELECT CountryCode FROM mUserCountryMapping CM  inner JOIN mCountry C ON CM.CountryId = C.ID WHERE UserId=@ParentID AND IsActive=1)          
   AND AL.UserTypeID in ( select UserTypeID from mUserTypeMapping WHERE UserId=@ParentID AND IsActive=1)          
   AND ((@Airline = '') or (a.airCode IN  ( select Data from sample_split(@Airline,','))))          
   AND a.BookingStatus  not in (0,3,9,10)              
    ) p              
              
   ORDER BY P.booking_date DESC    
  
SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA              
SELECT * FROM #tempTableA              
 ORDER BY               
               
booking_date               
 OFFSET @Start ROWS              
 FETCH NEXT @Pagesize ROWS ONLY              
END              
          
--Status 55 set for Void Bookings          
ELSE IF(@Status=55)          
BEGIN          
 IF OBJECT_ID ( 'tempdb..#tempTableA55') IS NOT NULL          
  DROP table  #tempTableA55          
 SELECT * INTO #tempTableA55           
from          
 ( select  pid,RemarkCancellation as [Operation Remark],RemarkCancellation2 as [Refund Remark],  ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob,          
         a.RiyaPNR, a.airName, BR.AgencyName ,BR.Icast, tbi.airlinePNR,    
  '' as BookedBy,  
   -- a.frmsector, a.tosector AS tosector,           
   a.deptTime AS deptdate, a.arrivalTime AS arrivaldate, a.OrderId, (a.totalfare + isnull(a.MCOAmount,0) + ISNULL(A.ServiceFee,0) + ISNULL(A.GST,0)+isnull(a.TotalHupAmount,0) + isnull(a.BFC,0)) as totalfare,isnull(a.ROE,1) ROE,isnull(a.AgentROE,1         
 
) AgentROE,isnull(a.B2BMarkup,0) B2BMarkup,isnull(a.AgentMarkup,0) Markup,          
   a.inserteddate as booking_date, a.GDSPNR, order_status, c.payment_mode, c.getway_name,           
   'Void' AS [Ticketstatus], case when a.BookingStatus=1 then 'Bookticket' END AS [Bookticket],          
   a.BookingSource, c.tracking_id,A.Country,c.currency       
     ,(SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'          
 ,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'          
 ,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'          
 , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'           
 ,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')           
 AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'          
--,airlinePNR =(SELECT STUFF((SELECT '/' + s.airlinePNR  FROM tblBookItenary s           
--WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')           
-- AS AllPax FROM tblBookItenary t where t.fkBookMaster=a.pkId  and t.frmSector=a.frmSector  GROUP BY t.fkBookMaster,airlinePNR)           
             
    from (select * from (select pid,RemarkCancellation,RemarkCancellation2, paxFName,paxLName,fkBookMaster,          
    ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN from tblPassengerBookDetails  where  CheckboxVoid=1)           
    as tblPBD where rn =1 ) as T1 join tblBookMaster  a              
        ON a.pkId=t1.fkBookMaster          
     LEFT JOIN tblBookItenary tbi ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector          
     LEFT JOIN Paymentmaster c ON a.OrderId=c.order_id          
   INNER JOIN AgentLogin AL on AL.UserID=a.AgentID           
   INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID          
          
    WHERE (          
    a.returnFlag = 0 and a.AgentID!='B2C'            
       AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL)           
    AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))          
    AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')             
   AND ((@RiyaPNR = '') or (a.riyaPNR = @riyaPNR) or (a.GDSPNR = @riyaPNR) or (tbi.airlinePNR = @RiyaPNR))          
    --AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )           
   --AND (airlinePNR =@AirlinePNR or @AirlinePNR ='' ) AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )          
    AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')          
    AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')          
    AND ( c.order_id =@OrderID or @OrderID ='' )              
  -- and a.BookingStatus=1           
  --  and (a.OfficeID=@OfficeID or @OfficeID is null ) -- AND a.isbooked=1             
  --AND a.Country in (select country from UserCountryMapping where UserID=ISNULL(@Userid,@ParentID)  AND IsActive=1)          
  AND (a.AgentID = CAST(@NewsUserID AS VARCHAR(10)) or @NewsUserID = '')          
   AND a.Country in (SELECT CountryCode FROM mUserCountryMapping CM  inner JOIN mCountry C ON CM.CountryId = C.ID WHERE UserId=@ParentID AND IsActive=1)          
   AND AL.UserTypeID in ( select UserTypeID from mUserTypeMapping WHERE UserId=@ParentID AND IsActive=1)          
   AND ((@Airline = '') or (a.airCode IN  ( select Data from sample_split(@Airline,','))))          
   AND a.BookingStatus  not in (0,3,9,10,11)          
    ) p          
          
   ORDER BY P.booking_date DESC          
SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTable55          
SELECT * FROM #tempTableA55          
 ORDER BY booking_date           
 OFFSET @Start ROWS          
 FETCH NEXT @Pagesize ROWS ONLY          
END          
          
ELSE               
BEGIN              
IF OBJECT_ID ( 'tempdb..#tempTableA1') IS NOT NULL              
DROP table  #tempTableA1               
SELECT * INTO #tempTableA1               
FROM              
 ( SELECT pid,RemarkCancellation as [Operation Remark],RemarkCancellation2 as [Refund Remark], ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob,              
          a.RiyaPNR, a.airName,  BR.AgencyName ,BR.Icast, tbi.airlinePNR,  
  '' as BookedBy,
    --a.frmsector, a.tosector AS tosector,               
    a.deptTime AS deptdate, a.arrivalTime AS arrivaldate, a.OrderId, (a.totalfare + isnull(a.MCOAmount,0) + ISNULL(A.ServiceFee,0) + ISNULL(A.GST,0)+isnull(a.TotalHupAmount,0) + isnull(a.BFC,0)) as totalfare,isnull(a.ROE,1) ROE,isnull(a.AgentROE,1)       
        
AgentROE,isnull(a.B2BMarkup,0) B2BMarkup,isnull(a.AgentMarkup,0) Markup,              
    a.inserteddate as booking_date, a.GDSPNR,               
    c.order_status,              
    c.payment_mode, c.getway_name,              
 case when a.BookingStatus=1 then 'Confirmed'          
 when a.BookingStatus=2 then 'Hold'          
 when a.BookingStatus=3 then 'Pending Ticket'          
 when a.BookingStatus=4 then 'Cancelled'          
 when a.BookingStatus=5 then 'Close'          
 when a.BookingStatus=6 then 'To Be Cancelled'          
 when a.BookingStatus=7 then 'To Be Rescheduled'          
 when a.BookingStatus=8 then 'Rescheduled'          
 when a.BookingStatus=0 then 'Failed'          
  when a.BookingStatus=11 then 'Cancelled'       
 ELSE 'Failed'           
   END AS [Ticketstatus],              
   case when a.BookingStatus=1 then 'Bookticket'              
   END AS [Bookticket],    c.tracking_id,a.Country,c.currency,a.BookingSource--a.OfficeID              
              
                  
     ,(SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'              
 ,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'              
              
 ,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'              
              
 , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')   
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'              
              
,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s WHERE              
 s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')               
 AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'              
              
              
-- ,(SELECT STUFF((SELECT '/' + s.airlinePNR  FROM tblBookItenary s               
--WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')               
-- AS AllPax FROM tblBookItenary t where t.fkBookMaster=a.pkId                
-- and t.frmSector=a.frmSector              
--   GROUP BY t.fkBookMaster,airlinePNR) as 'airlinePNR'              
               
    from (select * from (select pid,RemarkCancellation,RemarkCancellation2, paxFName,paxLName,fkBookMaster,              
    ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN              
     from tblPassengerBookDetails  ) as tblPBD where rn =1) as T1 join tblBookMaster  a         
                  
        ON a.pkId=t1.fkBookMaster              
 LEFT JOIN tblBookItenary tbi   ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector              
 LEFT JOIN Paymentmaster c  ON a.OrderId=c.order_id          
 INNER JOIN AgentLogin AL on AL.UserID=a.AgentID               
 INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID                   
      WHERE (              
   a.returnFlag = 0  and a.AgentID!='B2C'            
       AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL)              
  AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))              
  AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')              
  AND  ((@RiyaPNR = '') or (a.riyaPNR = @riyaPNR) or (a.GDSPNR = @riyaPNR) or (tbi.airlinePNR = @RiyaPNR))              
  --AND  (airlinePNR = @AirlinePNR or @AirlinePNR ='' )            
  --AND  ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )           
  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')              
  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')              
  AND  ( c.order_id =@OrderID or @OrderID ='' )          
  --AND a.isbooked=1               
  --AND B.Iscancelled = 0 AND B.IsRefunded=0  --avinash commented               
  --AND a.AgentID=CAST(@Userid AS VARCHAR(50))               
  AND a.BookingStatus = @Status          
  AND (a.AgentID = CAST(@Userid AS VARCHAR(10)) or @Userid = '' or @Userid = 0 )          
  AND a.Country in (SELECT CountryCode FROM mUserCountryMapping CM  inner JOIN mCountry C ON CM.CountryId = C.ID WHERE UserId=@ParentID AND IsActive=1)          
  AND AL.UserTypeID in ( select UserTypeID from mUserTypeMapping WHERE UserId=@ParentID AND IsActive=1)          
  AND ((@Airline = '') or (a.airCode IN  ( select Data from sample_split(@Airline,','))))          
    )p ORDER               
BY  P.booking_date DESC              
SELECT @RecordCount =@@ROWCOUNT              
SELECT * FROM #tempTableA1              
 ORDER BY  booking_date               
 OFFSET @Start ROWS              
 FETCH NEXT @Pagesize ROWS ONLY              
              
END              
              
END              
              
ELSE if(@ParentID is  null)              
BEGIN              
              
              
if (@Status = 99 )              
BEGIN              
IF OBJECT_ID ( 'tempdb..#tempTableB') IS NOT NULL              
  DROP table  #tempTableB              
 SELECT * INTO #tempTableB               
from              
 ( select  pid,RemarkCancellation as [Operation Remark],RemarkCancellation2 as [Refund Remark],  ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob,              
         a.RiyaPNR, a.airName,   BR.AgencyName ,BR.Icast, tbi.airlinePNR,        
   -- a.frmsector, a.tosector AS tosector,               
   a.deptTime AS deptdate, a.arrivalTime AS arrivaldate, a.OrderId, (a.totalfare + isnull(a.MCOAmount,0) + ISNULL(A.ServiceFee,0) + ISNULL(A.GST,0)+isnull(a.TotalHupAmount,0) + isnull(a.BFC,0)) as totalfare,isnull(a.ROE,1) ROE,isnull(a.AgentROE,1         
     
) AgentROE,isnull(a.B2BMarkup,0) B2BMarkup,isnull(a.AgentMarkup,0) Markup,              
   a.inserteddate as booking_date, a.GDSPNR, order_status,              
   c.payment_mode, c.getway_name,               
 case when a.BookingStatus=1 then 'Confirmed'          
 when a.BookingStatus=2 then 'Hold'          
 when a.BookingStatus=3 then 'Pending Ticket'          
 when a.BookingStatus=4 then 'Cancelled'          
 when a.BookingStatus=5 then 'Close'          
 when a.BookingStatus=6 then 'To Be Cancelled'          
 when a.BookingStatus=7 then 'To Be Rescheduled'          
 when a.BookingStatus=8 then 'Rescheduled'          
 when a.BookingStatus=0 then 'Failed'    
 when a.BookingStatus=11 then 'Cancelled'     
    ELSE              
   'Failed'                
   END AS [Ticketstatus],              
              
   case when a.BookingStatus=1 then 'Bookticket'              
   END AS [Bookticket],      
    --AVINASH ADDED  
  CASE WHEN a.MainAgentId>0 then mu.UserName else br1.Icast end BookedBy,  
    c.tracking_id,A.Country,c.currency,a.BookingSource              
                  
     ,(SELECT STUFF((SELECT '/' + s              
              
.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'              
 ,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s              
              
.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'              
              
 ,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'              
              
 , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'              
               
 ,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s               
              
WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')               
 AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'              
              
--,airlinePNR =(SELECT STUFF((SELECT '/' + s.airlinePNR  FROM tblBookItenary s               
--WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')               
-- AS AllPax FROM tblBookItenary t where t.fkBookMaster=a.pkId  and t.frmSector=a.frmSector  GROUP BY t.fkBookMaster,airlinePNR)              
               
    from (select * from (select pid,RemarkCancellation,RemarkCancellation2, paxFName,paxLName,fkBookMaster,              
    ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN from tblPassengerBookDetails  )              
     as tblPBD where rn =1 ) as T1 join tblBookMaster  a              
                  
        ON a.pkId=t1.fkBookMaster              
     LEFT JOIN tblBookItenary tbi ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector              
     LEFT JOIN Paymentmaster c ON a.OrderId=c.order_id              
 INNER JOIN AgentLogin AL ON  a.AgentID = AL.UserID          
 INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID  
left JOIN mUser MU ON MU.ID = A.BookedBy  
left JOIN B2BRegistration BR1 ON a.BookedBy = BR1.FKUserID  
    WHERE (              
    a.returnFlag = 0 and a.AgentID!='B2C'            
 AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL)               
    AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))              
    AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')              
    AND ((@RiyaPNR = '') or (a.riyaPNR = @riyaPNR) or (a.GDSPNR = @riyaPNR) or (tbi.airlinePNR = @RiyaPNR))               
 --AND (airlinePNR =@AirlinePNR or @AirlinePNR ='' )          
 --AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )           
    AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')              
    AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')              
    AND ( c.order_id =@OrderID or @OrderID ='' )              
                    
   --and a.BookingStatus=1               
   --and (a.OfficeID=@OfficeID or @OfficeID is null )              
   -- AND a.isbooked=1           
   --AND a.Country in (SELECT CountryCode FROM mUserCountryMapping CM  inner JOIN mCountry C ON CM.CountryId = C.ID WHERE UserId=isnull(@ParentID,@Userid) AND IsActive=1)          
 AND (a.AgentID = CAST(@Userid AS VARCHAR(10))or   @Userid = '')          
 AND ((@Airline = '') or (a.airCode IN  ( select Data from sample_split(@Airline,','))))             
 AND a.BookingStatus  not in (0,3,9,10,11)              
    ) p              
              
   ORDER BY P.booking_date DESC              
SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableA              
SELECT * FROM #tempTableB              
 ORDER BY               
               
booking_date               
 OFFSET @Start ROWS              
 FETCH NEXT @Pagesize ROWS ONLY              
END            
          
--Status 55 set for Void Bookings          
ELSE IF(@Status=55)          
BEGIN          
 IF OBJECT_ID ( 'tempdb..##tempTableB55') IS NOT NULL          
  DROP table  #tempTableB55          
 SELECT * INTO #tempTableB55           
from          
 ( select  pid,RemarkCancellation as [Operation Remark],RemarkCancellation2 as [Refund Remark],  ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob,          
         a.RiyaPNR, a.airName, BR.AgencyName ,BR.Icast, tbi.airlinePNR,  '' as BookedBy        ,
   -- a.frmsector, a.tosector AS tosector,           
   a.deptTime AS deptdate, a.arrivalTime AS arrivaldate, a.OrderId, (a.totalfare + isnull(a.MCOAmount,0) + ISNULL(A.ServiceFee,0) + ISNULL(A.GST,0) +isnull(a.TotalHupAmount,0)+ isnull(a.BFC,0)) as totalfare,isnull(a.ROE,1) ROE,isnull(a.AgentROE,1         
 
) AgentROE,isnull(a.B2BMarkup,0) B2BMarkup,isnull(a.AgentMarkup,0) Markup,          
   a.inserteddate as booking_date, a.GDSPNR, order_status, c.payment_mode, c.getway_name,           
   'Void' AS [Ticketstatus], case when a.BookingStatus=1 then 'Bookticket' END AS [Bookticket],          
   a.BookingSource, c.tracking_id,A.Country,c.currency         
     ,(SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'          
 ,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'          
 ,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'          
 , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')           
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'           
 ,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')           
 AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'          
--,airlinePNR =(SELECT STUFF((SELECT '/' + s.airlinePNR  FROM tblBookItenary s           
--WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')           
-- AS AllPax FROM tblBookItenary t where t.fkBookMaster=a.pkId  and t.frmSector=a.frmSector  GROUP BY t.fkBookMaster,airlinePNR)           
             
    from (select * from (select pid,RemarkCancellation,RemarkCancellation2, paxFName,paxLName,fkBookMaster,          
    ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN from tblPassengerBookDetails  where  CheckboxVoid=1)           
    as tblPBD where rn =1 ) as T1 join tblBookMaster  a              
        ON a.pkId=t1.fkBookMaster          
     LEFT JOIN tblBookItenary tbi ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector          
     LEFT JOIN Paymentmaster c ON a.OrderId=c.order_id          
   INNER JOIN AgentLogin AL on AL.UserID=a.AgentID           
   INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID          
          
    WHERE (          
    a.returnFlag = 0 and a.AgentID!='B2C'            
       AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL)           
    AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))          
    AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')             
   AND ((@RiyaPNR = '') or (a.riyaPNR = @riyaPNR) or (a.GDSPNR = @riyaPNR) or (tbi.airlinePNR = @RiyaPNR))          
    --AND (a.RiyaPNR like '%'+ @RiyaPNR +'%' or @RiyaPNR = '' )           
   --AND (airlinePNR =@AirlinePNR or @AirlinePNR ='' ) AND ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )          
    AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')          
    AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')          
    AND ( c.order_id =@OrderID or @OrderID ='' )              
  -- and a.BookingStatus=1           
  --  and (a.OfficeID=@OfficeID or @OfficeID is null ) -- AND a.isbooked=1             
  --AND a.Country in (select country from UserCountryMapping where UserID=ISNULL(@Userid,@ParentID)  AND IsActive=1)          
  AND (a.AgentID = CAST(@Userid AS VARCHAR(10))or   @Userid = '')             
   --AND AL.UserTypeID in ( select UserTypeID from mUserTypeMapping WHERE UserId=@ParentID AND IsActive=1)          
   AND ((@Airline = '') or (a.airCode IN  ( select Data from sample_split(@Airline,','))))          
   AND a.BookingStatus  not in (0,3,9,10,11)          
    ) p          
          
   ORDER BY P.booking_date DESC          
SELECT @RecordCount = @@ROWCOUNT --COUNT(*) FROM #tempTableB55          
SELECT * FROM #tempTableB55          
 ORDER BY booking_date           
 OFFSET @Start ROWS          
 FETCH NEXT @Pagesize ROWS ONLY          
END          
              
ELSE               
BEGIN              
IF OBJECT_ID ( 'tempdb..#tempTableB1') IS NOT NULL              
DROP table  #tempTableB1               
SELECT * INTO #tempTableB1               
FROM              
 ( SELECT pid,RemarkCancellation as [Operation Remark],RemarkCancellation2 as [Refund Remark], ISNULL(paxfname,'')+' '+paxlname as paxname, a.emailId as email, a.mobileNo as mob,              
          a.RiyaPNR, a.airName, BR.AgencyName ,BR.Icast, tbi.airlinePNR,   '' as BookedBy,           
    --a.frmsector, a.tosector AS tosector,               
    a.deptTime AS deptdate, a.arrivalTime AS arrivaldate, a.OrderId, (a.totalfare + isnull(a.MCOAmount,0) + ISNULL(A.ServiceFee,0) + ISNULL(A.GST,0)+isnull(a.TotalHupAmount,0) + isnull(a.BFC,0)) as totalfare,isnull(a.ROE,1) ROE,isnull(a.AgentROE,1)       
        
AgentROE,              
    a.inserteddate as booking_date, a.GDSPNR,               
    c.order_status,              
    c.payment_mode, c.getway_name,              
 case when a.BookingStatus=1 then 'Confirmed'          
 when a.BookingStatus=2 then 'Hold'          
 when a.BookingStatus=3 then 'Pending Ticket'          
 when a.BookingStatus=4 then 'Cancelled'          
 when a.BookingStatus=5 then 'Close'             
 when a.BookingStatus=6 then 'To Be Cancelled'          
 when a.BookingStatus=7 then 'To Be Rescheduled'          
 when a.BookingStatus=8 then 'Rescheduled'          
 when a.BookingStatus=0 then 'Failed'      
  when a.BookingStatus=11 then 'Cancelled'      
 ELSE 'Failed'         
   END AS [Ticketstatus],              
   case when a.BookingStatus=1 then 'Bookticket'              
   END AS [Bookticket],    c.tracking_id,a.Country,c.currency,isnull(a.B2BMarkup,0) B2BMarkup,isnull(a.AgentMarkup,0) Markup,              
   a.BookingSource,              
                  
     (SELECT STUFF((SELECT '/' + s.frmSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'frmsector'              
 ,(SELECT STUFF((SELECT '/' + s.toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'tosector'              
              
 ,(SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId) as 'Sector'              
              
 , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'')               
 AS Sector FROM tblBookItenary t where t.fkBookMaster=a.pkId  GROUP BY t.orderId)AS 'Dep Date all'              
              
,(SELECT STUFF((SELECT '/' + s.paxFName+ ' ' + paxLName FROM tblPassengerBookDetails s WHERE              
 s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')               
 AS AllPax FROM tblPassengerBookDetails t where t.fkBookMaster=a.pkId  GROUP BY t.fkBookMaster) as 'AllPax'              
-- ,(SELECT STUFF((SELECT '/' + s.airlinePNR  FROM tblBookItenary s               
--WHERE s.fkBookMaster = t.fkBookMaster FOR XML PATH('')),1,1,'')               
-- AS AllPax FROM tblBookItenary t where t.fkBookMaster=a.pkId                
-- and t.frmSector=a.frmSector              
--   GROUP BY t.fkBookMaster,airlinePNR) as 'airlinePNR'              
  from (select * from (select pid,RemarkCancellation,RemarkCancellation2, paxFName,paxLName,fkBookMaster,              
     ROW_NUMBER() OVER(Partition by fkBookMaster ORDER BY pid) AS RN from tblPassengerBookDetails )               
     as tblPBD where rn =1) as T1 join tblBookMaster  a              
        ON a.pkId=t1.fkBookMaster              
     LEFT JOIN tblBookItenary tbi ON a.pkId=tbi.fkBookMaster and a.frmSector=tbi.frmSector              
     LEFT JOIN Paymentmaster c  ON a.OrderId=c.order_id          
 INNER JOIN AgentLogin AL ON  a.AgentID = AL.UserID          
 INNER JOIN B2BRegistration BR ON AL.UserID = BR.FKUserID          
      WHERE               
   (a.returnFlag = 0 and a.AgentID!='B2C'             
     AND (CONVERT(date,a.inserteddate) >= (CONVERT(date,@FROMDate)) OR @FROMDate IS NULL)               
  AND (CONVERT(date,a.inserteddate) <= (CONVERT(date, @ToDate)) OR @ToDate IS NULL))              
  AND ( paxfname+' '+paxlname  like '%'+ @paxname +'%' or @paxname = '')              
  AND  ((@RiyaPNR = '') or (a.riyaPNR = @riyaPNR) or (a.GDSPNR = @riyaPNR) or (tbi.airlinePNR = @RiyaPNR))              
  --AND  (airlinePNR = @AirlinePNR or @AirlinePNR ='' )           
  --AND  ( a.GDSPNR =@GDSPNR or @GDSPNR ='' )          
  AND (a.emailId like '%'+ @EmailID +'%' or @EmailID = '')              
  AND (a.mobileNo like '%'+ @MobileNo +'%' or @MobileNo = '')              
  AND  ( c.order_id =@OrderID or @OrderID ='' )          
  --AND a.isbooked=1               
  --AND B.Iscancelled = 0 AND B.IsRefunded=0  avinash commented           
  --AND a.Country in (SELECT CountryCode FROM mUserCountryMapping CM  inner JOIN mCountry C ON CM.CountryId = C.ID WHERE UserId=isnull(@ParentID,@Userid) AND IsActive=1)            
  AND  a.BookingStatus = @Status                 
  AND (a.AgentID = CAST(@Userid AS VARCHAR(10)) or   @Userid = '')          
  AND ((@Airline = '') or (a.airCode IN  ( select Data from sample_split(@Airline,','))))             
              
    )p ORDER               
BY  P.booking_date DESC              
SELECT @RecordCount =@@ROWCOUNT              
SELECT * FROM #tempTableB1              
 ORDER BY  booking_date               
 OFFSET @Start ROWS              
 FETCH NEXT @Pagesize ROWS ONLY              
              
END              
              
END 
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[SearchprocessdataAgentByStatusNEW1] TO [rt_read]
    AS [dbo];

