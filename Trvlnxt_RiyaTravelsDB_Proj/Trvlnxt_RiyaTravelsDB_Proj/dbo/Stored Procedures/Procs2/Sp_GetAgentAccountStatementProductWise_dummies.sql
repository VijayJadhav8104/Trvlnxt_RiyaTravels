-- =============================================  
-- Author:  <Jitendra Nakum>  
-- Create date: <14.08.2023>  
-- Description: <This procedure is used to get Agent Account Statement Data Product Wise>  
-- =============================================  
--exec Sp_GetAgentAccountStatementProductWise '2023-12-01','2023-12-13','','','2','','IN','All',''  
CREATE PROCEDURE [dbo].[Sp_GetAgentAccountStatementProductWise_dummies]  
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
  
 IF OBJECT_ID ( 'tempdb..#tempTableAASAir') IS NOT NULL  
  DROP table #tempTableAASAir   
  
 IF (@PaymentType = 'Wallet')  
 BEGIN  
  SET @PaymentType='Credit'  
 END  
  
 --DECLARE @PaymentTypeHotel Varchar(50)  
 --SELECT @PaymentTypeHotel = CASE WHEN (@PaymentType = '223' OR @PaymentType = '224') THEN '1'  
 --  WHEN (@PaymentType = '204' OR @PaymentType = '209') THEN '2'  
 --  WHEN (@PaymentType = '206' OR @PaymentType = '210') THEN '3'  
 --  WHEN @PaymentType = '40' THEN '40'  
 --  END  
  
 SELECT * INTO #tempTableAASAir FROM (  
  --Payment Gateway Start  
  SELECT  
  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID  
  , ISNULL(R.Icast,R1.Icast) AS AgencyID  
  , ISNULL(R.AgencyName,R1.AgencyName) AS AgencyName  
  , CASE  
    WHEN B.BookingStatus = 6 AND  coun.CountryCode = 'AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13,CONVERT(varchar(20),b.BookingTrackModifiedOn,120))) -- 1 hour, 29 minutes AND 13 seconds  
    WHEN B.BookingStatus = 6 AND  coun.CountryCode = 'US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(20),b.BookingTrackModifiedOn,120))) -- 9 hour, 29 minutes AND 16 seconds  
    WHEN B.BookingStatus = 6 AND  coun.CountryCode = 'CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(20),b.BookingTrackModifiedOn,120))) -- 9 hour, 29 minutes AND 16 seconds  
    WHEN B.BookingStatus = 6 AND  coun.CountryCode = 'IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),b.BookingTrackModifiedOn,120))   -- 0 hour, 0 minutes AND 0 seconds     
    WHEN B.BookingStatus != 6 AND  coun.CountryCode = 'AE' THEN (DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13,CONVERT(varchar(20),ISNULL(b.inserteddate_old,b.inserteddate),120))) -- 1 hour, 29 minutes AND 13 seconds  
    WHEN B.BookingStatus != 6 AND  coun.CountryCode = 'US' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(20),ISNULL(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes AND 16 seconds  
    WHEN B.BookingStatus != 6 AND  coun.CountryCode = 'CA' THEN (DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16,CONVERT(varchar(20),ISNULL(b.inserteddate_old,b.inserteddate),120))) -- 9 hour, 29 minutes AND 16 seconds  
    WHEN B.BookingStatus != 6 AND  coun.CountryCode = 'IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(b.inserteddate_old,b.inserteddate),120))   -- 0 hour, 0 minutes AND 0 seconds        
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
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))) -- 1 hour, 29 minutes and13 seconds       
 WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))) -- 9 hour, 29 minutes and 16 seconds      
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))) -- 9 hour, 29 minutes and 16 seconds        
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))   -- 0 hour, 0 minutes and 0 seconds     
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
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120))) -- 1 hour, 29 minutes and 13 seconds       
WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate)END)),120))) -- 9 hour, 29 minutes and 16 seconds       
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120))) -- 9 hour, 29 minutes and 16 seconds      
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120))   -- 0 hour, 0 minutes and 0 seconds   
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
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate) END)),120))) -- 1 hour, 29 minutes and 13 seconds       
WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate)END)),120))) -- 9 hour, 29 minutes and 16 seconds      
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate) END)),120))) -- 9 hour, 29 minutes and 16 seconds       
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate) END)),120))   -- 0 hour, 0 minutes and 0 seconds       
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
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ab.createdon,120))) -- 1 hour, 29 minutes and 13 seconds       WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120))) -- 9 hour, 29 minutes and 16 seconds       WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120))) -- 9 hour, 29 minutes and 16 seconds     
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
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))) -- 1 hour, 29 minutes AND13 seconds   
 WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))) -- 9 hour, 29 minutes AND 16 seconds       
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))) -- 9 hour, 29 minutes AND 16 seconds      
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(ab.CreatedOn,b.inserteddate)END)),120))   -- 0 hour, 0 minutes AND 0 seconds        
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
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120))) -- 1 hour, 29 minutes AND 13 seconds       
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate)END)),120))) -- 9 hour, 29 minutes AND 16 seconds       
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120))) -- 9 hour, 29 minutes AND 16 seconds        
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120))   -- 0 hour, 0 minutes AND 0 seconds        
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
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120))) -- 1 hour, 29 minutes AND 13 seconds        
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate)END)),120))) -- 9 hour, 29 minutes AND 16 seconds      
WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate) END)),120))) -- 9 hour, 29 minutes AND 16 seconds     
WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate
) END)),120))   -- 0 hour, 0 minutes AND 0 seconds      
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
  , CASE WHEN coun.CountryCode='AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(varchar(20),ab.createdon,120))) -- 1 hour, 29 minutes AND 13 seconds       
  WHEN coun.CountryCode='US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120))) -- 9 hour, 29 minutes AND 16 seconds       WHEN coun.CountryCode='CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(varchar(20),ab.createdon,120))) -- 9 hour, 29 minutes AND 16 seconds  
  WHEN coun.CountryCode='IN' THEN DATEADD(SECOND, 0,CONVERT(varchar(20),ab.createdon,120))   -- 0 hour, 0 minutes AND 0 seconds   
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
  --IF(@PaymentType='3')   
  --BEGIN  
   SELECT  
   CAST(B.pkId AS VARCHAR(50)) AS BookMasterID  
   , BR.Icast as 'AgencyID'  
   , BR.AgencyName AS 'AgencyName'  
   , SH.CreateDate AS 'DateTime'  
   , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'  
   , BookingReference AS 'Booking id'  
   , B.riyaPNR AS 'Riya / CRSPNR'  
   , '' AS AirlinePNR  
   , CASE WHEN P.order_status = 'Cancelled' THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0'END AS 'CreditAmount'  
   , CASE WHEN P.order_status = 'Success' THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0' END AS 'DebitAmount'  
   , '0' AS 'Remaining'  
   , 'HotelSales' AS 'Service Type'  
   , '' AS 'Remark'  
   , '' AS RefNo  
   , '' AS 'Branch Name'  
   , c.Value AS 'AgentType'  
   , AL.bookingcountry AS 'Country'  
   , coun.Currency AS 'Currency'  
   , Al.UserName as 'Booked By'  
   , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'  
   , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'  
     
   , sm.STATUS AS 'Booking Status' 
   ,'' as 'Account Type'
   , B.providerConfirmationNumber AS 'Supplier confirmation'  
   , P.payment_mode AS 'Mode of Payment' 
   ,B.ModeOfCancellation as 'Mode of Cancellation '
   , cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'  
   , B.CheckInDate  
   , B.CheckOutDate   
   FROM Hotel_BookMaster B WITH(NOLOCK)  
   LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID  
   LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id = B.orderId   
   LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY  
   LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID  
   LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID  
   LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId   
   LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id  
   WHERE P.amount IS NOT NULL  
   AND SH.IsActive = 1  
   AND RiyaAgentID IS NOT NULL   
   AND B.BookingReference IS NOT NULL  
   AND (@PaymentType = '3' AND B2BPaymentMode = 3)   
   AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))  
   AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')   
   AND (AL.BookingCountry= @Country or @Country='')   
   AND (B.BranchCode =@BranchCode or @BranchCode='')  
   AND (B.RiyaAgentID=@AgentId or @AgentId='')  
  --END  
  ----IF(@PaymentType='Walllet')   
  --IF(@PaymentType='2')   
  --BEGIN  
    
  UNION   
  
  SELECT  
  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID  
  , BR.Icast as 'AgencyID'  
  , BR.AgencyName AS 'AgencyName'  
  , SH.CreateDate AS 'DateTime'  
  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'  
  , BookingReference AS 'Booking id'  
  , B.riyaPNR AS 'Riya / CRSPNR'  
  , '' AS airlinePNR  
  , CASE WHEN AB.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0')) ELSE '0' END AS 'CreditAmount'  
  , CASE WHEN AB.TransactionType = 'Debit' THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0')) ELSE '0' END AS 'DebitAmount'  
  , AB.CloseBalance AS 'Remaining'  
  , 'HotelSales' AS 'Service Type'  
  , '' AS 'Remark'  
  , '' AS RefNo  
  , '' AS 'Branch Name'  
  , c.Value AS 'AgentType'  
  , AL.bookingcountry AS 'Country'  
  , coun.Currency AS 'Currency'   
  , Al.UserName as 'Booked By'  
  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'  
  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'  
     
  , sm.STATUS AS 'Booking Status'
  ,'' as 'Account Type'
  , B.providerConfirmationNumber AS 'Supplier confirmation'  
  , '' as 'Mode of Payment'
  ,B.ModeOfCancellation as 'Mode of Cancellation'
  , cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'  
  , B.CheckInDate  
  , B.CheckOutDate  
  FROM Hotel_BookMaster B WITH(NOLOCK)  
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID  
  LEFT JOIN tblAgentBalance ab WITH(NOLOCK) ON ab.BookingRef = B.orderId   
  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY  
  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID  
  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID  
  LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId  
  LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id  
  WHERE ab.TranscationAmount IS NOT NULL  
  AND SH.IsActive = 1  
  AND RiyaAgentID IS NOT NULL  
  AND B.BookingReference is not NULL   
  AND (@PaymentType = '2' AND B.B2BPaymentMode = 2)  
  AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))  
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')   
  AND (AL.BookingCountry= @Country or @Country='')   
  AND (BR.BranchCode =@BranchCode or @BranchCode='')  
  AND (B.RiyaAgentID=@AgentId or @AgentId='')  
  
   --order by [Booking Date] desc  
  --END  
  ----IF(@PaymentType='Credit')  
  --IF(@PaymentType='40')  
  --Begin  
   --Credit Debit top up   
     
  UNION  
  
  SELECT  
  '0' AS BookMasterID  
  , BR.Icast as 'AgencyID'  
  , BR.AgencyName AS 'AgencyName'  
  , TAB.CreatedOn AS 'Booking Date'  
  , '' AS 'Description'  
  , '' AS 'Booking id'  
  , '' AS 'Riya / CRSPNR'  
  , '' AS airlinePNR  
  , CASE WHEN tab.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0' END AS 'CreditAmount'  
  , CASE WHEN tab.TransactionType = 'Debit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0' END AS 'DebitAmount'  
  , TAB.CloseBalance AS 'Remaining'  
  , 'TOP-UP' AS 'Service Type'  
  , '' AS 'Remark'  
  , '' AS RefNo  
  , '' AS 'Branch Name'  
  , c.Value AS 'AgentType'  
  , AL.bookingcountry AS 'Country'  
  , '' AS 'Currency'  
  , Al.UserName as 'Booked By'  
  , '' AS 'Passenger name'  
  , '' AS 'Travel date'  
  , '' AS 'Booking Status'
  ,'' as 'Account Type'
  , '' AS 'Supplier confirmation'  
  , '' AS 'Mode of Payment'
  ,'' as 'Mode of Cancellation'
  , '' AS 'Pax count'  
  , '' as CheckInDate  
  , '' as CheckOutDate  
  FROM tblAgentBalance TAB WITH(NOLOCK)   
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON TAB.AgentNo = BR.FKUserID  
  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON TAB.AgentNo = AL.UserID   
  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID  
  WHERE (@PaymentType='40' AND BookingRef IN ('Cash','Credit'))  
  AND ((@FROMDate = '' or @ToDate='') or (cast(TAB.CreatedOn as date) between @FROMDate and @ToDate ))  
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')   
  AND (AL.BookingCountry= @Country or @Country='')   
  AND (BR.BranchCode =@BranchCode or @BranchCode='')  
  AND (TAB.AgentNo=@AgentId or @AgentId='')  
  
  --End  
  ----IF(@PaymentType='Hold')   
  --IF(@PaymentType='1')   
  --BEGIN  
   --   
  UNION   
  
  SELECT  
  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID  
  , BR.Icast as 'AgencyID'  
  , BR.AgencyName AS 'AgencyName'  
  , SH.CreateDate AS 'DateTime'  
  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'  
  , BookingReference AS 'Booking id'  
  , B.riyaPNR AS 'Riya / CRSPNR'  
  , '' AS airlinePNR  
  , '0' AS 'CreditAmount'  
  , convert(VARCHAR(50), ISNULL(B.DisplayDiscountRate, '0')) AS 'DebitAmount'  
  , '0' AS 'Remaining'  
  , 'HotelSales' AS 'Service Type'  
  , '' AS 'Remark'  
  , '' AS RefNo  
  , '' AS 'Branch Name'  
  , c.Value AS 'AgentType'  
  , AL.bookingcountry AS 'Country'  
  , coun.Currency AS 'Currency'  
  , Al.UserName as 'Booked By'  
  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'  
  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'  
  , sm.STATUS AS 'Booking Status' 
  ,'' as 'Account Type'
  , B.providerConfirmationNumber AS 'Supplier confirmation'   
  , '' AS 'Mode of Payment'  
  ,B.ModeOfCancellation as 'Mode of cancellation'
  , cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'  
  , B.CheckInDate  
  , B.CheckOutDate   
  FROM Hotel_BookMaster B WITH(NOLOCK)  
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID   
  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY  
  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID  
  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID  
  LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId  
  LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id  
  WHERE SH.IsActive = 1  
  AND RiyaAgentID IS NOT NULL  
  AND B.BookingReference IS NOT NULL  
  AND (@PaymentType='1' AND B.B2BPaymentMode IN (4,1))  
  AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))  
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')   
  AND (AL.BookingCountry= @Country or @Country='')   
  AND (BR.BranchCode =@BranchCode or @BranchCode='')  
  AND (B.RiyaAgentID=@AgentId or @AgentId='')  
  --END  
  ----IF(@PaymentType='') All   
  --IF(@PaymentType='')   
  --BEGIN  
  -- (  
  
  UNION   
  
  SELECT  
  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID  
  , BR.Icast as 'AgencyID'  
  , BR.AgencyName AS 'AgencyName'  
  , SH.CreateDate AS 'DateTime' 
  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'  
  , BookingReference AS 'Booking id'  
  , B.riyaPNR AS 'Riya / CRSPNR'  
  , '' AS airlinePNR  
  , CASE WHEN P.order_status = 'Cancelled' THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0'END AS 'CreditAmount'  
  , CASE WHEN P.order_status = 'Success' THEN convert(VARCHAR(50), ISNULL(P.amount, '0')) ELSE '0' END AS 'DebitAmount'  
  , '0' AS 'Remaining'  
  , 'HotelSales' AS 'Service Type'  
  , '' AS 'Remark'  
  , '' AS RefNo  
  , '' AS 'Branch Name'  
  , c.Value AS 'AgentType'  
  , AL.bookingcountry AS 'Country'  
  , coun.Currency AS 'Currency'  
  , Al.UserName as 'Booked By'  
  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'  
  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'  
  
  , sm.STATUS AS 'Booking Status' 
  ,'' as 'Account Type'
  , B.providerConfirmationNumber AS 'Supplier confirmation'  
  , P.payment_mode AS 'Mode of Payment' 
  ,B.ModeOfCancellation as 'Mode of Cancellation'
  , cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'  
  , B.CheckInDate  
  , B.CheckOutDate   
  FROM Hotel_BookMaster B WITH(NOLOCK)  
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID  
  LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id = B.orderId   
  LEFT JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY  
  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID  
  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID  
  LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId   
  LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id  
  WHERE P.amount IS NOT NULL  
  AND SH.IsActive = 1  
  AND RiyaAgentID IS NOT NULL   
  AND B.BookingReference IS NOT NULL  
  AND (@PaymentType = '' AND B2BPaymentMode = 3)  
  AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))  
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')   
  AND (AL.BookingCountry= @Country or @Country='')   
  AND (B.BranchCode =@BranchCode or @BranchCode='')  
  AND (B.RiyaAgentID=@AgentId or @AgentId='')  
   
  UNION  
   
  SELECT  
  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID  
  , BR.Icast as 'AgencyID'  
  , BR.AgencyName AS 'AgencyName'  
  , SH.CreateDate AS 'DateTime'  
  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'  
  , BookingReference AS 'Booking id'  
  , B.riyaPNR AS 'Riya / CRSPNR'  
  , '' AS airlinePNR  
  , CASE WHEN AB.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0')) ELSE '0' END AS 'CreditAmount'  
  , CASE WHEN AB.TransactionType = 'Debit' THEN convert(VARCHAR(50), ISNULL(ab.TranscationAmount, '0')) ELSE '0' END AS 'DebitAmount'  
  , AB.CloseBalance AS 'Remaining'  
  , 'HotelSales' AS 'Service Type'  
  , '' AS 'Remark'  
  , '' AS RefNo  
  , '' AS 'Branch Name'  
  , c.Value AS 'AgentType'  
  , AL.bookingcountry AS 'Country'  
  , coun.Currency AS 'Currency'  
  , Al.UserName as 'Booked By'  
  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'  
  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'  
  
  , sm.STATUS AS 'Booking Status' 
  ,'' as 'Account Type'
  , B.providerConfirmationNumber AS 'Supplier confirmation'  
  , '' as 'Mode of Payment' 
  ,B.ModeOfCancellation as 'Mode of Cancellation'
  , cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'  
  , B.CheckInDate  
  , B.CheckOutDate   
  FROM Hotel_BookMaster B WITH(NOLOCK)  
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID  
  LEFT JOIN tblAgentBalance ab WITH(NOLOCK) ON ab.BookingRef = B.orderId   
  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY  
  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID  
  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID  
  LEFT JOIN Hotel_Status_History SH WITH(NOLOCK) ON B.pkId = SH.FKHotelBookingId  
  LEFT JOIN Hotel_Status_Master SM WITH(NOLOCK) ON SH.FkStatusId = SM.Id  
  WHERE ab.TranscationAmount IS NOT NULL  
  AND SH.IsActive = 1  
  AND RiyaAgentID IS NOT NULL  
  AND B.BookingReference is not NULL  
  AND (@PaymentType = '' AND B.B2BPaymentMode = 2)  
  AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate ))  
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')  
  AND (AL.BookingCountry= @Country or @Country='')  
  AND (BR.BranchCode =@BranchCode or @BranchCode='')  
  AND (B.RiyaAgentID=@AgentId or @AgentId='')  
  
  UNION   
   
  --Credit Debit top up  
  SELECT  
  '0' AS BookMasterID  
  , BR.Icast as 'AgencyID'  
  , BR.AgencyName AS 'AgencyName'  
  , TAB.CreatedOn AS 'Booking Date'   
  , '' AS 'Description'  
  , '' AS 'Booking id'  
  , '' AS 'Riya / CRSPNR'  
  , '' AS airlinePNR  
  , CASE WHEN tab.TransactionType = 'Credit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0' END AS 'CreditAmount'  
  , CASE WHEN tab.TransactionType = 'Debit' THEN convert(VARCHAR(50), ISNULL(TAB.TranscationAmount, '0')) ELSE '0' END AS 'DebitAmount'  
  , TAB.CloseBalance AS 'Remaining'  
  , 'TOP-UP' AS 'Service Type'  
  , '' AS 'Remark'  
  , '' AS RefNo  
  , '' AS 'Branch Name'  
  , c.Value AS 'AgentType'  
  , AL.bookingcountry AS 'Country'  
  , '' AS 'Currency'  
  , Al.UserName as 'Booked By'  
  , '' AS 'Passenger name'  
  , '' AS 'Travel date'  
    
  , '' AS 'Booking Status'
  ,'' as 'Account Type'
  , '' AS 'Supplier confirmairlinePNR'  
  , '' AS 'Mode of Payment'
  ,'' as 'Mode of cancellation'
  , '' AS 'Pax count'  
  , '' as CheckInDate  
  , '' as CheckOutDate  
  FROM tblAgentBalance TAB WITH(NOLOCK)  
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON TAB.AgentNo = BR.FKUserID  
  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON TAB.AgentNo = AL.UserID  
  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID  
  WHERE (@PaymentType = '' AND BookingRef IN ('Cash','Credit'))  
  AND ((@FROMDate = '' or @ToDate='') or (cast(TAB.CreatedOn as date) between @FROMDate and @ToDate ))  
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')   
  AND (AL.BookingCountry= @Country or @Country='')   
  AND (BR.BranchCode =@BranchCode or @BranchCode='')  
  AND (TAB.AgentNo=@AgentId or @AgentId='')  
   
  UNION  
   
  SELECT  
  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID  
  , BR.Icast as 'AgencyID'  
  , BR.AgencyName AS 'AgencyName'  
  , SH.CreateDate AS 'DateTime'  
  , (B.HotelName + ' ' + B.HotelAddress1) AS 'Description'  
  , BookingReference AS 'Booking id'  
  , B.riyaPNR AS 'Riya / CRSPNR'  
  , '' AS airlinePNR  
  , '0' AS 'CreditAmount'  
  , convert(VARCHAR(50), ISNULL(B.DisplayDiscountRate, '0')) AS 'DebitAmount'  
  , '0' AS 'Remaining'  
  , 'HotelSales' AS 'Service Type'  
  , '' AS 'Remark'  
  , '' AS RefNo  
  , '' AS 'Branch Name'  
  , c.Value AS 'AgentType'  
  , AL.bookingcountry AS 'Country'  
  , coun.Currency AS 'Currency'  
  , Al.UserName as 'Booked By'  
  , B.LeaderTitle + ' ' + B.LeaderFirstName + ' ' + B.LeaderLastName AS 'Passenger name'  
  , CONVERT(VARCHAR, B.CheckInDate, 101) + '-' + CONVERT(VARCHAR, B.CheckOutDate, 101) AS 'Travel date'  
  
  , sm.STATUS AS 'Booking Status'
  ,'' as 'Account Type'
  , B.providerConfirmationNumber AS 'Supplier confirmation'  
  , '' AS 'Mode of Payment'  
  ,B.ModeOfCancellation as 'Mode of Cancellation'
  , cast(Cast(TotalAdults as int) + Cast(TotalChildren as int) as int) AS 'Pax count'  
  , B.CheckInDate  
  , B.CheckOutDate  
  FROM Hotel_BookMaster B WITH(NOLOCK)  
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON B.RiyaAgentID = BR.FKUserID  
  INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode = b.BOOKINGCOUNTRY  
  LEFT JOIN AgentLogin AL WITH(NOLOCK) ON B.RiyaAgentID = AL.UserID  
  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID  
  LEFT JOIN Hotel_Status_History SH ON B.pkId = SH.FKHotelBookingId  
  LEFT JOIN Hotel_Status_Master SM ON SH.FkStatusId = SM.Id  
  WHERE SH.IsActive = 1   
  AND RiyaAgentID IS NOT NULL  
  AND B.BookingReference IS NOT NULL  
  AND (@PaymentType = '' AND B.B2BPaymentMode IN (4,1))  
  AND ((@FROMDate = '' or @ToDate='') or (cast(B.inserteddate as date) between @FROMDate and @ToDate))  
  AND (AL.UserTypeID= @AgentTypeId or @AgentTypeId ='')  
  AND (AL.BookingCountry= @Country or @Country='')  
  AND (BR.BranchCode =@BranchCode or @BranchCode='')  
  AND (B.RiyaAgentID=@AgentId or @AgentId='')  
 ) Hotel order by Hotel.[DateTime]  
  
 SELECT 'Air' AS Type,*  
  , '' AS 'Booking Status'  
  , '' AS 'Supplier confirmairlinePNR'  
  , '' AS 'Mode of Payment'  
  , 0 AS 'Pax count'  
  , CAST(NULL AS DATETIME) CheckInDate  
  , CAST(NULL AS DATETIME) CheckOutDate  
 FROM #tempTableAASAir  
 WHERE (@ProductType='ALL' OR @ProductType='Airline')   
  
 UNION  
  
 SELECT 'Hotel' AS Type, *, '' AS AccountType FROM #tempTableAASHotel  
 WHERE (@ProductType='ALL' OR @ProductType='Hotel')   
  
END