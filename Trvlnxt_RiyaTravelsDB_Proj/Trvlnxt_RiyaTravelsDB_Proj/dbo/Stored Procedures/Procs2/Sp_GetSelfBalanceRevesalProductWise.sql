    
CREATE PROCEDURE [dbo].[Sp_GetSelfBalanceRevesalProductWise]    
 @FromDate Datetime=null    
 , @ToDate Datetime=null    
 , @Status Varchar(10)=null    
 , @Start Int=null    
 , @Pagesize Int=null    
 , @IsPaging Bit    
 , @UserId Varchar(500)=null -- Jitendra Nakum 21/09/2022 add User Filter as per discussed date 20/09/2022    
 , @OBTC Int -- Jitendra Nakum 21/09/2022 add OBTC Filter when check box check then all record fetch other wise only OBTC No available that record fetch as per discussed date 20/09/2022    
 , @ProductType Int    
 , @RecordCount INT OUTPUT    
AS        
BEGIN        
 SET @RecordCount=0        
    
 Declare @statusInt Int     
 SELECT @statusInt= CASE @Status WHEN 'Pending' THEN 0 WHEN 'Completed' THEN 1 END     
    
 DECLARE @UID INT    
 Select @UID=UserID from agentLogin Where UserID=@UserId    
    
 IF OBJECT_ID ( 'tempdb..#tempTableAir') IS NOT NULL    
  DROP TABLE  #tempTableAir    
 SELECT * INTO #tempTableAir FROM    
 (    
  SELECT DISTINCT    
  --b.pkId,    
  b.IssueDate  AS 'Date/Time'    
  , R.Icast AS 'CUST ID'    
  ,(CASE WHEN (Select COUNT(*) FROM agentLogin WITH(NOLOCK) Where UserID=b.AgentID AND userTypeID=4)>0    
  THEN (Select top 1 (CASE WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='IN' THEN 'RTTICU'    
        WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='US' THEN 'RTTINC'    
        WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='CA' THEN 'RTTCAN'    
        WHEN (BookingCountry='IN' OR BookingCountry='US') AND mc.Value='AE' THEN 'RTTDXB'    
        ELSE '' END)    
    from agentLogin WITH(NOLOCK)    
      INNER JOIN mVendorCredential mc WITH(NOLOCK) ON mc.OfficeId=b.OfficeID AND FieldName='ERP Country'    
      WHERE UserID=b.AgentID AND userTypeID=4    
      )    
    ELSE (Select top 1 wy.[RH Ledgers] from tblInterBranchWinyatra wy WITH(NOLOCK)    
     INNER JOIN B2BRegistration r1 WITH(NOLOCK)ON wy.Icust=r1.Icast AND CAST(r1.FKUserID AS VARCHAR(50))=b.AgentID       
     INNER JOIN mVendorCredential mc WITH(NOLOCK) ON mc.OfficeId=b.OfficeID AND FieldName='ERP Country'  AND wy.Country=b.Country    
     )    
    END    
  ) AS [RH Ledgers]    
  --, AL.BookingCountry AS 'Country'    
  --, CM.Value AS 'User Type'    
  , (CASE WHEN (@UID!=NULL OR @UserId='')  THEN AL.BookingCountry ELSE     
   (Select     
   STUFF((SELECT ', ' + MC.CountryCode    
   FROM mUserCountryMapping MU    
   INNER JOIN mCountry MC ON MU.CountryId = MC.ID     
   INNER  JOIN mUser MS ON MU.UserId = MS.ID AND MS.ID=@UserId    
   FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'Country'    
  , (CASE WHEN (@UID!=NULL OR @UserId='') THEN CM.Value ELSE     
   (Select     
   STUFF((SELECT ', ' + MC.Value    
   FROM mUserTypeMapping MU    
   INNER JOIN mCommon MC ON MU.UserTypeId = MC.ID AND MC.Category = 'UserType'    
   INNER  JOIN mUser MS ON MU.UserId = MS.ID AND MS.ID=@UserId    
   FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'User Type'    
  , (u.UserName +' - '+u.FullName) AS 'Booked By'    
  , isnull(u1.UserName + ' - ' + u1.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) AS 'Issued By'    
  , b.riyaPNR AS 'Booking ID'    
  , CONVERT(varchar, b.depDate, 101) AS 'Departure date',b.airCode AS 'Airline Code'    
  , (SELECT TOP 1 airlinePNR FROM tblBookItenary BI WITH(NOLOCK) WHERE BI.fkBookMaster=B.pkId) AS  'Airlines PNR'    
  , (select STUFF((SELECT '/' + s.TicketNumber FROM tblPassengerBookDetails s WITH(NOLOCK)    
   WHERE s.fkBookMaster = t.fkBookMaster order by TicketNumber FOR XML PATH('')),1,1,'') AS TicketNumber    
   from tblPassengerBookDetails t WITH(NOLOCK) where TicketNumber is not null and fkBookMaster=b.pkId    
   GROUP BY t.fkBookMaster) AS 'Ticket No'    
  , (SELECT STUFF((SELECT '/' + s.frmSector+ '-' + toSector FROM tblBookItenary s WITH(NOLOCK) WHERE s.orderId = t.orderId FOR XML PATH('')),1,1,'') AS Sector    
   FROM tblBookItenary t WITH(NOLOCK) WHERE t.fkBookMaster=b.pkId  GROUP BY t.orderId) AS 'Travel Sector'    
  , (SELECT sum(b1.basicFare) FROM tblBookMaster b1 WITH(NOLOCK) WHERE b1.orderId=b.orderId GROUP BY orderId) AS 'Base Amt'    
  , (SELECT sum(b1.totalTax) FROM tblBookMaster b1 WITH(NOLOCK) WHERE b1.orderId=b.orderId GROUP BY orderId) AS 'Tax Amt'    
  , PM.amount AS 'Total Air Cost'    
  , c.Currency AS 'Currency'    
  , (SELECT TOP 1 paxFName + ' ' + paxLName FROM tblPassengerBookDetails pb WITH(NOLOCK) WHERE pb.fkBookMaster=b.pkId ORDER BY paxFName) AS 'Lead Pax Name'    
  , (SELECT count(*) FROM tblPassengerBookDetails PD WITH(NOLOCK) WHERE PD.fkBookMaster=b.pkId) AS 'No.of Pax'    
  , 'Self Balance' AS 'Payment Mode'    
  , (CASE WHEN isnull(b.AgentInvoiceNumber,'') ='' THEN 'Pending' ELSE 'Completed' END) AS 'Status'    
  , b.AgentInvoiceNumber AS 'Agent Invoice Number'    
  , b.InquiryNo    
  , b.FileNo    
  , b.PaymentRefNo    
  , (Select top 1 OBTCNo from mAttrributesDetails ma Where ma.OrderID=b.orderId) AS 'OBTCNo'    
  --, b.OBTCNo    
  , b.RTTRefNo    
  , b.OpsRemark    
  , b.AcctsRemark    
  , isnull(mu.UserName,'') + '-' + isnull(mu.FullName,'') AS 'AddUserSelfBalance'    
  FROM tblBookMaster b WITH(NOLOCK)    
  INNER JOIN Paymentmaster PM WITH(NOLOCK) ON PM.order_id=B.orderId    
  INNER JOIN B2BRegistration R WITH(NOLOCK) ON CAST(R.FKUserID AS VARCHAR(50))=B.AgentID    
  INNER JOIN mUser u WITH(NOLOCK) ON b.MainAgentId=u.ID    
  LEFT JOIN agentLogin al WITH(NOLOCK) ON cast(al.UserID AS VARCHAR(50))=B.AgentID    
  LEFT JOIN mCommon CM WITH(NOLOCK) ON CM.ID = al.UserTypeID    
  LEFT JOIN mUser u1 WITH(NOLOCK) ON u1.ID=b.IssueBy    
  INNER JOIN mCountry c WITH(NOLOCK) ON b.Country=c.CountryCode    
  LEFT JOIN mUser mu WITH(NOLOCK) ON mu.ID=b.AddUserSelfBalance    
  --LEFT JOIN mAttrributesDetails ma WITH(NOLOCK) on ma.OrderID=b.orderId    
  WHERE b.totalFare>0 AND ((@FROMDate = '') or (CONVERT(date,B.inserteddate) >= CONVERT(date,@FROMDate)))    
   AND ((@ToDate = '') OR (CONVERT(date,B.inserteddate) <= CONVERT(date,@ToDate)))    
  AND ((@Status='All')  OR (@Status='Pending' and isnull(b.AgentInvoiceNumber,'') ='')    
   OR (@Status='Completed' and  isnull(b.AgentInvoiceNumber,'') !=''))    
  AND b.IsBooked=1 AND b.returnFlag = 0    
  AND PM.payment_mode='Self Balance' and b.DisplaySelfBalanceReport=1    
  AND ((@UserId = '') or  (b.MainAgentId=@UserId) or  (b.AddUserSelfBalance=@UserId))    
  AND (@OBTC = 0 OR (@OBTC=1 and b.OBTCNo is not null AND b.OBTCNo != '')    
   OR (@OBTC=2 and (b.OBTCNo is null OR b.OBTCNo = '')))    
 ) Air    
 ORDER BY Air.[Date/Time] DESC    
        
 IF OBJECT_ID ( 'tempdb..#tempTableHotel') IS NOT NULL    
  DROP TABLE  #tempTableHotel    
 SELECT * INTO #tempTableHotel FROM (    
  SELECT DISTINCT    
  HB.inserteddate 'Date/Time'    
  , BR.Icast AS 'CUST ID'    
  ,'' AS [RH Ledgers]    
  --, AL.BookingCountry AS 'Country'    
  --, C.Value AS 'User Type'    
  , (CASE WHEN @UID!=NULL THEN AL.BookingCountry ELSE     
   (Select     
   STUFF((SELECT ', ' + MC.CountryCode    
   FROM mUserCountryMapping MU WITH(NOLOCK)   
   INNER JOIN mCountry MC WITH(NOLOCK) ON MU.CountryId = MC.ID     
   INNER  JOIN mUser MS WITH(NOLOCK) ON MU.UserId = MS.ID AND MS.ID=@UserId    
   FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'Country'    
  , (CASE WHEN @UID!=NULL THEN C.Value ELSE     
   (Select     
   STUFF((SELECT ', ' + MC.Value    
   FROM mUserTypeMapping MU  WITH(NOLOCK)  
   INNER JOIN mCommon MC WITH(NOLOCK) ON MU.UserTypeId = MC.ID AND MC.Category = 'UserType'    
   INNER  JOIN mUser MS WITH(NOLOCK) ON MU.UserId = MS.ID AND MS.ID=@UserId    
   FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'User Type'    
  , MU.UserName +'-'+ Mu.FullName 'Booked By'    
  , isnull(MU.UserName + ' - ' + MU.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) AS 'Issued By'    
  , Hb.BookingReference 'Booking ID'    
  , Hb.CheckInDate 'CheckInDate'    
  , '' AS 'Airline Code'    
  , HB.riyaPNR AS 'Hotel PNR'    
  , HB.riyaPNR AS 'Ticket No'    
  , '' AS 'Travel Sector'    
  , convert(decimal(18,2),HB.DisplayDiscountRate)  AS 'Base Amt'    
  , convert(decimal(18,2),0.00) AS 'Tax Amt'    
  , '' AS 'Total Air Cost'    
  , HB.CurrencyCode AS 'Currency'    
  , HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  AS 'Lead Pax Name'    
  , cast(cast(HB.TotalAdults AS decimal(18,2)) + cast(TotalChildren AS decimal(18,2)) AS Decimal(18,2)) AS 'No.of Pax'    
  , CASE WHEN HB.B2BPaymentMode =1 THEN 'Hold'    
   WHEN HB.B2BPaymentMode =2 THEN 'Credit Limit'    
   WHEN HB.B2BPaymentMode =3 THEN 'Make Payment'    
   WHEN HB.B2BPaymentMode =4 THEN 'Self Balance'    
   END AS 'Payment Mode'    
  , CASE WHEN HB.SB_ReversalStatus=0 THEN 'Pending'    
   WHEN HB.SB_ReversalStatus=1 THEN 'Completed'    
   END AS 'Status'    
  , HB.AgentInvoiceNumber    
  , HB.InquiryNo    
  , HB.FileNo    
  , HB.PaymentRefNo    
 -- , HB.OBTCNo 
 ,ISNULL(MBPageOBTCNo,OBTCNo)  as OBTCNo
  , HB.RTTRefNo    
  , HB.OpsRemark    
  , HB.AcctsRemark    
  , '' AS AddUserSelfBalance    
  FROM Hotel_BookMaster HB WITH(NOLOCK)    
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON HB.RiyaAgentID=BR.FKUserID    
  LEFT JOIN mUser MU WITH(NOLOCK) ON HB.MainAgentID=Mu.ID    
  LEFT JOIN AgentLogin al WITH(NOLOCK) ON HB.RiyaAgentID=al.UserID    
  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = al.UserTypeID    
  WHERE CAST(HB.inserteddate as date) BETWEEN @FromDate and @ToDate    
  AND (@Status='All' OR HB.SB_ReversalStatus=cast(@statusInt as bit))    
  AND HB.B2BPaymentMode=4    
  AND (@UserId='' OR HB.MainAgentID=@USerId)    
  AND (@OBTC = 0 OR (@OBTC=1 and HB.OBTCNo is not null AND HB.OBTCNo != '')    
   OR (@OBTC=2 and (HB.OBTCNo is null OR HB.OBTCNo = '')))    
 ) Hotel    
 ORDER BY Hotel.[Date/Time] DESC    
    
 IF OBJECT_ID ( 'tempdb..#tempTableCruise') IS NOT NULL    
  DROP TABLE  #tempTableCruise    
 SELECT * INTO #tempTableCruise FROM    
 (    
  SELECT DISTINCT    
  CB.CreatedOn 'Date/Time'    
  , BR.Icast as 'CUSTID'    
  ,'' AS [RH Ledgers]    
  --, AL.BookingCountry AS 'Country'    
  --, C.Value AS 'User Type'    
  , (CASE WHEN @UID!=NULL THEN AL.BookingCountry ELSE     
   (Select     
   STUFF((SELECT ', ' + MC.CountryCode    
   FROM mUserCountryMapping MU WITH(NOLOCK)   
   INNER JOIN mCountry MC WITH(NOLOCK) ON MU.CountryId = MC.ID     
   INNER  JOIN mUser MS WITH(NOLOCK) ON MU.UserId = MS.ID AND MS.ID=@UserId    
   FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'Country'    
  , (CASE WHEN @UID!=NULL THEN C.Value ELSE     
   (Select     
   STUFF((SELECT ', ' + MC.Value    
   FROM mUserTypeMapping MU WITH(NOLOCK)   
   INNER JOIN mCommon MC WITH(NOLOCK) ON MU.UserTypeId = MC.ID AND MC.Category = 'UserType'    
   INNER  JOIN mUser MS WITH(NOLOCK) ON MU.UserId = MS.ID AND MS.ID=@UserId    
   FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 2, '')) END) AS 'User Type'    
  , MU.UserName +' - '+ Mu.FullName 'BookedBy'    
  , isnull(MU.UserName + ' - ' + MU.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'IssuedBy'    
  , CB.BookingReferenceid 'BookingID'    
  --, CB.BookingReferenceid 'BookingReferenceid'    
  , (select top 1 ISNULL(ite.StartDate,'') as  StartDate from Cruise.BookedItineraries ite WITH(NOLOCK) where ite.FkBookingId=CB.Id) as 'StartDate'    
  , '' AS 'Airline Code'    
  , '' as 'Hotel PNR'    
  , '' as 'Ticket No'    
  , '' as 'Travel Sector'    
  , convert(decimal(18,2),0)  as 'Base Amt'    
  , convert(decimal(18,2),0.00) as 'Tax Amt'    
  , convert(varchar(20),CB.TotalPrice)  as 'TotalPrice'    
  , 'INR' as 'Currency'    
  , (select top 1 pax.FirstName +' '+ pax.LastName from Cruise.BookedPaxDetails pax WITH(NOLOCK) where pax.FkBookingId=CB.Id and pax.IsPrimaryPax=1) as  'LeadPaxName'    
  , (select Count(pax.FkBookingId) from Cruise.BookedPaxDetails pax WITH(NOLOCK) where pax.FkBookingId=CB.Id) as 'No.ofPax'    
  , 'Self Balance' AS 'PaymentMode'    
  , CASE WHEN CB.SB_ReversalStatus=0 then 'Pending'    
    WHEN CB.SB_ReversalStatus=1 then 'Completed'        END 'ReversalStatus'    
  , CB.AgentInvoiceNumber    
  , CB.InquiryNo    
  , CB.FileNo    
  , CB.PaymentRefNo    
  , CB.OBTCNo    
  , CB.RTTRefNo    
  , CB.OpsRemark    
  , CB.AcctsRemark    
  , '' AS  AddUserSelfBalance    
  FROM cruise.Bookings CB WITH(NOLOCK)     
  LEFT JOIN cruise.BookedItineraries CBI WITH(NOLOCK) ON CB.Id=CBI.FkBookingId      
  LEFT JOIN B2BRegistration BR WITH(NOLOCK) ON CB.AgentId=BR.FKUserID    
  LEFT JOIN mUser MU WITH(NOLOCK) ON CB.RiyaUserId=Mu.ID    
  LEFT JOIN AgentLogin al WITH(NOLOCK) ON CB.AgentId=al.UserID    
  LEFT JOIN mCommon C WITH(NOLOCK) ON C.ID = al.UserTypeID    
  WHERE    
  CAST(CB.CreatedOn AS DATE) BETWEEN @FromDate AND @ToDate    
  AND (@Status='All' OR (CB.SB_ReversalStatus=cast(@statusInt AS BIT)))    
  AND CB.PaymentMode=4    
  AND (@UserId='' OR CB.RiyaUserId=@USerId)    
  AND CB.IsActive = 1    
 ) Cruise    
 ORDER BY Cruise.[Date/Time] DESC    
    
 IF(@IsPaging=1)    
 BEGIN    
  SELECT *  INTO #tempALL FROM  (    
   SELECT     
   'Air' AS Type,    
   * FROM #tempTableAir       
   WHERE @ProductType=0 OR @ProductType=1    
          
   UNION ALL    
    
   SELECT     
   'Hotel' AS Type,    
   * FROM #tempTableHotel    
   WHERE @ProductType=0 OR @ProductType=2    
    
   UNION ALL    
    
   SELECT     
   'Cruise' AS Type,    
   * FROM #tempTableCruise    
   WHERE @ProductType=0 OR @ProductType=3    
      
  )AS RES    
  ORDER BY [Date/Time] desc      
      
  SELECT @RecordCount = @@ROWCOUNT    
    
  SELECT * FROM #tempALL    
  ORDER BY [Date/Time] DESC    
  OFFSET @Start * @Pagesize ROWS        
  FETCH NEXT @Pagesize ROWS ONLY    
 END    
 ELSE    
 BEGIN    
  SELECT * FROM (     
   SELECT     
   'Air' as Type,    
   * FROM #tempTableAir    
   WHERE @ProductType=0 OR @ProductType=1    
    
   UNION ALL    
    
   SELECT     
   'Hotel' AS Type,    
   * FROM #tempTableHotel    
   WHERE @ProductType=0 OR @ProductType=2    
    
   UNION ALL    
    
   SELECT     
   'Cruise' AS Type,    
   * FROM #tempTableCruise    
   WHERE @ProductType=0 OR @ProductType=3    
    
  ) AS RES ORDER BY [Date/Time]    
 END    
END 