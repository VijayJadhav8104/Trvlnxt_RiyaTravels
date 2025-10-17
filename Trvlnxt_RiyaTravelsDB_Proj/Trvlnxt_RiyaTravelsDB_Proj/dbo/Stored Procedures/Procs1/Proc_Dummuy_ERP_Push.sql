--Proc_Dummuy_ERP_Push'HotelBooking'
create procedure Proc_Dummuy_ERP_Push
 @Action varchar(50)=null
 As
 Begin
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
  WHEN HBM.BookingCountry = 'SA'                                                                                
   THEN 'VEND00024'       
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
 ,HBM.BranchCode                       
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
 ,MU.EmployeeNo 'EmployeeCode'                                                                        
,HBM.CurrencyCode AS 'SalesCurrencyCode'                                                                            
 ,HBM.CurrencyCode AS 'PurchCurrencyCode'                                                          
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
 -- ,4                                                                        
  )                                                                        
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
 AND HBM.inserteddate > (GETDATE() - 60) --'2022-03-31 23:59:59.999'                                                             
 AND HBM.Hotel_ERPResponceID IS NULL                                                                        
 AND (                                                                        
  HBM.Hotel_ERPPushStatus = 0                                          
  OR HBM.Hotel_ERPPushStatus IS NULL                                                                        
  )                                                                        
--and HBM.BookingReference in ('TNH00265658')                                                                        
ORDER BY HBM.pkId DESC                                                                        
   END   
 END