--EXEC Sp_GetAgentAccountStatement '2025-04-01','2025-04-17','','All','2','','IN','Airline','',''      
CREATE  PROCEDURE [dbo].[Sp_GetAgentAccountStatement]       
 @FromDate Date=null       
 , @ToDate Date=null      
 , @BranchCode varchar(40) = ''      
 , @PaymentType varchar(50) = ''      
 , @AgentTypeId Varchar(50) = ''      
 , @AgentId int = ''      
 , @Country varchar(50)=''      
 , @ProductType varchar(20)      
 , @RiyaPNR varchar(20)=''      
 --JD 03.10.2022      
 , @MainAgentId Int=null      
AS      
BEGIN      
      
 Declare @TillDate DateTime      
 -- IF MAIN AGENT ID = 0 AND AGENT ID > 0       
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
 --END      
  --  -- -------------------------    
 IF(@ProductType='Airline')      
 BEGIN      
  IF(@PaymentType='Payment Gateway')      
  BEGIN      
   SELECT B.pkId AS BookMasterID      
   , ISNULL(R.Icast,R1.Icast) AS AgencyID      
   , ISNULL(R.AgencyName,R1.AgencyName) AS AgencyName      
   --, 'ICUST35086' AS AgencyID, 'B2CINDIA' AS AgencyName      
   --(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate)END) AS 'DateTime'      
   , CASE      
    WHEN B.BookingStatus=6 AND coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, b.BookingTrackModifiedOn)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN B.BookingStatus=6 AND coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, - 9*60*60 -29*60 -16, CONVERT(DATETIME, b.BookingTrackModifiedOn)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN B.BookingStatus=6 AND coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, - 9*60*60 -29*60 -16, CONVERT(DATETIME, b.BookingTrackModifiedOn)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN B.BookingStatus=6 AND coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, b.BookingTrackModifiedOn)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                WHEN B.BookingStatus!=6 AND coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- 1 hour, 29 minutes, and 13 seconds      
                WHEN B.BookingStatus!=6 AND coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, - 9*60*60 -29*60 -16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- 9 hours, 29 minutes, and 16 seconds      
                WHEN B.BookingStatus!=6 AND coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, - 9*60*60 -29*60 -16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- 9 hours, 29 minutes, and 16 seconds      
                WHEN B.BookingStatus!=6 AND coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, - 9*60*60 -29*60 -16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- 9 hours, 29 minutes, and 16 seconds      
                WHEN B.BookingStatus!=6 AND coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- No adjustment for India      
    END 'DateTime',  
 CASE      
        WHEN B.BookingStatus = 6 AND coun.CountryCode = 'AE'   
            THEN DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, b.BookingTrackModifiedOn))    
        WHEN B.BookingStatus = 6 AND coun.CountryCode IN ('US', 'CA')   
            THEN DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, b.BookingTrackModifiedOn))    
        WHEN B.BookingStatus = 6 AND coun.CountryCode = 'IN'   
            THEN CONVERT(DATETIME, b.BookingTrackModifiedOn)    
        WHEN B.BookingStatus != 6 AND coun.CountryCode = 'AE'   
            THEN DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate)))    
        WHEN B.BookingStatus != 6 AND coun.CountryCode IN ('US', 'CA')   
            THEN DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate)))    
        WHEN B.BookingStatus != 6 AND coun.CountryCode = 'IN'   
            THEN CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))    
    END AS 'DateTime1'  
   , B.airName + '(' + B.frmSector + '-' + B.toSector + ')' AS Description      
   , B.riyaPNR AS 'Booking id'      
   , B.GDSPNR AS CRSPNR      
   , (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS airlinePNR      
   , 0 AS CreditAmount,0 AS DebitAmount      
   , 0 AS Remaining      
   , 'Airline Sales' AS TransactionType      
   , (SELECT TOP 1 his.Remark FROM AgentHistory his WITH(NOLOCK)       
     WHERE CAST(his.UserId AS VARCHAR(50)) = b.AgentID order by his.InsertDate desc) AS Remark      
   , '' AS RefNo      
   --,'BOMRC' AS 'Branch Name','B2C' AS AgentType      
   , BR.Name AS 'Branch Name'      
   , C.Value AS AgentType      
   , al.BookingCountry AS Country      
   , coun.Currency AS 'Currency'      
   --( ISNULL(AL.UserName,''))  as 'Booked By',      
   , (SELECT TOP 1 ISNULL(AgencyName,'') FROM B2BRegistration WITH(NOLOCK)       
     WHERE CAST(FKUserID AS VARCHAR(50)) = B.AgentID) AS 'Booked By' --B.BookedBy      
   , (SELECT TOP 1 (pb.paxFName +' '+pb.paxLName) FROM tblPassengerBookDetails pb WITH(NOLOCK)       
     WHERE pb.fkBookMaster = b.pkId) AS  'Passenger name'      
   , UPPER(FORMAT(b.depDate, 'dd-MMM-yyyy')) AS 'Travel date'      
   FROM tblBookMaster B WITH(NOLOCK)      
   INNER JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId      
   LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=B.AgentID      
   --LEFT JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID      
   --LEFT JOIN mBranch BR ON BR.CODE=R.LocationCode      
   --LEFT JOIN mCommon C on C.ID=AL.UserTypeID      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID from agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)      
   LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode       
   LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50))=B.AgentID      
   LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID=AL.UserTypeID      
   LEFT JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId      
   INNER JOIN mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country       
    WHERE ((@FROMDate = '') OR (CONVERT(date,ISNULL(b.inserteddate_old,b.inserteddate)) >= CONVERT(date,@FROMDate)))      
    AND ((@ToDate = '') OR (CONVERT(date,ISNULL(b.inserteddate_old,b.inserteddate)) <= CONVERT(date, @ToDate)))      
    AND (((@BranchCode = '') OR ( R.LocationCode = @BranchCode)) OR ((@BranchCode != '' AND @BranchCode = 'BOMRC')))      
    --AND ((@AgentId = '') OR (b.AgentID = 'B2C'))      
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))--Piyush      
   AND ((@AgentId = '') OR (b.AgentID = CAST(@AgentId AS VARCHAR(50))))      
   AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))        
    AND  p.payment_modE NOT IN ('Credit','PassThrough','Hold','Check')      
   AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR))      
    AND (IsBooked=1 OR BookingStatus=1)      
      
   UNION      
      
   SELECT       
   0 AS BookMasterID      
   , Icast AS AgencyID      
   , AgencyName      
   --AB.CreatedOn AS 'DateTime',      
   , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime',     
    CASE       
    WHEN coun.CountryCode = 'AE' THEN DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon))  -- 1 hour, 29 minutes, 13 seconds      
    WHEN coun.CountryCode = 'US' THEN DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, 16 seconds      
    WHEN coun.CountryCode = 'CA' THEN DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon))  -- same as US      
    WHEN coun.CountryCode = 'IN' THEN CONVERT(DATETIME, ab.createdon)   -- No adjustment      
END AS 'DateTime1'  
   , (CASE WHEN AB.TransactionType='Debit' THEN 'Balance Debited :' else 'Balance Credited :' END) +       
     CAST(M.UserName + '-' + M.FullName AS varchar(50)) AS Description      
   , '' AS 'Booking id'      
   , '' AS CRSPNR      
   , '' AS airlinePNR      
   , (CASE WHEN AB.TransactionType='Credit' THEN ab.TranscationAmount else 0 END) AS CreditAmount      
   , (CASE WHEN AB.TransactionType='Debit' THEN ab.TranscationAmount else 0 END) AS DebitAmount      
   , AB.CloseBalance AS Remaining      
   --, 0 AS DropNetCommission      
   , 'Payment Gateway' AS TransactionType      
   , AB.Remark      
   , '' AS RefNo      
   , BR.Name AS 'Branch Name'      
   , C.Value AS AgentType      
, al.BookingCountry AS Country      
   , coun.Currency AS 'Currency'      
   , ISNULL(AL.UserName,'') AS 'Booked By'      
   , '' AS 'Passenger name'      
   , null AS 'Travel date'      
   --, R.CustomerType AS AccountType      
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
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
    AND ((@AgentId='') OR ( AB.AgentNo = cast(@AgentId AS varchar(50))))      
   AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))      
   AND AB.PaymentMode='PaymentGateway'      
   AND (@RiyaPNR = '')      
  END      
  ELSE      
  BEGIN      
   IF (@PaymentType = 'Wallet')      
   BEGIN      
    SET @PaymentType='Credit'      
   END      
      
   --Payment Gateway Start      
   SELECT      
  CAST(B.pkId AS VARCHAR(50)) AS BookMasterID      
  --, 'ICUST35086' as AgencyID      
  --, 'B2CINDIA' AS AgencyName      
  , ISNULL(R.Icast,R1.Icast) AS AgencyID      
  , ISNULL(R.AgencyName,R1.AgencyName) AS AgencyName      
  --(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn ELSE ISNULL(b.inserteddate_old,b.inserteddate)END) AS 'DateTime'      
  , CASE      
    WHEN B.BookingStatus=6 AND coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, b.BookingTrackModifiedOn)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN B.BookingStatus=6 AND coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, - 9*60*60 -29*60 -16, CONVERT(DATETIME, b.BookingTrackModifiedOn)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN B.BookingStatus=6 AND coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, - 9*60*60 -29*60 -16, CONVERT(DATETIME, b.BookingTrackModifiedOn)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN B.BookingStatus=6 AND coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, b.BookingTrackModifiedOn)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                WHEN B.BookingStatus!=6 AND coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- 1 hour, 29 minutes, and 13 seconds      
                WHEN B.BookingStatus!=6 AND coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, - 9*60*60 -29*60 -16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- 9 hours, 29 minutes, and 16 seconds      
                WHEN B.BookingStatus!=6 AND coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, - 9*60*60 -29*60 -16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- 9 hours, 29 minutes, and 16 seconds      
       WHEN B.BookingStatus!=6 AND coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, - 9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- 9 hours, 29 minutes, and 16 seconds      
                WHEN B.BookingStatus!=6 AND coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))), 'dd-MMM-yyyy HH:mm:ss')) -- No adjustment for India      
    END 'DateTime'   
 , CASE      
    WHEN B.BookingStatus = 6 AND coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, b.BookingTrackModifiedOn))    
    WHEN B.BookingStatus = 6 AND coun.CountryCode IN ('US', 'CA')   
        THEN DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, b.BookingTrackModifiedOn))    
    WHEN B.BookingStatus = 6 AND coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, b.BookingTrackModifiedOn)    
  
    WHEN B.BookingStatus != 6 AND coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate)))    
    WHEN B.BookingStatus != 6 AND coun.CountryCode IN ('US', 'CA')   
        THEN DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate)))    
    WHEN B.BookingStatus != 6 AND coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ISNULL(b.inserteddate_old, b.inserteddate))    
END AS 'DateTime1'  
  
  , B.airName + '(' + B.frmSector + '-' + B.toSector + ')' AS Description      
  , B.riyaPNR as 'Booking id'      
  , B.GDSPNR AS CRSPNR      
  , (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS airlinePNR      
  , 0 AS CreditAmount      
  , 0 AS DebitAmount      
  , 0 as Remaining      
  --, (SELECT SUM(DropnetCommission) FROM tblPassengerBookDetails tpbd WHERE fkBookMaster in (b.pkId)) AS DropNetCommission      
  , 'Airline Sales' as TransactionType      
  , (SELECT top 1 his.Remark FROM AgentHistory his WITH(NOLOCK) WHERE CAST(his.UserId AS VARCHAR(50)) = b.AgentID order by his.InsertDate desc) as Remark      
  , '' AS RefNo      
  --, 'BOMRC' AS 'Branch Name'      
  --, 'B2C' AS AgentType      
  , BR.Name AS 'Branch Name'      
  , C.Value AS AgentType      
  , al.BookingCountry as Country      
  , coun.Currency AS 'Currency'      
  --( ISNULL(AL.UserName,''))  as 'Booked By',      
  , (SELECT top 1 ISNULL(AgencyName,'') FROM B2BRegistration WITH(NOLOCK) where  CAST(FKUserID AS VARCHAR(50))=  B.AgentID) AS 'Booked By' --B.BookedBy      
  , (SELECT top 1 (pb.paxFName +' '+pb.paxLName)  FROM tblPassengerBookDetails pb WITH(NOLOCK) WHERE pb.fkBookMaster=b.pkId)  AS  'Passenger name'      
  , CAST(UPPER(FORMAT(b.depDate, 'dd-MMM-yyyy')) AS Varchar(50)) AS 'Travel date'      
  , R.CustomerType as AccountType      
  FROM tblBookMaster B      
  INNER JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId      
  LEFT JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50))=B.AgentID      
  --LEFT JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID      
  --LEFT JOIN mBranch BR ON BR.CODE=R.LocationCode      
  --LEFT JOIN mCommon C on C.ID=AL.UserTypeID      
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (select ParentAgentID  FROM agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)      
  LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode       
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50)) = B.AgentID      
  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID=AL.UserTypeID      
      
  LEFT join Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId      
  INNER join mCountry coun WITH(NOLOCK) on coun.CountryCode=b.Country       
  WHERE ((@FROMDate = '') OR (CONVERT(date,ISNULL(b.inserteddate_old,b.inserteddate)) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') OR (CONVERT(date,ISNULL(b.inserteddate_old,b.inserteddate)) <= CONVERT(date, @ToDate)))      
   AND (((@BranchCode = '') OR ( R.LocationCode = @BranchCode)) OR ((@BranchCode != '' AND @BranchCode = 'BOMRC')))      
   --AND ((@AgentId = '') OR (b.AgentID = 'B2C'))      
  AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))--Piyush      
  AND ((@AgentId = '') OR (b.AgentID = CAST(@AgentId AS VARCHAR(50))))      
  AND ((@Country = '') OR (al.BookingCountry  in (SELECT Data FROM sample_split(@Country, ','))))            
   AND p.payment_modE NOT IN ('Credit','PassThrough','Hold','Check')      
  AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR))      
   AND (IsBooked=1 OR BookingStatus=1)      
      
  UNION      
      
  SELECT       
  '0' AS BookMasterID      
  , Icast as AgencyID      
  , AgencyName      
  --AB.CreatedOn AS 'DateTime',      
  , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime' ,  
     CASE       
    WHEN coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon))  -- 1 hour, 29 minutes, 13 seconds      
    WHEN coun.CountryCode IN ('US', 'CA')   
        THEN DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)) -- 9 hours, 29 minutes, 16 seconds      
    WHEN coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ab.createdon)  -- No adjustment      
END AS 'DateTime1'  
  
  , (CASE WHEN AB.TransactionType='Debit' THEN 'Balance Debited :' else 'Balance Credited :' end) +       
    CAST(M.UserName + '-' + M.FullName as varchar(50)) AS Description      
  , '' as 'Booking id'      
  , '' AS CRSPNR      
  , '' as airlinePNR      
  , (CASE WHEN AB.TransactionType='Credit' then ab.TranscationAmount else 0 END) AS CreditAmount      
  , (CASE WHEN AB.TransactionType='Debit' then ab.TranscationAmount else 0 END) AS DebitAmount      
  , AB.CloseBalance as Remaining      
  --, 0 AS DropNetCommission      
  , 'Payment Gateway' as TransactionType      
  --0 AS 'Riya Markup',      
  , AB.Remark      
  , '' AS RefNo      
  , BR.Name as 'Branch Name'      
  , C.Value as AgentType      
  , al.BookingCountry as Country      
  , coun.Currency as 'Currency'      
  , ISNULL(AL.UserName,'') AS 'Booked By'      
  , '' AS 'Passenger name'      
  , null as 'Travel date'      
  , R.CustomerType as AccountType      
  from tblAgentBalance AB WITH(NOLOCK)      
  INNER JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=AB.AgentNo      
  INNER JOIN agentLogin AL WITH(NOLOCK) ON AL.UserID=R.FKUserID      
  left JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode      
  INNER JOIN mCommon C WITH(NOLOCK) on C.ID=AL.UserTypeID      
  inner join mCountry coun WITH(NOLOCK) on coun.CountryCode=al.BookingCountry      
  LEFT join mUser M WITH(NOLOCK) ON M.ID=AB.CreatedBy      
  WHERE ((@FROMDate = '') or (CONVERT(date,AB.CreatedOn) >= CONVERT(date,@FROMDate)))      
   AND ((@ToDate = '') or (CONVERT(date,AB.CreatedOn) <= CONVERT(date, @ToDate)))      
   AND ((@BranchCode = '') or ( R.LocationCode = @BranchCode))      
  AND ((@AgentTypeId = '') or ( AL.UserTypeID in (SELECT cast(Data as int) FROM sample_split(@AgentTypeId, ','))))      
   AND ((@AgentId='')  or ( AB.AgentNo = cast(@AgentId as varchar(50))))      
  AND ((@Country = '') or (al.BookingCountry  in (SELECT Data FROM sample_split(@Country, ','))))      
  -- and  AB.TransactionType in      
  --(CASE @PaymentType WHEN 'Credit' then AB.TransactionType WHEN '' then AB.TransactionType else @PaymentType end)      
     --AND( BookingRef='Cash' or  BookingRef='Credit')      
  AND  AB.PaymentMode='PaymentGateway'      
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
   , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime' ,  
     CASE       
    WHEN coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon))  -- AE: -1h29m13s  
    WHEN coun.CountryCode IN ('US', 'CA')   
        THEN DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon))  -- US/CA: -9h29m16s  
    WHEN coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ab.createdon)  -- IN: No adjustment  
END AS 'DateTime1'  
   --STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description',      
   , (SELECT STUFF((SELECT '/' + tblBookMaster.airName + '(' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector + ')'      
     FROM tblBookMaster WITH(NOLOCK)      
     WHERE tblBookMaster.riyaPNR = @RiyaPNR       
     FOR XML PATH ('')) , 1, 1, '')) AS 'Description'      
   , B.riyaPNR AS 'Booking id'      
   , B.GDSPNR AS CRSPNR      
   --, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS airlinePNR      
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
   , STUFF((SELECT '/' + cast(UPPER(FORMAT(s.depDate, 'dd-MMM-yyyy')) AS varchar(50)) FROM tblBookMaster s WITH(NOLOCK)       
     WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Travel date'      
   , R.CustomerType AS AccountType      
   FROM tblBookMaster B WITH(NOLOCK)      
   INNER JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId      
   INNER JOIN agentLogin AL WITH(NOLOCK) ON cast(AL.UserID AS VARCHAR(50))=B.AgentID      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID from agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)      
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
   --AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
    AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50))      
   OR (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID = CAST(@AgentId AS varchar(50) ))))       
   OR (b.AgentID =CAST(@AgentId AS varchar(50))))      
    AND ((@PaymentType='') OR (@PaymentType='all') OR ( PM.payment_mode = @PaymentType ))      
   AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))      
   AND (b.BookingStatus =4 OR b.BookingStatus=11 OR pb.BookingStatus=4 OR pb.BookingStatus=6)  and (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) and (pm.payment_mode='Check' OR pm.payment_mode='Credit') and (IsBooked=1 OR b.BookingStatus=1)      
   AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) and b.returnFlag=0      
      
   UNION      
              
   SELECT       
   --B.pkId AS BookMasterID,      
   (SELECT STUFF((SELECT '/' + CONVERT(Varchar(50), tblBookMaster.pkId) FROM tblBookMaster WITH(NOLOCK)      
    WHERE tblBookMaster.riyaPNR = @RiyaPNR FOR XML PATH ('')) , 1, 1, '')) AS BookMasterID      
   , ISNULL(r.Icast,r1.Icast) AS AgencyID      
   , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName      
   , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime'   
    , CASE       
    WHEN coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ab.createdon))  -- AE: -1h29m13s  
    WHEN coun.CountryCode IN ('US', 'CA')   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- US/CA: -9h29m16s  
    WHEN coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ab.createdon)  -- IN: no adjustment  
END AS 'DateTime1'  
  
   --STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description',      
   , (SELECT STUFF((SELECT '/' + tblBookMaster.airName + '(' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector + ')'       
     FROM tblBookMaster WITH(NOLOCK) WHERE tblBookMaster.riyaPNR = @RiyaPNR FOR XML PATH ('')) , 1, 1, '')) AS 'Description'      
   , B.riyaPNR AS 'Booking id'      
   , B.GDSPNR AS CRSPNR      
   --, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  airlinePNR      
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
   , STUFF((SELECT '/' + cast(UPPER(FORMAT(s.depDate, 'dd-MMM-yyyy')) AS varchar(50)) FROM tblBookMaster s WITH(NOLOCK)       
     WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Travel date'      
   , R.CustomerType AS AccountType      
   FROM tblBookMaster B WITH(NOLOCK)      
   INNER JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId -- OR P.ParentOrderId=B.orderId      
   INNER JOIN agentLogin AL WITH(NOLOCK) ON cast(AL.UserID AS VARCHAR(50))=B.AgentID      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID from agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)      
   LEFT JOIN mBranch BR WITH(NOLOCK) ON BR.CODE=R.LocationCode       
   LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON CAST(R1.FKUserID AS VARCHAR(50))=B.AgentID      
   LEFT JOIN mBranch BR1 WITH(NOLOCK) ON BR1.CODE=R1.LocationCode       
   INNER JOIN mCommon C WITH(NOLOCK) ON C.ID=AL.UserTypeID      
   --INNER JOIN Paymentmaster PM ON PM.order_id=B.orderId      
   INNER JOIN mCountry coun WITH(NOLOCK) ON coun.CountryCode=b.Country      
         LEFT JOIN tblAgentBalance ab WITH(NOLOCK) ON ab.BookingRef=b.orderId AND ab.TransactionType='Debit'      
   --LEFT JOIN tblAgentBalance ab on (ab.BookingRef=p.order_id and ab.BookingRef=p.ParentOrderId) and ab.TransactionType='Debit'      
    WHERE ISNULL(B.IsMultiTST, 0) = 1 AND ((@FROMDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) >= CONVERT(date,@FROMDate)))      
    AND ((@ToDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) <= CONVERT(date, @ToDate)))      
    AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))      
   --AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
    --  AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId))      
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
    AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50))      
   OR (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) )))))      
    AND ((@PaymentType='') OR (@PaymentType='all') OR ( P.payment_mode = @PaymentType ))      
   -- AND ((@Country = '') OR (al.BookingCountry = @Country))      
   AND ((@Country = '') OR (al.BookingCountry IN (SELECT Data FROM sample_split(@Country, ','))))      
    AND BookingStatus !=2 AND BookingStatus !=5 AND BookingStatus !=0 AND (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) AND (P.payment_mode='Check' OR P.payment_mode='Credit')      
   AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) AND b.returnFlag=0 AND (IsBooked=1 OR BookingStatus=1) AND b.totalFare>0      
      
   UNION      
      
   --added by bhavika pass through record      
   SELECT       
   --B.pkId AS BookMasterID,      
   (SELECT STUFF((SELECT '/' + CONVERT(Varchar(50), tblBookMaster.pkId) FROM tblBookMaster WITH(NOLOCK)      
     WHERE tblBookMaster.riyaPNR = @RiyaPNR FOR XML PATH ('')) , 1, 1, '')) AS BookMasterID      
   , ISNULL(r.Icast,r1.Icast) AS AgencyID      
   , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName      
   --(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate) END) AS 'DateTime' ,      
   --ISNULL(ab.createdon,(CASE WHEN B.BookingStatus=6 THEN b.BookingTrackModifiedOn else ISNULL(b.inserteddate_old,b.inserteddate) END)) AS 'DateTime' ,      
   , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime'       
    , CASE       
    WHEN coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon))  -- 1h 29m 13s offset  
    WHEN coun.CountryCode IN ('US', 'CA')   
        THEN DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon))  -- 9h 29m 16s offset  
    WHEN coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ab.createdon)  -- No offset  
END AS 'DateTime1'  
  
   --STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description',      
   , (SELECT STUFF((SELECT '/' + tblBookMaster.airName + '(' + tblBookMaster.frmSector + '-' + tblBookMaster.toSector + ')' FROM tblBookMaster WITH(NOLOCK)      
     WHERE tblBookMaster.riyaPNR = @RiyaPNR FOR XML PATH ('')) , 1, 1, '')) AS 'Description'      
   , B.riyaPNR AS 'Booking id'      
   , B.GDSPNR AS CRSPNR      
   --,(SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  airlinePNR      
   , STUFF((SELECT '/' + BI.airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.orderId = B.orderId       
     GROUP BY BI.airlinePNR FOR XML PATH('')),1,1,'') AS airlinePNR      
   --(CASE WHEN ab.TransactionType ='Credit' THEN ab.TranscationAmount else 0 END) AS CreditAmount,      
   , 0 AS CreditAmount      
   , ab.TranscationAmount AS DebitAmount      
   --ISNULL(b.b2bmarkup,0) AS 'Riya Markup',      
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
   , (SELECT TOP 1 (pb.paxFName +' '+pb.paxLName) from tblPassengerBookDetails pb WITH(NOLOCK)      
     WHERE pb.fkBookMaster=b.pkId) AS  'Passenger name'      
   , STUFF((SELECT '/' + cast(UPPER(FORMAT(s.depDate, 'dd-MMM-yyyy')) AS varchar(50)) FROM tblBookMaster s WITH(NOLOCK) WHERE s.orderId = b.orderId       
     FOR XML PATH('')),1,1,'') AS 'Travel date',R.CustomerType AS AccountType      
   FROM tblBookMaster B WITH(NOLOCK)      
   INNER JOIN agentLogin AL WITH(NOLOCK) ON cast(AL.UserID AS VARCHAR(50))=B.AgentID      
   LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID from agentLogin WITH(NOLOCK) WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)      
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
   --AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
    --  AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId))      
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
    AND ((@AgentId = '') OR (b.AgentID =cast(@AgentId AS varchar(50))      
   Or (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) from agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =cast(@AgentId AS varchar(50) )))))      
    AND ((@PaymentType='') OR  (@PaymentType='all') OR ( PM.payment_mode = @PaymentType ))      
   -- AND ((@Country = '') OR (al.BookingCountry = @Country))      
   AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))      
    AND BookingStatus !=2 and BookingStatus !=5 AND BookingStatus !=0 and (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) and (pm.payment_mode='passThrough')      
   AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) and b.returnFlag=0 and (IsBooked=1 OR BookingStatus=1)      
      
   UNION      
       
   SELECT       
   '0/0' AS BookMasterID      
   , Icast AS AgencyID      
   , AgencyName      
   --AB.CreatedOn AS 'DateTime',      
   , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime'   
    , CASE       
    WHEN coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ab.createdon))  -- 1 hour, 29 minutes, and 13 seconds      
    WHEN coun.CountryCode = 'US'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'CA'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ab.createdon)  -- No adjustment for India      
END AS 'DateTime1'  
   , (CASE WHEN AB.TransactionType='Debit' THEN 'Balance Debited :' else 'Balance Credited :' END) +       
     cast(M.UserName + '-' + M.FullName AS varchar(50)) AS Description      
   , '' AS 'Booking id'      
   , '' AS CRSPNR      
   , '' AS airlinePNR      
   , (CASE WHEN AB.TransactionType='Credit' THEN ab.TranscationAmount else 0 END ) AS CreditAmount      
   , (CASE WHEN AB.TransactionType='Debit' THEN ab.TranscationAmount else 0 END ) AS DebitAmount      
   , AB.CloseBalance AS Remaining      
   , 'Agent Balance Updation' AS TransactionType      
   --0 AS 'Riya Markup',      
   , AB.Remark      
   , 'REF'  + CONVERT(VARCHAR(50), AB.createdon,112) + cast(AB.PKID AS varchar(50)) AS RefNo      
   , BR.Name AS 'Branch Name'      
   , C.Value AS AgentType      
   , al.BookingCountry AS Country      
   , coun.Currency AS 'Currency'      
   , ( ISNULL(AL.UserName,'')) AS 'Booked By'      
   , '' AS  'Passenger name'      
   , null AS 'Travel date'      
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
   --AND ((@AccountType = '') OR ( R.CustomerType = @AccountType))      
    -- AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId))      
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT cast(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
    AND ((@AgentId='') OR ( AB.AgentNo = cast(@AgentId AS varchar(50))))      
   -- AND ((@Country = '') OR (al.BookingCountry = @Country))      
   AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))      
    and  AB.TransactionType in      
   (CASE @PaymentType WHEN 'Credit' THEN AB.TransactionType WHEN '' THEN AB.TransactionType       
   WHEN 'all' THEN AB.TransactionType      
   else @PaymentType END)      
      AND( BookingRef='Cash' OR BookingRef='Credit')      
   AND ((@RiyaPNR = ''))      
      
   UNION      
      
   --order by [DateTime] DESC      
   --  END      
   --  ELSE      
   --  BEGIN      
   SELECT       
   CONVERT(Varchar(50),B.pkId) AS BookMasterID      
   , ISNULL(r.Icast,r1.Icast) AS AgencyID      
   , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName      
   , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime'   
    , CASE       
    WHEN coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ab.createdon))  -- 1 hour, 29 minutes, and 13 seconds      
    WHEN coun.CountryCode = 'US'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'CA'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ab.createdon)  -- No adjustment for India      
END AS 'DateTime1'  
   , STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WITH(NOLOCK)      
     WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description'      
   , B.riyaPNR AS 'Booking id'      
   , B.GDSPNR AS CRSPNR      
   --, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  airlinePNR      
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
   , STUFF((SELECT '/' + CAST(UPPER(FORMAT(s.depDate, 'dd-MMM-yyyy')) AS varchar(50))FROM tblBookMaster s WITH(NOLOCK)      
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
         LEFT JOIN tblAgentBalance ab WITH(NOLOCK) on ab.BookingRef=b.orderId  AND ab.TransactionType='Credit'      
   LEFT JOIN tblPassengerBookDetails pb WITH(NOLOCK) on pb.fkBookMaster=b.pkId        
    WHERE ISNULL(b.IsMultiTST,0) != 1       
   AND ((@FROMDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn, b.inserteddate)) >= CONVERT(date,@FROMDate)))      
    AND ((@ToDate = '') OR (CONVERT(date,ISNULL(ab.CreatedOn,b.inserteddate)) <= CONVERT(date, @ToDate)))      
    AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))      
    --  AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId))      
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
    AND ((@AgentId = '')       
    OR (b.AgentID =CAST(@AgentId AS varchar(50))       
    OR (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) ))))       
    OR (b.AgentID =CAST(@AgentId AS varchar(50))))      
    AND ((@PaymentType='') OR  (@PaymentType='all') OR ( PM.payment_mode = @PaymentType ))      
   -- AND((@Country = '') OR (al.BookingCountry = @Country))      
   AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))      
   AND (b.BookingStatus =4 OR b.BookingStatus=11 OR pb.BookingStatus=4 OR pb.BookingStatus=6)  AND (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) AND (pm.payment_mode='Check' OR pm.payment_mode='Credit') AND (IsBooked=1 OR b.BookingStatus=1)      
   AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) AND b.returnFlag=0      
      
UNION      
      
   SELECT       
   CONVERT(Varchar(50),B.pkId) AS BookMasterID      
   , ISNULL(r.Icast,r1.Icast) AS AgencyID      
   , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName      
   , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime'     
    , CASE       
    WHEN coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ab.createdon))  -- 1 hour, 29 minutes, and 13 seconds      
    WHEN coun.CountryCode = 'US'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'CA'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ab.createdon)  -- No adjustment for India      
END AS 'DateTime1'  
   , STUFF((SELECT '/' + B.airName + '(' + B.frmSector + '-' + B.toSector + ')' FROM tblBookMaster s WITH(NOLOCK)      
     WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'') AS 'Description'      
   , B.riyaPNR AS 'Booking id'      
   , B.GDSPNR AS CRSPNR      
   --, (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WHERE BI.fkBookMaster=B.pkId) AS  airlinePNR      
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
   , STUFF((SELECT '/' + CAST(UPPER(FORMAT(s.depDate, 'dd-MMM-yyyy')) AS varchar(50))FROM tblBookMaster s WITH(NOLOCK)      
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
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
    AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50))      
    Or (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) )))))      
    AND ((@PaymentType='') OR (@PaymentType='all') OR ( P.payment_mode = @PaymentType ))      
   AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))      
    AND BookingStatus !=2 AND BookingStatus !=5 AND BookingStatus !=0 AND (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) AND (P.payment_mode='Check' OR P.payment_mode='Credit')      
   AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) AND b.returnFlag=0 AND (IsBooked=1 OR BookingStatus=1) AND b.totalFare>0      
      
   UNION      
      
   --added by bhavika pass through record      
   SELECT       
   CONVERT(Varchar(50),B.pkId) AS BookMasterID      
   , ISNULL(r.Icast,r1.Icast) AS AgencyId      
   , ISNULL(r.AgencyName,r1.AgencyName) AS AgencyName      
   , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime'  ,  
 CASE       
    WHEN coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ab.createdon))  -- 1 hour, 29 minutes, and 13 seconds      
    WHEN coun.CountryCode = 'US'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'CA'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ab.createdon)  -- No adjustment for India      
END AS 'DateTime1'  
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
   , STUFF((SELECT '/' + CAST(UPPER(FORMAT(s.depDate, 'dd-MMM-yyyy')) AS varchar(50))FROM tblBookMaster s WITH(NOLOCK)       
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
    -- AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId))      
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
    AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50))      
    Or (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WITH(NOLOCK) WHERE ParentAgentID =CAST(@AgentId AS varchar(50) )))))      
    AND ((@PaymentType='') OR (@PaymentType='all') OR ( PM.payment_mode = @PaymentType ))      
   -- AND ((@Country = '') OR (al.BookingCountry = @Country))      
   AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))      
    AND BookingStatus !=2 AND BookingStatus !=5 AND BookingStatus !=0 AND (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) AND (pm.payment_mode='passThrough')      
   AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) AND b.returnFlag=0 AND (IsBooked=1 OR BookingStatus=1)      
      
   UNION      
       
   SELECT       
   '0/0' AS BookMasterID      
   , Icast AS AgencyID      
   , AgencyName      
   --AB.CreatedOn AS 'DateTime',      
   , CASE       
                WHEN coun.CountryCode='AE' THEN UPPER(FORMAT(DATEADD(SECOND, -1*60*60 -29*60 -13, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 1 hour, 29 minutes, and 13 seconds      
                WHEN coun.CountryCode='US' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='CA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                 WHEN coun.CountryCode='SA' THEN UPPER(FORMAT(DATEADD(SECOND, -9*60*60 -29*60 -16, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))  -- 9 hours, 29 minutes, and 16 seconds      
                WHEN coun.CountryCode='IN' THEN UPPER(FORMAT(DATEADD(SECOND, 0, CONVERT(DATETIME, ab.createdon)), 'dd-MMM-yyyy HH:mm:ss'))   -- No adjustment for India      
                END AS 'DateTime',  
    CASE       
    WHEN coun.CountryCode = 'AE'   
        THEN DATEADD(SECOND, -1 * 60 * 60 - 29 * 60 - 13, CONVERT(DATETIME, ab.createdon))  -- 1 hour, 29 minutes, and 13 seconds      
    WHEN coun.CountryCode = 'US'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'CA'   
        THEN DATEADD(SECOND, -9 * 60 * 60 - 29 * 60 - 16, CONVERT(DATETIME, ab.createdon))  -- 9 hours, 29 minutes, and 16 seconds      
    WHEN coun.CountryCode = 'IN'   
        THEN CONVERT(DATETIME, ab.createdon)  -- No adjustment for India      
END AS 'DateTime1'  
   , (CASE WHEN AB.TransactionType='Debit' THEN 'Balance Debited :' ELSE 'Balance Credited :' END)       
     + CAST(M.UserName + '-' + M.FullName AS varchar(50)) AS Description      
   , '' AS 'Booking id'      
   , '' AS CRSPNR      
   , '' AS airlinePNR      
   , (CASE WHEN AB.TransactionType='Credit' THEN ab.TranscationAmount ELSE 0 END ) AS CreditAmount      
   , (CASE WHEN AB.TransactionType='Debit' THEN ab.TranscationAmount ELSE 0 END ) AS DebitAmount      
   , AB.CloseBalance AS Remaining      
   , 'Agent Balance Updation' AS TransactionType      
   --0 AS 'Riya Markup',      
   , AB.Remark      
   , 'REF'  + CONVERT(VARCHAR(50), AB.createdon,112) + CAST(AB.PKID AS varchar(50)) AS RefNo      
   , BR.Name AS 'Branch Name'      
   , C.Value AS AgentType      
   , al.BookingCountry AS Country      
   , coun.Currency AS 'Currency'      
   , ISNULL(AL.UserName,'')  as 'Booked By'      
   , '' AS  'Passenger name'      
   , null AS 'Travel date'      
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
    -- AND ((@AgentTypeId = '') OR ( AL.UserTypeID = @AgentTypeId))      
   AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
    AND ((@AgentId='') OR ( AB.AgentNo = CAST(@AgentId AS varchar(50))))      
   -- AND ((@Country = '') OR (al.BookingCountry = @Country))      
   AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))      
    AND  AB.TransactionType in (CASE @PaymentType WHEN 'Credit' THEN AB.TransactionType WHEN '' THEN      
    AB.TransactionType      
    WHEN 'ALL' THEN  AB.TransactionType      
    ELSE @PaymentType END)      
      AND( BookingRef='Cash' OR BookingRef='Credit')      
   AND ((@RiyaPNR = ''))   
   ORDER BY [DateTime1]       
  END      
   --SELECT ssr.* FROM tblSSRDetails ssr      
   --LEFT JOIN tblPassengerBookDetails pb ON pb.pid=ssr.fkPassengerid      
   --LEFT JOIN tblBookMaster B ON B.pkId=pb.fkBookMaster AND B.pkid=ssr.fkBookMaster      
   --INNER JOIN Paymentmaster P ON P.order_id=B.orderId      
   --INNER JOIN agentLogin AL ON CAST(AL.UserID AS VARCHAR(50))=B.AgentID      
   --LEFT JOIN B2BRegistration R ON CAST(R.FKUserID AS VARCHAR(50))= (SELECT ParentAgentID FROM agentLogin WHERE CAST(UserID AS VARCHAR(50))= B.AgentID)      
   --LEFT JOIN mBranch BR ON BR.CODE=R.LocationCode       
   --LEFT JOIN B2BRegistration R1 ON CAST(R1.FKUserID AS VARCHAR(50))=B.AgentID      
   --LEFT JOIN mBranch BR1 ON BR1.CODE=R1.LocationCode       
   --INNER JOIN mCommon C on C.ID=AL.UserTypeID      
   --INNER JOIN Paymentmaster PM ON PM.order_id=B.orderId      
   --INNER JOIN mCountry coun on coun.CountryCode=b.Country      
    --   LEFT JOIN tblAgentBalance ab on ab.BookingRef=b.orderId AND ab.TransactionType='Debit'      
   --WHERE ((@FROMDate = '') OR (CONVERT(date,ISNULL(b.inserteddate_old,b.inserteddate)) >= CONVERT(date,@FROMDate)))      
   -- AND ((@ToDate = '') OR (CONVERT(date,ISNULL(b.inserteddate_old,b.inserteddate)) <= CONVERT(date, @ToDate)))      
   -- AND ((@BranchCode = '') OR ( R.LocationCode = @BranchCode))      
   --AND ((@AgentTypeId = '') OR ( AL.UserTypeID in (SELECT CAST(Data AS int) FROM sample_split(@AgentTypeId, ','))))      
   -- AND ((@AgentId = '') OR (b.AgentID =CAST(@AgentId AS varchar(50)) Or (b.AgentID IN (SELECT CAST(UserID AS VARCHAR(50)) FROM agentLogin AL WHERE ParentAgentID =CAST(@AgentId AS varchar(50) )))))      
   -- AND ((@PaymentType='') OR ( PM.payment_mode = @PaymentType ))      
   --AND ((@Country = '') OR (al.BookingCountry in (SELECT Data FROM sample_split(@Country, ','))))      
   -- --AND b.BookingStatus !=2 AND b.BookingStatus !=5 AND b.BookingStatus !=0 AND (b.totalFare>0 OR (ISNULL(b.PreviousRiyaPNR,'')!='')) AND (pm.payment_mode='Check' OR pm.payment_mode='Credit')      
   --AND ((@RiyaPNR = '') OR (B.riyaPNR = @RiyaPNR)) AND b.returnFlag=0 AND (IsBooked=1 OR b.BookingStatus=1) AND b.totalFare>0      
      
 END      
END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentAccountStatement] TO [rt_read]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[Sp_GetAgentAccountStatement] TO [dbariya]
    AS [dbo];


GO
GRANT CONTROL
    ON OBJECT::[dbo].[Sp_GetAgentAccountStatement] TO [dbariya]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[Sp_GetAgentAccountStatement] TO [dbariya]
    AS [dbo];


GO
GRANT TAKE OWNERSHIP
    ON OBJECT::[dbo].[Sp_GetAgentAccountStatement] TO [dbariya]
    AS [dbo];


GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Sp_GetAgentAccountStatement] TO [dbariya]
    AS [dbo];

