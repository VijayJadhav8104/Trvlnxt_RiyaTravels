-- =============================================                      
-- Author:  Rahul A                 
-- Create date: 28 Mar 2022                      
-- Description: ERP Activity              
-- =============================================              
--[USP_ERP_Activity] 'Search','','WGZVFE-1',''              
CREATE PROCEDURE [dbo].[USP_ERP_Hotel_Activity_190824]               
 @Action varchar(50)=null,              
 @empcode varchar(50) =null,              
 @Hotel_ERPResponceID varchar(500) = null,              
@Hotel_CanERPResponceID varchar(500) = null,              
@PKID int = null              
AS                      
BEGIN              
 IF @Action = 'HotelBooking'                  
   BEGIN              
 SELECT TOP 10000 HBM.pkId 'MoDocumentNo'              
 ,BookingReference 'TicketNoPolicyNo'              
 ,BR.AgencyName              
 ,HBM.inserteddate              
 ,HBM.BookingCountry              
 ,CASE               
  WHEN ', ' + HBM.cityName + ',' LIKE '%, india,%'              
   THEN 'Hotel-Dom'              
  ELSE 'Hotel-INT'              
  END AS 'ProductType'              
 ,'E-Ticket' AS 'TicketType'              
 ,CheckInDate              
 ,CheckOutDate              
 ,SUBSTRING(HBM.SupplierName, 1, 10) AS 'SupplierCode'              
 ,BR.CustomerCOde 'ShipToCustomer'              
 ,CASE               
  WHEN HBM.BookingCountry = 'AE'              
   THEN 'VEND00137'              
  ELSE 'VEND000151'              
  END AS 'PayToVendor'              
 ,HBM.riyaPNR              
 ,'Adult' AS 'PassangerType'              
 ,LeaderTitle              
 ,LeaderFirstName + ' ' + LeaderLastName 'PaxName'              
 ,HBM.BranchCode              
 ,CASE               
  WHEN HBM.BookingCountry = 'AE'              
   THEN 'CC1012000'              
  ELSE 'CC1001000'              
  END AS 'DivisionCode'              
 ,MU.EmployeeNo 'EmployeeCode'              
 ,'INR' AS 'SalesCurrencyCode'              
 ,'INR' AS 'PurchCurrencyCode'              
 ,DisplayDiscountRate 'BaseAmount'              
 ,0 'TaxAmount'              
 ,MarkupAmount 'MarkupOnBaseFare'              
 ,0 'VendorMarkup'              
 ,PM.CardNumber              
 ,PM.CardType              
 ,0 'ExtraCharges'              
 ,0 'ExtraBedCharges'              
 ,CASE               
  WHEN HBM.B2BPaymentMode = 3              
   THEN '1'              
  ELSE '0'              
  END AS 'PaymentMode_UATP'              
 ,BR.LocationCode 'CustomerLocationCode'              
 ,book_Id              
 ,hotelId              
 ,AgentId              
 ,PassengerPhone              
 ,PassengerEmail              
 ,'TRVLNXT' AS 'BookingType'              
 ,'' 'Hotel Inclusions'              
 ,HBM.TotalRooms AS 'NOOfRooms'              
 ,HBM.SelectedNights AS 'RoomNights'              
 ,Replace(HRM.RoomTypeDescription, '&', 'and') AS 'RoomType'              
 ,HBM.cityName AS 'HotelCity'              
 ,Replace(HBM.HotelName, '&', 'and') AS 'HotelName'              
 ,HBM.TotalAdults AS 'NOOfAdults'              
 ,HBM.TotalChildren AS 'NOOfChildren'              
 ,'' 'NOOfInfant'              
 ,HBM.RatePerNight 'RatePerNight-No'              
 ,'' 'ChildRate'              
 ,'' 'ExtraBed'              
FROM Hotel_BookMaster HBM              
LEFT JOIN B2BRegistration BR ON HBM.RiyaAgentID = BR.FKUserID              
LEFT JOIN Paymentmaster PM ON PM.order_id = HBM.orderId              
LEFT JOIN Hotel_Room_master HRM ON HRM.book_fk_id = HBM.pkId              
LEFT JOIN Muser MU ON MU.ID = HBM.MainAgentID              
INNER JOIN (              
 SELECT FKHotelBookingId              
  ,max(id) AS max_id              
  ,FkStatusId              
 FROM Hotel_Status_History AS cc              
 WHERE cc.FKStatusId = 4              
 GROUP BY FKHotelBookingId              
  ,FkStatusId              
 ) AS HSHVouchred ON HSHVouchred.FKHotelBookingId = HBM.pkId              
LEFT JOIN agentLogin AL ON AL.UserID = HBM.RiyaAgentID              
WHERE HSHVouchred.FkStatusId = 4              
 AND AL.userTypeID IN (      
  2              
  ,3              
  ,4              
  )              
 AND BR.CustomerCOde not in  ('23R231')              
 AND HBM.BookingPortal = 'TNH'              
 AND HBM.B2BPaymentMode = 2      
 AND HBM.inserteddate > (GETDATE() - 60) --'2022-03-31 23:59:59.999'              
 AND HBM.Hotel_ERPResponceID IS NULL              
 AND (              
  HBM.Hotel_ERPPushStatus = 0              
  OR HBM.Hotel_ERPPushStatus IS NULL              
  )              
--and HBM.BookingReference in ('TNH00005002')              
ORDER BY HBM.pkId DESC              
   END              
              
 IF @Action = 'HotelCancellation'                  
   BEGIN              
  SELECT TOP 10000 HBM.pkId 'MoDocumentNo',BookingReference 'TicketNoPolicyNo',HBM.BookingCountry,HBM.inserteddate,'Hotel-Dom' 'ProductType','E-Ticket' as 'TicketType',CheckInDate,CheckOutDate,              
  HBM.SupplierName as 'SupplierCode',BR.CustomerCOde 'ShipToCustomer',              
  case when HBM.BookingCountry = 'AE' then 'VEND00137' else              
  'VEND000151' end as 'PayToVendor',              
  HBM.riyaPNR,'Adult' as 'PassangerType',              
  LeaderTitle,LeaderFirstName+' '+LeaderLastName 'PaxName',HBM.BranchCode,              
  case when HBM.BookingCountry = 'AE' then 'CC1012000' else              
  'CC1001000' end as 'DivisionCode',              
  MU.EmployeeNo 'EmployeeCode',              
  'INR' as 'SalesCurrencyCode','INR' as 'PurchCurrencyCode',DisplayDiscountRate 'BaseAmount',0 'TaxAmount',MarkupAmount 'MarkupOnBaseFare',              
  0 'VendorMarkup',PM.CardNumber,PM.CardType,0 'ExtraCharges',0 'ExtraBedCharges',HBM.AddCancelCharge 'MarkupOnCancellation',              
  0 'PenaltyAmount',0 'SerFeeOnCancellation', 0 'MgmtFeeOnCancellation',              
  case when SH.FkStatusId=7 then  SH.CreateDate else  '' End as 'CancelDate',              
  Case When HBM.B2BPaymentMode=3 then '1'              
  Else '0'              
  End As 'PaymentMode_UATP'              
  ,BR.LocationCode 'CustomerLocationCode',book_Id,hotelId,AgentId,              
  PassengerPhone,PassengerEmail,'TRVLNXT' as 'BookingType'              
  ,'' 'Hotel Inclusions'              
  ,HBM.TotalRooms as 'NOOfRooms'              
  ,HBM.SelectedNights as 'RoomNights'              
  ,HRM.RoomTypeDescription as 'RoomType'              
  ,HBM.cityName as 'HotelCity'              
  ,Replace(HBM.HotelName,'&','and') as 'HotelName'              
  ,HBM.TotalAdults as 'NOOfAdults'              
  ,HBM.TotalChildren as 'NOOfChildren'              
  ,'' 'NOOfInfant'              
  ,HBM.RatePerNight 'RatePerNight-No'              
  ,'' 'ChildRate'              
  ,'' 'ExtraBed'               
  from Hotel_BookMaster HBM               
  left join B2BRegistration BR on HBM.RiyaAgentID=BR.FKUserID              
  left join Paymentmaster PM on PM.order_id=HBM.orderId               
  left join Hotel_Room_master HRM on HRM.book_fk_id=HBM.pkId              
  left join Muser MU on MU.ID=HBM.MainAgentID               
              
              
              
  left join Hotel_Status_History SH on SH.FKHotelBookingId=HBM.pkId              
              
              
              
  LEFT JOIN agentLogin AL ON  AL.UserID = HBM.RiyaAgentID              
  Where Sh.IsActive=1               
  and SH.FkStatusId=7               
  and AL.userTypeID in (2,3,4)               
  AND BR.CustomerCOde not in  ('23R231')              
  and HBM.B2BPaymentMode=2              
  and HBM.inserteddate > (GETDATE()-30) --'2022-03-31 23:59:59.999'              
  and HBM.Hotel_CanERPResponceID is null and (HBM.Hotel_CanERPPushStatus = 0 or HBM.Hotel_CanERPPushStatus is null)                         
  Order by HBM.pkId desc              
   END              
              
   IF @Action = 'Hotel_WinYatraBooking'                      
   BEGIN                  
  SELECT TOP 1000 HB.pkId,HB.BookingReference,HB.Hotel_ERPResponceID,HB.AgentCommission,MU.FullName + '-' + MU.UserName as 'UserName',              
  BW.BranchId,BW.SubLed,HB.cityName,HB.Hotel_ERPPushStatus,HB.AgentId,HB.RiyaAgentID,AL.userTypeID,HB.inserteddate,BW.SubLed,HB.riyaPNR,              
  isnull(BW.ledgers,(select ledgers from tblWinyatraHotelMapping where fkstateId = B2BR.StateID and supplier = 'Agoda India')) as Icast,AL.userTypeID,              
  HB.Hotel_ERPResponceID,HB.SupplierName,HB.LeaderTitle,HB.LeaderFirstName,HB.LeaderLastName,HB.CheckInDate,HB.CheckOutDate,HB.TotalRooms,HB.Meal,HB.HotelTDS              
  ,HB.SpecialRemark,HB.TotalChildren,HB.TotalAdults ,Cast(HB.TotalAdults as int) + Cast(HB.TotalChildren as int) as TotalPax,HB.FinalROE,HB.HotelTotalGross,B2BC.SupplierCommission,              
  B2BR.CustomerCOde,B2BR.Icast as obcust,B2BR.AgencyName,HB.providerConfirmationNumber,HB.AgentRefNo,HB.OBTCNo,HB.DisplayDiscountRate,HB.ServiceCharge,HB.CurrencyCode,              
  HB.SupplierCurrencyCode,HB.SupplierRate,HB.ROEValue,REPLACE(HB.HotelName,'&','and') as 'HotelName',HB.SupplierReferenceNo              
  ,B2BC.TDS,HB.HotelConfNumber,HB.SINRCommissionAmount,(B2BC.EarningAmount+B2BC.TDSDeductedAmount) as agentShare,HB.CancellationDeadLine              
  from Hotel_BookMaster HB              
  LEFT JOIN agentLogin AL ON  AL.UserID = HB.RiyaAgentID              
  --LEFT JOIN Hotel_Pax_master PM on HB.pkId = PM.book_fk_id              
  Left Join B2BRegistration B2BR on HB.RiyaAgentID = B2BR.FKUserID              
  left join tblWinyatraHotelMapping BW on B2BR.StateID = BW.fkStateId and HB.SupplierUsername = BW.[RhSupplierId]              
  --inner JOIN(              
  --    select FKHotelBookingId,max(id) as max_id,FkStatusId from Hotel_Status_History as cc                    
  --    where cc.FKStatusId=4              
  --    group by FKHotelBookingId,FkStatusId) as HSHVouchred              
  --ON HSHVouchred.FKHotelBookingId = HB.pkId               
  left join Muser MU on MU.ID=HB.MainAgentID                
  left join B2BHotel_Commission B2BC on B2BC.Fk_BookId=HB.pkId              
   WHERE              
   -- HSHVouchred.FkStatusId=4               
    ((AL.userTypeID = 2 and B2BR.Icast in (select HotelIcust from tblInterBranchWinyatra))              
      or AL.userTypeID IN(4))              
   and HB.inserteddate > (Getdate()-30)              
   and HB.BookingReference in ('TNH00265048')    --TNH00264660          
   --and HB.Hotel_ERPResponceID != null               
   --and (HB.Hotel_ERPPushStatus != 0 or HB.Hotel_ERPPushStatus != null)              
   order by HB.inserteddate desc                
   END                
              
   IF @Action = 'SightSeeingBooking'                  
   BEGIN              
    SELECT distinct BookingRefId,  HBM.BookingId 'MoDocumentNo'              
 ,BookingRefId 'TicketNoPolicyNo'              
 ,BR.AgencyName              
 ,HBM.creationDate              
 ,case when HBM.providerId = 'rt-rtactivities-live' then 'UAE' else BR.country end as 'country'              
 ,HBM.BookingStatus              
 ,BR.CustomerCOde              
 ,HBM.FinalROE              
 ,'Hotel-DOM' as 'ProductType'              
 ,'E-Ticket' AS 'TicketType'              
 ,TripStartDate as 'CheckInDate'              
 ,TripEndDate as 'CheckOutDate'              
 ,SUBSTRING(HBM.providername, 1, 10) AS 'SupplierCode'-- ask gary              
 ,case when HBM.providerId = 'rt-rtactivities-live' and BR.country = 'INDIA' then 'CUST00414'              
 when HBM.providerId = 'rt-vtactivities-live' and BR.country = 'UAE' then BR.CustomerCOde              
 when HBM.providerId = 'rt-rtactivities-live' and BR.country = 'US' then 'CUST01154'              
 when HBM.providerId = 'rt-hbactivities-live' and BR.country = 'UAE' then BR.CustomerCOde              
 when HBM.providerId = 'rt-rtactivities-live' and BR.country = 'CA' then 'CUST01155'              
 else BR.CustomerCOde              
 end as 'ShipToCustomer'              
 ,CASE WHEN HBM.providerId = 'rt-hbactivities-live' and BR.country = 'UAE' then              
 'VEND00137'              
 when HBM.providerid in ('rt-vtactivities-live') then 'VEND00137'              
 when HBM.providerid = 'rt-rtactivities-live ' then 'VEND00189'              
 end AS 'PayToVendor'              
 ,HBM.ProviderConfirmationNumber as 'riyaPNR' -- ask gary              
 ,'Adult' AS 'PassangerType'              
 ,(select top 1 Titel from SS.SS_PaxDetails where BookingId = HBM.BookingId  ) as 'Title'              
 , (select top 1 Name + ' ' + Surname from SS.SS_PaxDetails where BookingId = HBM.BookingId  ) as 'PaxName'              
 ,BR.BranchCode -- Ask Gary              
 ,CASE               
  WHEN BR.Country = 'AE' or BR.Country = 'UAE'or HBM.providerId = 'rt-rtactivities-live'              
   THEN 'CC1012000'              
  ELSE 'CC1001000'              
  END AS 'DivisionCode'              
 ,MU.EmployeeNo 'EmployeeCode'              
 ,'INR' AS 'SalesCurrencyCode'              
 ,'INR' AS 'PurchCurrencyCode'              
 ,BookingRate 'BaseAmount'              
 ,0 'TaxAmount'              
 ,Markup 'MarkupOnBaseFare'              
 ,0 'VendorMarkup'              
 ,PM.CardNumber              
 ,PM.CardType              
 ,0 'ExtraCharges'              
 ,0 'ExtraBedCharges'              
 ,CASE               
  WHEN HBM.PaymentMode = 3              
   THEN '1'              
  ELSE '0'              
  END AS 'PaymentMode_UATP'              
 ,BR.LocationCode 'CustomerLocationCode'              
 --,book_Id              
 --,hotelId              
 --,AgentId              
 ,PassengerPhone              
 ,PassengerEmail              
 ,'TRVLNXT' AS 'BookingType'              
 ,'' 'Hotel Inclusions'              
 --,HBM.TotalRooms AS 'NOOfRooms' -- ask gary              
 --,HBM.SelectedNights AS 'RoomNights' -- ask gary              
 --,Replace(HRM.RoomTypeDescription, '&', 'and') AS 'RoomType'              
 ,HBM.cityName AS 'HotelCity'              
 ,Replace(SSB.ActivityName, '&', 'and') AS 'HotelName'              
 ,(select top 1 totalPax from  SS.SS_PaxDetails where BookingId = HBM.BookingId and totalPax is not null) AS 'NOOfAdults'              
 ,HBM.TotalChildren AS 'NOOfChildren'              
 ,'' 'NOOfInfant'              
 --,HBM.BookingRate 'RatePerNight-No' -- Ask Gary              
 ,'' 'ChildRate'              
 ,'' 'ExtraBed'              
 --,case when BR.Country = MU.CountryID then '0' else '1' end as Intcompanytrans              
FROM SS.SS_BookingMaster HBM              
LEFT JOIN B2BRegistration BR ON HBM.AgentID = BR.FKUserID              
LEFT JOIN Paymentmaster PM ON PM.order_id = HBM.bookingrefid              
LEFT JOIN Hotel_Room_master HRM ON HRM.book_fk_id = HBM.BookingId              
LEFT JOIN Muser MU ON MU.ID = HBM.MainAgentID              
--LEFT JOIN SS.SS_PaxDetails SSP ON SSP.BookingId = HBM.BookingId               
LEFT JOIN SS.SS_BookedActivities SSB ON SSB.BookingId = HBM.BookingId              
INNER JOIN (              
 SELECT BookingId              
  ,max(id) AS max_id              
  ,FkStatusId              
 FROM SS.SS_Status_History AS cc              
 WHERE cc.FKStatusId = 4              
 GROUP BY BookingId              
  ,FkStatusId              
 ) AS HSHVouchred ON HSHVouchred.BookingId = HBM.BookingId              
LEFT JOIN agentLogin AL ON AL.UserID = HBM.AgentID              
WHERE HSHVouchred.FkStatusId = 4              
 and AL.userTypeID IN (              
  2              
  ,3              
  ,4              
  )              
 and HBM.BookingStatus not in ('Cancelled','cancelled','Failed','failed')              
 AND BR.CustomerCOde not in  ('23R231')              
 --AND HBM.BookingPortal = 'TNH'              
 --AND HBM.PaymentMode = 2 --discuss with Gary and faizan sir              
 AND HBM.creationDate > (GETDATE() - 60) --'2022-03-31 23:59:59.999'              
 AND HBM.SightSeeing_ERPResponseID IS NULL              
 AND (              
  HBM.SightSeeing_ERPPushStatus = 0              
  OR HBM.SightSeeing_ERPPushStatus IS NULL              
  )              
 --and BR.country = case when HBM.providerId in ('rt-rtactivities-live')              
 --then 'INDIA' when HBM.providerId in ('rt-vtactivities-live','rt-hbactivities-live') then 'UAE'              
 --WHEN HBM.providerId in ('rt-vtactivities-live','rt-hbactivities-live') then 'US'               
 --WHEN HBM.providerId in ('rt-vtactivities-live','rt-hbactivities-live') then 'CA'              
 --end              
 and HBM.BookingRefId in ('TNA0001198')              
ORDER BY HBM.BookingId DESC              
   END              
              
   IF @Action = 'SightSeeing_BookingSuccessResponce'                      
   BEGIN                  
   Update SS.SS_BookingMaster SET SightSeeing_ERPResponseID = @Hotel_ERPResponceID, SightSeeing_ERPPushStatus = 1        
   Where BookingId = @PKID;              
   select @PKID              
   END                
   IF @Action = 'SightSeeing_CancellationSuccessResponce'                      
   BEGIN                  
   Update SS.SS_BookingMaster SET SightSeeing_ERPResponseID = @Hotel_CanERPResponceID, SightSeeing_ERPPushStatus = 1              
    Where BookingId = @PKID;              
    select @PKID              
                 
   END                
              
     IF @Action = 'Hotel_BookingSuccessResponce'                      
   BEGIN                  
   Update Hotel_BookMaster SET Hotel_ERPResponceID = @Hotel_ERPResponceID, Hotel_ERPPushStatus = 1              
   Where pkId = @PKID;                 
   select @PKID              
   END                
   IF @Action = 'Hotel_CancellationSuccessResponce'                      
   BEGIN                  
   Update Hotel_BookMaster SET Hotel_CanERPResponceID = @Hotel_CanERPResponceID, Hotel_CanERPPushStatus = 1              
    Where pkId = @PKID;              
    select @PKID              
                 
   END                
              
END