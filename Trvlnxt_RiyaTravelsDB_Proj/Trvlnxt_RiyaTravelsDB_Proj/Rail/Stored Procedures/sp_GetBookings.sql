--[Rail].[sp_GetBookings] null,47982,0,null,'2024-01-01','2024-12-12'                    
CREATE PROCEDURE [Rail].[sp_GetBookings] @StatusID INT = NULL                
 ,@AgentID VARCHAR(10) = NULL                
 ,@RiyaUserID VARCHAR(10) = NULL                
 ,@BookingReference VARCHAR(30) = NULL                
 ,@FromDate DATETIME = NULL                
 ,@ToDate DATETIME = NULL                
AS                
BEGIN                
 IF (                
   @ToDate IS NOT NULL                
   AND @ToDate >= @FROMDate                
   )                
 BEGIN                
  SET @ToDate = DATEADD(DAY, 1, @ToDate)                
 END                
                
 IF (                
   @AgentID IS NOT NULL                
   AND @AgentID = '0'                
   )                
 BEGIN                
  SET @AgentID = ''                
 END                
                
 SELECT al.FirstName AS AgentName                
  ,usr.FullName AS RiyaUserName                
  ,b2b.CustomerCOde AS ICUST                
  ,bk.AgentId                
  ,bk.RiyaUserId                
  ,bk.Id                
  ,bk.BookingId                
  ,bk.BookingReference AS BookingReferenceid                
  ,bk.bookingStatus AS [Status]                
  ,bk.expirationDate AS ExpirationDate                
  ,ISNULL(bki.RiyaCommission, 0) AS RiyaCommission                
  ,bk.CreatedDate AS CreatedOn                
  ,bk.AmountPaidbyAgent AS TotalPrice                
  ,(                
   SELECT TOP 1 pax.FirstName + ' ' + pax.LastName                
   FROM Rail.PaxDetails pax                
   WHERE pax.fk_ItemId = bki.Id                
   ) AS PassengerName                
  ,(                
   SELECT TOP 1 pax.phoneNumber                
   FROM Rail.PaxDetails pax                
   WHERE pax.fk_ItemId = bki.Id                
   ) AS Phone                
  ,(                
   SELECT TOP 1 pax.emailAddress                
   FROM Rail.PaxDetails pax                
   WHERE pax.fk_ItemId = bki.Id                
   ) AS EmailID           
   ,bk.RiyaPnr      
 FROM Rail.Bookings bk                
 LEFT JOIN AgentLogin al ON bk.AgentId = al.UserID                
 LEFT JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID                
 LEFT JOIN mUser usr ON bk.RiyaUserId = usr.ID                
 LEFT JOIN RAIL.BookingItems bki ON bk.Id = bki.fk_bookingId                
 WHERE         
 --bk.bookingStatus != 'CREATED'    
 --AND    
 (                
   CONVERT(DATE, bk.CreatedDate, 126) >= (CONVERT(DATE, @FROMDate, 126))                
   AND CONVERT(DATE, bk.CreatedDate, 126) <= (CONVERT(DATE, @ToDate, 126))                
   )                
  AND         
  (                
   bk.AgentId = @AgentID                
   OR ISNULL(@AgentID, '') = ''                
   )                
   AND         
   (        
   ISNULL(@RiyaUserID, '') = '' or @RiyaUserID = 0 OR ISNULL(@AgentID, '') <> '' or   
   bk.RiyaUserId = @RiyaUserID)        
   order by bk.CreatedDate desc
  --AND (bk.bookingStatus = @StatusID OR ISNULL(@StatusID, '') = '')                    
END 