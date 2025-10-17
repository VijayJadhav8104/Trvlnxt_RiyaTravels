CREATE PROCEDURE [dbo].[Sp_GetBookingTrackReport_Optimize_JN1] 
 @FromDate Datetime=null,     
 @ToDate Datetime=null,     
 @PaymentType varchar(50)=null,    
 @UserType varchar(max)=null,     
 @Country varchar(max)=null,    
 @AgentId int=null,    
 @SubUserId int=null,    
 @Status varchar(2)=null,    
 @ProductType varchar(20)=null,    
 @BookingType varchar(20)=null,    
 @AirportType varchar(20)=null,    
 @Airline varchar(max)=null,    
 @CRS varchar(20)=null,     
 @BookingId varchar(50)=null,    
 @AirlinePnr varchar(50)=null,    
 @GDSPnr varchar(50)=null,    
 @Start int=null,    
 @Pagesize int=null,    
 @JournyType Varchar(50)=null,    
 @officeid VARCHAR(100)='',    
 @StaffID INT='',    
 @IsPaging bit=null,    
 @RecordCount INT OUTPUT    
AS    

BEGIN    
 --select top 1000 * from tblBookMaster order by inserteddate_old desc    
    
 DECLARE @FirstRecord Int,@LastRecord Int,@TotalRecords Int,@TotalPage Int    
 --SET ARITHABORT ON    
 DECLARE @DATA TABLE(    
  SrNo INT    
  , [Country] Varchar(50)    
  , [User Type] Varchar(50)    
  , [Agency Name] Varchar(500)    
  , [Cust id] Varchar(50)    
  --, [Booking date & time] Varchar(50)    
  , [Booking date & timeSort] datetime    
  , [Track ID] Varchar(50)    
  , [Status] Varchar(50)    
  , [Booking id] Varchar(20)    
  , [Airline PNR] Varchar(50)    
  , [CRS PNR] Varchar(50)    
  , Remarks Varchar(MAX)    
  , [User] Varchar(500)    
  , Airport Varchar(50)    
  , [Airline name] Varchar(50)    
  , Sector Varchar(MAX)    
  , [Flight No] Varchar(MAX)    
  , [Class Code] Varchar(MAX)    
  , [Dep Date all] Varchar(MAX)    
  , [Arrvl Date all] Varchar(MAX)    
  , [Dep Date] Varchar(50)    
  , [Arrvl Date] Varchar(50)    
  , [Payment Mode] Varchar(50)    
  , Currency Varchar(20)    
  , [Net fare] Decimal(18,2)    
  , [Gross fare] Decimal(18,2)    
  , [MCO Amount] Decimal(18,2)    
  , [UpdatedDate] Varchar(50)    
  , [UpdatedbyUser] Varchar(50)    
  , [UpdatedUserRemarks] Varchar(MAX)    
  , [Booking Mode] Varchar(500)     
  , CRS Varchar(50)    
  , [Booking Supplier] Varchar(50)     
  , [Ticketing Suppier] Varchar(50)     
  , [Agent Currency] Varchar(50)     
  , ROE Varchar(50)    
  , TFBookingRef Varchar(50)    
  , TFBookingstatus Varchar(50)    
  , [Bank Ref No.] Varchar(50)    
  , [Order Status] Varchar(50)    
  , [Failure_Message] Varchar(MAX)    
  , [PG_Charges] decimal(18,2)    
  , [bank_ref_no] Varchar(100)    
  , [Journey_Type] Varchar(20)    
  , [Fare_Type] Varchar(100)    
 )    
     
 --IF(@CRS='Air India Express' OR @CRS='3L Air Arabia' OR @CRS='Air Arabia')    
 --BEGIN    
 -- SET @CRS=@CRS    
 --END    
 --ELSE    
 --BEGIN    
  SET @CRS=REPLACE(@CRS, ' ', '');    
 --END    
    
 IF(@IsPaging=1)    
 BEGIN    
  insert into @DATA    
  SELECT     
  ROW_NUMBER() OVER (ORDER BY ISNULL(b.inserteddate_old,b.inserteddate) DESC) AS SrNo    
  , AL.BookingCountry AS 'Country'    
  , c.Value AS 'User Type'    
  , ISNULL(R.AgencyName,R1.AgencyName) AS 'Agency Name'    
  , ISNULL(R.Icast,R1.Icast) AS 'Cust id'    
  --, (CASE country.CountryCode     
  --  WHEN 'AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(DATETIME, ISNULL(b.IssueDate, ISNULL(b.inserteddate_old,b.inserteddate)))))     
  --     WHEN 'US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(DATETIME, ISNULL(b.IssueDate, ISNULL(b.inserteddate_old,b.inserteddate)))))     
  --     WHEN 'CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(DATETIME, ISNULL(b.IssueDate, ISNULL(b.inserteddate_old,b.inserteddate)))))     
  --  WHEN 'UK' THEN (DATEADD(SECOND, - 5*60*60 + 30*60, CONVERT(DATETIME, ISNULL(b.IssueDate, ISNULL(b.inserteddate_old,b.inserteddate)))))    
  --     WHEN 'IN' THEN DATEADD(SECOND, 0, CONVERT(DATETIME, ISNULL(b.IssueDate, ISNULL(b.inserteddate_old,b.inserteddate))))    
  --   END) AS 'Booking date & timeSort'    
  , CONVERT(DATETIME, ISNULL(b.IssueDate, ISNULL(b.inserteddate_old,b.inserteddate))) AS 'Booking date & timeSort'    
  , b.orderId AS 'Track ID'    
  , (CASE WHEN (b.BookingStatus=1 or b.BookingStatus=6) THEN 'Confirmed' WHEN B.BookingStatus=2 THEN 'Hold' WHEN B.BookingStatus=3 THEN 'Pending'    
    WHEN (B.BookingStatus=9 or B.BookingStatus=4) THEN 'Cancelled' WHEN B.BookingStatus=0 THEN 'Failed' WHEN B.BookingStatus=5 THEN 'Close'    
    WHEN B.BookingStatus=10 THEN 'Manual Booking' WHEN B.BookingStatus=8 THEN 'Reschedule PNR' WHEN B.BookingStatus=12 THEN 'In-Process'    
    WHEN B.BookingStatus=15 THEN 'OnHoldCanceled' END) AS 'Status'    
  , b.riyaPNR AS 'Booking id'    
  , (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS  'Airline PNR'    
  , B.GDSPNR AS 'CRS PNR'    
  , B.TicketIssuanceError AS 'Remarks'    
  , (CASE     
    WHEN b.MainAgentId=0 AND ParentAgentID is null AND  BookedBy>0 THEN (SELECT  a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a WITH(NOLOCK) where a.UserID=b.BookedBy)    
    WHEN b.MainAgentId=0 AND BookedBy=0 THEN (SELECT a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a WITH(NOLOCK) WHERE Cast(a.UserID AS varchar(50))=b.AgentID)    
    WHEN b.MainAgentId>0  AND ParentAgentID is null   then (SELECT a.UserName + '-' +   a.FullName FROM mUser a WITH(NOLOCK) WHERE a.ID=b.MainAgentId)    
    WHEN b.MainAgentId=0 AND ParentAgentID is not null    
    THEN     
     (SELECT r.Icast + ' Sub user : ' + al.UserName + ', Display name : ' + al.FirstName+' '+isnull(al.LastName,'')    
      FROM tblBookMaster b1 WITH(NOLOCK)    
      INNER JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID as varchar(50))=b1.AgentID    
      INNER JOIN B2BRegistration r WITH(NOLOCK) ON r.FKUserID=al.ParentAgentID    
      WHERE b1.pkId=b.pkId)    
    ELSE '' END) AS 'User'    
  , (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Airport'    
  , B.airName+' ('+B.airCode+')' 'Airline name'    
  --Jitendra Nakum (02.06.2023) Query optimize for booking track report    
  , (SELECT STUFF((SELECT '/' + frmSector+ '-' + toSector FROM tblBookItenary WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS Sector    
  , (SELECT STUFF((SELECT '/' + s.airCode+ '-' + flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS 'Flight No'    
  , (SELECT STUFF((SELECT '-' + CASE when  CHARINDEX('-',s.cabin) = 0 then s.cabin else substring(s.cabin, 1, CHARINDEX('-',s.cabin)-1) END FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'')) as 'Class Code'    
  , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Dep Date all'    
  , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.arrivalDate, 0), 103))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Arrvl Date all'    
  , (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.depDate, 0), 103) ) AS 'Dep Date'    
  , (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.arrivalDate, 0), 103)) AS 'Arrvl Date'    
  , (CASE WHEN P.payment_mode='PassThrough' THEN 'Credit Card' ELSE P.payment_mode END) AS 'Payment Mode'    
  , country.Currency as 'Currency'    
  , (select SUM (cast(((    
    ((ISNULL(bm.totalFare,0)* bm.ROE)+isnull(bm.TotalMarkup,0)+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0))    
    -isnull(bm.TotalDiscount,0)) + isnull(bm.BFC,0)) as decimal(18,2)))    
    from tblBookMaster as bm WITH(NOLOCK) where bm.pkId = b.pkId)     
    + ISNULL((Select SUM(SSR_Amount)*(select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) from tblSSRDetails as ssr WITH(NOLOCK)     
    Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = b.pkId)),0) AS 'Net fare'         
  , (select SUM(cast((((bm.totalFare * bm.ROE)+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0)) + ISNULL(bm.TotalMarkup,0) + isnull(bm.BFC,0)) as decimal(18,2)))    
    From tblBookMaster as bm WITH(NOLOCK) where bm.pkId = b.pkId) +    ISNULL((Select SUM(SSR_Amount)*(select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) from tblSSRDetails as ssr WITH(NOLOCK)    
    Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = b.pkId)),0) as 'Gross fare'     
  , ISNULL(B.MCOAmount,0) as 'MCO Amount'    
  , CONVERT(VARCHAR(10), CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 103) + ' '+ CONVERT(VARCHAR(10),CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 108) as 'UpdatedDate'    
  , (u.UserName + '-' + u.FullName) as 'UpdatedbyUser'    
  , b.Remarks as 'UpdatedUserRemarks'    
  , (case when b.MainAgentId > 0 AND b.BookingSource='Web' then 'Internal Booking (Web)'    
    when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'    
    when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Internal Booking Retrive PNR - MultiTST)'    
    when b.MainAgentId > 0 AND b.BookingSource='Cryptic' then 'Internal Booking (Cryptic)'    
    when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting' then 'Internal Booking Accounting(Retrive PNR Accounting)'    
    when b.MainAgentId = 0 AND b.BookingSource='Web' then 'Agent Booking (Web)'    
    when b.MainAgentId = 0 AND b.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)'     
    when b.MainAgentId = 0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Agent Booking (Retrive PNR - MultiTST)'     
    when b.MainAgentId > 0 AND (b.BookingSource='ManualTicketing' OR b.BookingSource='Manual Ticketing') then 'ManualTicketing'    
    when b.MainAgentId = 0 AND b.BookingSource='Cryptic' then 'Agent Booking (Cryptic)'    
    when  b.BookingSource='GDS' then 'TJQ'    
    when  b.BookingSource='API' then 'API OUT'    
    WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'    
    WHEN b.MainAgentId > 0 AND b.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'    
   end   
    +
    CASE 
        WHEN ISNULL(LTRIM(RTRIM(b.SubBookingSource)), '') <> '' 
            THEN ' - ' + b.SubBookingSource 
        ELSE '' 
    END
   ) as 'Booking Mode'    
  --, b.VendorName as 'CRS'    
  ,(CASE WHEN (b.airCode='EK' OR b.airCode='BA') AND b.VendorName='Travelfusion' THEN 'Travelfusion NDC' ELSE b.VendorName END) as 'CRS'    
  , b.OfficeID as 'Booking Supplier'    
  , b.TicketingPCC as 'Ticketing Suppier'    
  , ''  as 'Agent Currency'    
  , '' as 'ROE'    
  , TFBookingRef    
  , TFBookingstatus      
  , p.bank_ref_no AS [Bank Ref No.]    
  , p.order_status AS [Order Status]    
  , p.failure_message AS [Failure_Message]    
  , pc.TotalCommission As [PG_Charges]    
  , P.bank_ref_no AS [bank_ref_no]    
  , CASE WHEN ISNULL(TripType,'')='M' THEN 'Multi City' ELSE CASE b.journey WHEN 'O' THEN 'One Way' WHEN 'R' THEN 'Round Trip' WHEN 'M' THEN 'Round Trip Special' END END AS [Journey_Type]    
  , b.FareType AS [Fare_Type]    
  FROM tblBookMaster AS b WITH(NOLOCK)    
  INNER JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50)) = b.AgentID    
  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID    
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50)) = b.AgentID AND b.AgentID!='B2C'    
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON R1.FKUserID = AL.ParentAgentID    
  INNER JOIN mCountry country WITH(NOLOCK) ON b.Country = country.CountryCode    
  LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId    
  LEFT JOIN Paymentmaster pay WITH(NOLOCK) ON pay.ParentOrderId=b.orderid    
  LEFT JOIN mUser u WITH(NOLOCK) ON b.BookingTrackModifiedBy=u.ID    
  LEFT JOIN B2BMakepaymentCommission pc WITH(NOLOCK) ON pc.OrderId=b.orderId    
  WHERE     
  b.AgentID!='B2C'    
  AND ((@FROMDate = '') or (CONVERT(datetime,isnull(b.IssueDate,isnull(b.inserteddate_old,b.inserteddate))) >= CONVERT(datetime,@FROMDate)))    
   AND ((@ToDate = '') or (CONVERT(datetime,isnull(b.IssueDate,isnull(b.inserteddate_old,b.inserteddate))) <= CONVERT(datetime, @ToDate)))    
  --AND ((@FROMDate = '') OR (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(datetime,@FROMDate)))    
  -- AND ((@ToDate = '') OR (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(datetime, @ToDate)))    
   AND ((@PaymentType = '') OR (@PaymentType='Wallet' AND (p.payment_mode='Check' OR p.payment_mode='Credit')) OR (p.payment_mode=@PaymentType))    
  AND ((@UserType = '') OR ( AL.UserTypeID IN ( select Data from sample_split(@UserType,','))))    
  AND ((@Country = '') OR (al.BookingCountry IN ( select Data from sample_split(@Country,','))))    
  AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId as varchar(50))) or (al.ParentAgentID=@AgentId))    
  AND ((@SubUserId = '') OR  (b.AgentID =cast(@SubUserId as varchar(50))))    
  AND ((@StaffID = '') OR  (b.MainAgentId =@StaffID))    
  --AND b.BookingStatus in (0,1,2,3,4,5,6,7,8,9,11,10,12,13,14,15)    
AND (
    (@Status = '')
    OR (
        @Status = '1' 
        AND b.IsBooked = 1 
        AND b.BookingStatus IN (1,6)
    )
    OR (
        @Status = '4' 
        AND b.BookingStatus = 4
    )
    OR (
        @Status NOT IN ('','1','4') 
        AND b.BookingStatus = CAST(@Status AS INT)
    )
)

   
  AND ((@ProductType = '') OR ( @ProductType = 'Airline'))    
  AND ((@AirportType = '')      
  OR ((@AirportType = 'Domestic') AND (b.CounterCloseTime = 1))     
  OR ((@AirportType = 'International') AND (b.CounterCloseTime != 1)))    
  AND ((@Airline = '') OR (b.airCode IN  ( select Data from sample_split(@Airline,','))))    
  AND ((@BookingId = '') OR (b.riyaPNR = @BookingId))    
  AND ((@AirlinePnr = '') OR ((SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) = @AirlinePnr))    
  AND ((@GDSPnr = '') OR (b.GDSPNR = @GDSPnr))    
  --AND ((@CRS = '') OR (b.VendorName = @CRS))    
  AND (
  @CRS = ''
  OR 
  REPLACE(b.VendorName, ' ', '') IN (
    -- Case 1: TravelFusionNDC with EK or BA
    CASE 
      WHEN @CRS = 'TravelFusionNDC' AND b.airCode IN ('EK', 'BA') THEN 'TravelFusion'
      WHEN @CRS = 'AmadeusNDC' THEN '1ANDC'
      ELSE REPLACE(@CRS, ' ', '')
    END,
    -- Also include @CRS literally (for fallback matching)
    REPLACE(@CRS, ' ', '')
  )
  OR 
  b.VendorName IN (
    CASE 
      WHEN @CRS = 'TravelFusionNDC' AND b.airCode IN ('EK', 'BA') THEN 'TravelFusionNDC'
      WHEN @CRS = 'AmadeusNDC' THEN '1ANDC'
      ELSE @CRS
    END,
    @CRS
  )
)

  --AND ((@CRS = '') OR (REPLACE(b.VendorName, ' ', '') = (CASE WHEN (b.airCode='EK' OR b.airCode='BA') AND @CRS='TravelFusionNDC' THEN 'TravelFusion' WHEN @CRS='AmadeusNDC' THEN '1ANDC' ELSE @CRS END))    
  --OR (b.VendorName = (CASE WHEN (b.airCode='EK' OR b.airCode='BA') AND @CRS='TravelFusionNDC' THEN 'TravelFusionNDC' WHEN @CRS='AmadeusNDC' THEN '1ANDC' ELSE @CRS END)))    
  AND ((@JournyType='TTM' AND ISNULL(b.TripType,'') = 'M') OR (@JournyType='A' OR (b.journey = @JournyType and  B.TripType!='M')))    
  AND (    
   (@BookingType = '')     
   OR ((@BookingType='IBW') AND b.MainAgentId>0 AND (b.BookingSource='Web'))    
   OR ((@BookingType='IBR') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))    
   OR ((@BookingType='IBRA') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR Accounting'))    
   OR ((@BookingType='ABW') AND b.MainAgentId=0 AND (b.BookingSource='Web'))    
   OR ((@BookingType='ABR') AND b.MainAgentId=0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))     
   OR ((@BookingType='CRYPI') AND b.MainAgentId>0 AND (b.BookingSource='Cryptic'))    
   OR ((@BookingType='CRYPA') AND b.MainAgentId=0 AND (b.BookingSource='Cryptic'))    
   OR ((@BookingType='TJQ') AND (b.BookingSource='GDS'))    
   OR ((@BookingType='API') AND (b.BookingSource='API'))    
   OR ((@BookingType='Manual') AND b.MainAgentId>0 AND (b.BookingSource='ManualTicketing' OR b.BookingSource='Manual Ticketing'))    
   OR (@BookingType='ANCI' AND isnull(b.MainAgentId,0)>=0 AND pay.ParentOrderId is not null)    
  )    
  AND b.returnFlag = 0    
  AND (@officeid='' OR b.OfficeID=@officeid)    
  AND b.pkId IN (SELECT TOP 1 pkid FROM tblBookMaster WITH(NOLOCK) WHERE orderid=b.orderId ORDER BY pkId ASC)    
  --ORDER BY ISNULL(b.inserteddate_old,b.inserteddate) DESC    
  --OFFSET (@Start) * @Pagesize ROWS    
  --FETCH NEXT @Pagesize ROWS ONLY    
      
    
  --SELECT @recordcount=100    
  SELECT @recordcount=count(*) from tblbookmaster b WITH(NOLOCK)    
  INNER JOIN agentlogin al WITH(NOLOCK) on cast(al.userid as varchar(50))=b.agentid    
  INNER JOIN mcommon c WITH(NOLOCK) on c.id=al.usertypeid    
  LEFT JOIN b2bregistration r WITH(NOLOCK) on cast(r.fkuserid as varchar(50))=b.agentid and b.AgentID!='B2C'    
  LEFT JOIN b2bregistration r1 WITH(NOLOCK) on r1.fkuserid = al.parentagentid    
  LEFT JOIN paymentmaster p WITH(NOLOCK) on p.order_id=b.orderid    
  LEFT JOIN Paymentmaster pay WITH(NOLOCK) ON pay.ParentOrderId=b.orderid    
  LEFT JOIN muser u WITH(NOLOCK) on b.bookingtrackmodifiedby=u.id    
  INNER JOIN mcountry country WITH(NOLOCK) on b.country=country.countrycode    
  LEFT JOIN b2bmakepaymentcommission pc WITH(NOLOCK) on pc.orderid=b.orderid     
  where     
  b.AgentID!='B2C'    
  AND ((@FROMDate = '') or (CONVERT(datetime,isnull(b.IssueDate,isnull(b.inserteddate_old,b.inserteddate))) >= CONVERT(datetime,@FROMDate)))    
   AND ((@ToDate = '') or (CONVERT(datetime,isnull(b.IssueDate,isnull(b.inserteddate_old,b.inserteddate))) <= CONVERT(datetime, @ToDate)))    
  --AND ((@fromdate = '') or (convert(datetime,isnull(b.inserteddate_old,b.inserteddate)) >= convert(datetime,@fromdate)))    
  -- AND ((@todate = '') or (convert(datetime,isnull(b.inserteddate_old,b.inserteddate)) <= convert(datetime, @todate)))    
   AND ((@paymenttype = '') or (@paymenttype='wallet' and (p.payment_mode='check' or p.payment_mode='credit')) or (p.payment_mode=@paymenttype))    
  AND ((@usertype = '') or ( al.usertypeid in (select data from sample_split(@usertype,','))))    
  AND ((@country = '') or (al.bookingcountry in (select data from sample_split(@country,','))))    
  AND ((@agentid = '') or  (b.agentid =cast(@agentid as varchar(50))) or (al.parentagentid=@agentid))    
  AND ((@subuserid = '') or  (b.agentid =cast(@subuserid as varchar(50))))    
  AND ((@StaffID = '') OR  (b.MainAgentId =@StaffID))    
  --AND b.BookingStatus in (0,1,2,3,4,5,6,7,8,9,11,10,12,13,14,15) 
AND (
    (@Status = '')
    OR (
        @Status = '1' 
        AND b.IsBooked = 1 
        AND b.BookingStatus IN (1,6)
    )
    OR (
        @Status = '4' 
        AND b.BookingStatus = 4
    )
    OR (
        @Status NOT IN ('','1','4') 
        AND b.BookingStatus = CAST(@Status AS INT)
    )
)


  --AND ((@status = '')      
  --OR ((@status = '1') and (cast(b.bookingstatus as varchar(50))='1' or cast(b.bookingstatus as varchar(50))='6' or cast(b.bookingstatus as varchar(50))='4') and ( b.isbooked=1))    
  --OR ((@status != '') and (cast(b.bookingstatus as varchar(50))=@status)))    
  AND ((@producttype = '') or ( @producttype = 'airline'))    
  AND ((@airporttype = '')      
  OR ((@airporttype = 'domestic') and (b.counterclosetime = 1))     
  OR ((@airporttype = 'international') and (b.counterclosetime != 1)))    
  AND ((@airline = '') or (b.aircode in  ( select data from sample_split(@airline,','))))    
  AND ((@bookingid = '') or (b.riyapnr = @bookingid))    
  AND ((@airlinepnr = '') or ((select top 1 airlinepnr from tblbookitenary bi WITH(NOLOCK) where bi.fkbookmaster=b.pkid) = @airlinepnr))    
  AND ((@gdspnr = '') or (b.gdspnr = @gdspnr))    
  --AND ((@crs = '') or (b.vendorname = @crs))    
  AND (
  @CRS = ''
  OR 
  REPLACE(b.VendorName, ' ', '') IN (
    -- Case 1: TravelFusionNDC with EK or BA
    CASE 
      WHEN @CRS = 'TravelFusionNDC' AND b.airCode IN ('EK', 'BA') THEN 'TravelFusion'
      WHEN @CRS = 'AmadeusNDC' THEN '1ANDC'
      ELSE REPLACE(@CRS, ' ', '')
    END,
    -- Also include @CRS literally (for fallback matching)
    REPLACE(@CRS, ' ', '')
  )
  OR 
  b.VendorName IN (
    CASE 
      WHEN @CRS = 'TravelFusionNDC' AND b.airCode IN ('EK', 'BA') THEN 'TravelFusionNDC'
      WHEN @CRS = 'AmadeusNDC' THEN '1ANDC'
      ELSE @CRS
    END,
    @CRS
  )
)

  --AND ((@CRS = '') OR (REPLACE(b.VendorName, ' ', '') = (CASE WHEN (b.airCode='EK' OR b.airCode='BA') AND @CRS='TravelFusionNDC' THEN 'TravelFusion' WHEN @CRS='AmadeusNDC' THEN '1ANDC' ELSE @CRS END))    
  --OR (b.VendorName = (CASE WHEN (b.airCode='EK' OR b.airCode='BA') AND @CRS='TravelFusionNDC' THEN 'TravelFusionNDC' WHEN @CRS='AmadeusNDC' THEN '1ANDC' ELSE @CRS END)))    
  AND ((@journytype='ttm' and isnull(b.triptype,'') = 'm') or (@journytype='a' or (b.journey = @journytype and  b.triptype!='m')))    
  AND (    
   (@bookingtype = '')     
   OR ((@bookingtype='ibw') and b.mainagentid>0 and (b.bookingsource='web'))    
   OR ((@bookingtype='ibr') and b.mainagentid>0 and (b.bookingsource='retrive pnr' or b.bookingsource='retrive pnr - multitst'))    
   OR ((@bookingtype='ibra') and b.mainagentid>0 and (b.bookingsource='retrive pnr accounting'))    
   OR ((@bookingtype='abw') and b.mainagentid=0 and (b.bookingsource='web'))    
   OR ((@bookingtype='abr') and b.mainagentid=0 and (b.bookingsource='retrive pnr' or b.bookingsource='retrive pnr - multitst'))     
   OR ((@bookingtype='crypi') and b.mainagentid>0 and (b.bookingsource='cryptic'))    
   OR ((@bookingtype='crypa') and b.mainagentid=0 and (b.bookingsource='cryptic'))    
   OR ((@bookingtype='tjq') and (b.bookingsource='gds'))    
   OR ((@BookingType='api') AND (b.BookingSource='api'))    
   OR ((@bookingtype='manual') and b.mainagentid>0 and (b.bookingsource='manualticketing' OR b.BookingSource='Manual Ticketing'))    
   OR (@bookingtype='anci' and isnull(b.mainagentid,0)>=0 and pay.parentorderid is not null)    
  )    
  AND b.returnflag=0    
  AND (@officeid='' OR b.OfficeID=@officeid)    
  AND b.pkid IN (SELECT TOP 1 pkid FROM tblBookMaster WITH(NOLOCK) WHERE orderid=b.orderId ORDER BY pkId ASC)     
      
  select 
  FORMAT([Booking date & timeSort],'dd-MMM-yyyy hh:mm tt') as [Booking date & time],* from @data    
  ORDER BY [Booking date & timeSort] DESC    
  OFFSET (@Start) * @Pagesize ROWS    
  FETCH NEXT @Pagesize ROWS ONLY    
      
  print @RecordCount    
 END    
 ELSE    
 BEGIN    
  SELECT ROW_NUMBER() OVER (ORDER BY ISNULL(b.inserteddate_old,b.inserteddate) DESC) AS SrNo    
  , AL.BookingCountry AS 'Country'    
  , c.Value AS 'User Type'    
  , ISNULL(R.AgencyName,R1.AgencyName) AS 'Agency Name'    
  , ISNULL(R.Icast,R1.Icast) AS 'Cust id'    
  --,FORMAT((CASE country.CountryCode     
  --  WHEN 'AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate))))     
  --     WHEN 'US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate))))     
  --     WHEN 'CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate))))     
  --  WHEN 'GB' THEN (DATEADD(SECOND, - 5*60*60 + 30*60, CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate))))    
  --     WHEN 'IN' THEN DATEADD(SECOND, 0, CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)))    
  --   END),'MMM dd yyyy hh:mm tt') AS 'Booking date & time'    
 ,FORMAT(CONVERT(DATETIME, ISNULL(b.IssueDate, ISNULL(b.inserteddate_old,b.inserteddate))),'dd-MMM-yyyy hh:mm tt') AS 'Booking date & time'   
  , b.orderId AS 'Track ID'    
  , (CASE WHEN (b.BookingStatus=1 or b.BookingStatus=6) THEN 'Confirmed' WHEN B.BookingStatus=2 THEN 'Hold' WHEN B.BookingStatus=3 THEN 'Pending'    
    WHEN (B.BookingStatus=9 or B.BookingStatus=4) THEN 'Cancelled' WHEN B.BookingStatus=0 THEN 'Failed' WHEN B.BookingStatus=5 THEN 'Close'    
    WHEN B.BookingStatus=10 THEN 'Manual Booking' WHEN B.BookingStatus=8 THEN 'Reschedule PNR' WHEN B.BookingStatus=12 THEN 'In-Process'    
    WHEN B.BookingStatus=15 THEN 'OnHoldCanceled' END) AS 'Status'    
  , b.riyaPNR AS 'Booking id'    
  , (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS  'Airline PNR'    
  , B.GDSPNR AS 'CRS PNR'    
  , B.TicketIssuanceError AS 'Remarks'    
  , (CASE     
    WHEN b.MainAgentId=0 AND ParentAgentID is null AND  BookedBy>0 THEN (SELECT  a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a WITH(NOLOCK) where a.UserID=b.BookedBy)    
    WHEN b.MainAgentId=0 AND BookedBy=0 THEN (SELECT a.UserName + '-' + isnull(a.FirstName,'') +' '+isnull(a.LastName,'') FROM AgentLogin a WHERE Cast(a.UserID AS varchar(50))=b.AgentID)    
    WHEN b.MainAgentId>0  AND (ParentAgentID is null OR ParentAgentID=0)  then (SELECT a.UserName + '-' +   a.FullName FROM mUser a WITH(NOLOCK) WHERE a.ID=b.MainAgentId)    
    WHEN b.MainAgentId=0 AND ParentAgentID is not null    
    THEN     
     (SELECT r.Icast + ' Sub user : ' + al.UserName + ', Display name : ' + al.FirstName+' '+isnull(al.LastName,'')    
      FROM tblBookMaster b1 WITH(NOLOCK)    
      INNER JOIN agentLogin al WITH(NOLOCK) ON CAST(al.UserID as varchar(50))=b1.AgentID    
      INNER JOIN B2BRegistration r WITH(NOLOCK) ON r.FKUserID=al.ParentAgentID    
      WHERE b1.pkId=b.pkId)    
    ELSE '' END) AS 'User'    
  , (CASE WHEN b.CounterCloseTime=1 THEN 'Domestic' ELSE 'International' END) AS 'Airport'    
  , B.airName+' ('+B.airCode+')' 'Airline name'    
  --Jitendra Nakum (02.06.2023) Query optimize for booking track report    
  , (SELECT STUFF((SELECT '/' + frmSector+ '-' + toSector FROM tblBookItenary WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS Sector    
  , (SELECT STUFF((SELECT '/' + s.airCode+ '-' + flightNo FROM tblBookItenary s WITH(NOLOCK) WHERE orderId = b.orderId FOR XML PATH('')),1,1,'')) AS 'Flight No'    
  , (SELECT STUFF((SELECT '-' + CASE when  CHARINDEX('-',s.cabin) = 0 then s.cabin else substring(s.cabin, 1, CHARINDEX('-',s.cabin)-1) END FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,'')) as 'Class Code'    
  , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.depDate, 0), 103))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Dep Date all'    
  , (SELECT STUFF((SELECT '-' +(SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, s.arrivalDate, 0), 103))  FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = b.orderId FOR XML PATH('')),1,1,''))AS 'Arrvl Date all'    
  , (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.depDate, 0), 103) ) AS 'Dep Date'    
  , (SELECT CONVERT(VARCHAR(10), CONVERT(DATETIME, B.arrivalDate, 0), 103)) AS 'Arrvl Date'    
  , (CASE WHEN P.payment_mode='PassThrough' THEN 'Credit Card' ELSE P.payment_mode END) AS 'Payment Mode'    
  , country.Currency as 'Currency'    
  --, (select SUM (cast(((    
  --  (bm.totalFare+isnull(bm.TotalMarkup,0)+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0)+isnull(bm.BFC,0))    
  --  -isnull(bm.TotalDiscount,0))* bm.ROE + isnull(bm.B2BMarkup,0)) as decimal(18,2)))    
  --  from tblBookMaster as bm WITH(NOLOCK) where bm.pkId = b.pkId)     
  --  + ISNULL((Select SUM(SSR_Amount) * (select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) from tblSSRDetails as ssr WITH(NOLOCK)     
  --  Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = b.pkId)),0) AS 'Net fare'         
  , (select SUM (cast(((    
    ((ISNULL(bm.totalFare,0)* bm.ROE)+isnull(bm.TotalMarkup,0)+isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0))    
    -isnull(bm.TotalDiscount,0)) + isnull(bm.BFC,0) + isnull(bm.B2BMarkup,0)) as decimal(18,2)))    
    from tblBookMaster as bm WITH(NOLOCK) where bm.pkId = b.pkId)     
    + ISNULL((Select SUM(SSR_Amount)*(select broe.ROE from tblBookMaster broe WITH(NOLOCK) where broe.pkId=b.pkId) from tblSSRDetails as ssr WITH(NOLOCK)     
    Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = b.pkId)),0) AS 'Net fare'    
  , (select SUM(cast((((bm.totalFare * bm.ROE) +isnull(bm.ServiceFee,0)+isnull(bm.GST,0)+isnull(bm.AgentMarkup,0)) + ISNULL(bm.B2BMarkup,0) + isnull(bm.BFC,0)) as decimal(18,2)))    
    From tblBookMaster as bm WITH(NOLOCK) where bm.pkId = b.pkId) +    ISNULL((Select SUM(SSR_Amount) from tblSSRDetails as ssr WITH(NOLOCK)    
    Where ssr.fkBookMaster IN (Select pkid From tblBookMaster WITH(NOLOCK) where pkId = b.pkId)),0) as 'Gross fare'     
  , ISNULL(B.MCOAmount,0) as 'MCO Amount'    
  , CONVERT(VARCHAR(10), CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 103) + ' '+ CONVERT(VARCHAR(10),CONVERT(DATETIME, b.BookingTrackModifiedOn, 0), 108) as 'UpdatedDate'    
  , (u.UserName + '-' + u.FullName) as 'UpdatedbyUser'    
  , b.Remarks as 'UpdatedUserRemarks'    
  , (case when b.MainAgentId > 0 AND b.BookingSource='Web' then 'Internal Booking (Web)'    
    when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR' then 'Internal Booking (Retrive PNR)'    
    when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Internal Booking Retrive PNR - MultiTST)'    
    when b.MainAgentId > 0 AND b.BookingSource='Cryptic' then 'Internal Booking (Cryptic)'    
    when b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting' then 'Internal Booking Accounting(Retrive PNR Accounting)'    
    when b.MainAgentId = 0 AND b.BookingSource='Web' then 'Agent Booking (Web)'    
    when b.MainAgentId = 0 AND b.BookingSource='Retrive PNR' then 'Agent Booking (Retrive PNR)'     
    when b.MainAgentId = 0 AND b.BookingSource='Retrive PNR - MultiTST' then 'Agent Booking (Retrive PNR - MultiTST)'     
    when b.MainAgentId > 0 AND (b.BookingSource='ManualTicketing' OR b.BookingSource='Manual Ticketing') then 'ManualTicketing'    
    when b.MainAgentId = 0 AND b.BookingSource='Cryptic' then 'Agent Booking (Cryptic)'    
    when  b.BookingSource='GDS' then 'TJQ'    
    when  b.BookingSource='API' then 'API OUT'    
    WHEN b.MainAgentId > 0 AND b.BookingSource='Retrive PNR Accounting-TicketNumber' THEN 'Internal Booking (PNR Accounting)'    
    WHEN b.MainAgentId > 0 AND b.BookingSource='Retrieve PNR accounting - MultiTST' THEN 'Internal Booking Retrive PNR accounting - MultiTST'    
   end  
    +
    CASE 
        WHEN ISNULL(LTRIM(RTRIM(b.SubBookingSource)), '') <> '' 
            THEN ' - ' + b.SubBookingSource 
        ELSE '' 
    END
   ) as 'Booking Mode'    
  --, b.VendorName as 'CRS'    
  ,(CASE WHEN (b.airCode='EK' OR b.airCode='BA') AND b.VendorName='Travelfusion' THEN 'Travelfusion NDC' ELSE b.VendorName END) as 'CRS'    
  , b.OfficeID as 'Booking Supplier'    
  , b.TicketingPCC as 'Ticketing Suppier'    
  , ''  as 'Agent Currency'    
  , '' as 'ROE'    
  , TFBookingRef    
  , TFBookingstatus      
  , p.bank_ref_no AS [Bank Ref No.]    
  , p.order_status AS [Order Status]    
  , p.failure_message AS [Failure_Message]    
  , pc.TotalCommission As [PG_Charges]    
  , P.bank_ref_no AS [bank_ref_no]    
  , CASE WHEN ISNULL(TripType,'')='M' THEN 'Multi City' ELSE CASE b.journey WHEN 'O' THEN 'One Way' WHEN 'R' THEN 'Round Trip' WHEN 'M' THEN 'Round Trip Special' END END AS [Journey_Type]    
  , b.FareType AS [Fare_Type]    
  FROM tblBookMaster AS b WITH(NOLOCK)    
  INNER JOIN agentLogin AL WITH(NOLOCK) ON CAST(AL.UserID AS VARCHAR(50)) = b.AgentID    
  INNER JOIN mCommon C WITH(NOLOCK) ON C.ID = AL.UserTypeID    
  LEFT JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50)) = b.AgentID AND b.AgentID!='B2C'    
  LEFT JOIN B2BRegistration R1 WITH(NOLOCK) ON R1.FKUserID = AL.ParentAgentID    
  INNER JOIN mCountry country WITH(NOLOCK) ON b.Country = country.CountryCode    
  LEFT JOIN Paymentmaster P WITH(NOLOCK) ON P.order_id=B.orderId    
  LEFT JOIN Paymentmaster pay WITH(NOLOCK) ON pay.ParentOrderId=B.orderid    
  LEFT JOIN mUser u WITH(NOLOCK) ON b.BookingTrackModifiedBy=u.ID    
  LEFT JOIN B2BMakepaymentCommission pc WITH(NOLOCK) ON pc.OrderId=b.orderId    
  WHERE     
  b.AgentID!='B2C'    
  AND ((@FROMDate = '') or (CONVERT(datetime,isnull(b.IssueDate,isnull(b.inserteddate_old,b.inserteddate))) >= CONVERT(datetime,@FROMDate)))    
   AND ((@ToDate = '') or (CONVERT(datetime,isnull(b.IssueDate,isnull(b.inserteddate_old,b.inserteddate))) <= CONVERT(datetime, @ToDate)))    
  --AND ((@FROMDate = '') OR (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) >= CONVERT(datetime,@FROMDate)))    
  -- AND ((@ToDate = '') OR (CONVERT(datetime,isnull(b.inserteddate_old,b.inserteddate)) <= CONVERT(datetime, @ToDate)))    
   AND ((@PaymentType = '') OR (@PaymentType='Wallet' AND (p.payment_mode='Check' OR p.payment_mode='Credit')) OR (p.payment_mode=@PaymentType))    
  AND ((@UserType = '') OR ( AL.UserTypeID IN ( select Data from sample_split(@UserType,','))))    
  AND ((@Country = '') OR (al.BookingCountry IN ( select Data from sample_split(@Country,','))))    
  AND ((@AgentId = '') OR  (b.AgentID =cast(@AgentId as varchar(50))) or (al.ParentAgentID=@AgentId))    
  AND ((@SubUserId = '') OR  (b.AgentID =cast(@SubUserId as varchar(50))))    
  AND ((@StaffID = '') OR  (b.MainAgentId =@StaffID)) 
  
AND (
    (@Status = '')
    OR (
        @Status = '1' 
        AND b.IsBooked = 1 
        AND b.BookingStatus IN (1,6)
    )
    OR (
        @Status = '4' 
        AND b.BookingStatus = 4
    )
    OR (
        @Status NOT IN ('','1','4') 
        AND b.BookingStatus = CAST(@Status AS INT)
    )
)


  --AND ((@Status = '')      
  --OR ((@Status = '1') AND (cast(b.BookingStatus as varchar(50))='1' OR cast(b.BookingStatus as varchar(50))='6' OR cast(b.BookingStatus as varchar(50))='4') AND ( b.IsBooked=1))    
  --OR ((@Status != '') AND (cast(b.BookingStatus as varchar(50))=@Status)))    
  AND ((@ProductType = '') OR ( @ProductType = 'Airline'))    
  AND ((@AirportType = '')      
  OR ((@AirportType = 'Domestic') AND (b.CounterCloseTime = 1))     
  OR ((@AirportType = 'International') AND (b.CounterCloseTime != 1)))    
  AND ((@Airline = '') OR (b.airCode IN  ( select Data from sample_split(@Airline,','))))    
  AND ((@BookingId = '') OR (b.riyaPNR = @BookingId))    
  AND ((@AirlinePnr = '') OR ((SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) = @AirlinePnr))    
  AND ((@GDSPnr = '') OR (b.GDSPNR = @GDSPnr))    
  --AND ((@CRS = '') OR (b.VendorName = @CRS))    
  AND (
  @CRS = ''
  OR 
  REPLACE(b.VendorName, ' ', '') IN (
    -- Case 1: TravelFusionNDC with EK or BA
    CASE 
      WHEN @CRS = 'TravelFusionNDC' AND b.airCode IN ('EK', 'BA') THEN 'TravelFusion'
      WHEN @CRS = 'AmadeusNDC' THEN '1ANDC'
      ELSE REPLACE(@CRS, ' ', '')
    END,
    -- Also include @CRS literally (for fallback matching)
    REPLACE(@CRS, ' ', '')
  )
  OR 
  b.VendorName IN (
    CASE 
      WHEN @CRS = 'TravelFusionNDC' AND b.airCode IN ('EK', 'BA') THEN 'TravelFusionNDC'
      WHEN @CRS = 'AmadeusNDC' THEN '1ANDC'
      ELSE @CRS
    END,
    @CRS
  )
)

  --AND ((@CRS = '') OR (REPLACE(b.VendorName, ' ', '') = (CASE WHEN (b.airCode='EK' OR b.airCode='BA') AND @CRS='TravelFusionNDC' THEN 'TravelFusion' WHEN @CRS='AmadeusNDC' THEN '1ANDC' ELSE @CRS END))    
  --OR (b.VendorName = (CASE WHEN (b.airCode='EK' OR b.airCode='BA') AND @CRS='TravelFusionNDC' THEN 'TravelFusionNDC' WHEN @CRS='AmadeusNDC' THEN '1ANDC' ELSE @CRS END)))    
  AND ((@JournyType='TTM' AND ISNULL(b.TripType,'') = 'M') OR (@JournyType='A' OR (b.journey = @JournyType and  B.TripType!='M')))    
  AND (    
   (@BookingType = '')     
   OR ((@BookingType='IBW') AND b.MainAgentId>0 AND (b.BookingSource='Web'))    
   OR ((@BookingType='IBR') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))    
   OR ((@BookingType='IBRA') AND b.MainAgentId>0 AND (b.BookingSource='Retrive PNR Accounting'))    
   OR ((@BookingType='ABW') AND b.MainAgentId=0 AND (b.BookingSource='Web'))    
   OR ((@BookingType='ABR') AND b.MainAgentId=0 AND (b.BookingSource='Retrive PNR' OR b.BookingSource='Retrive PNR - MultiTST'))     
   OR ((@BookingType='CRYPI') AND b.MainAgentId>0 AND (b.BookingSource='Cryptic'))    
   OR ((@BookingType='CRYPA') AND b.MainAgentId=0 AND (b.BookingSource='Cryptic'))    
   OR ((@BookingType='TJQ') AND (b.BookingSource='GDS'))    
   OR ((@BookingType='API') AND (b.BookingSource='API'))    
   OR ((@BookingType='Manual') AND b.MainAgentId>0 AND (b.BookingSource='ManualTicketing' OR b.BookingSource='Manual Ticketing'))    
   OR (@BookingType='ANCI' AND isnull(b.MainAgentId,0)>=0 AND pay.ParentOrderId is not null)    
  )    
  AND b.returnFlag=0    
  AND (@officeid='' OR b.OfficeID=@officeid)    
  AND b.pkId IN (SELECT TOP 1 pkid FROM tblBookMaster WITH(NOLOCK) WHERE orderid=b.orderId ORDER BY pkId ASC)    
  --ORDER BY ISNULL(b.inserteddate_old,b.inserteddate) DESC    
  ORDER BY (CASE country.CountryCode     
    WHEN 'AE' THEN (DATEADD(SECOND, -1*60*60 -29*60 -13,CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate))))     
       WHEN 'US' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate))))     
       WHEN 'CA' THEN (DATEADD(SECOND, - 9*60*60 -29*60 -16,CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate))))     
    WHEN 'GB' THEN (DATEADD(SECOND, - 5*60*60 + 30*60, CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate))))    
       WHEN 'IN' THEN DATEADD(SECOND, 0, CONVERT(DATETIME, ISNULL(b.inserteddate_old,b.inserteddate)))    
     END) DESC    
      
  SELECT @recordcount= @@ROWCOUNT    
     
 END    
END 