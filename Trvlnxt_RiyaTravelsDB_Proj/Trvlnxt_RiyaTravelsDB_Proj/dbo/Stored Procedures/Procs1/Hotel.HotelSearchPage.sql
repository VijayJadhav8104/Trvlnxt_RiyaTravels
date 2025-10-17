    
---Created by : Aman Wagde ---    
--- Created on : 12 march 2025--    
-- Created for : to address page load data issue with existing stored proc causing high cpu    
    
CREATE PROCEDURE [dbo].[Hotel.HotelSearchPage]    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    SELECT TOP 400    
          HB.pkId,    
          HB.BookingReference AS book_Id,    
          HB.orderId AS OrderID,    
          -- Consolidated CurrentStatus using a simplified CASE structure.    
          CASE     
              WHEN HM.Status = 'Confirmed'     
              THEN '<span style="color:blue;">Hold</span> / ' +     
                   CASE     
                        WHEN HB.B2BPaymentMode = 1 THEN '<span style="color:blue;">Hold</span>'    
                        WHEN HB.B2BPaymentMode = 2 THEN '<span style="color:black;">Credit Limit</span>'    
                        WHEN HB.B2BPaymentMode = 3 THEN '<span style="color:black;">Make Payment</span>'    
                        WHEN HB.B2BPaymentMode = 4 THEN '<span style="color:black;">Self Balance</span>'    
                        ELSE ''    
                   END    
              ELSE HM.Status + ' / ' +    
                   CASE     
                        WHEN HB.B2BPaymentMode = 1 THEN '<span style="color:blue;">Hold</span>'    
                        WHEN HB.B2BPaymentMode = 2 THEN '<span style="color:black;">Credit Limit</span>'    
                        WHEN HB.B2BPaymentMode = 3 THEN '<span style="color:black;">Make Payment</span>'    
                        WHEN HB.B2BPaymentMode = 4 THEN '<span style="color:black;">Self Balance</span>'    
                        WHEN HB.B2BPaymentMode = 5 THEN '<span style="color:black;">PayAtHotel</span>'    
                        ELSE 'NA'    
                   END    
          END AS CurrentStatus,    
          -- Optimized AgencyName logic.    
          CASE     
              WHEN HB.B2BPaymentMode = 4 AND HB.SuBMainAgentID <> 0     
              THEN BR.AgencyName + ISNULL('-' + MU.FullName, '') + ' (' + Mus.FullName + ')'    
              ELSE BR.AgencyName + ISNULL('-' + MU.FullName, '')    
          END AS AgencyName,    
          HB.cityName AS Destination,    
          CASE     
              WHEN SH.MethodName IN ('Manually_OfflineCancel', 'H', 'HotelBookingCancel', 'Manually Updated')    
                   AND SH.IsActive = 1     
              THEN HB.CurrencyCode + ' ' + FORMAT(COALESCE(HB.agentCancellationCharges, 0), 'N2')    
              ELSE HB.CurrencyCode + ' ' + FORMAT(CAST(HB.DisplayDiscountRate AS DECIMAL(18,2)), 'N2')    
          END AS Amount,    
         -- CONVERT(VARCHAR, HB.inserteddate, 0) AS BookingDate,   
   FORMAT(CAST(HB.inserteddate AS datetime),'dd MMM yyyy hh:mm tt') as BookingDate,  
          CASE     
              WHEN HB.ServiceTimeModified = 1     
              THEN FORMAT(HB.CheckInDate, 'dd MMM yyyy') + ' ' + SUBSTRING(HB.ModifiedCheckInTime, 1, 8)    
              ELSE FORMAT(HB.CheckInDate, 'dd MMM yyyy') + ' ' + HB.CheckInTime    
          END AS ServiceDate,    
          --CONVERT(VARCHAR, CancellationDeadLine, 0) AS DeadlineDate,   
     FORMAT(CAST(HB.CancellationDeadLine AS datetime),'dd MMM yyyy hh:mm tt') as DeadlineDate,  
          HB.SupplierName,    
          CASE     
              WHEN (HB.providerConfirmationNumber = '' OR HB.providerConfirmationNumber IS NULL)    
              THEN HB.SupplierReferenceNo     
              ELSE HB.providerConfirmationNumber     
          END AS SupplierReferenceNo,    
          CASE     
              WHEN HB.B2BPaymentMode = 1 THEN '<span style="color:blue; font-weight:bold;">Hold</span>'    
              WHEN HB.B2BPaymentMode = 2 THEN '<span style="color:black; font-weight:bold;">Credit Limit</span>'    
              WHEN HB.B2BPaymentMode = 3 THEN '<span style="color:black; font-weight:bold;">Make Payment</span>'    
              WHEN HB.B2BPaymentMode = 4 THEN '<span style="color:black; font-weight:bold;">Self Balance</span>'    
              ELSE ''    
     END AS PaymentMode,    
          HB.LeaderTitle + ' ' + HB.LeaderFirstName + ' ' + HB.LeaderLastName AS TravellerName,    
          HB.BookingReference AS ConfirmationNumber,    
          HB.VoucherNumber AS VoucherID,    
          HB.VoucherDate,    
          HB.AgentRefNo AS AgentReferenceNo,    
          HB.HotelConfNumber AS HotelConfirmationAdded,    
          HB.PayAtHotel,    
          '' AS Action,    
          HB.HotelName,    
          ISNULL(HB.ExpirationDate, CAST('2025-02-01 17:41:00.000' AS DATE)) AS ExpirationDate,    
          CASE HB.ReconStatus    
              WHEN 'Y' THEN 'YELLOWGREEN'    
              WHEN 'N' THEN 'RED'    
              ELSE 'Black'    
          END AS ReconStatus,    
       '' as LastModifiedDate,    
    CancelDate as CancellationDate                                                                                                                                                                                         
          ,'' as 'Action',                                                                                                                                                    
           HB.HotelName,                                                                                                                                                      
    case when (HB.ExpirationDate is null) then ( cast('2025-02-01 17:41:00.000' as date)) else HB.ExpirationDate End as ExpirationDate    
    FROM Hotel_BookMaster HB    
         LEFT JOIN Hotel_Status_History SH     
             ON HB.pkId = SH.FKHotelBookingId     
            AND SH.IsActive = 1    
         LEFT JOIN B2BRegistration BR WITH (NOLOCK)     
             ON HB.RiyaAgentID = BR.FKUserID    
         LEFT JOIN AgentLogin AGL WITH (NOLOCK)     
             ON HB.RiyaAgentID = AGL.UserID    
         LEFT JOIN Hotel_Status_Master HM WITH (NOLOCK)     
             ON SH.FkStatusId = HM.Id    
         LEFT JOIN mUser MU WITH (NOLOCK)     
             ON HB.MainAgentID = MU.ID    
         LEFT JOIN mUser MUS WITH (NOLOCK)     
             ON HB.SuBMainAgentID = MUS.ID     
            AND HB.SuBMainAgentID <> 0    
         LEFT Join Hotel.HotelBookingModifyDetails HD with(nolock)
		 on HB.pkId=HD.book_fk_id 
		 and HD.IsLeadPax=1 and HD.IsActive=1         

    ORDER BY HB.pkId DESC;    
END; 