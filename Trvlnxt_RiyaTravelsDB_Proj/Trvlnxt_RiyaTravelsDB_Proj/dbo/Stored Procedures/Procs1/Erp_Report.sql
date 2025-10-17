-- ================================================        
-- Template generated from Template Explorer using:        
-- Create Procedure (New Menu).SQL        
--        
-- Use the Specify Values for Template Parameters         
-- command (Ctrl-Shift-M) to fill in the parameter         
-- values below.        
CREATE  PROCEDURE [dbo].[Erp_Report]         
     @Fromdate VARCHAR(30)=null        
 , @Todate VARCHAR(30)=null        
 , @RiyaPnr Varchar(30)=null        
 , @TicketNo Varchar(30)=null        
 , @Status varchar(2)=null        
 , @Flag Varchar(30)=null      
  ,@Usertype Varchar(30)=null        
 ,@Country varchar(10)=null        
 --,@Id int=null        
 , @Start int=null        
 , @Pagesize int=null        
 , @IsPaging bit        
 , @RecordCount INT OUTPUT        
AS        
BEGIN        
 --BEGIN        
 --if(@Flag='Data')        
 -- BEGIN        
 -- SELECT        
 --     distinct b.pkid,         
 --     convert(VARCHAR, B.inserteddate, 106) AS 'BookingDate'        
 --  ,B.riyaPNR AS 'RiyaPnr'        
 --  ,P.ticketNum AS 'TicketNumber'        
 --  ,CASE          
 --     when P.ERPPuststatus=0 then 'Failed'        
 --     when P.ERPPuststatus=1 then 'Success'        
 --      END AS 'ERPPuststatus'        
 --  ,p.ERPResponseID AS 'ERPResponseID'        
 --  ,P.CancERPPuststatus AS 'CancERPPuststatus'        
 --  ,P.CancERPResponseID AS 'CancERPResponseID'        
         
 -- FROM tblBookMaster B        
 -- INNER JOIN tblPassengerBookDetails P ON B.pkId = P.fkBookMaster        
 -- LEFT JOIN  NewERPData_Log ED on B.pkid=ED.FK_tblbookmasterID         
 -- WHERE cast(B.inserteddate AS DATE) BETWEEN @FromDate AND @ToDate        
 --  END        
 --if(@Flag='ErrorResponse')        
 -- BEGIN        
 -- select top 1 Response from NewERPData_Log where FK_tblbookmasterID=@Id order by createdon desc         
 -- END        
        
 --END        
 SET @RecordCount=0        
 IF(@Flag='Data')        
 BEGIN        
  IF(@IsPaging=1)        
  BEGIN        
   IF OBJECT_ID ( 'tempdb..#tempTableA') IS NOT NULL        
    DROP table  #tempTableA        
           
   SELECT * INTO #tempTableA FROM (        
    SELECT distinct        
    b.pkid        
    , P.pid        
    --convert(VARCHAR, B.inserteddate, 106) AS 'BookingDate'        
	--	, B.inserteddate as 'BookingDate'       
		,FORMAT(B.inserteddate, 'dd-MMM-yyyy HH:mm:ss') AS [BookingDate]
    , B.riyaPNR AS 'RiyaPnr'        
    --,P.ticketNum AS 'TicketNumber'        
    , (CASE WHEN CHARINDEX('/',ticketNum) > 0 THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum) + 1,        
      LEN(ticketNum)),0,CHARINDEX('/',(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum) + 1,        
      LEN(ticketNum))),0)) ELSE ticketNum END) as 'TicketNumber'        
    , CASE WHEN P.ERPPuststatus = 0 THEN 'Failed' WHEN P.ERPPuststatus=1         
      THEN 'Success' END AS 'ERPPuststatus'        
    , p.ERPResponseID AS 'ERPResponseID'        
    , P.CancERPPuststatus AS 'CancERPPuststatus'        
    , P.CancERPResponseID AS 'CancERPResponseID'        
    FROM tblBookMaster B WITH(NOLOCK)        
    INNER JOIN tblPassengerBookDetails P WITH(NOLOCK) ON B.pkId = P.fkBookMaster        
 LEFT JOIN agentLogin A WITH(NOLOCK) ON cast(A.UserID as varchar)=b.AgentID       
    -- LEFT JOIN  NewERPData_Log ED on B.pkid=ED.FK_tblbookmasterID         
    --WHERE cast(B.inserteddate AS DATE) BETWEEN @FromDate AND @ToDate        
    WHERE ((@FROMDate = '') OR (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))        
       AND ((@ToDate = '') OR (CONVERT(date,B.inserteddate) <= CONVERT(date, @ToDate)))        
    AND (B.riyaPNR = @RiyaPnr  OR @RiyaPnr ='')       
  AND (A.UserTypeid=@usertype or @usertype='')      
  and (B.Country= @Country or @Country = '')      
    AND IsBooked=1  AND ((@Status = '') OR (cast(b.BookingStatus as varchar(50))=@Status))AND B.totalFare>0        
   ) P        
   WHERE (TicketNumber=@TicketNo OR @TicketNo='')        
   ORDER BY p.[BookingDate] DESC        
        
   SELECT  @RecordCount = @@ROWCOUNT        
   --select @RecordCount         
        
    SELECT * FROM #tempTableA  ORDER BY  [BookingDate] DESC        
   OFFSET @Start ROWS        
   FETCH NEXT @Pagesize ROWS ONLY        
        
   END        
   ELSE        
   BEGIN        
   IF OBJECT_ID ( 'tempdb..#tempTableB') IS NOT NULL        
    DROP table  #tempTableB        
           
   SELECT * INTO #tempTableB FROM (        
    SELECT DISTINCT        
    b.pkid        
    , P.pid        
    --, CONVERT(VARCHAR, B.inserteddate, 106) AS 'BookingDate' 
	,FORMAT(B.inserteddate, 'dd-MMM-yyyy HH:mm:ss') AS [BookingDate]
    , B.riyaPNR AS 'RiyaPnr'        
    --,P.ticketNum AS 'TicketNumber'        
    , (CASE WHEN CHARINDEX('/',ticketNum)>0 THEN SUBSTRING(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum)+1,        
      LEN(ticketNum)),0,CHARINDEX('/',(SUBSTRING(ticketNum, CHARINDEX('-', ticketNum) + 1,        
      LEN(ticketNum))),0)) ELSE ticketNum END ) AS 'TicketNumber'        
    , CASE WHEN P.ERPPuststatus=0 THEN 'Failed' WHEN P.ERPPuststatus=1 THEN 'Success'        
         END AS 'ERPPuststatus'        
    , p.ERPResponseID AS 'ERPResponseID'        
    , P.CancERPPuststatus AS 'CancERPPuststatus'        
    , P.CancERPResponseID AS 'CancERPResponseID'         
    FROM tblBookMaster B WITH(NOLOCK)        
    INNER JOIN tblPassengerBookDetails P WITH(NOLOCK) ON B.pkId = P.fkBookMaster        
  LEFT JOIN agentLogin A WITH(NOLOCK) ON cast(A.UserID as varchar)=b.AgentID       
    -- LEFT JOIN  NewERPData_Log ED on B.pkid=ED.FK_tblbookmasterID         
    --WHERE cast(B.inserteddate AS DATE) BETWEEN @FromDate AND @ToDate        
    WHERE ((@FROMDate = '') OR (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))        
     AND ((@ToDate = '') OR (CONVERT(date,B.inserteddate) <= CONVERT(date, @ToDate)))        
    AND (B.riyaPNR = @RiyaPnr  OR @RiyaPnr ='')      
   AND (A.UserTypeid=@usertype or @usertype='')      
  and (B.Country= @Country or @Country = '')      
    AND  IsBooked=1 AND B.totalFare>0        
    AND ((@Status = '') OR (cast(b.BookingStatus AS varchar(50))=@Status))        
   ) R        
   WHERE (TicketNumber=@TicketNo OR @TicketNo='')        
   ORDER BY R.[BookingDate] DESC        
        
   SELECT * FROM #tempTableB        
   ORDER BY  [BookingDate] DESC        
  END        
 END        
 --if(@Flag='ErrorResponse')        
 -- BEGIN        
 -- select top 1 Response from NewERPData_Log where FK_tblbookmasterID=@Id order by createdon desc         
 -- END        
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Erp_Report] TO [rt_read]
    AS [dbo];

