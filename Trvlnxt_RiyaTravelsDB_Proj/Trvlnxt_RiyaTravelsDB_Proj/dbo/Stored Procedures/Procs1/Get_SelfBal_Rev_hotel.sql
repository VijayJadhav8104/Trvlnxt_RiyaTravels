--'01/07/2021 12:00:00','10/07/2021 12:00:00','all'             
 --exec [Get_SelfBal_Rev_hotel] @FromDate= '2024-04-01',@ToDate='2025-01-15',@Status='1',@UserId='23262',@OBTC=0  

CREATE PROCEDURE [dbo].[Get_SelfBal_Rev_hotel]  
 @FromDate Date=null,  
 @ToDate Date=null,  
 @Status Varchar(10)='',  
 @UserId Varchar(500)=null,-- Jitendra Nakum 21/09/2022 add User Filter as per discussed date 20/09/2022  
 @OBTC Int-- Jitendra Nakum 21/09/2022 add OBTC Filter when check box check then all record fetch other wise only OBTC No available that record fetch as per discussed date 20/09/2022  
AS  
BEGIN  
 if(@Status='All')  
 BEGIN  
  SELECT  
  HB.inserteddate 'Date/Time'  
  ,BR.Icast as 'CUST ID'  
  ,MU.UserName +'-'+ Mu.FullName 'Booked By'  
  ,isnull(MU.UserName + ' - ' + MU.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) as 'Issued By'  
  ,Hb.BookingReference 'Booking ID'  
  ,Hb.CheckInDate 'CheckInDate'  
  ,HB.riyaPNR as 'Hotel PNR'  
  ,HB.riyaPNR as 'Ticket No'  
  ,HB.DisplayDiscountRate  as 'Base Amt'  
  ,HB.CurrencyCode as 'Currency'      
  ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'Lead Pax Name'  
  ,cast(cast(HB.TotalAdults as int) + cast(TotalChildren as int) as int) 'No.of Pax'  
  ,CASE  
  WHEN HB.B2BPaymentMode =1 THEN 'Hold'  
  WHEN HB.B2BPaymentMode =2 THEN 'Credit Limit'  
  WHEN HB.B2BPaymentMode =3 THEN 'Make Payment'  
  WHEN HB.B2BPaymentMode =4 THEN 'Self Balance'  
  END AS 'Payment Mode'  
  ,CASE  
  WHEN HB.SB_ReversalStatus=0 then 'Pending'  
  WHEN HB.SB_ReversalStatus=1 then 'Completed'  
  END 'Status'  
  ,HB.AgentInvoiceNumber  
  ,HB.InquiryNo  
  ,HB.FileNo  
  ,HB.PaymentRefNo  
  --,HB.OBTCNo  
  ,ISNULL(HB.OBTCNo,'NA') as 'Old OBTC No'      ---added as per moin 15/1/25                     
 ,isnull(HB.MBPageOBTCNo,'NA') AS 'OBTCNo'    ---added as per moin 15/1/25      
  ,HB.RTTRefNo  
  ,HB.OpsRemark  
  ,HB.AcctsRemark  
  FROM  
  Hotel_BookMaster HB  
  left join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID  
  left join mUser MU on HB.MainAgentID=Mu.ID  
  left join AgentLogin al on HB.RiyaAgentID=al.UserID  
  --left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId  
  --left join Hotel_Status_Master HM on SH.FkStatusId=HM.Id  
  --left join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id  
  WHERE  
  CAST(HB.inserteddate as date) between @FromDate and @ToDate  
  --AND (HB.SB_ReversalStatus=cast(@Status as bit))  
  AND HB.B2BPaymentMode=4  
  AND (@UserId='' OR HB.MainAgentID=@USerId)  
  --and (@IsOBTC = 1 OR (HB.OBTCNo is not null and HB.OBTCNo != ''))  
  AND (@OBTC = 0   
   OR  
   (@OBTC=1 and HB.OBTCNo is not null AND HB.OBTCNo != '')  
   OR  
   (@OBTC=2 and (HB.OBTCNo is null OR HB.OBTCNo = ''))  
   )  
 END  
 IF(@Status!='All')  
 BEGIN  
  SELECT  
  HB.inserteddate 'Date/Time'  
  ,BR.Icast as 'CUST ID'  
  ,MU.UserName +'-'+ Mu.FullName 'Booked By'  
  ,ISNULL(MU.UserName + ' - ' + MU.FullName, al.UserName  + ' - ' + al.FirstName + ' ' +al.LastName ) AS 'Issued By'  
  ,Hb.BookingReference 'Booking ID'  
  ,Hb.CheckInDate 'CheckInDate'  
  ,HB.BookingReference as 'Hotel PNR'  
  ,HB.riyaPNR as 'Ticket No'  
  ,HB.DisplayDiscountRate  as 'Base Amt'  
  ,HB.CurrencyCode as 'Currency'  
  ,HB.LeaderTitle+' '+HB.LeaderFirstName+' '+HB.LeaderLastName  as 'Lead Pax Name'  
  ,cast(cast(HB.TotalAdults as int) + cast(TotalChildren as int) as int) 'No.of Pax'  
  ,CASE  
  WHEN HB.B2BPaymentMode =1 THEN 'Hold'  
  WHEN HB.B2BPaymentMode =2 THEN 'Credit Limit'  
  WHEN HB.B2BPaymentMode =3 THEN 'Make Payment'  
  WHEN HB.B2BPaymentMode =4 THEN 'Self Balance'  
  END AS 'Payment Mode'  
  ,CASE  
  WHEN HB.SB_ReversalStatus=0 THEN 'Pending'  
  WHEN HB.SB_ReversalStatus=1 THEN 'Completed'  
  END 'Status'  
  ,HB.AgentInvoiceNumber  
  ,HB.InquiryNo  
  ,HB.FileNo  
  ,HB.PaymentRefNo  
 -- ,HB.OBTCNo
   ,ISNULL(HB.OBTCNo,'NA') as 'Old OBTC No'        ---added as per moin 15/1/25                        
 ,isnull(HB.MBPageOBTCNo,'NA') AS 'OBTCNo'   ---added as per moin 15/1/25      
  ,HB.RTTRefNo  
  ,HB.OpsRemark  
  ,HB.AcctsRemark  
  FROM Hotel_BookMaster HB  
  left join B2BRegistration BR on HB.RiyaAgentID=BR.FKUserID  
  left join mUser MU on HB.MainAgentID=Mu.ID  
  left join AgentLogin al on HB.RiyaAgentID=al.UserID  
  --left join Hotel_Status_History SH on HB.pkId=SH.FKHotelBookingId               
  --left join Hotel_Status_Master HM on SH.FkStatusId=HM.Id              
  --left join Hotel_Pax_master HP on HB.pkId=HP.book_fk_id               
  WHERE  
  cast(HB.inserteddate as date) between @FromDate and @ToDate  
  AND (HB.SB_ReversalStatus=cast(@Status as bit))  
  AND HB.B2BPaymentMode=4  
  AND (@UserId='' OR HB.MainAgentID=@USerId)  
  --AND (@IsOBTC =1 OR (HB.OBTCNo IS NOT NULL AND HB.OBTCNo != ''))  
  AND (@OBTC = 0   
   OR  
   (@OBTC=1 AND HB.OBTCNo IS NOT NULL AND HB.OBTCNo != '')  
   OR  
   (@OBTC=2 AND (HB.OBTCNo IS NULL OR HB.OBTCNo = ''))  
  )  
 END  
 END
GO
GRANT VIEW DEFINITION
    ON OBJECT::[dbo].[Get_SelfBal_Rev_hotel] TO [rt_read]
    AS [dbo];

