        
        
--sp_helptext USP_ERP_Hotel_Activity 'SightSeeingBooking'                            
                            
--'TNHAPI00094088,TNA0001624,TNA0001623,TNA0001629,TNA0001624,TNA0001623,TNA0001622,TNA0001629,TNA0001627,TNA0001631,TNA0001635,TNA0001633,TNA0001648,TNA0001647,TNA0001646,TNH00278810,TNH00278811,TNH00278809,TNH00278810'                            
--sp_helptext USP_ERP_Hotel_Activity 'SightSeeingBooking'                                                          
--=================================                                                          
                                                                     
-- =============================================                                                                                                                    
-- Author:  Rahul A                                                                                                               
-- Create date: 28 Mar 2022                                                                                                                    
-- Description: ERP Activity                                                                                                            
-- =============================================                                                                                                            
--[USP_ERP_Hotel_Activity_winYatraUAT] 'Hotel_WinYatraBooking','','',''                                                                                                            
CREATE PROCEDURE [dbo].[USP_ERP_Hotel_Activity_winYatraUAT]                                                                                                             
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
  ,HSHVouchred.CreateDate as 'PostingDate' --#1044-PostingDate Should Status Change Date                      
                      
 ,HBM.BookingCountry                                                                                                            
 ,CASE                                                                                                             
  WHEN AL.BookingCountry= isnull(HBM.HotelBookCountryCode,HBM.DestinationCountryCode)      
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
  WHEN HBM.BookingCountry = 'SA'                                                                                                                    
   THEN 'VEND000024'                                           
    --NEw for US CA                                            
  WHEN HBM.BookingCountry = 'US'                                                              
   THEN 'UVEND01021'                                                        
   WHEN HBM.BookingCountry = 'CA'                                                                                            
   THEN 'CVEND00242'                                                    
  --ELSE 'VEND000151'                                                                                   
  else isnull(ERP_PayToVendor,'BOMVEND002137') end as 'PayToVendor',                                                                                    
 HBM.riyaPNR                                                                                               
 ,'Adult' AS 'PassangerType'                                                                                                            
 ,LeaderTitle                                                                                                            
 ,LeaderFirstName + ' ' + LeaderLastName 'PaxName'                                                                                            
 ,isnull(HBM.BranchCode,'') as BranchCode                                                          
 ,CASE                                                                                                             
  WHEN HBM.BookingCountry = 'AE'                                                                                                            
   THEN 'CC1012000'                                                                                              
  WHEN HBM.BookingCountry = 'US'                                                                                                   
   THEN 'CC1010000'                                                                      
  WHEN HBM.BookingCountry = 'CA'                                                              
   THEN 'CC1011000'                                                                                                        
  WHEN HBM.BookingCountry = 'GB'                                                                                                                    
   THEN 'CC1013000'                                                                                                       
  WHEN HBM.BookingCountry = 'SA'                                                                                                                    
   THEN 'CC1013000'                                                                     
  ELSE 'CC1001000'                                                                                                            
  END AS 'DivisionCode'                                                                                              
 ,isnull(MU.EmployeeNo,'') as 'EmployeeCode'                                     
,HBM.CurrencyCode AS 'SalesCurrencyCode'         
 ,HBM.CurrencyCode AS 'PurchCurrencyCode'                                                                                              
 --,DisplayDiscountRate 'BaseAmount'                                                                    
 --,hbm.HotelTotalGross 'BaseAmount'                        
,  case when isnull(hbm.ServiceChargesPercent,0.00) = 0.00 and isnull(hbm.TotalServiceCharges,0)>0 and HBM.BookingCountry='IN' then                         
 (hbm.DisplayDiscountRate- hbm.TotalServiceCharges) else hbm.DisplayDiscountRate end 'BaseAmount'            
             
 --,hbm.ServiceCharges 'ServiceFee'                  
 ,case when isnull(hbm.ServiceChargesPercent,0.00)>0.00 then 0 else hbm.ServiceCharges  end 'ServiceFee'                 
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
 ,'' 'Hotel Inclusions'                           ,HBM.TotalRooms AS 'NOOfRooms'                                                                                                            
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
  ,FkStatusId  ,CreateDate                                                                                                  
 FROM Hotel_Status_History AS cc                                                                                                            
 WHERE cc.FKStatusId = 4                                                                                                            
 GROUP BY FKHotelBookingId                                                                                                            
  ,FkStatusId,CreateDate                                                                                     
 ) AS HSHVouchred ON HSHVouchred.FKHotelBookingId = HBM.pkId                                                                                                            
LEFT JOIN agentLogin AL ON AL.UserID = HBM.RiyaAgentID                                                                                                            
WHERE HSHVouchred.FkStatusId = 4                                                                                      
 AND AL.userTypeID IN (                                                                                                    
  2                                                                                                            
  ,3                                                                       
 -- ,4                                                                                                            
  )         
   /*Br.Icast condition applied for test icast to excluded in prod*/        
    and br.Icast not in(        
'BOMCUST059180A'        
,'CUST99999'        
,'CUST01377'        
,'SACUST000001'        
,'SACUST0000002'        
,'UCUST0200100'        
,'17T075'        
,'CCUST12345'        
,'12452')        
        
 AND BR.CustomerCOde not in  (                                                      
 '23R231',                                                      
 '23R263',                                                      
 '23AA46',                                                      
 '23AA46',                                                      
 '17D171',                                                      
 '19H301',                                                      
 '24A278',                                                      
 '18B042',                                                      
 '19SP18','09r039') -- '23R263' , cust id added after discussing with steven for RBTCliq                                                                                                           
 AND HBM.BookingPortal IN ('TNH','TNHAPI')                                                                                                            
 AND HBM.B2BPaymentMode = 2                                              
 AND HSHVouchred.CreateDate > (GETDATE() - 60) --'2022-03-31 23:59:59.999'                                                                                                 
 AND HBM.Hotel_ERPResponceID IS NULL                                                                                                            
 AND (                                                                                        
  HBM.Hotel_ERPPushStatus = 0                                                                              
  OR HBM.Hotel_ERPPushStatus IS NULL                                                                                                            
  )                                                                                                            
--and HBM.BookingReference in ('TNH00265658')                                                    
ORDER BY HBM.pkId DESC                                                                                                            
   END                                         
                
 IF @Action = 'HotelCancellation'                                                                                                                
   BEGIN                                                   
  SELECT TOP 10000 HBM.pkId 'MoDocumentNo',BookingReference 'TicketNoPolicyNo',HBM.BookingCountry                      
  ,HBM.inserteddate                      
   ,SH.CreateDate as 'PostingDate' --#1044-PostingDate Should Status Change Date                      
                        
   ,CASE                                                                                                             
  WHEN AL.BookingCountry= isnull(HBM.HotelBookCountryCode,HBM.DestinationCountryCode)      
   THEN 'Hotel-Dom'                                                                                                            
  ELSE 'Hotel-INT'                                                                                                            
  END AS 'ProductType'                                                         
,'E-Ticket' as 'TicketType',CheckInDate,CheckOutDate,                                                                 
 SUBSTRING(HBM.SupplierName, 1, 10) as 'SupplierCode',BR.CustomerCOde 'ShipToCustomer',                                                                                                            
  case                                           
 when HBM.BookingCountry = 'AE' then 'VEND00137'                                           
 WHEN HBM.BookingCountry = 'SA' THEN 'VEND000024'                                           
  --US, CA integration                                             
   WHEN HBM.BookingCountry = 'US'                                                                    
   THEN 'UVEND01021'                                                        
   WHEN HBM.BookingCountry = 'CA'                                                                                            
   THEN 'CVEND00242'                                           
  --else 'VEND000151' end as 'PayToVendor'                                            
  else isnull(ERP_PayToVendor,'BOMVEND002137') end as 'PayToVendor',                                                                                    
  HBM.riyaPNR,'Adult' as 'PassangerType',                              
  LeaderTitle,LeaderFirstName+' '+LeaderLastName 'PaxName',HBM.BranchCode,                                                                                                            
  CASE                                                                                    
  WHEN HBM.BookingCountry = 'AE'                                     
   THEN 'CC1012000'                                                                                                                    
  WHEN HBM.BookingCountry = 'US'                                               
   THEN 'CC1010000'                                                    
  WHEN HBM.BookingCountry = 'CA'                                                                                                         
   THEN 'CC1011000'                                                                     
  WHEN HBM.BookingCountry = 'GB'                                                                                                                    
   THEN 'CC1013000'                                                                                                       
  WHEN HBM.BookingCountry = 'SA'                                                                                                                    
   THEN 'CC1013000'                                                                                                          
  ELSE 'CC1001000'                                                                                                 
  END AS 'DivisionCode',                                                                                                             
  MU.EmployeeNo 'EmployeeCode',                                                                                                            
   HBM.CurrencyCode as 'SalesCurrencyCode',HBM.CurrencyCode as 'PurchCurrencyCode',                                          
   --DisplayDiscountRate 'BaseAmount',                      
    --hbm.HotelTotalGross 'BaseAmount'                         
  case       
 when isnull(hbm.ServiceChargesPercent,0.00) = 0.00 and isnull(hbm.TotalServiceCharges,0)>0 and HBM.BookingCountry = 'IN'      
  then (hbm.DisplayDiscountRate- hbm.TotalServiceCharges)       
 else hbm.DisplayDiscountRate end 'BaseAmount'                  
 ,hbm.ServiceCharges 'ServiceFee'                        
 ,case when isnull(hbm.ServiceChargesPercent,0.00)>0.00 then 0 else hbm.ServiceCharges  end 'ServiceFee'                 
           
 ,0 'TaxAmount'                
  ,MarkupAmount 'MarkupOnBaseFare',                                                                                                            
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
  and AL.userTypeID in (2,3--,4                                                      
  )                                                           
   AND BR.CustomerCOde not in  ('23R231','23R263','23AA46','23AA46','17D171','19H301','24A278','18B042','19SP18') -- '23R263' , cust id added after discussing with steven for RBTCliq                                                                        
  
    
      
        
 /*Br.Icast condition applied for test icast to excluded in prod*/        
    and br.Icast not in(        
'BOMCUST059180A'        
,'CUST99999'        
,'CUST01377'        
,'SACUST000001'        
,'SACUST0000002'        
,'UCUST0200100'        
,'17T075'        
,'CCUST12345'        
,'12452')        
and HBM.B2BPaymentMode=2                                                                                                            
  and SH.CreateDate > (GETDATE()-30) --'2022-03-31 23:59:59.999'                                                                                             
  and HBM.Hotel_CanERPResponceID is null and (HBM.Hotel_CanERPPushStatus = 0 or HBM.Hotel_CanERPPushStatus is null)                                                                                                                       
  Order by HBM.pkId desc                                                                                                            
   END                                                                                                       
                                              
   IF @Action = 'Hotel_WinYatraBooking'                                      
   BEGIN                                                    
    SELECT                                                                   
  TOP 1000 HB.pkId,HB.BookingReference,HB.Hotel_ERPResponceID,HB.AgentCommission,MU.FullName + '-' + MU.UserName as 'UserName',                                     
   
 isnull(BW.BranchId,(select BranchId from tblWinyatraHotelMapping where fkstateId = B2BR.StateID and supplier = 'Agoda India'))  
 as BranchId,  
 isnull(BW.SubLed,(select SubLed from tblWinyatraHotelMapping where fkstateId = B2BR.StateID and supplier = 'Agoda India'))  
    
  as SubLed,  
    
  HB.cityName,HB.Hotel_ERPPushStatus,HB.AgentId,HB.RiyaAgentID                    
  ,AL.userTypeID,HB.inserteddate                      
   ,HSHVouchred.CreateDate as 'PostingDate' --#1044-PostingDate Should Status Change Date                      
            ,HB.riyaPNR,                                                                                           
  isnull(BW.ledgers,(select ledgers from tblWinyatraHotelMapping where fkstateId = B2BR.StateID and supplier = 'Agoda India')) as Icast,  
    
  AL.userTypeID,                                                                                                          
    
  HB.Hotel_ERPResponceID,HB.SupplierName,HB.LeaderTitle,HB.LeaderFirstName,HB.LeaderLastName,HB.CheckInDate,HB.CheckOutDate,HB.TotalRooms,HB.Meal,HB.HotelTDS                                                             
 ,HB.SpecialRemark,HB.TotalChildren,HB.TotalAdults ,Cast(HB.TotalAdults as int) + Cast(HB.TotalChildren as int) as TotalPax,HB.FinalROE,HB.HotelTotalGross,B2BC.SupplierCommission,        
  B2BR.CustomerCOde,B2BR.Icast as obcust,B2BR.AgencyName,HB.providerConfirmationNumber,HB.AgentRefNo,  
    
  case when  HB.OBTCNo ='12345678' then '' else isnull(HB.OBTCNo,'') end OBTCNo,  
  HB.DisplayDiscountRate,HB.ServiceCharge,HB.CurrencyCode,                   
  HB.SupplierCurrencyCode,HB.SupplierRate,HB.ROEValue,REPLACE(HB.HotelName,'&','and') as 'HotelName',HB.SupplierReferenceNo                                                                                                            
  ,B2BC.TDS,HB.HotelConfNumber,HB.SINRCommissionAmount,(B2BC.EarningAmount+B2BC.TDSDeductedAmount) as agentShare,HB.CancellationDeadLine                                                                                    
  ,HB.winyatraInvoice                                                                          
  ,HB.winyatraError                                                                     
  ,                                                                  
                                                                  
 case B2BR.EntityType                                                                   
 when 'Agent' then 'A'                                                                  
 when 'APIOUT' then 'A'                                                                  
 when 'Intercompany' then 'I'                                                                  
 when 'Internal' then 'NA' end as 'AgtType'                                                                  
 ,                                                                  
 case UPPER( isnull(HB.DestinationCountryCode ,HB.HotelBookCountryCode) )when 'INDIA' then '510010'                                                                   
                                                                   
 when 'IN' then '510010'                                                                  
 else '510020' end                                                                  
 'ObCrCode'                                                                  
                                                                  
                                                                  
  from Hotel_BookMaster HB                                                   
  LEFT JOIN agentLogin AL ON  AL.UserID = HB.RiyaAgentID                                                                                                            
  --LEFT JOIN Hotel_Pax_master PM on HB.pkId = PM.book_fk_id                                                                                                            
  Left Join B2BRegistration B2BR on HB.RiyaAgentID = B2BR.FKUserID                                                                                                            
  left join tblWinyatraHotelMapping BW on B2BR.StateID = BW.fkStateId and HB.SupplierUsername = BW.[RhSupplierId]                                                                                                            
  inner JOIN(                                                                                                   
      select FKHotelBookingId,max(id) as max_id,FkStatusId,CreateDate from Hotel_Status_History as cc                                                                                                                  
      where cc.FKStatusId IN (4)                    
      group by FKHotelBookingId,FkStatusId,CreateDate) as HSHVouchred                                                                                                          
  ON HSHVouchred.FKHotelBookingId = HB.pkId                                                                                                             
  left join Muser MU on MU.ID=HB.MainAgentID                                                                                                     
  left join B2BHotel_Commission B2BC on B2BC.Fk_BookId=HB.pkId                                                                                              
   WHERE                                              
  (                                                    
 (AL.userTypeID = 2 and B2BR.Icast in (select HotelIcust from tblInterBranchWinyatra))                                                     
 or                                                     
 AL.userTypeID IN(4)                    
 )    
 ----AND                                                                                                           
 ---- DATEDIFF(MINUTE,CAST( HB.inserteddate AS datetime),GETDATE())>5                                                                          
 ----     AND CAST( HB.inserteddate  AS DATE )= CAST('2025-05-04' AS DATE)                                                                          
 and (isnull(HB.winyatraInvoice ,'')='' )                                                
 AND isnull(HB.winyatraError,'') !='Invalid PNR No. Or PNR No. already converted into Invoice !!!'                                                
AND
		 HB.BookingReference IN (

'TNHAPI00196505'
,'TNHAPI00196642'
,'TNHAPI00196634'
,'TNHAPI00196626'
,'TNHAPI00196304'
,'TNHAPI00196622'

		)   
                 
 END                                
   IF @Action = 'SightSeeingBooking'                                            
   BEGIN                                                                    
    SELECT distinct BookingRefId,  HBM.BookingId 'MoDocumentNo'                                                                 
 ,BookingRefId 'TicketNoPolicyNo'                                                                                                            
 ,BR.AgencyName                                                                                                            
 ,HBM.creationDate                     
  ,HSHVouchred.CreateDate as 'PostingDate' --#1044-PostingDate Should Status Change Date                      
                   
 ,case when HBM.providerId = 'rt-rtactivities-live' then 'UAE' else BR.country end as 'country'                                                             
 ,HBM.BookingStatus                                                                                                            
 ,BR.CustomerCOde                                                                                                   
 ,isnull(HBM.ROEValue,1)   as 'FinalROE'                                                                                                         
 ,'Hotel-Dom' as 'ProductType'                                                                                                            
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
 end as 'ShipToCustomer',                                                                                                            
                                                                              
                                                                              
CASE                                                               
    WHEN HBM.providerId = 'rt-rtactivities-live' AND BR.country = 'UAE' THEN 'VEND00189'                                                                                  
    WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live') AND BR.country = 'UAE' THEN 'VEND00137'  -- Default for the first condition                                                                                  
  WHEN HBM.providerId = 'rt-rtactivities-live' AND BR.country = 'USA' THEN 'UVEND01174'                                                                                  
  WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live') AND BR.country = 'USA' THEN 'UVEND01021'                                                                                  
  WHEN HBM.providerId = 'rt-rtactivities-live' AND BR.country = 'CANADA' THEN 'CVEND00279'                                                                                  
   WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live')  AND BR.country = 'CANADA' THEN  'CVEND00242'                                                                                   
WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live') AND BR.country = 'INDIA' and AL.userTypeID!=4 THEN 'BOMVEND002137'                          
-- Default for the first condition                                                                                  
WHEN HBM.providerId IN ('rt-rtactivities-live') AND BR.country = 'INDIA' and AL.userTypeID!=4 THEN 'BOMVEND000639'  -- Default for the first condition                                                                                  
ELSE                                                                         
 'VEND00189'                                                                                  
END AS PayToVendor                                                                              
                                                                                                      
 ,HBM.ProviderConfirmationNumber as 'riyaPNR' -- ask gary                                                                                                          
 ,'Adult' AS 'PassangerType'                                                                     
 ,(select top 1 Titel from SS.SS_PaxDetails where BookingId = HBM.BookingId  ) as 'Title'                                                                                 
 , (select top 1 Name + ' ' + Surname from SS.SS_PaxDetails where BookingId = HBM.BookingId  ) as 'PaxName'                                                                                   
 ,BR.BranchCode -- Ask Gary                                                                                                            
,CASE   WHEN BR.Country = 'AE' OR BR.Country = 'UAE' OR HBM.providerId = 'rt-rtactivities-live'                                                                                          
THEN 'CC1012000'                                                                               
WHEN BR.Country = 'SAUDI ARABIA'                                                    
THEN 'CC1013000'                                                                                
WHEN BR.Country = 'CANADA'                                                                                
THEN 'CC1011000'                                                         
WHEN BR.Country = 'USA'                                                                                
THEN 'CC1010000'                                                                          
WHEN BR.Country = 'UNITED KINGDOM'              
THEN 'CC1013000'                                                                                
ELSE 'CC1001000' END AS DivisionCode                       
 ,MU.EmployeeNo 'EmployeeCode'                                                                                                            
 ,HBM.BookingCurrency AS 'SalesCurrencyCode'                                                                                                            
 ,HBM.BookingCurrency AS 'PurchCurrencyCode'                                                                                                            
 ,BookingRate 'BaseAmount'                                                                                                            
 ,0 'TaxAmount'                                        
 ,Markup 'MarkupOnBaseFare'                                                                                                            
 ,0 'VendorMarkup'                                                                                                            
 ,PM.CardNumber                                                                                          
 ,PM.CardType                       ,0 'ExtraCharges'                                                                     
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
  ,FkStatusId   , CreateDate                                                                                                       
 FROM SS.SS_Status_History AS cc                                                                                                           
 WHERE cc.FKStatusId = 4                                                                                                        
 GROUP BY BookingId                                                                                                            
  ,FkStatusId ,CreateDate                                                                                                           
 ) AS HSHVouchred ON HSHVouchred.BookingId = HBM.BookingId                                                                                                            
LEFT JOIN agentLogin AL ON AL.UserID = HBM.AgentID                                                                                                            
WHERE HSHVouchred.FkStatusId = 4                                                                                                            
 and AL.userTypeID IN (                                                     
  2                                          
  ,3                                                           
  ,4                                                                                                          
  )                                                                                                            
 and HBM.BookingStatus not in ('Cancelled','cancelled','Failed','failed')                                                                                                            
 --AND BR.CustomerCOde not in  ('23R231')                                                                                                            
 --AND HBM.BookingPortal = 'TNH'                                                                                                            
 --AND HBM.PaymentMode = 2 --discuss with Gary and faizan sir                                         
                            
 and BR.country in ('India','UAE','CA','US')                                      
 AND HSHVouchred.CreateDate > (GETDATE() - 60) --'2022-03-31 23:59:59.999'                                        
 AND Cast(HBM.creationDate as date) >=cast('2025-03-10' as date)                                        
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
 --                            
                          
                                                                                                           
                          
ORDER BY HBM.BookingId DESC                                                                                           
   END                                                                                      
                                                                                     
    IF @Action = 'SightSeeingCancellation'                                                 
   BEGIN                                                                                                            
    SELECT distinct BookingRefId,  HBM.BookingId 'MoDocumentNo'                                                 
,BookingRefId 'TicketNoPolicyNo'                                                                                  
 ,BR.AgencyName                                                                                                            
 ,HBM.creationDate                     
 ,HSHVouchred.CreateDate as 'PostingDate' --#1044-PostingDate Should Status Change Date                      
                   
 ,case when HBM.providerId = 'rt-rtactivities-live' then 'UAE' else BR.country end as 'country'                                                                                                            
 ,HBM.BookingStatus                                                                    
 ,BR.CustomerCOde                                                                                                            
 ,/*isnull(HBM.ROEValue,1) */Cast(1 as float)      as 'FinalROE'                                                                                                      
 ,'Hotel-Dom' as 'ProductType'                                                                                                            
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
 end as 'ShipToCustomer',                                                     
--CASE                                                                         
--WHEN HBM.providerId = 'rt-rtactivities-live' AND BR.country = 'UAE' THEN 'VEND00137'                                                                              
--    WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live') AND BR.country = 'UAE' THEN 'VEND00189'  -- Default for the first condition                                                       
--  WHEN HBM.providerId = 'rt-rtactivities-live' AND BR.country = 'USA' THEN 'UVEND01174'                                               
--  WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live') AND BR.country = 'USA' THEN 'UVEND01021'                                                                              
--  WHEN HBM.providerId = 'rt-rtactivities-live' AND BR.country = 'CANADA' THEN 'CVEND00279'                                                                              
--   WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live')  AND BR.country = 'CANADA' THEN  'CVEND00242'                                                                               
--ELSE                                                                              
-- 'VEND00189'                                                                              
--END AS PayToVendor                                                                              
         CASE                                                                                   
    WHEN HBM.providerId = 'rt-rtactivities-live' AND BR.country = 'UAE' THEN 'VEND00189'                                                                 
    WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live') AND BR.country = 'UAE' THEN 'VEND00137'  -- Default for the first condition                                                                                  
  WHEN HBM.providerId = 'rt-rtactivities-live' AND BR.country = 'USA' THEN 'UVEND01174'                                                                                  
  WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live') AND BR.country = 'USA' THEN 'UVEND01021'                                                                                  
  WHEN HBM.providerId = 'rt-rtactivities-live' AND BR.country = 'CANADA' THEN 'CVEND00279'                                   
   WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live')  AND BR.country = 'CANADA' THEN  'CVEND00242'                                                                                   
ELSE                                    
 'VEND00189'                                                                                  
END AS PayToVendor                                                                     
                                                                                                            
 ,HBM.ProviderConfirmationNumber as 'riyaPNR' -- ask gary                                                                                                          
 ,'Adult' AS 'PassangerType'                                                                                                            
 ,(select top 1 Titel from SS.SS_PaxDetails where BookingId = HBM.BookingId  ) as 'Title'                                                 
 , (select top 1 Name + ' ' + Surname from SS.SS_PaxDetails where BookingId = HBM.BookingId  ) as 'PaxName'                                                                                                            
 ,BR.BranchCode -- Ask Gary                          
,CASE   WHEN BR.Country = 'AE' OR BR.Country = 'UAE' OR HBM.providerId = 'rt-rtactivities-live'                                                                                          
THEN 'CC1012000'                                                                     
WHEN BR.Country = 'SAUDI ARABIA'                                                         
THEN 'CC1013000'                                                                              
WHEN BR.Country = 'CANADA'                                                                                
THEN 'CC1011000'                                                                                
WHEN BR.Country = 'USA'                                                                                
THEN 'CC1010000'                              
WHEN BR.Country = 'UNITED KINGDOM'                                                         
THEN 'CC1013000'                                        
ELSE 'CC1001000' END AS DivisionCode     
 ,MU.EmployeeNo 'EmployeeCode'                                                                                                            
 ,HBM.BookingCurrency AS 'SalesCurrencyCode'                                                                                                            
 ,HBM.BookingCurrency AS 'PurchCurrencyCode'                                                                                                            
 ,BookingRate 'BaseAmount'                                                                                                            
 ,0 'TaxAmount'                                                                                    
 ,Markup 'MarkupOnBaseFare'                                                                                                     
 ,0 'VendorMarkup'                                                          
 ,PM.CardNumber                                                                                                            
 ,PM.CardType                       ,0 'ExtraCharges'                                                                                       
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
,'' 'NOOfInfant' ,                                                         
  0 'PenaltyAmount',0 'SerFeeOnCancellation', 0 'MgmtFeeOnCancellation', 0 'MarkupOnCancellation'                                                                                      
 --,HBM.BookingRate 'RatePerNight-No' -- Ask Gary                                  
 ,'' 'ChildRate'                                                 
 ,'' 'ExtraBed'                                                               
 ,case when SS.FkStatusId=7 then  SS.CreateDate else  '' End as 'CancelDate'                                                                   
 --,case when BR.Country = MU.CountryID then '0' else '1' end as Intcompanytrans                                                                                                            
FROM SS.SS_BookingMaster HBM                                                                                                      
LEFT JOIN B2BRegistration BR ON HBM.AgentID = BR.FKUserID                                                                                                            
LEFT JOIN Paymentmaster PM ON PM.order_id = HBM.bookingrefid                                                                                                            
LEFT JOIN Hotel_Room_master HRM ON HRM.book_fk_id = HBM.BookingId                                                                                                            
LEFT JOIN Muser MU ON MU.ID = HBM.MainAgentID                                   
--LEFT JOIN SS.SS_PaxDetails SSP ON SSP.BookingId = HBM.BookingId                                                                                                             
LEFT JOIN SS.SS_BookedActivities SSB ON SSB.BookingId = HBM.BookingId                                                                                    
LEFT JOIN SS.SS_Status_History SS ON  SS.BookingId = HBM.BookingId                                                                                   
INNER JOIN (                                                                                 
SELECT BookingId                                                                          
  ,max(id) AS max_id                                                                                                            
  ,FkStatusId  ,CreateDate                                                                                                          
 FROM SS.SS_Status_History AS cc                                                           
 WHERE cc.FKStatusId = 4             
GROUP BY BookingId                                                                                                      
  ,FkStatusId,CreateDate                                                            
 ) AS HSHVouchred ON HSHVouchred.BookingId = HBM.BookingId                                                                                                            
LEFT JOIN agentLogin AL ON AL.UserID = HBM.AgentID                                                                                                         
   Where SS.IsActive=1                                                                    
  and SS.FkStatusId=7                                                                                                             
  and AL.userTypeID in (2,3,4)                                                                                                             
  --AND BR.CustomerCOde not in  ('23R231')                                                                                               
  --and HBM.PaymentMode=2                        
  and HBM.creationDate > (GETDATE()-30) --'2022-03-31 23:59:59.999'                                          
 AND Cast(HBM.creationDate as date) >=cast('2025-03-13' as date)                                        
 and BR.country in ('India','UAE','CA','US')                                      
                                        
  and HBM.SightSeeing_ERPCanResponseID is null and (HBM.SightSeeing_ERPCanPushStatus = 0 or HBM.SightSeeing_ERPCanPushStatus is null)                                                                                                                       
--  and HBM.BookingRefId in (select value                             
-- from                             
-- dbo.fn_split('TNHAPI00094088,TNA0001624,TNA0001623,TNA0001629,TNA0001624,TNA0001623,TNA0001622,TNA0001629,TNA0001627,TNA0001631,TNA0001635,TNA0001633,TNA0001648,TNA0001647,TNA0001646,TNH00278810,TNH00278811,TNH00278809,TNH00278810'                    
  
    
      
        
--,','))                                      
  Order by HBM.BookingId desc                                                                                                     
   END                               
                                                                                            
                                                                                                  
                                                                                                            
   IF @Action = 'SightSeeing_BookingSuccessResponce'                                                                                                          
   BEGIN                                                                                                 
   Update SS.SS_BookingMaster SET SightSeeing_ERPResponseID = @Hotel_ERPResponceID, SightSeeing_ERPPushStatus = 1                                                                                                      
   Where BookingId = @PKID;                                                                                                            
   select @PKID                                                                                                            
   END                                                                                                              
   IF @Action = 'SightSeeing_CancellationSuccessResponce'                                
   BEGIN                                                                               
   Update SS.SS_BookingMaster SET SightSeeing_ERPCanResponseID = @Hotel_CanERPResponceID, SightSeeing_ERPCanPushStatus = 1                                                                           
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