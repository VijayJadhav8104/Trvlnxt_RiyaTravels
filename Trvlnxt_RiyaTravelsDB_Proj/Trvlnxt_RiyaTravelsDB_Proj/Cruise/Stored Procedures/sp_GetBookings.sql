  
  
--Cruise.[sp_GetBookings] null,0,null,null,'2023-01-01','2023-12-12'  
CREATE Procedure [Cruise].[sp_GetBookings]  
@StatusID int = null,  
@AgentID varchar(10) = null,  
@RiyaUserID  varchar(10) = null,  
@BookingReference varchar(30) = null,  
@FromDate datetime = null,  
@ToDate datetime = null  
AS  
BEGIN  
  IF(@ToDate IS NOT NULL AND @ToDate >= @FROMDate)  
  BEGIN  
   SET @ToDate = DATEADD(DAY, 1, @ToDate)  
  END  
  IF(@AgentID IS NOT NULL AND @AgentID = '0')  
  BEGIN  
   SET @AgentID = ''  
  END  
  
  
  Select al.FirstName as AgentName, usr.FullName as RiyaUserName, b2b.CustomerCOde as ICUST,   
  Case when (bk.[Status] is null and IsConfirmed=1) then 1 else bk.[Status] end as [Status],   
  ISNULL(bk.AgentCommissionPct,0) as AgentCommissionPct, ISNULL(bk.AgentCommission,0) as AgentCommission,   
  ISNULL(bk.RiyaCommissionPct,0) as RiyaCommissionPct, ISNULL(bk.RiyaCommission,0) as RiyaCommission,   
  ISNULL(bk.ChargeType,'') as ChargeType, ISNULL(bk.CalculationType,'') as CalculationType,   
  (select top 1 pax.FirstName +' '+ pax.LastName from Cruise.BookedPaxDetails pax where pax.FkBookingId=bk.Id) as PassengerName,  
  (select top 1 pax.Phone from Cruise.BookedPaxDetails pax where pax.FkBookingId=bk.Id) as Phone,  
  (select top 1 pax.Email from Cruise.BookedPaxDetails pax where pax.FkBookingId=bk.Id) as EmailID,  
  (select top 1 ISNULL(ite.StartDate,'') as  StartDate from Cruise.BookedItineraries ite where ite.FkBookingId=bk.Id) as StartDate,  
  (select top 1 ISNULL(ite.EndDate,'') as EndDate  from Cruise.BookedItineraries ite where ite.FkBookingId=bk.Id) as EndDate,  
  bk.* from Cruise.Bookings bk  
  LEFT JOIN AgentLogin al ON bk.AgentId = al.UserID  
  LEFT JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID  
  LEFT JOIN mUser usr ON bk.RiyaUserId = usr.ID  
  WHERE (CONVERT(date, bk.CreatedOn,126) >= (CONVERT(date, @FROMDate, 126))          
  AND CONVERT(date, bk.CreatedOn,126) <= (CONVERT(date, @ToDate, 126)))  
  AND (bk.[Status] = @StatusID OR ISNULL(@StatusID, '') = '')  
  AND (bk.AgentId = @AgentID OR ISNULL(@AgentID,'') = '')  
     AND       
   (      
   @RiyaUserID = 0 or       
   bk.RiyaUserId = @RiyaUserID)      
   
END  
  
  