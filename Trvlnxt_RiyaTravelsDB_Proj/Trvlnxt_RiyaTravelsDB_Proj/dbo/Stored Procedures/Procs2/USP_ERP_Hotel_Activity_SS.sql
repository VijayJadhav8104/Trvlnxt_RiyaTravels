--sp_helptext USP_ERP_Hotel_Activity_SS 'SightSeeingBooking'            
            
--'TNHAPI00094088,TNA0001624,TNA0001623,TNA0001629,TNA0001624,TNA0001623,TNA0001622,TNA0001629,TNA0001627,TNA0001631,TNA0001635,TNA0001633,TNA0001648,TNA0001647,TNA0001646,TNH00278810,TNH00278811,TNH00278809,TNH00278810'            
--sp_helptext USP_ERP_Hotel_Activity 'SightSeeingBooking'                                          
--=================================                                          
                                                     
-- =============================================                                                                                                    
-- Author:  Rahul A                                                                                               
-- Create date: 28 Mar 2022                                                                                                    
-- Description: ERP Activity                                                                                            
-- =============================================                                                                                            
--[USP_ERP_Hotel_Activity] 'Hotel_WinYatraBooking','','',''                                                                                            
CREATE PROCEDURE [dbo].[USP_ERP_Hotel_Activity_SS]                                                                                             
 @Action varchar(50)=null,                                                                                            
 @empcode varchar(50) =null,                                                                                            
 @Hotel_ERPResponceID varchar(500) = null,                                                                                            
@Hotel_CanERPResponceID varchar(500) = null,                                                                                            
@PKID int = null                                                                                            
AS                                                                                                    
BEGIN                                            
                                          
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
 ,'Others' as 'ProductType'                                                                                            
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
WHEN HBM.providerId IN ('rt-rtactivities-live') AND BR.country = 'INDIA' and AL.userTypeID!=4 THEN 'BOMVEND000639'       
-- Default for the first condition                                                                  
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
  ,FkStatusId ,CreateDate                                                                                         
 FROM SS.SS_Status_History AS cc                                                                                           
 WHERE cc.FKStatusId = 4                                                                                        
 GROUP BY BookingId                                                                                            
  ,FkStatusId  ,CreateDate                                                                                          
 ) AS HSHVouchred ON HSHVouchred.BookingId = HBM.BookingId                                                                                            
LEFT JOIN agentLogin AL ON AL.UserID = HBM.AgentID                                                                                            
WHERE HSHVouchred.FkStatusId = 4                                                                                            
 and AL.userTypeID IN (                                     
  2                                                                  
  ,3                                                                                            
 -- ,4       As Discussed with gary no holiday booking will go to ERP                                                                                   
  )                                                                                            
 and HBM.BookingStatus not in ('Cancelled','cancelled','Failed','failed')                                                                                            
 --AND BR.CustomerCOde not in  ('23R231')                                                                                            
 --AND HBM.BookingPortal = 'TNH'                                                                                            
  AND HBM.PaymentMode = 2 --discuss with Gary and faizan sir, 08/04/2025- As discussed with Gary only creditlimit records will  get push inERP                         
                                                                                            
 and BR.country in ('India','UAE','CA','US')                      
 AND HBM.creationDate > (GETDATE() - 60) --'2022-03-31 23:59:59.999'                        
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
--   and BookingRefId in('TNA0001906'  
--,'TNA0001907'      )  
                          
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
 ,'Others' as 'ProductType'                                                                                            
                                                                                           
 ,'E-Ticket' AS 'TicketType'                                            
 ,TripStartDate as 'CheckInDate'                                                  
 ,TripEndDate as 'CheckOutDate'                                                                                            
 ,SUBSTRING(HBM.providername, 1, 10) AS 'SupplierCode'-- ask gary                                                               
 ,case when HBM.providerId = 'rt-rtactivities-live' and BR.country = 'INDIA' then 'CUST00414'                                                                       when HBM.providerId = 'rt-vtactivities-live' and BR.country = 'UAE' then BR.CustomerCOde  
  
    
      
        
        
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
WHEN HBM.providerId IN ('rt-hbactivities-live','rt-vtactivities-live') AND BR.country = 'INDIA' and AL.userTypeID!=4 THEN 'BOMVEND002137'          
WHEN HBM.providerId IN ('rt-rtactivities-live') AND BR.country = 'INDIA' and AL.userTypeID!=4 THEN 'BOMVEND000639'       
      
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
 --WHERE cc.FKStatusId = 4                                                                                            
 GROUP BY BookingId                                                                                      
  ,FkStatusId  ,CreateDate                                             
 ) AS HSHVouchred ON HSHVouchred.BookingId = HBM.BookingId                                                                                            
LEFT JOIN agentLogin AL ON AL.UserID = HBM.AgentID                                                                                         
   Where SS.IsActive=1                                                    
  and SS.FkStatusId=7                                                                                             
  and AL.userTypeID in (2,3        
  --,4-- No ERP Push for Holiday USErs. discussed with Gary modified on 08/04/25        
          
  )                                                                                             
  --AND BR.CustomerCOde not in  ('23R231')                                                                                            
  and HBM.PaymentMode=2  -- As discussed with Gary Uncommented ERP push only for Creditlimit , modified on 08/04/25                                      
  and HBM.creationDate > (GETDATE()-30) --'2022-03-31 23:59:59.999'                          
 AND Cast(HBM.creationDate as date) >=cast('2025-03-13' as date)                        
 and BR.country in ('India','UAE','CA','US')                      
                        
  and HBM.SightSeeing_ERPCanResponseID is null         
  and (HBM.SightSeeing_ERPCanPushStatus = 0 or HBM.SightSeeing_ERPCanPushStatus is null)               
                      
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