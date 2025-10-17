CREATE PROCEDURE [dbo].[USP_ERP_Rail_Activity]                           
 @Action varchar(50)=null,                          
 @empcode varchar(50) =null,                          
 @Rail_ERPResponceID varchar(500) = null,                          
@Rail_CanERPResponceID varchar(500) = null,                    
@RiyaPnr varchar(50)=null,                    
@PKID int = null                          
AS                          
BEGIN                          
 IF @Action = 'RailBooking'                              
   BEGIN                          
  WIth RankedRecords as                     
(                    
select top 10000                     
 bk.Id as 'BID',                    
  bki.Id as 'BKIID',                    
  bk.Id as 'MoDocumentNo',                          
  bk.RiyaPnr as 'TicketNoPolicyNo',                          
  b2b.AgencyName,                    
   bk.BookingFee,                    
  bk.BookingDate as 'inserteddate',                          
  'Foreign Rail'  as 'ProductType',                          
  'E-Ticket' as 'TicketType',                          
  CASE                          
   WHEN bk.AgentCurrency='INR' THEN 'IN'                          
   WHEN bk.AgentCurrency='AED' THEN 'AE'                          
   WHEN bk.AgentCurrency='USD' THEN 'US'                          
   WHEN bk.AgentCurrency='CAD' THEN 'CA'                    
   WHEN bk.AgentCurrency='GBP' THEN 'UK'                    
   WHEN bk.AgentCurrency='SAR' THEN 'SA'                    
   END AS 'BookingCountry',                    
                       
  CASE                          
    WHEN bki.Type = 'PASS' THEN                          
    CASE                          
     WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''                          
      THEN bki.validityPeriodStart                          
      ELSE bki.activationPeriodStart                          
    END                          
   ELSE bki.Departure                          
  END AS CheckInDate,                          
  CASE                          
    WHEN bki.Type = 'PASS' THEN                          
    CASE                          
      WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''                          
                     THEN bki.validityPeriodEnd                          
                     ELSE bki.activationPeriodEnd                          
    END                          
   ELSE bki.Arrival                          
   END AS CheckOutDate,                    
  bk.Supplier as 'SupplierCode',                    
 b2b.Icast AS 'ShipToCustomer',                     
                    
  CASE WHEN bk.AgentCurrency = 'INR'                          
  THEN 'BOMVEND002137'                          
  ELSE                           
   CASE WHEN bk.Currency = 'CHF' THEN 'VEND004032'                          
     ELSE   'VEND004033'                          
     END                          
  END AS PayToVendor,                    
                      
  bk.Currency AS 'Currency',                    
  bk.BookingReference as 'riyaPNR',                          
  pax.type as 'PassangerType',                          
  pax.title as 'LeaderTitle',                          
  pax.firstName+' '+ pax.lastName as 'PaxName',                          
  b2b.BranchCode,                    
  'CC1012000' AS 'DivisionCode',                    
  MU.EmployeeNo 'EmployeeCode',                          
  bk.AgentCurrency AS 'SalesCurrencyCode',                          
  bk.Currency AS 'PurchCurrencyCode',                          
  ROUND(bki.AgentAmount * bki.FinalROE, 2) AS 'BaseAmount',                    
  bk.AmountPaidbyAgent as 'AmountPaidbyAgent',                    
  0 'TaxAmount',                          
  bk.MarkUpOnBookingFee as MarkupOnBaseFare,                          
  0 'VendorMarkup',                          
  '' AS CardNumber,                           
  '' AS CardType,                          
  0 'ExtraCharges',                          
  0 'ExtraBedCharges',                          
  '' AS PaymentMode_UATP,                          
  b2b.LocationCode as 'CustomerLocationCode',                          
  pax.phoneNumber as 'PassengerPhone',                          
  pax.emailAddress as 'PassengerEmail',                          
  'TRVLNXT' AS 'BookingType',                          
  '' AS  'Rail Inclusions',                          
  0 'NOOfRooms',                          
  0 'RoomNights',                          
  '' as 'RoomType',                          
  '' AS 'RailCity',                          
  '' AS 'RailName',                          
   (SELECT COUNT(*)                           
       FROM Rail.PaxDetails pd WITH (NOLOCK)                           
       WHERE pd.fk_ItemId = bki.Id                           
         AND (pd.type = 'ADULT' OR pd.type = 'SENIOR')) AS NOOfAdults,                          
                   
      (SELECT COUNT(*)                           
       FROM Rail.PaxDetails pd WITH (NOLOCK)                          
       WHERE pd.fk_ItemId = bki.Id                              
         AND pd.type = 'YOUTH') AS NOOfChildren,                          
  0 'NOOfInfant',                          
  0 'RatePerNight-No',                          
  0 'ChildRate',                          
  0 'ExtraBed',                    
  bki.PNR,                    
  CASE                    
  when al.userTypeID=1 then 'B2C'                    
  when al.userTypeID=2 then 'B2B'                    
  when al.userTypeID=3 then 'Marine'                    
  when al.userTypeID=4 then 'Holiday'                    
  when al.userTypeID=5 then 'RBT'                    
  END as 'UserType',               
  case              
  when bki.Type='pass' then bki.Title              
  when bki.Type='Ticket' then bki.Origin              
  end as Origin,              
   case              
  when bki.Type='pass' then bki.Title              
  when bki.Type='Ticket' then bki.Destination              
  end as Destination,              
   case              
  when bki.Comfort='1' then 'First'              
  when bki.Comfort='2' then 'Second'              
  else bki.Comfort              
  end as Travelclass,              
  --al.userTypeID,                    
  --al.country,                   
  ROW_NUMBER() over(PARTITION BY bki.fk_bookingId order by bki.Id) as row_N                    
  FROM Rail.Bookings bk  WITH (NOLOCK)                                
    left JOIN AgentLogin al  WITH (NOLOCK) ON bk.AgentId = al.UserID                                
    left JOIN B2BRegistration b2b  WITH (NOLOCK) ON bk.AgentId = b2b.FKUserID                                
    left JOIN RAIL.BookingItems bki  WITH (NOLOCK) ON bk.Id=bki.fk_bookingId                                
    left join Rail.PaxDetails pax  WITH (NOLOCK) on pax.fk_ItemId = bki.Id --and pax.leadTraveler = 1                     
    LEFT JOIN mUser MU WITH (NOLOCK) ON bk.RiyaUserId = MU.ID                          
                            
    where bk.bookingStatus='INVOICED'                          
    and bki.Status='CONFIRMED'                    
 and (al.userTypeID !=4 or al.Country !='INDIA')                    
 and al.userTypeID !=5                    
 --and bk. RiyaPnr in('TNR00003566')                    
 AND CONVERT(DATE, bk.CreatedDate) >='2025-08-14'  -- Start from today's date (and onwards)                    
 and bk.Rail_ERPPushStatus=0                    
 and bk.PaymentMode!='RiyaAgentSelfBalance'                    
 --And bk.AgentCurrency='AED'                    
                    
 )                    
 select * ,                    
 case when row_N = 1 then 1                    
 Else 0 END as IsLastRecord                    
 from RankedRecords order by BKIID desc                    
 END                          
 IF @Action = 'RailCancellation'                              
   BEGIN                     
   WIth RankedRecords as                     
(   
  select top 10000                     
  bk.Id as 'BID',                    
  bki.Id as 'BKIID',                    
  bk.Id as 'MoDocumentNo',                          
  bk.RiyaPnr as 'TicketNoPolicyNo',                          
  b2b.AgencyName,                    
  bk.BookingFee,                    
  bk.BookingDate as 'inserteddate',                          
  'Foreign Rail'  as 'ProductType',                          
  'E-Ticket' as 'TicketType',                    
                      
 CASE                          
   WHEN bk.AgentCurrency='INR' THEN 'IN'                          
   WHEN bk.AgentCurrency='AED' THEN 'AE'                          
   WHEN bk.AgentCurrency='USD' THEN 'US'                          
   WHEN bk.AgentCurrency='CAD' THEN 'CA'                    
   WHEN bk.AgentCurrency='GBP' THEN 'UK'                    
   WHEN bk.AgentCurrency='SAR' THEN 'SA'                    
   END AS 'BookingCountry',                          
  CASE                          
    WHEN bki.Type = 'PASS' THEN                          
    CASE                          
     WHEN bki.activationPeriodStart IS NULL OR bki.activationPeriodStart = ''                          
      THEN bki.validityPeriodStart                          
      ELSE bki.activationPeriodStart                          
    END                          
   ELSE bki.Departure                          
  END AS CheckInDate,                          
  CASE                          
    WHEN bki.Type = 'PASS' THEN                          
    CASE                          
      WHEN bki.activationPeriodEnd IS NULL OR bki.activationPeriodEnd = ''                          
                     THEN bki.validityPeriodEnd                          
                     ELSE bki.activationPeriodEnd                          
    END                          
   ELSE bki.Arrival                          
   END AS CheckOutDate,                    
                       
 bk.Supplier as 'SupplierCode',                    
 b2b.Icast AS 'ShipToCustomer',                     
   CASE WHEN bk.AgentCurrency = 'INR'                          
  THEN 'BOMVEND002137'                          
  ELSE                           
   CASE WHEN bk.Currency = 'CHF' THEN 'VEND004032'                          
     ELSE   'VEND004033'                          
     END                          
  END AS PayToVendor,                
                      
    bk.Currency AS 'Currency',                    
  bk.BookingReference as 'riyaPNR',                          
  pax.type as 'PassangerType',                          
  pax.title as 'LeaderTitle',                          
  pax.firstName+' '+ pax.lastName as 'PaxName',                          
  b2b.BranchCode,                    
  'CC1012000' AS 'DivisionCode',                    
  MU.EmployeeNo 'EmployeeCode',                          
  bk.AgentCurrency AS 'SalesCurrencyCode',                          
  bk.Currency AS 'PurchCurrencyCode',                    
  ROUND(bki.AgentAmount * bki.FinalROE, 2) AS 'BaseAmount',                    
  bk.AmountPaidbyAgent as 'AmountPaidbyAgent',                    
  --bk.AmountPaidbyAgent as 'BaseAmount',                          
  0 'TaxAmount',                          
  bk.MarkUpOnBookingFee as MarkupOnBaseFare,                          
  0 'VendorMarkup',                          
  '' AS CardNumber,                           
  '' AS CardType,                            
  0 'ExtraCharges',                          
  0 'ExtraBedCharges',                          
  0 'MarkupOnCancellation',                          
  --(bk.BookingFee + bk.MarkUpOnBookingFee + bk.TaxOnBookingFee) * bk.BFFinalROE AS 'PenaltyAmount',
    (bk.AmountPaidbyAgent-(ph.AgentAmount*bki.FinalROE)) as 'PenaltyAmount',
  0 'SerFeeOnCancellation',                           
  0 'MgmtFeeOnCancellation',                          
  bk.expirationDate as 'CancelDate',                          
  '' AS PaymentMode_UATP,                          
  b2b.LocationCode as 'CustomerLocationCode',                          
 pax.phoneNumber as 'PassengerPhone',                          
  pax.emailAddress as 'PassengerEmail',                          
  'TRVLNXT' AS 'BookingType',                          
  '' AS  'Rail Inclusions',                          
  0 'NOOfRooms',                          
  0 'RoomNights',                          
  '' as 'RoomType',                          
  '' AS 'RailCity',                          
  '' AS 'RailName',                          
   (SELECT COUNT(*)                         
       FROM Rail.PaxDetails pd WITH (NOLOCK)                          
       WHERE pd.fk_ItemId = bki.Id                           
         AND (pd.type = 'ADULT' OR pd.type = 'SENIOR')) AS NOOfAdults,                          
                                   
      (SELECT COUNT(*)                           
       FROM Rail.PaxDetails pd WITH (NOLOCK)                          
       WHERE pd.fk_ItemId = bki.Id                           
         AND pd.type = 'YOUTH') AS NOOfChildren,                          
  0 'NOOfInfant',                          
  0 'RatePerNight-No',                          
  0 'ChildRate',                          
  0 'ExtraBed',                    
  bki.PNR,                    
   CASE                    
  when al.userTypeID=1 then 'B2C'                    
  when al.userTypeID=2 then 'B2B'                    
  when al.userTypeID=3 then 'Marine'                    
  when al.userTypeID=4 then 'Holiday'                    
  when al.userTypeID=5 then 'RBT'                    
  END as 'UserType',               
  case           
  when bki.Type='pass' then bki.Title              
  when bki.Type='Ticket' then bki.Origin              
  end as Origin,              
   case              
  when bki.Type='pass' then bki.Title              
  when bki.Type='Ticket' then bki.Destination              
  end as Destination,              
   case              
  when bki.Comfort='1' then 'First'              
  when bki.Comfort='2' then 'Second'              
  else bki.Comfort              
  end as Travelclass,              
  ROW_NUMBER() over(PARTITION BY bki.fk_bookingId order by bki.Id) as row_N                    
  FROM Rail.Bookings bk WITH (NOLOCK)                               
    left JOIN AgentLogin al WITH (NOLOCK) ON bk.AgentId = al.UserID                                
    left JOIN B2BRegistration b2b WITH (NOLOCK) ON bk.AgentId = b2b.FKUserID                                
    left JOIN RAIL.BookingItems bki WITH (NOLOCK) ON bk.Id=bki.fk_bookingId and bki.isinbound=0                               
    left join Rail.PaxDetails pax WITH (NOLOCK) on pax.fk_ItemId = bki.Id and pax.leadTraveler = 1 
    left join rail.PricingHistory PH on bk.id=PH.Fk_BookingId and ph.OperationType='Refund'
    LEFT JOIN mUser MU WITH (NOLOCK) ON bk.RiyaUserId = MU.ID                          
                            
      where (bk.bookingStatus = 'MODIFIED' OR bk.bookingStatus = 'REFUNDED')
    AND bki.Status = 'CANCELED'                   
 and (al.userTypeID !=4 or al.Country !='INDIA')                    
 and al.userTypeID !=5                    
AND CONVERT(DATE, bk.CreatedDate) >='2025-08-18'  
  and bk.PaymentMode!='RiyaAgentSelfBalance'                    
 and bk.Rail_CanERPPushStatus=0                
 --and bk.RiyaPnr in('TNR00003856')               
                    
 )                    
 select * ,                    
 case when row_N = 1 then 1                    
 Else 0 END as IsLastRecord                    
 from RankedRecords order by BKIID desc                    
  END                      
  IF @Action='RailBookingFess'                    
  begin                    
   select                    
   bk.Id as 'IdB',                    
   100 as 'BKIID',                    
  bk.RiyaPnr as 'MoDocumentNo',                          
  bk.RiyaPnr as 'TicketNoPolicyNo',                    
   bk.BookingFee,                    
  b2b.AgencyName,                          
 bk.BookingDate as 'inserteddate',                          
  'Foreign Rail'  as 'ProductType',                          
  'E-Ticket' as 'TicketType',                    
  'BookingFees' as 'Narration',                    
    CASE                          
   WHEN bk.AgentCurrency='INR' THEN 'IN'                          
   WHEN bk.AgentCurrency='AED' THEN 'AE'                          
   WHEN bk.AgentCurrency='USD' THEN 'US'                          
   WHEN bk.AgentCurrency='CAD' THEN 'CA'                    
   WHEN bk.AgentCurrency='GBP' THEN 'UK'                    
   WHEN bk.AgentCurrency='SAR' THEN 'SA'                    
   END AS 'BookingCountry',                     
  bk.BookingDate as 'CheckInDate',                    
 bk.BookingDate as 'CheckOutDate',                    
  bk.Supplier as 'SupplierCode',                          
 b2b.Icast AS 'ShipToCustomer',                     
                     
   CASE WHEN bk.AgentCurrency = 'INR'                          
  THEN 'VEND00137'                          
  ELSE                           
   CASE WHEN bk.Currency = 'CHF' THEN 'VEND004032'                          
     ELSE   'VEND004033'                          
     END                          
  END AS PayToVendor,                    
                      
  bk.BookingReference as 'riyaPNR',                          
  '' as 'PassangerType',                          
  '' as 'LeaderTitle',                          
  pax.firstName+' '+ pax.lastName as 'PaxName',                           
 '00' as 'BranchCode',                     
                     
  --CASE                         
  --WHEN bk.AgentCurrency = 'AED'                        
  -- THEN 'CC1012000'                        
  --ELSE 'CC1001000'                        
  --END AS 'DivisionCode',                     
  --AED DivisionCode                    
  'CC1012000' AS 'DivisionCode',                    
  MU.EmployeeNo as  'EmployeeCode',                          
  bk.AgentCurrency AS 'SalesCurrencyCode',                          
  bk.Currency AS 'PurchCurrencyCode',                    
CASE WHEN bk.AgentCurrency = 'INR'     THEN ROUND((bk.BookingFee + bk.MarkUpOnBookingFee) * bk.BFFinalROE, 2)           + ROUND((bk.MarkUpOnBookingFee * 18 / 100) * bk.BFFinalROE, 2)     ELSE ROUND((bk.BookingFee + bk.MarkUpOnBookingFee) * bk.BFFinalROE,
  
     
     
        
          
            
               
               
                   
2) END AS 'BaseAmount',                    
bk.AmountPaidbyAgent as 'AmountPaidbyAgent',                    
0 'TaxAmount',                          
  bk.MarkUpOnBookingFee as MarkupOnBaseFare,                          
  0 'VendorMarkup',                          
  '' AS CardNumber,                           
  '' AS CardType,                          
  0 'ExtraCharges',                          
  0 'ExtraBedCharges',                    
  '' AS 'MarkupOnCancellation',                          
  0 'PenaltyAmount',                          
  0 'SerFeeOnCancellation',                           
  0 'MgmtFeeOnCancellation',                        
  bk.expirationDate as 'CancelDate',                     
  '' AS PaymentMode_UATP,                          
 '' as 'CustomerLocationCode',                          
  '' as 'PassengerPhone',                          
  '' as 'PassengerEmail',                          
  'TRVLNXT' AS 'BookingType',                          
  '' AS  'Rail Inclusions',                          
  0 'NOOfRooms',                          
  0 'RoomNights',                          
 '' as 'RoomType',                          
  '' AS 'RailCity',                          
  '' AS 'RailName',                          
   '0' AS NOOfAdults,                          
   '0' AS NOOfChildren,                          
  0 'NOOfInfant',                          
  0 'RatePerNight-No',                          
  0 'ChildRate',              
  0 'ExtraBed'                          
                      
   FROM Rail.Bookings bk WITH (NOLOCK)                               
  left JOIN AgentLogin al WITH (NOLOCK) ON bk.AgentId = al.UserID                       
  left JOIN RAIL.BookingItems bki WITH (NOLOCK) ON bk.Id=bki.fk_bookingId                                
  left join Rail.PaxDetails pax WITH (NOLOCK) on pax.fk_ItemId = bki.Id and pax.leadTraveler = 1                    
  left JOIN B2BRegistration b2b WITH (NOLOCK) ON bk.AgentId = b2b.FKUserID                     
  LEFT JOIN mUser MU WITH (NOLOCK) ON bk.RiyaUserId = MU.ID                    
  where bk.bookingStatus='INVOICED'                    
  AND bk.RiyaPnr=@RiyaPnr                    
                      
  GROUP BY     bk.Id, bk.RiyaPnr, bk.BookingFee, b2b.AgencyName, bk.BookingDate, bk.AgentCurrency,      bk.Supplier, b2b.Icast, bk.MarkUpOnBookingFee, bk.expirationDate,MU.EmployeeNo,  bk.BFFinalROE,bk.Currency,pax.firstName,pax.lastName,                 
 
  bk.AmountPaidbyAgent,bk.BookingReference                    
  end                    
   IF @Action='ICUST'                    
  begin                    
   select                    
   bk.Id as 'BID',                    
   bk.RiyaPnr AS 'RiyaPNR',                    
       b2b.Icast AS 'ShipToCustomer',                    
    bk.AmountPaidbyAgent as 'AmountPaidbyAgent'                    
   FROM Rail.Bookings bk WITH (NOLOCK)                               
  left JOIN AgentLogin al WITH (NOLOCK) ON bk.AgentId = al.UserID                       
  --left JOIN RAIL.BookingItems bki WITH (NOLOCK) ON bk.Id=bki.fk_bookingId                                
  --left join Rail.PaxDetails pax WITH (NOLOCK) on pax.fk_ItemId = bki.Id and pax.leadTraveler = 1                    
  left JOIN B2BRegistration b2b WITH (NOLOCK) ON bk.AgentId = b2b.FKUserID                     
  LEFT JOIN mUser MU WITH (NOLOCK) ON bk.RiyaUserId = MU.ID                    
  where bk.bookingStatus='INVOICED'                    
  AND bk.RiyaPnr=@RiyaPnr                    
  end                    
  IF @Action='ICUSTCancellation'                    
  begin                    
   select                    
   bk.Id as 'BID',                    
   bk.RiyaPnr AS 'RiyaPNR',                    
       b2b.Icast AS 'ShipToCustomer',                    
    bk.AmountPaidbyAgent as 'AmountPaidbyAgent'                    
   FROM Rail.Bookings bk WITH (NOLOCK)                               
  left JOIN AgentLogin al WITH (NOLOCK) ON bk.AgentId = al.UserID                       
  --left JOIN RAIL.BookingItems bki WITH (NOLOCK) ON bk.Id=bki.fk_bookingId                                
  --left join Rail.PaxDetails pax WITH (NOLOCK) on pax.fk_ItemId = bki.Id and pax.leadTraveler = 1                    
  left JOIN B2BRegistration b2b WITH (NOLOCK) ON bk.AgentId = b2b.FKUserID                     
  LEFT JOIN mUser MU WITH (NOLOCK) ON bk.RiyaUserId = MU.ID                    
   where bk.bookingStatus='MODIFIED'                           
  --and bki.Status='CANCELED'                    
  AND bk.RiyaPnr=@RiyaPnr                    
  end                    
 IF @Action = 'Rail_BookingSuccessResponce'                          
  BEGIN                          
   UPDATE Rail.Bookings                          
   SET Rail_ERPResponceID = @Rail_ERPResponceID,                           
    Rail_ERPPushStatus = 1                          
   WHERE Id = @PKID;                          
   SELECT @PKID;                          
  END                          
                          
 IF @Action = 'Rail_CancellationSuccessResponce'                          
   BEGIN                          
    UPDATE Rail.Bookings                          
    SET Rail_CanERPResponceID = @Rail_CanERPResponceID,                           
     Rail_CanERPPushStatus = 1                          
    WHERE Id = @PKID;                          
    SELECT @PKID;                          
   END                     
    IF @Action = 'Rail_BookingSuccessResponceBOOKINGFESS'                          
   BEGIN                          
    UPDATE Rail.BookingItems                          
    SET Rail_ERPResponceID = @Rail_ERPResponceID,                           
     Rail_ERPPushStatus = 1                          
    WHERE Id = @PKID;                          
    SELECT @PKID;                          
   END                      
                          
END