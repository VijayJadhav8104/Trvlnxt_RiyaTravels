          
            
-- exec [Sp_GetAgentAccountStatementProductWise_test2] '2024-08-01','2024-09-13','','2','2','','IN','Rail','' ,''                             
CREATE PROCEDURE [dbo].[Sp_GetAgentAccountStatementProductWise_test2]                              
 @FROMDate Date=NULL                               
 , @ToDate Date=NULL                              
 , @BranchCode varchar(40) = ''                              
 , @PaymentType varchar(50) = ''                              
 , @AgentTypeId Varchar(50) = ''                              
 , @AgentId int = ''                              
 , @Country varchar(50)=''                              
 , @ProductType varchar(20)                              
 , @RiyaPNR varchar(20)=''                              
 , @MainAgentId Int=NULL                              
AS                              
BEGIN                              
 Declare @TillDate DateTime                              
 IF(@MainAgentId = 0 AND @AgentID <= 0)                              
 BEGIN                                
  Return;                              
 END                              
                              
 SELECT @TillDate = TillDate FROM tblBlockTransaction WITH(NOLOCK) WHERE AgentId = @AgentID                              
                              
 IF(@TillDate IS NOT NULL AND (@TillDate >= @FROMDate AND @TillDate >= @ToDate))                              
 BEGIN                              
  Return;                              
 END                              
                               
 IF(@TillDate IS NOT NULL AND (@TillDate >= @FROMDate))                              
 BEGIN                              
  SET @FROMDate = DATEADD(DAY, 1, @TillDate)                              
 END           
     
 IF OBJECT_ID ( 'tempdb..#tempTableAASActivity') IS NOT NULL                                        
  DROP table #tempTableAASActivity       
      
 IF OBJECT_ID ( 'tempdb..#tempTableAASRail') IS NOT NULL                                        
  DROP table #tempTableAASRail          
                              
 IF OBJECT_ID ( 'tempdb..#tempTableAASAir') IS NOT NULL                              
  DROP table #tempTableAASAir                               
                              
 IF (@PaymentType = 'Wallet')                              
 BEGIN                              
  SET @PaymentType='Credit'                              
 END                              
                              
 DECLARE @PaymentTypeHotel Varchar(50)                              
 SELECT @PaymentTypeHotel = CASE WHEN (@PaymentType = '223' OR @PaymentType = '224') THEN '1'                              
   WHEN (@PaymentType = '204' OR @PaymentType = '209') THEN '2'                              
   WHEN (@PaymentType = '206' OR @PaymentType = '210') THEN '3'                              
   WHEN @PaymentType = '40' THEN '40'                              
   END                              
                              
 SELECT * INTO #tempTableAASAir FROM (                              
  --Payment Gateway Start                              
  SELECT                              
  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                              
  , ISNULL(R.Icast,R1.Icast) AS AgencyID                              
  , ISNULL(R.AgencyName,R1.AgencyName) AS AgencyName                              
  , CASE                              
    WHEN B.BookingStatus = 6 AND  coun.CountryCode = 'AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13,CONVERT(varchar(20),b.BookingTrackModifiedOn,120)))               
 WHEN B.BookingStatus = 6 AND  coun.CountryCode = 'US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(20),b.BookingTrackModifiedOn,120))) -- 9 hour, 29 minutes AND 16 seconds                              
    WHEN B.BookingStatus = 6 AND  coun.CountryCode = 'CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(20),b.BookingTrackModifiedOn,120))) -- 9 hour, 29 minutes AND 16 seconds                              
    WHEN B.BookingStatus = 6 AND  coun.CountryCode = 'IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),b.BookingTrackModifiedOn,120))   -- 0 hour, 0 minutes AND 0 seconds                                 
    WHEN B.BookingStatus != 6 AND  coun.CountryCode = 'AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13,CONVERT(varchar(20),ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)),120))) -- 1 hour, 29 minutes AND 13 seconds                    
   
    
      
        
         
    WHEN B.BookingStatus != 6 AND  coun.CountryCode = 'US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(20),ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes AND 16 seconds                    
  
    
      
        
          
    WHEN B.BookingStatus != 6 AND  coun.CountryCode = 'CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(20),ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)),120))) -- 9 hour, 29 minutes AND 16 seconds                    
  
    
      
        
          
WHEN B.BookingStatus != 6 AND  coun.CountryCode = 'IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)),120))   -- 0 hour, 0 minutes AND 0 seconds                         
    END 'DateTime'                              
  , B.airName + '(' + B.frmSector + '-' + B.toSector + ')' AS Description                              
  , B.riyaPNR as 'Booking id'                              
  , B.GDSPNR AS CRSPNR                              
  , (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS airlinePNR                              
  , 0 AS CreditAmount                              
  , 0 AS DebitAmount                              
  , 0 as Remaining                              
  , 'Airline Sales' as TransactionType                              
  , (SELECT top 1 his.Remark FROM AgentHistory his WITH(NOLOCK) WHERE CAST(his.UserId AS VARCHAR(50)) = b.AgentID order by his.InsertDate desc) as Remark                              
  , '' AS RefNo                              
  , BR.Name AS 'Branch Name'                              
  , C.Value AS AgentType                              
  , al.BookingCountry as Country                              
  , coun.Currency AS 'Currency'                              
  , (SELECT top 1 ISNULL(AgencyName,'') FROM B2BRegistration WITH(NOLOCK) where CAST(FKUserID AS VARCHAR(50))= B.AgentID) AS 'Booked By' --B.BookedBy                              
  , (SELECT top 1 (pb.paxFName +' '+pb.paxLName) FROM tblPassengerBookDetails pb WITH(NOLOCK) WHERE pb.fkBookMaster=b.pkId) AS  'Passenger name'                              
  , CAST(b.depDate AS Varchar(50)) AS 'Travel date'                              
  , R.CustomerType as AccountType                              
  FROM tblBookMaster B WITH(NOLOCK)                              
  INNER JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId                              
  LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                               
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50)) = B.AgentID                              
  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID=AL.UserTypeID                              
  LEFT JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId                              
  INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country                               
  WHERE ((@FROMDate = '') OR (CONVERT(date,ISNULL(b.inserteddate_old,b.inserteddate)) >= CONVERT(date,@FROMDate)))             
   AND ((@ToDate = '') OR (CONVERT(date,ISNULL(b.inserteddate_old,b.inserteddate)) <= CONVERT(date, @ToDate)))                              
   AND (((@BranchCode = '') OR ( R.LocationCode = @BranchCode)) OR ((@BranchCode != '' AND @BranchCode = 'BOMRC')))                              
  AND ((@AgentId = '') OR (b.AgentID = CAST(@AgentId AS VARCHAR(50))))                              
  AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                                
   AND p.payment_modE NOT IN ('Credit','PassThrough','Hold','Check')                              
  AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR))                              
   AND (IsBooked=1 OR BookingStatus=1)                              
                              
  UNION                              
                              
  SELECT                               
  '0' AS BookMasterID                              
  , Icast as AgencyID                              
  , AgencyName                              
  , case when coun.CountryCode='AE' then (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ab.createdon,120))) -- 1 hour, 29 minutes and 13 seconds                                    
  when coun.CountryCode='US' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120))) -- 9 hour, 29 minutes and 16 seconds                                    
  when coun.CountryCode='CA' then (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120))) -- 9 hour, 29 minutes and 16 seconds                                    
  when coun.CountryCode='IN' then DATEADD(SECOND, 0,CONVERT(varchar(20),ab.createdon,120))   -- 0 hour, 0 minutes and 0 seconds                                     
  end AS 'DateTime'                              
  , (CASE WHEN AB.TransactionType='Debit' THEN 'Balance Debited :' else 'Balance Credited :' end) +                               
    CAST(M.UserName + '-' + M.FullName as varchar(50)) AS Description                              
  , '' as 'Booking id'                              
  , '' AS CRSPNR                              
  , '' as airlinePNR                              
  , (CASE WHEN AB.TransactionType='Credit' then ab.TranscationAmount else 0 END) AS CreditAmount                              
  , (CASE WHEN AB.TransactionType='Debit' then ab.TranscationAmount else 0 END) AS DebitAmount                              
  , AB.CloseBalance as Remaining                              
  , 'Payment Gateway' as TransactionType                              
  , AB.Remark                              
  , '' AS RefNo                              
  , BR.Name as 'Branch Name'                              
  , C.Value as AgentType                              
  , al.BookingCountry as Country                              
  , coun.Currency as 'Currency'                              
  , ISNULL(AL.UserName,'') AS 'Booked By'                              
  , '' AS 'Passenger name'                              
  , NULL as 'Travel date'                              
  , R.CustomerType as AccountType                              
  FROM tblAgentBalance AB WITH(NOLOCK)                      
  INNER JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=AB.AgentNo                              
  INNER JOIN agentLogin AL WITH(NOLOCK) ON AL.UserID=R.FKUserID                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                              
  INNER JOIN mCommon C WITH(NOLOCK) on C.ID=AL.UserTypeID                              
  INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=al.BookingCountry                              
  LEFT JOIN mUser M WITH(NOLOCK) ON M.ID=AB.CreatedBy                              
  WHERE ((@FROMDate = '') or (CONVERT(date,AB.CreatedOn) >= CONVERT(date,@FROMDate)))                              
   AND ((@ToDate = '') or (CONVERT(date,AB.CreatedOn) <= CONVERT(date, @ToDate)))                 
   AND ((@BranchCode = '') or ( R.LocationCode = @BranchCode))                              
  AND ((@AgentTypeId = '') or ( AL.UserTypeID IN (SELECT cast(Data as int) FROM sample_split(@AgentTypeId, ','))))                              
   AND ((@AgentId='') or ( AB.AgentNo = cast(@AgentId as varchar(50))))                              
  AND ((@Country = '') or (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                              
  AND AB.PaymentMode='PaymentGateway'                              
  AND (@RiyaPNR = '')                              
                              
  UNION                              
                                
  --Payment Gateway END                              
                              
  SELECT --B.pkId AS BookMasterID                              
  (SELECT STUFF((SELECT '/' + CONVERT(Varchar(50), tblBookMaster.pkId)          
     FROM tblBookMaster WITH(NOLOCK)                              
     WHERE tblBookMaster.riyaPNR = @RiyaPNR                               
     FOR XML PATH ('')) , 1, 1, '')) AS BookMasterID                              
  , ISNULL(r.Icast,r1.Icast) AS AgencyID                              
  , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName                              
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120)))               
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120)))                               
   
   
      
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120)))                                  
  
   
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))                                 
                
                  
                   
END AS 'DateTime'                              
  , (SELECT STUFF((SELECT '/' + tblBookMaster.airName + '(' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector + ')'                              
    FROM tblBookMaster WITH(NOLOCK)                              
    WHERE tblBookMaster.riyaPNR = @RiyaPNR                               
    FOR XML PATH ('')) , 1, 1, '')) AS 'Description'                              
  , B.riyaPNR AS 'Booking id'                              
  , B.GDSPNR AS CRSPNR                              
  , STUFF((SELECT '/' + BI.airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.orderId = B.orderId                              
    GROUP BY BI.airlinePNR FOR XML PATH('')),1,1,'') AS airlinePNR                              
  , ab.TranscationAmount AS CreditAmount                              
  , 0 AS DebitAmount                              
  , (ab.CloseBalance)AS Remaining                              
  , 'Cancellation' AS TransactionType                              
  , ((CASE WHEN b.BookingStatus=1 THEN 'Ticketed' WHEN B.BookingStatus=2 THEN 'Hold' WHEN B.BookingStatus=3 THEN 'Pending'                              
    WHEN B.BookingStatus=4 THEN 'Cancelled' WHEN B.BookingStatus=0 THEN 'Failed' WHEN B.BookingStatus=5 THEN 'Close'                              
    WHEN B.BookingStatus=6 THEN 'Manual Booking' END)) AS Remark                              
  , '' AS RefNo                              
  , BR.Name AS 'Branch Name'                              
  , C.Value AS AgentType                              
  , al.BookingCountry AS Country                              
  , coun.Currency AS 'Currency'                              
  , (ISNULL(AL.UserName,''))  AS 'Booked By'                              
  , (SELECT TOP 1 (pb.paxFName +' '+ pb.paxLName) FROM tblPassengerBookDetails pb WITH(NOLOCK)                               
    WHERE pb.fkBookMaster=b.pkId) AS 'Passenger name'                               
  , STUFF((SELECT '/' + cast(s.depDate AS varchar(50)) FROM tblBookMaster s WITH(NOLOCK)               
    WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Travel date'                              
  , R.CustomerType AS AccountType                              
  FROM tblBookMaster B WITH(NOLOCK)                              
  INNER JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId                              
  INNER JOIN agentLogin AL WITH(NOLOCK) ON cast(AL.UserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                               
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN mBranch BR1 WITH(NOLOCK) ON BR1.CODE=R1.LocationCode                               
  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID=AL.UserTypeID                              
  INNER JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId                              
  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode=b.Country                              
        LEFT JOIN tblAgentBalance ab WITH(NOLOCK) ON ab.BookingRef=b.orderId AND ab.TransactionType='Credit'                              
  LEFT JOIN tblPassengerBookDetails pb WITH(NOLOCK) ON pb.fkBookMaster=b.pkId                               
  WHERE ISNULL(B.IsMultiTST, 0) = 1 AND ((@FROMDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) >= CONVERT(date,@FROMDate)))                              
   AND ((@ToDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) <= CONVERT(DATE, @ToDate)))                              
   AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))                              
  AND ((@AgentTypeId = '') OR ( AL.UserTypeID IN (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))                              
   AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50))                              
  OR (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID = CAST(@AgentId AS varchar(50) ))))                               
  OR (b.AgentID =CAST(@AgentId AS varchar(50))))                              
   AND ((@PaymentType='') OR (@PaymentType='all') OR ( PM.payment_mode = @PaymentType ))                              
  AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                              
  AND (b.BookingStatus =4 OR b.BookingStatus=11 OR pb.BookingStatus=4 OR pb.BookingStatus=6) and (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) and (pm.payment_mode='Check' OR pm.payment_mode='Credit') and (IsBooked=1 OR b.BookingStatus=1)         
 
     
      
        
          
            
             
                
                   
                    
                     
  AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) and b.returnFlag=0                              
                              
  UNION                              
                                      
  SELECT                               
  (SELECT STUFF((SELECT '/' + CONVERT(Varchar(50), tblBookMaster.pkId) FROM tblBookMaster WITH(NOLOCK)                              
   WHERE tblBookMaster.riyaPNR = @RiyaPNR FOR XML PATH ('')) , 1, 1, '')) AS BookMasterID                              
  , ISNULL(r.Icast,r1.Icast) AS AgencyID                              
  , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName                              
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)) END)),120))
  
    
      
        
          
            
              
)                                    
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND,- 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)) END)),120)))      
  
    
      
        
          
            
             
                                   
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)) END)),120)))       
  
    
      
        
                                  
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)) END)),120))                
                    
                        
                         
END AS 'DateTime'                              
  , (SELECT STUFF((SELECT '/' + tblBookMaster.airName + '(' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector + ')'                               
    FROM tblBookMaster WITH(NOLOCK) WHERE tblBookMaster.riyaPNR = @RiyaPNR FOR XML PATH ('')) , 1, 1, '')) AS 'Description'                              
  , B.riyaPNR AS 'Booking id'                              
  , B.GDSPNR AS CRSPNR                              
  , STUFF((SELECT '/' + BI.airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.orderId = B.orderId                               
    GROUP BY BI.airlinePNR FOR XML PATH('')),1,1,'') AS airlinePNR                              
  , 0 AS CreditAmount                              
  , CASE WHEN p.ParentOrderId IS NULL THEN CAST(ab.TranscationAmount AS decimal(18,2))                               
    ELSE CAST(p.mer_amount AS decimal(18,2)) END AS DebitAmount                              
  , (ab.CloseBalance)AS Remaining,'Airline Sales' AS TransactionType                    
  , ((CASE WHEN b.BookingStatus=1 THEN 'Ticketed' WHEN B.BookingStatus=2 THEN 'Hold' WHEN B.BookingStatus=3 THEN 'Pending'                              
    WHEN B.BookingStatus=4 THEN 'Ticketed' WHEN B.BookingStatus=0 THEN 'Failed' WHEN B.BookingStatus=5 THEN 'Close'                              
    WHEN B.BookingStatus=6 THEN 'Manual Booking' END))  as Remark                              
  , '' AS RefNo                              
  , BR.Name AS 'Branch Name'                              
  , C.Value AS AgentType                              
  , al.BookingCountry AS Country                              
  , coun.Currency AS 'Currency'                              
  , (ISNULL(AL.UserName,'')) AS 'Booked By'                              
  , (SELECT TOP 1 (pb.paxFName +' '+pb.paxLName) FROM tblPassengerBookDetails pb WITH(NOLOCK)                              
    WHERE pb.fkBookMaster=b.pkId) AS  'Passenger name'                               
  , STUFF((SELECT '/' + cast(s.depDate AS varchar(50)) FROM tblBookMaster s WITH(NOLOCK)                               
    WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Travel date'                              
  , R.CustomerType AS AccountType                              
  FROM tblBookMaster B WITH(NOLOCK)                              
INNER JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId -- OR P.ParentOrderId=B.orderId                              
  INNER JOIN agentLogin AL WITH(NOLOCK) ON cast(AL.UserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                               
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN mBranch BR1 WITH(NOLOCK) ON BR1.CODE=R1.LocationCode                               
  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID=AL.UserTypeID                              
  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode=b.Country                              
        LEFT JOIN tblAgentBalance ab WITH(NOLOCK) ON ab.BookingRef=b.orderId AND ab.TransactionType='Debit'                              
   WHERE ISNULL(B.IsMultiTST, 0) = 1 AND ((@FROMDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) >= CONVERT(date,@FROMDate)))                              
   AND ((@ToDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) <= CONVERT(date, @ToDate)))                              
   AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))                              
  AND ((@AgentTypeId = '') OR ( AL.UserTypeID IN (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))                              
   AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50))                              
  OR (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) )))))                              
   AND ((@PaymentType='') OR (@PaymentType='all') OR ( P.payment_mode = @PaymentType ))                              
  AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                              
   AND BookingStatus !=2 AND BookingStatus !=5 AND BookingStatus !=0 AND (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) AND (P.payment_mode='Check' OR P.payment_mode='Credit')                              
  AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) AND b.returnFlag=0 AND (IsBooked=1 OR BookingStatus=1) AND b.totalFare>0                              
                              
  UNION                              
                              
  --added by bhavika pass through record                              
  SELECT                               
  (SELECT STUFF((SELECT '/' + CONVERT(Varchar(50), tblBookMaster.pkId) FROM tblBookMaster WITH(NOLOCK)                              
    WHERE tblBookMaster.riyaPNR = @RiyaPNR FOR XML PATH ('')) , 1, 1, '')) AS BookMasterID                              
  , ISNULL(r.Icast,r1.Icast) AS AgencyID                              
  , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName                              
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate) END)),120)))                   
  
    
      
       
          
             
              
WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate)END)),120)))                            
  
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate) END)),120)))                           
  
    
      
        
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate                            
) END)),120))                                     
END AS 'DateTime'                              
  , (SELECT STUFF((SELECT '/' + tblBookMaster.airName + '(' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector + ')' FROM tblBookMaster WITH(NOLOCK)                              
    WHERE tblBookMaster.riyaPNR = @RiyaPNR FOR XML PATH ('')) , 1, 1, '')) AS 'Description'                              
  , B.riyaPNR AS 'Booking id'                              
  , B.GDSPNR AS CRSPNR                              
  , STUFF((SELECT '/' + BI.airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.orderId = B.orderId                               
    GROUP BY BI.airlinePNR FOR XML PATH('')),1,1,'') AS airlinePNR                              
  , 0 AS CreditAmount                              
  , ab.TranscationAmount AS DebitAmount                              
  , (ab.CloseBalance)AS Remaining,'Mark up' AS TransactionType                              
  , ((CASE WHEN b.BookingStatus=1 THEN 'Ticketed' WHEN B.BookingStatus=2 THEN 'Hold' WHEN B.BookingStatus=3 THEN 'Pending'                              
    WHEN B.BookingStatus=4 THEN 'Ticketed' WHEN B.BookingStatus=0 THEN 'Failed' WHEN B.BookingStatus=5 THEN 'Close'                              
    WHEN B.BookingStatus=6 THEN 'Manual Booking' END))  as Remark                              
  , '' AS RefNo                              
  , BR.Name AS 'Branch Name'                              
  , C.Value AS AgentType                              
, al.BookingCountry AS Country                              
  , coun.Currency AS 'Currency'                              
  , (ISNULL(AL.UserName,'')) AS 'Booked By'                              
  , (SELECT TOP 1 (pb.paxFName +' '+pb.paxLName) FROM tblPassengerBookDetails pb WITH(NOLOCK)                              
    WHERE pb.fkBookMaster=b.pkId) AS  'Passenger name'                              
  , STUFF((SELECT '/' + cast(s.depDate AS varchar(50)) FROM tblBookMaster s WITH(NOLOCK) WHERE s.orderId = b.orderId                               
    FOR XML PATH('')),1,1,'') AS 'Travel date',R.CustomerType AS AccountType                              
  FROM tblBookMaster B WITH(NOLOCK)                              
  INNER JOIN agentLogin AL WITH(NOLOCK) ON cast(AL.UserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                               
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN mBranch BR1 WITH(NOLOCK) ON BR1.CODE=R1.LocationCode                               
  INNER JOIN mCommon C WITH(NOLOCK) on C.ID=AL.UserTypeID                              
  INNER JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId                              
INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country                              
        INNER JOIN tblAgentBalance ab WITH(NOLOCK) on ab.BookingRef=b.orderId and ab.TransactionType='Debit'                              
  WHERE ISNULL(B.IsMultiTST, 0) = 1 AND ((@FROMDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) >= CONVERT(date,@FROMDate)))                              
   AND ((@ToDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) <= CONVERT(date, @ToDate)))                              
   AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))                              
  AND ((@AgentTypeId = '') OR ( AL.UserTypeID IN (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))                              
  AND ((@AgentId = '') OR (b.AgentID =cast(@AgentId AS varchar(50))                              
  Or (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =cast(@AgentId AS varchar(50) )))))                              
   AND ((@PaymentType='') OR (@PaymentType='all') OR ( PM.payment_mode = @PaymentType ))                              
  AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                              
   AND BookingStatus !=2 and BookingStatus !=5 AND BookingStatus !=0 and (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) and (pm.payment_mode='passThrough')                              
  AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) and b.returnFlag=0 and (IsBooked=1 OR BookingStatus=1)                              
                              
  UNION                              
                               
  SELECT                               
  '0/0' AS BookMasterID                              
  , Icast AS AgencyID                              
  , AgencyName                              
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ab.createdon,120))) -- 1 hour, 29 minutes and 13 seconds                                  
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120))) -- 9 hour, 29 minutes and 16 seconds                                  
  WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120))) -- 9 hour, 29 minutes and 16 seconds                                  
  WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ab.createdon,120))   -- 0 hour, 0 minutes and 0 seconds                                   
  END AS 'DateTime'                              
  , (CASE WHEN AB.TransactionType='Debit' THEN 'Balance Debited :' else 'Balance Credited :' END) +                               
    cast(M.UserName + '-' + M.FullName AS varchar(50)) AS Description                              
  , '' AS 'Booking id'                              
  , '' AS CRSPNR                              
  , '' AS airlinePNR                              
  , (CASE WHEN AB.TransactionType='Credit' THEN ab.TranscationAmount else 0 END ) AS CreditAmount                              
  , (CASE WHEN AB.TransactionType='Debit' THEN ab.TranscationAmount else 0 END ) AS DebitAmount                              
  , AB.CloseBalance AS Remaining                              
  , 'Agent Balance Updation' AS TransactionType                              
  , AB.Remark                              
  , 'REF'  + CONVERT(VARCHAR(50), AB.createdon,112) + cast(AB.PKID AS varchar(50)) AS RefNo                              
  , BR.Name AS 'Branch Name'                              
  , C.Value AS AgentType                              
  , al.BookingCountry AS Country                              
  , coun.Currency AS 'Currency'                              
  , ( ISNULL(AL.UserName,'')) AS 'Booked By'                              
  , '' AS  'Passenger name'                              
  , NULL AS 'Travel date'                              
  , R.CustomerType AS AccountType                              
  FROM tblAgentBalance AB WITH(NOLOCK)                              
  INNER JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=AB.AgentNo                              
 INNER JOIN agentLogin AL WITH(NOLOCK) ON AL.UserID=R.FKUserID                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                              
  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID=AL.UserTypeID                              
  INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=al.BookingCountry                              
  LEFT JOIN mUser M WITH(NOLOCK) ON M.ID=AB.CreatedBy                              
  WHERE ((@FROMDate = '') OR (CONVERT(date,AB.CreatedOn) >= CONVERT(date,@FROMDate)))                              
   AND ((@ToDate = '') OR (CONVERT(date,AB.CreatedOn) <= CONVERT(date, @ToDate)))                              
   AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))                              
  AND ((@AgentTypeId = '') OR ( AL.UserTypeID IN (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))                              
   AND ((@AgentId='') OR ( AB.AgentNo = cast(@AgentId AS varchar(50))))                              
  AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                             
   and  AB.TransactionType IN                              
  (CASE @PaymentType WHEN 'Credit' THEN AB.TransactionType WHEN '' THEN AB.TransactionType else @PaymentType END)                              
     AND( BookingRef='Cash' OR BookingRef='Credit')                              
  AND ((@RiyaPNR = ''))                              
                              
  UNION                              
                              
  SELECT                               
  CONVERT(Varchar(50),B.pkId) AS BookMasterID          
  , ISNULL(r.Icast,r1.Icast) AS AgencyID                              
  , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName                              
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120)))                          
 
    
       
       
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120)))                                
 
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120)))                                
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))                                  
END AS 'DateTime'                              
  , STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WITH(NOLOCK)                              
    WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description'                              
  , B.riyaPNR AS 'Booking id'                              
  , B.GDSPNR AS CRSPNR                              
  , STUFF((SELECT '/' + BI.airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.orderId = B.orderId                               
    GROUP BY BI.airlinePNR FOR XML PATH('')),1,1,'') AS airlinePNR                              
  , ab.TranscationAmount AS CreditAmount                              
  , 0 AS DebitAmount                              
  , (ab.CloseBalance) AS Remaining                              
  , 'Cancellation' AS TransactionType                    
  , ((CASE b.BookingStatus                              
    WHEN 1 THEN 'Ticketed'                              
    WHEN 2 THEN 'Hold'                               
    WHEN 3 THEN 'Pending'                              
     WHEN 4 THEN 'Cancelled'                               
    WHEN 0 THEN 'Failed'                               
    WHEN 5 THEN 'Close'                              
     WHEN 6 THEN 'Manual Booking' END))  as Remark                              
  , '' AS RefNo                              
  , BR.Name AS 'Branch Name'                              
  , C.Value AS AgentType                              
  , al.BookingCountry AS Country                              
  , coun.Currency AS 'Currency'                              
  , (SELECT TOP 1 ISNULL(AgencyName,'') FROM B2BRegistration WITH(NOLOCK) WHERE FKUserID = B.AgentID) AS 'Booked By' --B.BookedBy                              
  , (SELECT TOP 1 (pb.paxFName +' '+pb.paxLName) FROM tblPassengerBookDetails pb WITH(NOLOCK)                              
    WHERE pb.fkBookMaster=b.pkId) AS  'Passenger name'               
  , STUFF((SELECT '/' + CAST(s.depDate AS varchar(50))FROM tblBookMaster s WITH(NOLOCK)                              
    WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Travel date'                              
  , R.CustomerType AS AccountType                              
  FROM tblBookMaster B WITH(NOLOCK)                              
  INNER JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId                              
  INNER JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                               
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN mBranch BR1 WITH(NOLOCK) ON BR1.CODE=R1.LocationCode                               
  INNER JOIN mCommon C WITH(NOLOCK) on C.ID=AL.UserTypeID                              
  INNER JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId                              
  INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country                              
        LEFT JOIN tblAgentBalance ab WITH(NOLOCK) on ab.BookingRef=b.orderId AND ab.TransactionType='Credit'                              
  LEFT JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId                               
   WHERE ISNULL(b.IsMultiTST,0) != 1                               
  AND ((@FROMDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn, b.inserteddate)) >= CONVERT(date,@FROMDate)))                              
   AND ((@ToDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) <= CONVERT(date, @ToDate)))                              
   AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))                              
  AND ((@AgentTypeId = '') OR ( AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))))                 
   AND ((@AgentId = '')                               
   OR (b.AgentID =CAST(@AgentId AS varchar(50))                               
   OR (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) ))))                               
   OR (b.AgentID =CAST(@AgentId AS varchar(50))))                              
   AND ((@PaymentType='') OR (@PaymentType='all') OR ( PM.payment_mode = @PaymentType ))                              
  AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                              
  AND (b.BookingStatus =4 OR b.BookingStatus=11 OR pb.BookingStatus=4 OR pb.BookingStatus=6) AND (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) AND (pm.payment_mode='Check' OR pm.payment_mode='Credit') AND (IsBooked=1 OR b.BookingStatus=1)        
   
   
      
        
          
            
               
                
                 
                     
                     
  AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) AND b.returnFlag=0                              
                              
  UNION                              
                              
  SELECT                               
  CONVERT(Varchar(50),B.pkId) AS BookMasterID                              
  , ISNULL(r.Icast,r1.Icast) AS AgencyID                              
  , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName                              
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)) END)),120))
  
    
      
        
          
            
              
)                                     
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)) END)),120)))     
  
    
      
        
          
            
                               
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)) END)),120)))       
  
    
      
        
          
            
                          
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.IssueDate,ISNULL(b.inserteddate_old,b.inserteddate)) END)),120))                            
  
    
      
        
         
END AS 'DateTime'                              
  , STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WITH(NOLOCK)                              
    WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description'                              
  , B.riyaPNR AS 'Booking id'                              
  , B.GDSPNR AS CRSPNR                              
  , STUFF((SELECT '/' + BI.airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.orderId = B.orderId                               
    GROUP BY BI.airlinePNR FOR XML PATH('')),1,1,'') AS airlinePNR                              
  , 0 AS CreditAmount                              
  , CASE WHEN p.ParentOrderId IS NULL THEN CAST(ab.TranscationAmount AS decimal(18,2))                              
    ELSE CAST(p.mer_amount AS decimal(18,2)) END AS DebitAmount                              
  , (ab.CloseBalance) AS Remaining                              
  , 'Airline Sales' AS TransactionType                              
  , ((CASE b.BookingStatus                              
     WHEN 1 THEN 'Ticketed'                               
     WHEN 2 THEN 'Hold'                               
     WHEN 3 THEN 'Pending'                              
     WHEN 4 THEN 'Ticketed'                              
     WHEN 0 THEN 'Failed'                               
     WHEN 5 THEN 'Close'                              
     WHEN 6 THEN 'Manual Booking' END))  as Remark                              
  , '' AS RefNo                              
  , BR.Name AS 'Branch Name'                              
  , C.Value AS AgentType                              
  , al.BookingCountry AS Country                              
  , coun.Currency AS 'Currency'                              
  , (SELECT TOP 1 ISNULL(AgencyName,'') FROM B2BRegistration WITH(NOLOCK) WHERE FKUserID = B.AgentID) AS 'Booked By' --B.BookedBy                              
  , (SELECT TOP 1 (pb.paxFName +' '+pb.paxLName) FROM tblPassengerBookDetails pb WITH(NOLOCK)                              
    WHERE pb.fkBookMaster=b.pkId) AS  'Passenger name'                               
  , STUFF((SELECT '/' + CAST(s.depDate AS varchar(50))FROM tblBookMaster s WITH(NOLOCK)                              
    WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Travel date'                              
  , R.CustomerType AS AccountType                              
  FROM tblBookMaster B WITH(NOLOCK)                              
  INNER JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId --OR P.ParentOrderId=B.orderId                              
  INNER JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                               
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN mBranch BR1 WITH(NOLOCK) ON BR1.CODE=R1.LocationCode                               
  INNER JOIN mCommon C WITH(NOLOCK) on C.ID=AL.UserTypeID                              
  INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country                              
        LEFT JOIN tblAgentBalance ab WITH(NOLOCK) on ab.BookingRef=b.orderId AND ab.TransactionType='Debit'                              
   WHERE ISNULL(b.IsMultiTST,0) != 1                               
  AND ((@FROMDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) >= CONVERT(date,@FROMDate)))                              
   AND ((@ToDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) <= CONVERT(date, @ToDate)))                              
   AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))                              
  AND ((@AgentTypeId = '') OR ( AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))))                              
   AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50))          
   Or (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) )))))                              
   AND ((@PaymentType='') OR (@PaymentType='all') OR ( P.payment_mode = @PaymentType ))                              
  AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                              
   AND BookingStatus !=2 AND BookingStatus !=5 AND BookingStatus !=0 AND (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) AND (P.payment_mode='Check' OR P.payment_mode='Credit')                              
  AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) AND b.returnFlag=0 AND (IsBooked=1 OR BookingStatus=1) AND b.totalFare>0                              
                              
  UNION                              
                              
  --added by bhavika pass through record                              
  SELECT                               
  CONVERT(Varchar(50),B.pkId) AS BookMasterID                              
  , ISNULL(r.Icast,r1.Icast) AS AgencyId                              
  , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName                              
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120)))               
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate)END)),120)))                          
 
     
      
       
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120)))                           
  
    
     
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120))                            
                
                  
                    
                      
                        
END AS 'DateTime'                              
  , STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WITH(NOLOCK)                               
    WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description'                              
  , B.riyaPNR AS 'Booking id'                              
  , B.GDSPNR AS CRSPNR                              
  --, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  airlinePNR                    
  , STUFF((SELECT '/' + BI.airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.orderId = B.orderId                               
    GROUP BY BI.airlinePNR FOR XML PATH('')),1,1,'') AS airlinePNR                              
  , 0 AS CreditAmount                     
  , ab.TranscationAmount AS DebitAmount                              
  , (ab.CloseBalance)AS Remaining                              
  , 'Mark up' AS TransactionType                              
  , ((CASE                               
   WHEN b.BookingStatus=1 THEN 'Ticketed'                              
   WHEN B.BookingStatus=2 THEN 'Hold'                              
   WHEN B.BookingStatus=3 THEN 'Pending'                              
   WHEN B.BookingStatus=4 THEN 'Ticketed'                              
   WHEN B.BookingStatus=0 THEN 'Failed'                              
   WHEN B.BookingStatus=5 THEN 'Close'                              
   WHEN B.BookingStatus=6 THEN 'Manual Booking'                              
   END))  as Remark                              
  , '' AS RefNo                              
  , BR.Name AS 'Branch Name'                              
  , C.Value AS AgentType                              
  , al.BookingCountry AS Country                              
  , coun.Currency AS 'Currency'                              
  , (SELECT TOP 1 ISNULL(AgencyName,'') FROM B2BRegistration WITH(NOLOCK) WHERE FKUserID = B.AgentID) AS 'Booked By' --B.BookedBy                              
  , (SELECT TOP 1 (pb.paxFName +' '+pb.paxLName) FROM tblPassengerBookDetails pb WITH(NOLOCK)                              
    WHERE pb.fkBookMaster=b.pkId) AS  'Passenger name'                               
  , STUFF((SELECT '/' + CAST(s.depDate AS varchar(50))FROM tblBookMaster s WITH(NOLOCK)                               
    WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Travel date'                              
  , R.CustomerType AS AccountType                              
  FROM tblBookMaster B WITH(NOLOCK)                              
  INNER JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                               
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50))=B.AgentID                              
  LEFT JOIN mBranch BR1 WITH(NOLOCK) ON BR1.CODE=R1.LocationCode                               
  INNER JOIN mCommon C WITH(NOLOCK) on C.ID=AL.UserTypeID                              
  INNER JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId                              
  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode=b.Country                              
  INNER JOIN tblAgentBalance ab WITH(NOLOCK) on ab.BookingRef=b.orderId AND ab.TransactionType='Debit'                              
   WHERE ISNULL(b.IsMultiTST,0) != 1                               
  AND ((@FROMDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) >= CONVERT(date,@FROMDate)))                              
   AND ((@ToDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) <= CONVERT(date, @ToDate)))                              
   AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))                              
  AND ((@AgentTypeId = '') OR ( AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))))                            
   AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50))                              
   Or (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) )))))                              
   AND ((@PaymentType='') OR (@PaymentType='all') OR ( PM.payment_mode = @PaymentType ))                              
  AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                              
   AND BookingStatus !=2 AND BookingStatus !=5 AND BookingStatus !=0 AND (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) AND (pm.payment_mode='passThrough')                              
  AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) AND b.returnFlag=0 AND (IsBooked=1 OR BookingStatus=1)                              
                              
  UNION                              
                               
  SELECT                               
  '0/0' AS BookMasterID                              
  , Icast AS AgencyID                              
  , AgencyName                              
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ab.createdon,120)))                                  
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120)))                                  
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120)))                                 
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ab.createdon,120))                                  
END AS 'DateTime'                              
  , (CASE WHEN AB.TransactionType='Debit' THEN 'Balance Debited :' ELSE 'Balance Credited :' END)                               
    + CAST(M.UserName + '-' + M.FullName AS varchar(50)) AS Description                              
  , '' AS 'Booking id'                              
  , '' AS CRSPNR                              
  , '' AS airlinePNR                              
  , (CASE WHEN AB.TransactionType='Credit' THEN ab.TranscationAmount ELSE 0 END ) AS CreditAmount                              
  , (CASE WHEN AB.TransactionType='Debit' THEN ab.TranscationAmount ELSE 0 END ) AS DebitAmount                              
  , AB.CloseBalance AS Remaining                              
  , 'Agent Balance Updation' AS TransactionType                              
  , AB.Remark                              
  , 'REF'  + CONVERT(VARCHAR(50), AB.createdon,112) + CAST(AB.PKID AS varchar(50)) AS RefNo                              
  , BR.Name AS 'Branch Name'                              
  , C.Value AS AgentType                              
  , al.BookingCountry AS Country                              
  , coun.Currency AS 'Currency'                              
  , ISNULL(AL.UserName,'')  as 'Booked By'                              
  , '' AS  'Passenger name'                              
  , NULL AS 'Travel date'                              
  , R.CustomerType AS AccountType                              
  FROM tblAgentBalance AB WITH(NOLOCK)                              
  INNER JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=AB.AgentNo                              
  INNER JOIN agentLogin AL WITH(NOLOCK) ON AL.UserID=R.FKUserID                              
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode                              
  INNER JOIN mCommon C WITH(NOLOCK) on C.ID=AL.UserTypeID                              
  INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=al.BookingCountry                              
  LEFT JOIN mUser M WITH(NOLOCK) ON M.ID=AB.CreatedBy                              
  WHERE ((@FROMDate = '') OR (CONVERT(date,AB.CreatedOn) >= CONVERT(date,@FROMDate)))                              
   AND ((@ToDate = '') OR (CONVERT(date,AB.CreatedOn) <= CONVERT(date, @ToDate)))                              
   AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))                              
  AND ((@AgentTypeId = '') OR ( AL.UserTypeID IN (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))))                              
   AND ((@AgentId='') OR ( AB.AgentNo = CAST(@AgentId AS varchar(50))))                              
  AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))                              
   AND  AB.TransactionType IN (CASE @PaymentType WHEN 'Credit' THEN AB.TransactionType WHEN '' THEN                             
   AB.TransactionType ELSE @PaymentType END)                              
     AND( BookingRef='Cash' OR BookingRef='Credit')                            
  AND ((@RiyaPNR = ''))                              
 ) Air                               
                              
                              
 SELECT * INTO #tempTableAASHotel FROM(             
             
  SELECT                            
   CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                            
   , BR.Icast as 'AgencyID'                            
   , BR.AgencyName AS 'AgencyName'                              
   ,TAB.CreatedOn  AS 'DateTime'                          
--   ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                          
   , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                            
   , BookingReference AS 'Booking id'                            
   , B.riyaPNR AS 'Riya / CRSPNR'                            
   , '' AS AirlinePNR                        
  -- , CASE WHEN tAB.TransactionType = 'Credit' and TL.BookingStatus='Cancelled' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                         
  , CASE WHEN tAB.TransactionType = 'Credit' and (TL.BookingStatus='Cancelled' or TL.BookingStatus IS NULL) THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                         
                 
   ELSE '0' END AS 'CreditAmount'                            
  , CASE WHEN TAB.TransactionType = 'Debit' and (TL.BookingStatus='Vouchered' or TL.BookingStatus IS NULL) THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))            
   WHEN TAB.TransactionType = 'Debit' and TL.BookingStatus='Confirmed' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                         
   ELSE '0' END AS 'DebitAmount'               
               
  , TAB.CloseBalance AS 'Remaining'                            
   , 'HotelSales' AS 'Service Type'                            
   , B.Post_addCancellationRemarks  as 'Remark'                            
                           
   , '' AS RefNo                            
   , '' AS 'Branch Name'                            
   , c.Value AS 'AgentType'                            
   , AL.bookingcountry AS 'Country'                            
   , coun.Currency AS 'Currency'                            
   , Al.UserName as 'Booked By'                            
   , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                            
   , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                         
   ,'' AS 'AccountType'                        
    ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                          
                          
  ,case when TL.BookingStatus='Confirmed' then 'Vouchered'else ISNULL(TL.BookingStatus,'NA') end AS 'Booking Status'                           
                             
   , B.providerConfirmationNumber AS 'Supplier confirmation'                            
   , P.payment_mode AS 'Mode of Payment'                           
   ,isnull(B.ModeOfCancellation,'') As ModeOfCancellation                           
   --, cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'                            
   , B.CheckInDate  as 'CheckInDate'                          
   , B.CheckOutDate  as 'CheckOutDate'          
   ,'Credit Limit' as Booking_PaymentMode          
   FROM Hotel_BookMaster B WITH(NOLOCK)             
   left join tblAgentBalance TAB WITH(NOLOCK) on B.orderId=TAB.BookingRef             
   LEFT Join hotel.Agentbalance_StatusLog TL on TAB.PKID=TL.FKtransactionID              
   LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                            
   LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id = B.orderId                        
   LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                            
   LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                            
   LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                            
                   
                    
   WHERE                         
   P.amount IS NOT NULL                            
   --AND SH.IsActive = 1                          
  -- and SH.FkStatusId not in (9,3)                        
   AND RiyaAgentID IS NOT NULL                             
   AND B.BookingReference IS NOT NULL                            
   --AND (@PaymentType = '3' AND B2BPaymentMode = 3)             
   AND (P.payment_mode=@PaymentType or @PaymentType='' )            
  -- AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))                     
    AND ((@FROMDate = '' or @ToDate='') or (cast(TAB.CreatedOn as date) between @FROMDate and @ToDate ))                  
   AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                             
   AND (AL.BookingCountry= @Country or @Country='')                             
   AND (B.BranchCode =@BranchCode or @BranchCode='')                       
   AND (B.RiyaAgentID=@AgentId or @AgentId='')            
            
  union         
          
   -- hold Condition --          
   SELECT                          
   CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                          
   , BR.Icast as 'AgencyID'                          
   , BR.AgencyName AS 'AgencyName'                            
   ,B.inserteddate  AS 'DateTime'                        
   , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                          
   , BookingReference AS 'Booking id'                          
   , B.riyaPNR AS 'Riya / CRSPNR'                          
   , '' AS AirlinePNR                      
   , '0' as 'CreditAmount'                          
  , '0' as 'DebitAmount'             
             
  , '0' AS 'Remaining'                          
   , 'HotelSales' AS 'Service Type'                          
   , B.Post_addCancellationRemarks  as 'Remark'                          
                         
   , '' AS RefNo                          
   , '' AS 'Branch Name'                          
   , c.Value AS 'AgentType'                          
   , AL.bookingcountry AS 'Country'                          
   , coun.Currency AS 'Currency'                          
   , Al.UserName as 'Booked By'                          
   , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                          
   , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                       
   ,'' AS 'AccountType'                      
    ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                        
                        
  ,'Confirmed'  AS 'Booking Status'                         
                           
   , B.providerConfirmationNumber AS 'Supplier confirmation'                          
   , P.payment_mode AS 'Mode of Payment'                         
   ,isnull(B.ModeOfCancellation,'') As ModeOfCancellation                         
   , B.CheckInDate  as 'CheckInDate'                        
   , B.CheckOutDate  as 'CheckOutDate'          
   ,'Hold' as Booking_PaymentMode          
   FROM Hotel_BookMaster B WITH(NOLOCK)           
   left join tblAgentBalance TAB WITH(NOLOCK) on B.orderId=TAB.BookingRef           
   LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                          
   LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id = B.orderId                      
   LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                          
   LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                          
   LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                          
                 
                  
   WHERE                       
   P.amount IS NOT NULL                          
                     
   AND RiyaAgentID IS NOT NULL                           
   AND B.BookingReference IS NOT NULL                          
   AND B.B2BPaymentMode=1           
   AND (P.payment_mode=@PaymentType or @PaymentType='' )          
  AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))                   
    --AND ((@FROMDate = '' or @ToDate='') or (cast(TAB.CreatedOn as date) between @FROMDate and @ToDate ))                
   AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                           
   AND (AL.BookingCountry= @Country or @Country='')                           
   AND (B.BranchCode =@BranchCode or @BranchCode='')                     
   AND (B.RiyaAgentID=@AgentId or @AgentId='')          
          
   --- Pay At Hotel --          
          
   UNION          
          
   SELECT                          
   CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                          
   , BR.Icast as 'AgencyID'                          
   , BR.AgencyName AS 'AgencyName'                            
   ,B.inserteddate  AS 'DateTime'                        
   , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                          
   , BookingReference AS 'Booking id'                          
   , B.riyaPNR AS 'Riya / CRSPNR'                          
   , '' AS AirlinePNR                      
   ,'0' as 'CreditAmount'                          
  , '0'   as 'DebitAmount'             
           
  , '0' AS 'Remaining'                          
   , 'HotelSales' AS 'Service Type'                          
   , B.Post_addCancellationRemarks  as 'Remark'                          
                         
   , '' AS RefNo                          
   , '' AS 'Branch Name'                          
   , c.Value AS 'AgentType'                          
   , AL.bookingcountry AS 'Country'                          
   , coun.Currency AS 'Currency'                          
   , Al.UserName as 'Booked By'                          
   , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                          
   , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                       
   ,'' AS 'AccountType'                      
    ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                        
                        
  ,B.CurrentStatus  AS 'Booking Status'                         
                           
   , B.providerConfirmationNumber AS 'Supplier confirmation'                          
   , P.payment_mode AS 'Mode of Payment'                         
   ,isnull(B.ModeOfCancellation,'') As ModeOfCancellation                         
   , B.CheckInDate  as 'CheckInDate'                        
   , B.CheckOutDate  as 'CheckOutDate'           
   ,'Pay At Hotel' as Booking_PaymentMode          
   FROM Hotel_BookMaster B WITH(NOLOCK)          
   left join tblAgentBalance TAB WITH(NOLOCK) on B.orderId=TAB.BookingRef          
   LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                          
   LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id = B.orderId                      
   LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                          
   LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                          
   LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                          
                 
        
   WHERE                       
   P.amount IS NOT NULL                          
                     
   AND RiyaAgentID IS NOT NULL                           
   AND B.BookingReference IS NOT NULL                          
   AND B.B2BPaymentMode=5           
   AND (P.payment_mode=@PaymentType or @PaymentType='' )          
  AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))                   
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                           
   AND (AL.BookingCountry= @Country or @Country='')                           
   AND (B.BranchCode =@BranchCode or @BranchCode='')                     
   AND (B.RiyaAgentID=@AgentId or @AgentId='')          
          
   -- Make Payment ---          
   UNION          
          
   SELECT                          
   CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                          
   , BR.Icast as 'AgencyID'                          
   , BR.AgencyName AS 'AgencyName'                            
   ,B.inserteddate  AS 'DateTime'                        
   , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                          
   , BookingReference AS 'Booking id'                          
   , B.riyaPNR AS 'Riya / CRSPNR'                          
   , '' AS AirlinePNR                      
   , '0' 'CreditAmount'                          
  , Convert(varchar(200),MC.AmountBeforeCommission) as 'DebitAmount'             
            
  , '0' AS 'Remaining'                          
   , 'HotelSales' AS 'Service Type'                          
   , B.Post_addCancellationRemarks  as 'Remark'                          
                         
   , '' AS RefNo                          
   , '' AS 'Branch Name'                          
   , c.Value AS 'AgentType'          
   , AL.bookingcountry AS 'Country'                          
   , coun.Currency AS 'Currency'                          
   , Al.UserName as 'Booked By'                          
   , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                          
   , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                       
   ,'' AS 'AccountType'                      
    ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                        
                        
  ,B.CurrentStatus  AS 'Booking Status'                         
                           
   , B.providerConfirmationNumber AS 'Supplier confirmation'                          
   , P.payment_mode AS 'Mode of Payment'                         
   ,isnull(B.ModeOfCancellation,'') As ModeOfCancellation                         
   , B.CheckInDate  as 'CheckInDate'                        
   , B.CheckOutDate  as 'CheckOutDate'          
   ,'Make Payment' as Booking_PaymentMode          
   FROM Hotel_BookMaster B WITH(NOLOCK)           
   left join B2BMakepaymentCommission MC on B.pkId=MC.FkBookId and Mc.ProductType='Hotel'          
  left join tblAgentBalance TAB WITH(NOLOCK) on B.orderId=TAB.BookingRef          
   left join tblAgentBalance AB WITH(NOLOCK) on AB.BookingRef=MC.OrderId          
   LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                          
   LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id = B.orderId                      
   LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                          
   LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                          
   LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                          
                 
                  
   WHERE                     
   P.amount IS NOT NULL                          
                     
   AND RiyaAgentID IS NOT NULL                           
   AND B.BookingReference IS NOT NULL                          
   AND B.B2BPaymentMode=3           
   AND (P.payment_mode=@PaymentType or @PaymentType='' )          
  AND ((@FROMDate is null or @ToDate is null) or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))                   
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                           
   AND (AL.BookingCountry= @Country or @Country='')                           
   AND (B.BranchCode =@BranchCode or @BranchCode='')                     
   AND (B.RiyaAgentID=@AgentId or @AgentId='')          
          
            
   ----  old query --            
--  --IF(@PaymentType='3')                               
--  --BEGIN                              
                            
                            
--  --1-vouchered---                            
--   SELECT                              
--   CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                              
--   , BR.Icast as 'AgencyID'                              
--   , BR.AgencyName AS 'AgencyName'                                
--   ,SH.CreateDate  AS 'DateTime'                            
----   ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
--   , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                              
--   , BookingReference AS 'Booking id'                              
--   , B.riyaPNR AS 'Riya / CRSPNR'                              
--   , '' AS AirlinePNR                              
--   , CASE WHEN P.order_status = 'Cancelled' THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0'END AS 'CreditAmount'                              
--   , CASE WHEN P.order_status = 'Success' THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0' END AS 'DebitAmount'                              
--   , '0' AS 'Remaining'                              
--   , 'HotelSales' AS 'Service Type'                              
--   , B.Post_addCancellationRemarks  as 'Remark'        
                             
--   , '' AS RefNo                              
--   , '' AS 'Branch Name'                              
--   , c.Value AS 'AgentType'                              
--   , AL.bookingcountry AS 'Country'                              
--   , coun.Currency AS 'Currency'                              
--   , Al.UserName as 'Booked By'                              
--   , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                              
--   , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                           
--   ,'' AS 'AccountType'                          
--    ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
                            
--  , sm.STATUS AS 'Booking Status'                             
                               
--   , B.providerConfirmationNumber AS 'Supplier confirmation'                              
--   , P.payment_mode AS 'Mode of Payment'                             
--   ,isnull(B.ModeOfCancellation,'') As ModeOfCancellation                             
--   --, cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'                              
--   , B.CheckInDate  as 'CheckInDate'                            
--   , B.CheckOutDate  as 'CheckOutDate'              
            
--   FROM Hotel_BookMaster B WITH(NOLOCK)                              
--   LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                              
--   LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id = B.orderId                          
--   LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                              
--   LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                              
--   LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                              
--   LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId                              
--   LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id                      
--  left join tblAgentBalance TAB on B.orderId=TAB.BookingRef                      
--  --left join tblSelfBalance TSB on B.orderId =TSB.BookingRef                      
--   WHERE                           
--   P.amount IS NOT NULL                              
--   --AND SH.IsActive = 1                            
--   and SH.FkStatusId not in (9,3)                          
--   AND RiyaAgentID IS NOT NULL                               
--   AND B.BookingReference IS NOT NULL                              
--   AND (@PaymentType = '3' AND B2BPaymentMode = 3)                               
--  -- AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))                       
--    AND ((@FROMDate = '' or @ToDate='') or (cast(SH.CreateDate as date) between @FROMDate and @ToDate ))                    
--   AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                               
--   AND (AL.BookingCountry= @Country or @Country='')                               
--   AND (B.BranchCode =@BranchCode or @BranchCode='')                       
--   AND (B.RiyaAgentID=@AgentId or @AgentId='')                              
--  --END                          
--  ----IF(@PaymentType='Walllet')                               
--  --IF(@PaymentType='2')                               
--  --BEGIN                              
                                
--  UNION                               
                              
--  --2-cancelled---                            
--  SELECT                              
--  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                              
--  , BR.Icast as 'AgencyID'                              
--  , BR.AgencyName AS 'AgencyName'                              
--  --, SH.CreateDate AS 'Booking Date'                            
                              
--   , sh.CreateDate   AS 'DateTime'                            
--   --,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
--  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                              
--  , BookingReference AS 'Booking id'                              
--  , B.riyaPNR AS 'Riya / CRSPNR'                              
--  , '' AS airlinePNR                              
--  , CASE WHEN AB.TransactionType = 'Credit' and SH.FkStatusId=7 and SH.IsActive=1 THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0'))                           
--   WHEN ab.TransactionType is not null and SH.FkStatusId=11 THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0'))                           
--  ELSE '0' END AS 'CreditAmount'                              
--  , CASE WHEN AB.TransactionType = 'Debit' and SH.FkStatusId=4 THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0'))                          
--   WHEN ab.TransactionType is not null and SH.FkStatusId=11 THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0'))                           
--   ELSE '0' END AS 'DebitAmount'                              
--  , AB.CloseBalance AS 'Remaining'                              
--  , 'HotelSales' AS 'Service Type'                              
--  --, case when isnull(ab.Remark,'' )+''+B.Post_addCancellationRemarks is null then B.Post_addCancellationRemarks else CONCAT(ab.remark,' ',B.Post_addCancellationRemarks) end  AS 'Remark'                              
--   ,case when ab.TransactionType='TOP-UP' then isnull(ab.Remark,' ') else isnull(B.Post_addCancellationRemarks,' ') end  AS 'Remark'                              
-- , '' AS RefNo                              
--  , '' AS 'Branch Name'                              
--  , c.Value AS 'AgentType'                              
--  , AL.bookingcountry AS 'Country'                              
--  , coun.Currency AS 'Currency'                  
--  , Al.UserName as 'Booked By'                              
--  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                              
--  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                           
--  ,'' AS 'AccountType'                           
--     ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
                              
--  , sm.STATUS AS 'Booking Status'                             
                             
--  , B.providerConfirmationNumber AS 'Supplier confirmation'                       
--  , '' as 'Mode of Payment'                             
--  ,isnull(B.ModeOfCancellation,'') As ModeOfCancellation                             
--  --, cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'                              
--  , B.CheckInDate  as 'CheckInDate'                            
--   , B.CheckOutDate  as 'CheckOutDate'              
             
--  FROM Hotel_BookMaster B WITH(NOLOCK)                              
--  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                              
--  LEFT JOIN tblAgentBalance ab WITH(NOLOCK) ON ab.BookingRef = B.orderId                            
--  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                              
--  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                              
--  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                              
--  LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId                           
--  LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id                       
--   left join tblAgentBalance TAB on B.orderId=TAB.BookingRef                      
--  --left join tblSelfBalance TSB on B.orderId =TSB.BookingRef                      
--  WHERE --ab.TranscationAmount IS NOT NULL               
--  --AND SH.IsActive = 1                            
--  SH.FkStatusId not in (9,3)                          
--  AND RiyaAgentID IS NOT NULL                              
--  AND B.BookingReference is not NULL                               
--  AND (@PaymentType = '2' AND B.B2BPaymentMode = 2)                              
--  --AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))                      
--  AND ((@FROMDate = '' or @ToDate='') or (cast(SH.CreateDate as date) between @FROMDate and @ToDate ))                    
                      
--  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                               
--  AND (AL.BookingCountry= @Country or @Country='')                               
--  AND (BR.BranchCode =@BranchCode or @BranchCode='')                              
--  AND (B.RiyaAgentID=@AgentId or @AgentId='')                              
                              
--   --order by [Booking Date] desc                              
--  --END                              
--  ----IF(@PaymentType='Credit')                              
--  --IF(@PaymentType='40')                              
--  --Begin                              
--   --Credit Debit top up                               
                              
--  UNION                               
                            
--  --3-failed--                            
                            
--  SELECT                              
--  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                              
--  , BR.Icast as 'AgencyID'                              
--  , BR.AgencyName AS 'AgencyName'                              
-- -- , SH.CreateDate AS 'Booking Date'                            
                             
--   , SH.CreateDate  AS 'DateTime'                            
--   --,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
--  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                              
--  , BookingReference AS 'Booking id'                              
--  , B.riyaPNR AS 'Riya / CRSPNR'                           
--  , '' AS airlinePNR                              
--  , '0' AS 'CreditAmount'                              
--  , convert(VARCHAR(50), ISNULL(B.DisplayDiscountRate, '0')) AS 'DebitAmount'                              
--  , '0' AS 'Remaining'                              
--  , 'HotelSales' AS 'Service Type'                              
---- , case when ab.TransactionType='TOP-UP' then ab.Remark else CONCAT(isnull(ab.Remark,''),' ', B.Post_addCancellationRemarks) end  AS 'Remark'                      
-- , B.Post_addCancellationRemarks  AS 'Remark'                              
--  , '' AS RefNo                              
--  , '' AS 'Branch Name'                              
--  , c.Value AS 'AgentType'                              
--  , AL.bookingcountry AS 'Country'                              
--  , coun.Currency AS 'Currency'                              
--  , Al.UserName as 'Booked By'                              
--  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                              
--  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                          
--  ,'' AS 'AccountType'                           
--  ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
                            
--  , sm.STATUS AS 'Booking Status'                              
                             
--  , B.providerConfirmationNumber AS 'Supplier confirmation'                               
--  , '' AS 'Mode of Payment'                              
--  ,isnull(B.ModeOfCancellation,'') As ModeOfCancellation                            
-- -- , cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'                              
-- , B.CheckInDate  as 'CheckInDate'                            
--   , B.CheckOutDate  as 'CheckOutDate'                
              
--  FROM Hotel_BookMaster B WITH(NOLOCK)                              
--  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                               
--  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                              
--  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                              
--  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                         
--  LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId                            
--  LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id                        
--  left join tblAgentBalance TAB on B.orderId=TAB.BookingRef                      
--  --left join tblSelfBalance TSB on B.orderId =TSB.BookingRef                      
--  WHERE SH.IsActive = 1                              
--  AND SH.FkStatusId not in (9,3)                          
--  AND RiyaAgentID IS NOT NULL                              
--  AND B.BookingReference IS NOT NULL                              
--  AND (@PaymentType='1' AND B.B2BPaymentMode IN (4,1))                              
--  --AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))                       
--   AND ((@FROMDate = '' or @ToDate='') or (cast(SH.CreateDate as date) between @FROMDate and @ToDate ))                    
--  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                               
--  AND (AL.BookingCountry= @Country or @Country='')                               
--  AND (BR.BranchCode =@BranchCode or @BranchCode='')                              
--  AND (B.RiyaAgentID=@AgentId or @AgentId='')                              
--  --END                              
--  ----IF(@PaymentType='') All                               
--  --IF(@PaymentType='')                               
--  --BEGIN                              
--  -- (                              
                              
--  UNION                               
                              
--  --4-Confirmed--                            
                            
--  SELECT                              
--  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                              
--  , BR.Icast as 'AgencyID'                              
--  , BR.AgencyName AS 'AgencyName'                              
--  --, SH.CreateDate AS 'Booking Date'                              
                              
--   , SH.CreateDate   AS 'DateTime'                            
----   ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
--  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                              
--  , BookingReference AS 'Booking id'                              
--  , B.riyaPNR AS 'Riya / CRSPNR'                              
--  , '' AS airlinePNR                              
--  , CASE WHEN P.order_status = 'Cancelled' THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0'END AS 'CreditAmount'                              
--  , CASE WHEN P.order_status = 'Success' THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0' END AS 'DebitAmount'                           
--  , '0' AS 'Remaining'                              
--  , 'HotelSales' AS 'Service Type'                              
-- , B.Post_addCancellationRemarks  AS 'Remark'                              
--  , '' AS RefNo                              
--  , '' AS 'Branch Name'                              
--  , c.Value AS 'AgentType'                              
--  , AL.bookingcountry AS 'Country'                              
--  , coun.Currency AS 'Currency'                              
--  , Al.UserName as 'Booked By'                              
--  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                              
--  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                     
--  ,'' AS 'AccountType'                           
--    ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
                            
--  , sm.STATUS AS 'Booking Status'                            
                             
--  , B.providerConfirmationNumber AS 'Supplier confirmation'                              
--  , P.payment_mode AS 'Mode of Payment'                            
--  ,isnull(B.ModeOfCancellation,'') As ModeOfCancellation                            
--  --, cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'                              
-- , B.CheckInDate  as 'CheckInDate'                            
--   , B.CheckOutDate  as 'CheckOutDate'              
             
--  FROM Hotel_BookMaster B WITH(NOLOCK)                              
--  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                              
--  LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id = B.orderId                               
--  LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                              
--  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                              
--  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                              
--  LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId                             
--  LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id                       
--   left join tblAgentBalance TAB on B.orderId=TAB.BookingRef          
--  --left join tblSelfBalance TSB on B.orderId =TSB.BookingRef                      
--  WHERE P.amount IS NOT NULL                              
--  --AND SH.IsActive = 1                            
--  and SH.FkStatusId not in (9,3)                          
--  AND RiyaAgentID IS NOT NULL                               
--  AND B.BookingReference IS NOT NULL                              
--  AND (@PaymentType = '' AND B2BPaymentMode = 3)                              
--  --AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))                       
-- AND ((@FROMDate = '' or @ToDate='') or (cast(SH.CreateDate as date) between @FROMDate and @ToDate ))                      
--  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                               
--  AND (AL.BookingCountry= @Country or @Country='')                               
--  AND (B.BranchCode =@BranchCode or @BranchCode='')                              
--  AND (B.RiyaAgentID=@AgentId or @AgentId='')                              
                               
--  UNION            
                               
--   --Not Found--                            
                            
--  SELECT                              
--  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                              
--  , BR.Icast as 'AgencyID'                              
--  , BR.AgencyName AS 'AgencyName'                              
-- -- ,SH.CreateDate AS 'Booking Date'                            
                             
--   , SH.CreateDate   AS 'DateTime'                            
-- -- ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
--  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                              
--  , BookingReference AS 'Booking id'                              
--  , B.riyaPNR AS 'Riya / CRSPNR'                              
--  , '' AS airlinePNR                              
--  , CASE WHEN AB.TransactionType = 'Credit' and SH.FkStatusId=7 and SH.IsActive=1 THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0'))                           
-- WHEN ab.TransactionType is not null and SH.FkStatusId=11 THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0'))                           
--  ELSE '0' END AS 'CreditAmount'                              
--  , CASE WHEN AB.TransactionType = 'Debit' and SH.FkStatusId=4 THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0'))                           
--   WHEN ab.TransactionType is not null and SH.FkStatusId=11 THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0'))                           
--  ELSE '0' END AS 'DebitAmount'                              
--  , AB.CloseBalance AS 'Remaining'                              
--  , 'HotelSales' AS 'Service Type'                    
--   ,case when ab.TransactionType='TOP-UP' then isnull(ab.Remark,'') else isnull(B.Post_addCancellationRemarks,'') end  AS 'Remark'                              
-- -- , B.Post_addCancellationRemarks  AS 'Remark'                              
--  , '' AS RefNo                              
--  , '' AS 'Branch Name'                              
--  , c.Value AS 'AgentType'                              
--  , AL.bookingcountry AS 'Country'                              
--  , coun.Currency AS 'Currency'                              
--  , Al.UserName as 'Booked By'                              
--  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                              
                            
--  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                           
--  ,'' AS 'AccountType'                          
-- ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
                            
                               
                
--  , sm.STATUS AS 'Booking Status'                            
                             
--  , B.providerConfirmationNumber AS 'Supplier confirmation'                              
--  , '' as 'Mode of Payment'                             
-- ,isnull(B.ModeOfCancellation,'') As ModeOfCancellation                            
----  , cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'                              
--   , B.CheckInDate  as 'CheckInDate'                            
--   , B.CheckOutDate  as 'CheckOutDate'               
             
--  FROM Hotel_BookMaster B WITH(NOLOCK)                              
--  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                              
--  LEFT JOIN tblAgentBalance ab WITH(NOLOCK) ON ab.BookingRef = B.orderId                              
--  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                              
--  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                              
--  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                              
--  LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId                              
--  LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id                      
--  left join tblAgentBalance TAB on B.orderId=TAB.BookingRef                      
--  --left join tblSelfBalance TSB on B.orderId =TSB.BookingRef                      
--  WHERE --ab.TranscationAmount IS NOT NULL                              
--  --AND SH.IsActive = 1                             
--  --and                           
--  SH.FkStatusId not in (9,3)                          
--  AND RiyaAgentID IS NOT NULL                              
--  AND B.BookingReference is not NULL                              
--  AND (@PaymentType = '' AND B.B2BPaymentMode = 2)                              
-- -- AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))                       
--   AND ((@FROMDate = '' or @ToDate='') or (cast(SH.CreateDate as date) between @FROMDate and @ToDate ))                    
--  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                              
--  AND (AL.BookingCountry= @Country or @Country='')                              
--  AND (BR.BranchCode =@BranchCode or @BranchCode='')                              
--  AND (B.RiyaAgentID=@AgentId or @AgentId='')                    
           
                            
                            
--  UNION                              
                              
--  SELECT                              
--  '0' AS BookMasterID                              
--  , BR.Icast as 'AgencyID'                              
--  , BR.AgencyName AS 'AgencyName'                              
--  , TAB.CreatedOn AS 'Booking Date'                             
                              
                              
--  , '' AS 'Description'                              
--  , '' AS 'Booking id'                              
--  , '' AS 'Riya / CRSPNR'                              
--  , '' AS airlinePNR                              
--  , CASE WHEN tab.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0' END AS 'CreditAmount'                              
--  , CASE WHEN tab.TransactionType = 'Debit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0' END AS 'DebitAmount'                              
--  , TAB.CloseBalance AS 'Remaining'                              
--  , 'TOP-UP' AS 'Service Type'                              
                     
-- , TAB.Remark  AS 'Remark'                              
--  , '' AS RefNo                              
--  , '' AS 'Branch Name'                              
--  , c.Value AS 'AgentType'                              
--  , AL.bookingcountry AS 'Country'                 
--  , '' AS 'Currency'                              
-- , Al.UserName as 'Booked By'                              
--  , '' AS 'Passenger name'                              
--  , '' AS 'Travel date'                             
--  ,'' AS 'AccountType'                          
--  ,'' AS 'TravelType'                            
--  , '' AS 'Booking Status'                             
                              
--  , '' AS 'Supplier confirmation'                              
--  , '' AS 'Mode of Payment'                             
--  ,'' As ModeOfCancellation                            
--  --, '' AS 'Pax count'                              
--  , '' as CheckInDate                              
--  , '' as CheckOutDate                
             
--  FROM tblAgentBalance TAB WITH(NOLOCK)                               
--  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON TAB.AgentNo = BR.FKUserID                              
--  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON TAB.AgentNo = AL.UserID                               
--  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                              
--  WHERE (@PaymentType='40' AND BookingRef IN ('Cash','Credit'))                              
--  AND ((@FROMDate = '' or @ToDate='') or (cast(TAB.CreatedOn as date) between @FROMDate and @ToDate ))                              
--  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                               
--  AND (AL.BookingCountry= @Country or @Country='')                               
--  AND (BR.BranchCode =@BranchCode or @BranchCode='')                              
--  AND (TAB.AgentNo=@AgentId or @AgentId='')                              
                              
--  --End                              
--  ----IF(@PaymentType='Hold')                               
--  --IF(@PaymentType='1')                               
--  --BEGIN                              
--   --                               
                              
--  UNION                               
                               
--  --Credit Debit top up                              
--  SELECT                              
--  '0' AS BookMasterID                              
--  , BR.Icast as 'AgencyID'                              
--  , BR.AgencyName AS 'AgencyName'                              
--  , TAB.CreatedOn AS 'Booking Date'                             
                              
--  , '' AS 'Description'                              
--  , '' AS 'Booking id'                              
--  , '' AS 'Riya / CRSPNR'                              
--  , '' AS airlinePNR                              
--  , CASE WHEN tab.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0' END AS 'CreditAmount'                              
--  , CASE WHEN tab.TransactionType = 'Debit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0' END AS 'DebitAmount'                              
--  , TAB.CloseBalance AS 'Remaining'                              
--  , 'TOP-UP' AS 'Service Type'                              
--  , TAB.Remark AS 'Remark'             
--  , '' AS RefNo                              
--  , '' AS 'Branch Name'                              
--  , c.Value AS 'AgentType'                              
--  , AL.bookingcountry AS 'Country'                              
--  , '' AS 'Currency'                              
--  , Al.UserName as 'Booked By'                              
--  , '' AS 'Passenger name'                              
--  , '' AS 'Travel date'                          
--  ,'' AS 'AccountType'                          
--  ,'' AS 'TravelType'                            
                             
--  , '' AS 'Booking Status'                             
                              
--  , '' AS 'Supplier confirmation'                              
--  , '' AS 'Mode of Payment'                            
--  ,'' As ModeOfCancellation                            
--  --, '' AS 'Pax count'                              
--  , '' as CheckInDate                              
--  , '' as CheckOutDate                  
               
--  FROM tblAgentBalance TAB WITH(NOLOCK)                              
--  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON TAB.AgentNo = BR.FKUserID                              
--  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON TAB.AgentNo = AL.UserID                              
--  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                              
--  WHERE (@PaymentType = '' AND BookingRef IN ('Cash','Credit'))                              
--  AND ((@FROMDate = '' or @ToDate='') or (cast(TAB.CreatedOn as date) between @FROMDate and @ToDate ))                              
--  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                               
--  AND (AL.BookingCountry= @Country or @Country='')                               
--  AND (BR.BranchCode =@BranchCode or @BranchCode='')                              
--  AND (TAB.AgentNo=@AgentId or @AgentId='')                             
                            
--  UNION                              
                               
--  SELECT                              
--  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID                              
--  , BR.Icast as 'AgencyID'                              
--  , BR.AgencyName AS 'AgencyName'                              
--  , SH.CreateDate AS 'Booking Date'                             
                              
--   --, case when B.CurrentStatus='Cancelled' then B.CancellationDate else B.inserteddate end   AS 'Booking Date'                            
                               
--  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'                              
--  , BookingReference AS 'Booking id'                              
--  , B.riyaPNR AS 'Riya / CRSPNR'                              
--  , '' AS airlinePNR                              
--  , '0' AS 'CreditAmount'                              
--  , convert(VARCHAR(50), ISNULL(B.DisplayDiscountRate, '0')) AS 'DebitAmount'                              
--  , '0' AS 'Remaining'                              
--  , 'HotelSales' AS 'Service Type'                     
--  ,  B.Post_addCancellationRemarks AS 'Remark'                      
--  --, B.Post_addCancellationRemarks  AS 'Remark'                              
--  , '' AS RefNo                              
--  , '' AS 'Branch Name'                              
--  , c.Value AS 'AgentType'                              
--  , AL.bookingcountry AS 'Country'                              
--  , coun.Currency AS 'Currency'                              
--  , Al.UserName as 'Booked By'                              
--  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'                              
--  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'                              
--  ,'' AS 'AccountType'                          
--  ,case When B.BookingCountry='IN' then 'Domestic' else 'International' End as 'TravelType'                            
--  , sm.STATUS AS 'Booking Status'                             
                              
                             
--  , B.providerConfirmationNumber AS 'Supplier confirmation'                              
--  , '' AS 'Mode of Payment'                             
--  ,B.ModeOfCancellation as 'Mode Of Cancellation'                            
--  --, cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'                      
--   , B.CheckInDate  as 'CheckInDate'                            
-- , B.CheckOutDate  as 'CheckOutDate'               
            
--  FROM Hotel_BookMaster B WITH(NOLOCK)                              
--  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID                      
--  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY                              
--  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID                              
--  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID                              
--  LEFT JOIN Hotel_Status_History SH ON B.pkId = SH.FKHotelBookingId                              
--  LEFT JOIN Hotel_Status_Master SM ON SH.FkStatusId = SM.Id                      
--  left join tblAgentBalance TAB on B.orderId=TAB.BookingRef                      
--  --left join tblSelfBalance TSB on B.orderId =TSB.BookingRef                      
--  WHERE SH.IsActive = 1                            
--  AND SH.FkStatusId not in (9,3)                          
--  AND RiyaAgentID IS NOT NULL                              
--  AND B.BookingReference IS NOT NULL                              
--  AND (@PaymentType = '' AND B.B2BPaymentMode IN (4,1))                              
--  --AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate))                      
--  AND ((@FROMDate = '' or @ToDate='') or (cast(SH.CreateDate as date) between @FROMDate and @ToDate ))                       
--  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                              
--  AND (AL.BookingCountry= @Country or @Country='')                              
--  AND (BR.BranchCode =@BranchCode or @BranchCode='')                              
--  AND (B.RiyaAgentID=@AgentId or @AgentId='')                              
 ) Hotel order by Hotel.[DateTime]                                
     
 select * into #tempTableAASActivity                 
   from           
   (              
              
   /*Credit Limit*/              
            
   /*Credit Limit*/              
   SELECT                                  
   CAST(b.bookingid AS VARCHAR(50)) AS BookMasterID                                  
   ,cast( BR.Icast as varchar) as 'AgencyID'                                  
   , BR.AgencyName AS 'AgencyName'                                    
   ,convert(varchar,isnull(TAB.CreatedOn,sh.CreateDate),120)  AS 'DateTime'                                
   , CONCAT( isnull(act.activityname,' '),' - ',    isnull(act.activityoptionname,' ')) AS 'Description'                                  
   , b.BookingRefId AS 'Booking id'                                  
   , '' AS 'Riya / CRSPNR'                                  
   , '' AS AirlinePNR                              
 , CASE WHEN tAB.TransactionType = 'Credit' and sh.FkStatusId='7' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                                 
 --  WHEN tAB.TransactionType is not null and SH.FkStatusId=11 THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                                 
   ELSE '0' END AS 'CreditAmount'                                    
  , CASE WHEN TAB.TransactionType = 'Debit' and sh.FkStatusId='4' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                    
   WHEN TAB.TransactionType = 'Debit' and sh.FkStatusId='3' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                                 
   ELSE '0' END AS 'DebitAmount'                       
                       
  , TAB.CloseBalance AS 'Remaining'                                    
   , 'ActivitySales' AS 'Service Type'                               
   ,isnull( B.CancellationRemark  , '')as 'Remark'                                  
                                 
   , '' AS RefNo                                  
   , '' AS 'Branch Name'                     
   , c.Value AS 'AgentType'                                  
   , AL.bookingcountry AS 'Country'                               
   , b.BookingCurrency AS 'Currency'                                  
   , Al.UserName as 'Booked By'                                  
   , B.titel + ' ' + B.NAME + ' ' + B.surname  AS 'Passenger name'                                  
   , CONVERT(VARCHAR, B.TripStartDate, 101) + ' - ' + CONVERT(VARCHAR, B.TripEndDate, 101) AS 'Travel date'                               
   ,'' AS 'AccountType'                              
    ,case When B.CountryCode='IN' then 'Domestic' else 'International' End as 'TravelType'                                
                                
  ,B.BookingStatus  AS 'Booking Status'                                 
                                   
   , B.providerConfirmationNumber AS 'Supplier confirmation'                                  
   , cast (b.PaymentMode as varchar) AS 'Mode of Payment'                                 
   ,case when sh.FkStatusId=7 then isnull(B.ModeOfCancellation,'') else '' end  As ModeOfCancellation                                 
   , convert(varchar,B.TripStartDate ,101) as 'CheckInDate'                                
   , convert(varchar,B.TripEndDate ,101)  as 'CheckOutDate'                  
   ,'Credit Limit' as Booking_PaymentMode                  
               
              
FROM    ss.ss_bookingmaster B WITH(nolock)    LEFT JOIN ss.ss_bookedactivities act ON act.bookingid = b.bookingid             
      LEFT JOIN tblagentbalance TAB WITH(nolock) ON (Cast(B.BookingRefId AS VARCHAR) = TAB.bookingref or  Cast(B.BookingId AS VARCHAR) = TAB.bookingref)                   
 LEFT Join hotel.Agentbalance_StatusLog TL on TAB.pkid=TL.FKtransactionID                      
            
   LEFT JOIN ss.ss_status_history sh ON sh.bookingid = act.bookingid  AND sh.isactive = 1              
   LEFT JOIN mcountry coun WITH(nolock) ON coun.countrycode = b.countrycode               
   LEFT JOIN agentlogin AL WITH(nolock) ON B.agentid = AL.userid     LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.agentid = BR.FKUserID                                  
               
 LEFT JOIN mcommon C WITH(nolock) ON C.id = AL.usertypeid              
            
 where              
 b.PaymentMode=2 and              
  b.BookingRate IS NOT NULL                                  
                             
   AND AgentID IS NOT NULL                                   
   AND b.BookingRefId IS NOT NULL                                  
                     
   AND (b.PaymentMode=@PaymentType or @PaymentType='' )                  
  AND ((@FROMDate = '' or @ToDate='') or (cast(isnull(TAB.CreatedOn,sh.CreateDate) as date) between @FROMDate and @ToDate ))                           
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                                   
   AND (AL.BookingCountry= @Country or @Country='')                                   
   --AND (B.BranchCode =@BranchCode or @BranchCode='')                             
   AND (B.AgentID=@AgentId or @AgentId='')                
              
   union              
              
/**Hold payment           
*/                 
               
   SELECT                                  
   CAST(b.bookingid AS VARCHAR(50)) AS BookMasterID                                  
   , cast( BR.Icast as varchar) as 'AgencyID'                                
   , BR.AgencyName AS 'AgencyName'                                    
 ,convert(varchar,sh.CreateDate,120)  AS 'DateTime'                                
   , CONCAT( isnull(act.activityname,' '),' - ',    isnull(act.activityoptionname,' ')) AS 'Description'                                  
   , b.BookingRefId AS 'Booking id'                                  
   , '' AS 'Riya / CRSPNR'                                  
   , '' AS AirlinePNR                              
  , '0' as 'CreditAmount'                                  
  , '0' as 'DebitAmount'                     
                     
  , '0' AS 'Remaining'                                  
   , 'ActivitySales' AS 'Service Type'                                  
   , isnull( B.CancellationRemark  , '')  as 'Remark'                                  
                                 
   , '' AS RefNo                                  
   , '' AS 'Branch Name'                     
   , c.Value AS 'AgentType'                                  
   , AL.bookingcountry AS 'Country'                                  
   ,  b.BookingCurrency AS 'Currency'                                  
   , Al.UserName as 'Booked By'                                  
   , B.titel + ' ' + B.NAME + ' ' + B.surname  AS 'Passenger name'                                  
   , CONVERT(VARCHAR, B.TripStartDate, 101) + ' - ' + CONVERT(VARCHAR, B.TripEndDate, 101) AS 'Travel date'                               
   ,'' AS 'AccountType'                              
    ,case When B.CountryCode='IN' then 'Domestic' else 'International' End as 'TravelType'                                
                                
  ,B.BookingStatus  AS 'Booking Status'                                 
                                   
   , B.providerConfirmationNumber AS 'Supplier confirmation'                                  
   , '' AS 'Mode of Payment'                                 
   ,case when sh.FkStatusId=7 then isnull(B.ModeOfCancellation,'') else '' end As ModeOfCancellation                                 
   , convert(varchar,B.TripStartDate ,101) as 'CheckInDate'                                
   , convert(varchar,B.TripEndDate ,101)  as 'CheckOutDate'                  
   ,'Hold' as Booking_PaymentMode                  
               
              
FROM    ss.ss_bookingmaster B WITH(nolock)    LEFT JOIN ss.ss_bookedactivities act ON act.bookingid = b.bookingid              
LEFT JOIN tblagentbalance TAB WITH(nolock) ON Cast(B.clientbookingid AS VARCHAR) = TAB.bookingref          
LEFT JOIN ss.ss_status_history sh     ON sh.bookingid = act.bookingid           
AND sh.isactive = 1    LEFT JOIN mcountry coun WITH(nolock) ON coun.countrycode = b.countrycode          
 LEFT JOIN agentlogin AL WITH(nolock) ON B.agentid = AL.userid     LEFT JOIN B2BRegistration BR WITH(NOLOCK)           
 ON B.agentid= BR.FKUserID                                  
               
 LEFT JOIN mcommon C WITH(nolock) ON C.id = AL.usertypeid               
 where              
 b.PaymentMode=1 and              
  b.BookingRate IS NOT NULL                                  
                             
   AND AgentID IS NOT NULL                                   
   AND b.BookingRefId IS NOT NULL                                  
                     
   AND (b.PaymentMode=@PaymentType or @PaymentType='' )                  
  AND ((@FROMDate = '' or @ToDate='') or (cast(sh.CreateDate as date) between @FROMDate and @ToDate ))                           
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                                   
   AND (AL.BookingCountry= @Country or @Country='')                                   
   --AND (B.BranchCode =@BranchCode or @BranchCode='')                             
   AND (B.AgentID=@AgentId or @AgentId='')                
              
              
                
 /*--MakePayment*/              
 union              
               
   SELECT                                  
   CAST(b.bookingid AS VARCHAR(50)) AS BookMasterID                                  
   , cast( BR.Icast as varchar) as 'AgencyID'                                  
   , BR.AgencyName AS 'AgencyName'                                    
   ,convert(varchar,sh.CreateDate,120)  AS 'DateTime'                                
   , CONCAT( isnull(act.activityname,' '),' - ',    isnull(act.activityoptionname,' ')) AS 'Description'                                 
   , b.BookingRefId AS 'Booking id'                                  
   , '' AS 'Riya / CRSPNR'                                  
   , '' AS AirlinePNR                              
   , '0' 'CreditAmount'                                  
  , Convert(varchar(200),MC.AmountBeforeCommission) as 'DebitAmount'                     
                    
  , '0' AS 'Remaining'                                  
   , 'ActivitySales' AS 'Service Type'                                  
   , isnull( B.CancellationRemark  , '')  as 'Remark'                            
                                 
   , '' AS RefNo    
   , '' AS 'Branch Name'                     
   , c.Value AS 'AgentType'                                  
   , AL.bookingcountry AS 'Country'                                  
   ,  b.BookingCurrency AS 'Currency'                                  
   , Al.UserName as 'Booked By'                                  
   , B.titel + ' ' + B.NAME + ' ' + B.surname  AS 'Passenger name'                                  
   , CONVERT(VARCHAR, B.TripStartDate, 101) + ' - ' + CONVERT(VARCHAR, B.TripEndDate, 101) AS 'Travel date'                               
   ,'' AS 'AccountType'                              
    ,case When B.CountryCode='IN' then 'Domestic' else 'International' End as 'TravelType'                                
                                
  ,B.BookingStatus  AS 'Booking Status'                    
                                   
   , B.providerConfirmationNumber AS 'Supplier confirmation'                                  
   , mc.ModeOfPayment AS 'Mode of Payment'                                 
   ,case when sh.FkStatusId=7 then isnull(B.ModeOfCancellation,'') else '' end  As ModeOfCancellation                                 
   , convert(varchar,B.TripStartDate ,101) as 'CheckInDate'                                
   , convert(varchar,B.TripEndDate ,101)  as 'CheckOutDate'                  
   ,'Make Payment' as Booking_PaymentMode                  
               
              
FROM    ss.ss_bookingmaster B WITH(nolock)         
LEFT JOIN ss.ss_bookedactivities act ON act.bookingid = b.bookingid           
left join B2BMakepaymentCommission MC on B.BookingId=MC.FkBookId and Mc.ProductType='Activity'                  
   LEFT JOIN tblagentbalance TAB WITH(nolock) ON Cast(B.clientbookingid AS VARCHAR) = TAB.bookingref       
   LEFT JOIN ss.ss_status_history sh ON sh.bookingid = act.bookingid    AND sh.isactive = 1         
   LEFT JOIN mcountry coun WITH(nolock) ON coun.countrycode =b.countrycode          
   LEFT JOIN agentlogin AL WITH(nolock) ON B.agentid = AL.userid          
   LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.agentid = BR.FKUserID                                  
               
 LEFT JOIN mcommon C WITH(nolock) ON C.id = AL.usertypeid               
 where              
 b.PaymentMode=3 and              
  b.BookingRate IS NOT NULL                                  
                             
   AND AgentID IS NOT NULL                                   
   AND b.BookingRefId IS NOT NULL                                  
                     
   AND (b.PaymentMode=@PaymentType or @PaymentType='' )                  
  AND ((@FROMDate = '' or @ToDate='') or (cast(sh.CreateDate as date) between @FROMDate and @ToDate ))                           
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                                   
   AND (AL.BookingCountry= @Country or @Country='')                                   
   --AND (B.BranchCode =@BranchCode or @BranchCode='')                             
   AND (B.AgentID=@AgentId or @AgentId='')                
              
                   
)Activity order by Activity.[DateTime]               
                                              
SELECT * INTO #tempTableAASRail FROM(    
           
            
   /*Credit Limit*/         
   SELECT                          
   CAST(B.BookingId AS VARCHAR(50)) AS BookMasterID                            
   , BR.Icast as 'AgencyID'                            
   , BR.AgencyName AS 'AgencyName'                              
   ,B.CreatedDate  AS 'DateTime'                          
   ,'' AS 'Description'                            
   , b.BookingReference AS 'Booking id'                            
   , B.riyaPNR AS 'Riya / CRSPNR'                            
   , '' AS AirlinePNR                        
 , CASE WHEN tAB.TransactionType = 'Credit' and (bki.Status='CANCELED' or bki.Status IS NULL) THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                                       
   ELSE '0' END AS 'CreditAmount'                  
   , CASE WHEN TAB.TransactionType = 'Debit' and (bki.Status='CONFIRMED' or bki.Status IS NULL) THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                                   
   ELSE '0' END AS 'DebitAmount'               
               
  , TAB.CloseBalance AS 'Remaining'                            
   , 'RailSales' AS 'Service Type'                            
  , ''  as 'Remark'                            
                           
   , '' AS RefNo                            
   , '' AS 'Branch Name'                            
   , c.Value AS 'AgentType'                            
   , AL.bookingcountry AS 'Country'                            
   , coun.Currency AS 'Currency'                            
   , Al.UserName as 'Booked By'                            
   , pax.title + ' ' + pax.firstName + ' ' + pax.lastName AS 'Passenger name'                            
  ,CONVERT(VARCHAR,     
    CASE    
        WHEN bki.Type = 'PASS' THEN    
            CASE     
                WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''     
                    THEN bki.validityPeriodStart    
                    ELSE bki.activationPeriodStart    
            END    
        ELSE bki.Departure    
    END, 101)     
 + '-' +     
CONVERT(VARCHAR,     
    CASE    
        WHEN bki.Type = 'PASS' THEN    
            CASE    
                WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''    
                    THEN bki.validityPeriodEnd    
                    ELSE bki.activationPeriodEnd    
            END    
        ELSE bki.Arrival    
    END, 101)     
AS 'Travel date'    
                        
   ,'' AS 'AccountType'                        
    , 'International' as 'TravelType'                          
                          
  ,case when B.bookingStatus='INVOICED' then 'Confirmed'else ISNULL(b.bookingStatus,'NA') end AS 'Booking Status'                           
                             
   , '' AS 'Supplier confirmation'                            
   , B.PaymentType AS 'Mode of Payment'                           
   ,cast(isnull(Bki.CancellationEligible,'') as varchar(10)) As ModeOfCancellation                           
   ,CASE          
    WHEN bki.Type = 'PASS' THEN          
    CASE          
     WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''          
      THEN bki.validityPeriodStart          
      ELSE bki.activationPeriodStart          
    END          
   ELSE bki.Departure          
  END AS CheckInDate    
      
  ,CASE          
    WHEN bki.Type = 'PASS' THEN          
    CASE          
      WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''          
                     THEN bki.validityPeriodEnd          
                     ELSE bki.activationPeriodEnd          
    END          
   ELSE bki.Arrival          
   END AS CheckOutDate    
       
   ,'Credit Limit' as Booking_PaymentMode     
   FROM Rail.Bookings B WITH (NOLOCK)    
    left JOIN RAIL.BookingItems bki WITH (NOLOCK) ON B.Id=bki.fk_bookingId                
    left join Rail.PaxDetails pax WITH (NOLOCK) on pax.fk_ItemId = bki.Id and pax.leadTraveler = 1          
    LEFT JOIN mUser MU WITH (NOLOCK) ON B.RiyaUserId = MU.ID      
    LEFT JOIN AgentLogin AL WITH (NOLOCK) ON B.AgentId = AL.UserID                  
    LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BR.FKUserID = AL.UserID   
 LEFT JOIN tblagentbalance TAB WITH(NOLOCK)ON TAB.BookingRef=b.BookingId  
 Left join PaymentGatewayMode PGM on B.PaymentType = PGM.Mode and PGID=2                
    LEFT JOIN mCommon C WITH (NOLOCK) ON AL.UserTypeID = C.ID    LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = B.AgentCurrency                 
WHERE B.AmountPaidbyAgent IS NOT NULL          
AND B.PaymentMode = 'AgentCreditBalance'    
and b.PaymentMode is not null       
AND B.AgentId IS NOT NULL                
AND B.BookingReference IS NOT NULL                               
AND ((@FROMDate IS NULL OR @ToDate IS NULL) OR (CAST(B.CreatedDate AS DATE) BETWEEN @FROMDate AND @ToDate))                     
AND (AL.UserTypeID = @AgentTypeId OR @AgentTypeId = '')         
AND ((@PaymentType = '2' AND B.PaymentMode = 'AgentCreditBalance') )           
AND(@PaymentType = '')    
  --and b.PaymentMode='AgentCreditBalance'        
            
  union         
          
   -- hold Condition --          
  SELECT                          
   CAST(B.BookingId AS VARCHAR(50)) AS BookMasterID                            
   , BR.Icast as 'AgencyID'                            
   , BR.AgencyName AS 'AgencyName'                              
   ,B.CreatedDate  AS 'DateTime'                          
   ,'' AS 'Description'                            
   , b.BookingReference AS 'Booking id'                            
   , B.riyaPNR AS 'Riya / CRSPNR'                            
   , '' AS AirlinePNR                        
  ,'0' AS 'CreditAmount'                            
  , '0' AS 'DebitAmount'               
               
  , '0' AS 'Remaining'                            
   , 'RailSales' AS 'Service Type'                            
  , ''  as 'Remark'                            
                           
   , '' AS RefNo                            
   , '' AS 'Branch Name'                            
   , c.Value AS 'AgentType'                            
   , AL.bookingcountry AS 'Country'                            
   , coun.Currency AS 'Currency'                            
   , Al.UserName as 'Booked By'                            
   , pax.title + ' ' + pax.firstName + ' ' + pax.lastName AS 'Passenger name'                            
  ,CONVERT(VARCHAR,     
    CASE    
        WHEN bki.Type = 'PASS' THEN    
            CASE     
                WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''     
                    THEN bki.validityPeriodStart    
                    ELSE bki.activationPeriodStart    
            END    
        ELSE bki.Departure    
    END, 101)     
 + '-' +     
CONVERT(VARCHAR,     
    CASE    
        WHEN bki.Type = 'PASS' THEN    
            CASE    
                WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''    
                    THEN bki.validityPeriodEnd    
                    ELSE bki.activationPeriodEnd    
            END    
        ELSE bki.Arrival    
    END, 101)     
AS 'Travel date'    
                        
   ,'' AS 'AccountType'                        
    , 'International' as 'TravelType'                          
                          
  ,case when B.bookingStatus='INVOICED' then 'Confirmed'else ISNULL(b.bookingStatus,'NA') end AS 'Booking Status'                           
                             
   , '' AS 'Supplier confirmation'                            
   , B.PaymentType AS 'Mode of Payment'                           
   ,cast(isnull(Bki.CancellationEligible,'') as varchar(10)) As ModeOfCancellation                           
   ,CASE          
    WHEN bki.Type = 'PASS' THEN          
    CASE          
     WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''          
      THEN bki.validityPeriodStart          
      ELSE bki.activationPeriodStart          
    END          
   ELSE bki.Departure          
  END AS CheckInDate    
      
  ,CASE          
    WHEN bki.Type = 'PASS' THEN          
    CASE          
      WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''          
                     THEN bki.validityPeriodEnd          
                     ELSE bki.activationPeriodEnd          
    END          
   ELSE bki.Arrival          
   END AS CheckOutDate    
       
   ,'HOLD' as Booking_PaymentMode     
   FROM Rail.Bookings B WITH (NOLOCK)    
    left JOIN RAIL.BookingItems bki WITH (NOLOCK) ON B.Id=bki.fk_bookingId                
    left join Rail.PaxDetails pax WITH (NOLOCK) on pax.fk_ItemId = bki.Id and pax.leadTraveler = 1          
    LEFT JOIN mUser MU WITH (NOLOCK) ON B.RiyaUserId = MU.ID      
    LEFT JOIN AgentLogin AL WITH (NOLOCK) ON B.AgentId = AL.UserID           
    LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BR.FKUserID = AL.UserID  
 LEFT JOIN tblagentbalance TAB WITH(NOLOCK)ON TAB.BookingRef=b.BookingId  
 Left join PaymentGatewayMode PGM on B.PaymentType = PGM.Mode and PGID=2                
    LEFT JOIN mCommon C WITH (NOLOCK) ON AL.UserTypeID = C.ID    LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = B.AgentCurrency                 
   WHERE                         
   B.AmountPaidbyAgent IS NOT NULL                            
   AND B.AgentId IS NOT NULL                             
   AND B.BookingReference IS NOT NULL    
   --and B.bookingStatus='PREBOOKED'or b.overviewStatus='ON_HOLD'    
    AND ((@PaymentType = '1' AND  B.bookingStatus='PREBOOKED'and b.overviewStatus='ON_HOLD'))  
 and b.PaymentMode is not null  
           
   AND ((@FROMDate is null or @ToDate is null ) or (cast(B.CreatedDate as date) between @FROMDate and @ToDate ))                  
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                             
   AND (AL.BookingCountry= @Country or @Country='')                             
  -- AND (B.BranchCode =@BranchCode or @BranchCode='')                       
  AND (B.AgentId=@AgentId or @AgentId='')              
   and b.PaymentMode='AgentCreditBalance'       
            
          
   UNION          
      --- Payment GateWay  --     
 SELECT                          
   CAST(B.BookingId AS VARCHAR(50)) AS BookMasterID                            
   , BR.Icast as 'AgencyID'                            
   , BR.AgencyName AS 'AgencyName'                              
   ,B.CreatedDate  AS 'DateTime'                          
   ,'' AS 'Description'                            
   , b.BookingReference AS 'Booking id'                            
   , B.riyaPNR AS 'Riya / CRSPNR'                            
   , '' AS AirlinePNR                        
  ,'0' AS 'CreditAmount'                            
  , '0' AS 'DebitAmount'               
               
  , '0' AS 'Remaining'                            
   , 'RailSales' AS 'Service Type'                            
  , ''  as 'Remark'                            
                           
   , '' AS RefNo                            
   , '' AS 'Branch Name'                            
   , c.Value AS 'AgentType'                            
   , AL.bookingcountry AS 'Country'                            
   , coun.Currency AS 'Currency'                            
   , Al.UserName as 'Booked By'                            
   , pax.title + ' ' + pax.firstName + ' ' + pax.lastName AS 'Passenger name'                            
  ,CONVERT(VARCHAR,     
    CASE    
        WHEN bki.Type = 'PASS' THEN    
            CASE     
                WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''     
                    THEN bki.validityPeriodStart    
                    ELSE bki.activationPeriodStart    
            END    
        ELSE bki.Departure    
    END, 101)     
 + '-' +     
CONVERT(VARCHAR,     
    CASE    
        WHEN bki.Type = 'PASS' THEN    
            CASE    
                WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''    
                    THEN bki.validityPeriodEnd    
                    ELSE bki.activationPeriodEnd    
            END    
        ELSE bki.Arrival    
    END, 101)     
AS 'Travel date'    
                        
   ,'' AS 'AccountType'                        
    , 'International' as 'TravelType'                          
                          
  ,case when B.bookingStatus='INVOICED' then 'Confirmed'else ISNULL(b.bookingStatus,'NA') end AS 'Booking Status'                           
                             
   , '' AS 'Supplier confirmation'                            
   , B.PaymentType AS 'Mode of Payment'                           
   ,cast(isnull(Bki.CancellationEligible,'') as varchar(10)) As ModeOfCancellation                           
   ,CASE          
    WHEN bki.Type = 'PASS' THEN          
    CASE          
     WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''          
      THEN bki.validityPeriodStart          
      ELSE bki.activationPeriodStart          
    END          
   ELSE bki.Departure          
  END AS CheckInDate    
      
  ,CASE          
    WHEN bki.Type = 'PASS' THEN          
    CASE          
      WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''          
                     THEN bki.validityPeriodEnd          
                     ELSE bki.activationPeriodEnd          
    END          
   ELSE bki.Arrival          
   END AS CheckOutDate    
       
   ,'PaymentGateway' as Booking_PaymentMode     
   FROM Rail.Bookings B WITH (NOLOCK)    
    left JOIN RAIL.BookingItems bki WITH (NOLOCK) ON B.Id=bki.fk_bookingId                
    left join Rail.PaxDetails pax WITH (NOLOCK) on pax.fk_ItemId = bki.Id and pax.leadTraveler = 1          
    LEFT JOIN mUser MU WITH (NOLOCK) ON B.RiyaUserId = MU.ID      
    LEFT JOIN AgentLogin AL WITH (NOLOCK) ON B.AgentId = AL.UserID                  
    LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BR.FKUserID = AL.UserID   
 LEFT JOIN tblagentbalance TAB WITH(NOLOCK)ON TAB.BookingRef=b.BookingId  
  
 Left join PaymentGatewayMode PGM on B.PaymentType = PGM.Mode and PGID=2                
    LEFT JOIN mCommon C WITH (NOLOCK) ON AL.UserTypeID = C.ID    LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = B.AgentCurrency                 
   WHERE                         
   B.AmountPaidbyAgent IS NOT NULL                            
   AND B.AgentId IS NOT NULL                             
   AND B.BookingReference IS NOT NULL     
     AND (@PaymentType = '3' AND  B.PaymentMode='PaymentGateway')  
  --OR (@PaymentType is not null or @PaymentType=null))        
   AND ((@FROMDate is null or @ToDate is null) or (cast(B.CreatedDate as date) between @FROMDate and @ToDate ))                  
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')                             
   AND (AL.BookingCountry= @Country or @Country='')                                               
  AND (B.AgentId=@AgentId or @AgentId='')   
  and pax.leadTraveler=1  
  and b.PaymentMode is not null  
  -- and b.PaymentMode='AgentCreditBalance'       
        
   UNION          
         -- ALL ---      
   SELECT                          
   CAST(bki.bookingItemId AS VARCHAR(50)) AS BookMasterID                            
   , BR.Icast as 'AgencyID'                            
   , BR.AgencyName AS 'AgencyName'                              
   ,B.CreatedDate  AS 'DateTime'                          
   ,'' AS 'Description'                            
   , b.BookingReference AS 'Booking id'                            
   , B.riyaPNR AS 'Riya / CRSPNR'                            
   , '' AS AirlinePNR                        
  ,'0' AS 'CreditAmount'                            
  , CASE WHEN TAB.TransactionType = 'Debit' and (bki.Status='CONFIRMED' or bki.Status IS NULL) THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0'))                                   
   ELSE '0' END AS 'DebitAmount'               
               
  , TAB.CloseBalance AS 'Remaining'                            
   , 'RailSales' AS 'Service Type'                            
  , ''  as 'Remark'                            
                           
   , '' AS RefNo                            
   , '' AS 'Branch Name'                            
   , c.Value AS 'AgentType'                            
   , AL.bookingcountry AS 'Country'                            
   , coun.Currency AS 'Currency'                            
   , Al.UserName as 'Booked By'                            
   , pax.title + ' ' + pax.firstName + ' ' + pax.lastName AS 'Passenger name'                            
  ,CONVERT(VARCHAR,     
    CASE    
        WHEN bki.Type = 'PASS' THEN    
            CASE     
                WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''     
                    THEN bki.validityPeriodStart    
                    ELSE bki.activationPeriodStart    
          END    
        ELSE bki.Departure    
    END, 101)     
 + '-' +     
CONVERT(VARCHAR,     
    CASE    
        WHEN bki.Type = 'PASS' THEN    
            CASE    
                WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''    
                    THEN bki.validityPeriodEnd    
                    ELSE bki.activationPeriodEnd    
            END    
        ELSE bki.Arrival    
    END, 101)     
AS 'Travel date'    
                        
   ,'' AS 'AccountType'                        
    , 'International' as 'TravelType'                          
                          
  ,case when B.bookingStatus='INVOICED' then 'Confirmed'else ISNULL(b.bookingStatus,'NA') end AS 'Booking Status'                           
                             
   , '' AS 'Supplier confirmation'                            
   , B.PaymentMode AS 'Mode of Payment'                           
   ,cast(isnull(Bki.CancellationEligible,'') as varchar(10)) As ModeOfCancellation                           
   ,CASE          
    WHEN bki.Type = 'PASS' THEN          
    CASE          
     WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''          
      THEN bki.validityPeriodStart          
      ELSE bki.activationPeriodStart          
    END          
   ELSE bki.Departure          
  END AS CheckInDate    
      
  ,CASE          
    WHEN bki.Type = 'PASS' THEN          
    CASE          
      WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''          
                     THEN bki.validityPeriodEnd          
                     ELSE bki.activationPeriodEnd          
    END          
   ELSE bki.Arrival          
   END AS CheckOutDate    
       
   ,'Credit Limit'as Booking_PaymentMode     
   FROM Rail.Bookings B WITH (NOLOCK)    
    left JOIN RAIL.BookingItems bki WITH (NOLOCK) ON B.Id=bki.fk_bookingId                
    left join Rail.PaxDetails pax WITH (NOLOCK) on pax.fk_ItemId = bki.Id and pax.leadTraveler = 1  
  LEFT JOIN tblagentbalance TAB WITH(NOLOCK)ON TAB.BookingRef=b.BookingId  
    LEFT JOIN mUser MU WITH (NOLOCK) ON B.RiyaUserId = MU.ID      
    LEFT JOIN AgentLogin AL WITH (NOLOCK) ON B.AgentId = AL.UserID                  
    LEFT JOIN B2BRegistration BR WITH (NOLOCK) ON BR.FKUserID = AL.UserID         
 Left join PaymentGatewayMode PGM on B.PaymentType = PGM.Mode and PGID=2                
    LEFT JOIN mCommon C WITH (NOLOCK) ON AL.UserTypeID = C.ID    LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = B.AgentCurrency                 
   WHERE                         
   B.AmountPaidbyAgent IS NOT NULL                            
   AND B.AgentId IS NOT NULL                             
   AND B.BookingReference IS NOT NULL                            
  AND (@PaymentType='' )            
   AND ((@FROMDate is null  or @ToDate is null) or (cast(B.CreatedDate as date) between @FROMDate and @ToDate ))                  
  AND (AL.UserTypeID in(2,3,4,5) or @AgentTypeId ='')                             
   AND (AL.BookingCountry= @Country or @Country='')                             
  AND ( @BranchCode='')                       
  AND (B.AgentId=@AgentId or @AgentId='')   
  and pax.leadTraveler = 1  
  and b.bookingStatus='INVOICED' 
  --and b.overviewStatus='ON_HOLD'  
  --and b.PaymentMode is not null  
  and b.PaymentMode !='RiyaAgentSelfBalance' 
  --and b.PaymentMode='PaymentGateway  
                                    
 ) Rail order by Rail.[DateTime]                
       
 SELECT 'Air' AS Type,*                             
  , '' AS 'TravelType'                            
  , '' AS 'Booking Status'                            
  , '' AS 'Supplier Confirmation'                           
  , '' AS 'Mode of Payment'                              
  --, 0 AS 'Pax count'                                
  ,'' as 'Mode Of cancellation'                            
  , CAST(NULL AS DATETIME) CheckInDate                              
  , CAST(NULL AS DATETIME) CheckOutDate                   
   ,'' as Booking_PaymentMode                     
                             
 FROM #tempTableAASAir                              
 WHERE (@ProductType='ALL' OR @ProductType='Airline')                               
                              
 UNION                              
                              
 SELECT 'Hotel' AS Type, *                   
                 
 FROM #tempTableAASHotel                              
 WHERE (@ProductType='ALL' OR @ProductType='Hotel') and (CreditAmount not in ('0') or DebitAmount not in ('0') or [Booking Status]='Failed')     
    
 UNION                 
   SELECT 'Activity' AS Type, *                             
                           
 FROM #tempTableAASActivity                
 WHERE (@ProductType='ALL' OR @ProductType='Activity')                 
                 
 and (CreditAmount not in ('0') or DebitAmount not in ('0')                 
 or [Booking Status]='Failed')         
     
 UNION                              
                              
 SELECT 'Rail' AS Type, *                   
                 
 FROM #tempTableAASRail                              
 WHERE (@ProductType='ALL' OR @ProductType='Rail')    
                
 order by [DateTime]                  
                              
      
END 