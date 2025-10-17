-- =============================================          
-- Author:  <Author,,Amol c>          
-- Create date: <27-03-2023,,>          
-- Description: <Description,,>          
-- =============================================          
--[Rail].[GetAllRailBookingsCON] 1,'2023-03-28','2023-03-28',95,'BRH103101','51366','S852667269'            
CREATE PROCEDURE [Rail].[GetAllRailBookingsCON11]   --@RiyaPnr ='TNR00002001'     
 @Id int=0,          
 @BookingFromDate varchar(50)='',                                        
 @BookingToDate varchar(50)='',          
 @RiyaUserID nvarchar(200)='',                                        
 @Branch nvarchar(200)='',                                        
 @Agent nvarchar(200)='',          
 @BookingID nvarchar(200)='',    
@Status nvarchar(200)='',  
@RiyaPnr nvarchar(50)=''  
    
AS          
BEGIN          
          
IF OBJECT_ID(N'tempdb..#bookings') IS NOT NULL    
    
BEGIN    
DROP TABLE #bookings    
END    
if(@Status ='All' )    
Begin    
SELECT *    
INTO #bookings FROM (    
 SELECT DISTINCT bk.Id,bk.RiyaPnr, bk.bookingStatus, bk.expirationDate,b2b.AgencyName as AgencyName,       
 usr.FullName as AgentName,    
 b2b.CustomerCOde as ICUST, bk.AgentId, bk.RiyaUserId,         
  bk.BookingId, bk.BookingReference AS BookingReferenceId,    
   pax.Pan As PanNo,    
  CASE     
 WHEN bk.bookingStatus = 'INVOICED'    
 THEN 'CONFIRMED'    
 WHEN bk.bookingStatus = 'PREBOOKED'    
 THEN 'ON-HOLD'    
 WHEN bk.bookingStatus = 'MODIFIED'    
 THEN 'MODIFIED'    
 WHEN bk.bookingStatus = 'CREATED'    
 THEN 'CREATED'    
 END AS Status,    
     
  bk.creationDate as BookingFromDate,bk.expirationDate as BookingToDate,b2b.BranchCode as Branch,          
  bk.AmountPaidbyAgent as AmountPaidbyAgent,          
            
  --( SELECT TOP 1 pax.FirstName + ' ' + pax.LastName  FROM Rail.PaxDetails pax WHERE pax.bookingItemId = bki.bookingItemId  ) as PassengerName     
    (select top 1 pax.FirstName +' '+ pax.LastName from Rail.PaxDetails pax where pax.fk_ItemId=bki.Id) as 'PassengerName'    
    
  FROM Rail.Bookings bk          
  LEFT JOIN AgentLogin al ON bk.AgentId = al.UserID          
  LEFT JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID          
  LEFT JOIN mUser usr ON bk.RiyaUserId = usr.ID          
  LEFT JOIN RAIL.BookingItems bki ON bk.Id=bki.fk_bookingId     
  inner join Rail.PaxDetails pax on pax.fk_ItemId = bki.Id    
  where     
  (Convert(varchar(12),bk.creationDate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                          
  case when @BookingToDate <> ''             
  then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)            
  else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))           
  And(( @RiyaUserID ='') or (bk.RiyaUserId IN  (select Data from sample_split(@RiyaUserID,','))) )              
  And (( @Branch ='') or (b2b.BranchCode IN  (select Data from sample_split(@Branch,','))) )             
  And ((@Agent ='') or (bk.AgentID IN  (select Data from sample_split(@Agent,','))) )    
 -- And ((@Status='') or (bk.bookingStatus IN (select Data from sample_Split(@Status,','))) )    
  And ((@BookingID ='') or (bk.BookingReference = @BookingID))  
   --AND ((@RiyaPnr IS NULL OR @RiyaPnr = '') and (bk.RiyaPnr = @RiyaPnr))  
   AND ((@RiyaPnr ='') OR (bk.RiyaPnr = @RiyaPnr))  
     
  ) as t    
    
  ;with cteq as (    
  SELECT  ROW_NUMBER() OVER (PARTITION BY #bookings.Id order by #bookings.PassengerName) as Rnum, * from #bookings)    
    
  select * from cteq where cteq.Rnum = 1 order by BookingFromDate desc    
    
    
DROP TABLE #bookings      
            
END    
  if(@Status != 'All')    
Begin    
SELECT *    
INTO #bookings1 FROM (    
 SELECT DISTINCT bk.Id,bk.RiyaPnr, bk.bookingStatus, bk.expirationDate,b2b.AgencyName as AgencyName,       
 usr.FullName as AgentName,     
 b2b.CustomerCOde as ICUST, bk.AgentId, bk.RiyaUserId,         
  bk.BookingId, bk.BookingReference AS BookingReferenceId,    
   pax.Pan As PanNo,    
CASE     
 WHEN bk.bookingStatus = 'INVOICED'    
 THEN 'CONFIRMED'    
 WHEN bk.bookingStatus = 'PREBOOKED'    
 THEN 'ON-HOLD'    
 WHEN bk.bookingStatus = 'MODIFIED'    
 THEN 'MODIFIED'    
 WHEN bk.bookingStatus = 'CREATED'    
 THEN 'CREATED'    
 END AS Status,    
  bk.creationDate as BookingFromDate,bk.expirationDate as BookingToDate,b2b.BranchCode as Branch,          
  bk.AmountPaidbyAgent as AmountPaidbyAgent,          
  --(select SUM(AgentAmount) as amt from Rail.BookingItems b where b.fk_bookingId=bk.Id) as TotalPrice,           
  --( SELECT TOP 1 pax.FirstName + ' ' + pax.LastName FROM Rail.PaxDetails pax  WHERE pax.bookingItemId = bki.bookingItemId ) as PassengerName     
     (select top 1 pax.FirstName +' '+ pax.LastName from Rail.PaxDetails pax where pax.fk_ItemId=bki.Id) as 'PassengerName'    
    
  FROM Rail.Bookings bk          
  LEFT JOIN AgentLogin al ON bk.AgentId = al.UserID          
  LEFT JOIN B2BRegistration b2b ON bk.AgentId = b2b.FKUserID          
  LEFT JOIN mUser usr ON bk.RiyaUserId = usr.ID          
  LEFT JOIN RAIL.BookingItems bki ON bk.Id=bki.fk_bookingId    
  inner join Rail.PaxDetails pax on pax.fk_ItemId = bki.Id    
  where     
  (Convert(varchar(12),bk.creationDate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                          
  case when @BookingToDate <> ''             
  then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)            
  else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))           
  And(( @RiyaUserID ='') or (bk.RiyaUserId IN  (select Data from sample_split(@RiyaUserID,','))) )              
  And (( @Branch ='') or (b2b.BranchCode IN  (select Data from sample_split(@Branch,','))) )             
  And ((@Agent ='') or (bk.AgentID IN  (select Data from sample_split(@Agent,','))) )            
  And ((@BookingID ='') or (bk.BookingReference = @BookingID))   
  And ((@Status='') or (bk.bookingStatus IN (select Data from sample_Split(@Status,','))) )    
  --AND ((@RiyaPnr IS NULL OR @RiyaPnr = '') and (bk.RiyaPnr = @RiyaPnr))  
  AND ((@RiyaPnr ='') OR (bk.RiyaPnr = @RiyaPnr))  
 ) as t    
    
  ;with cteq as (    
  SELECT  ROW_NUMBER() OVER (PARTITION BY #bookings1.Id order by #bookings1.PassengerName) as Rnum, * from #bookings1)    
    
  select * from cteq where cteq.Rnum = 1 order by BookingFromDate desc    
    
    
DROP TABLE #bookings1     
END    
    
     
END    
    
    
--[Rail].[GetAllRailBookingsCON] ' ','','','','','','','','TNR00002803'; 