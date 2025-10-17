-- =============================================          
-- Author:  <Author,,Amol c>          
-- Create date: <27-03-2023,,>          
-- Description: <Description,,>          
-- =============================================          
--[Rail].[GetAllRailBookingsCON] 1,'2023-03-28','2023-03-28',95,'BRH103101','51366','S852667269'            
create PROCEDURE [Rail].[GetAllRailBookingsCON22]   --@RiyaPnr ='TNR00002001'     
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
 SELECT 
    bk.Id,
    bk.RiyaPnr, 
    MAX(bk.bookingStatus) AS bookingStatus,  
    MAX(bk.expirationDate) AS expirationDate,
    MAX(b2b.AgencyName) AS AgencyName,  
    MAX(Al.FirstName) AS AgentName,    
    MAX(b2b.CustomerCode) AS ICUST, 
    bk.AgentId, 
    bk.RiyaUserId,         
    bk.BookingId, 
    bk.BookingReference AS BookingReferenceId,    
    MAX(pax.Pan) AS PanNo,    

    -- Selecting one Status based on bookingStatus
    CASE     
        WHEN MAX(bk.bookingStatus) = 'INVOICED' THEN 'CONFIRMED'    
        WHEN MAX(bk.bookingStatus) = 'PREBOOKED' THEN 'ON-HOLD'    
        WHEN MAX(bk.bookingStatus) = 'MODIFIED' THEN 'MODIFIED'    
        WHEN MAX(bk.bookingStatus) = 'CREATED' THEN 'CREATED'    
    END AS Status,    

    MAX(bk.creationDate) AS BookingFromDate,
    MAX(bk.expirationDate) AS BookingToDate,
    MAX(b2b.BranchCode) AS Branch,          
   CONCAT('INR ', MAX(bk.AmountPaidbyAgent)) AS AmountPaidbyAgent,         

    -- Get the first passenger name using MAX()
    MAX(pax.FirstName + ' ' + pax.LastName) AS PassengerName,    

    -- Fix: Use MAX() for BookingItems.Id to avoid errors
    MAX(bki.Id) AS BookingItemId  

FROM Rail.Bookings bk          
LEFT JOIN AgentLogin al 
    ON bk.AgentId = al.UserID          
LEFT JOIN B2BRegistration b2b 
    ON (al.ParentAgentID IS NULL AND bk.AgentId = b2b.FKUserID) 
    OR (al.ParentAgentID IS NOT NULL AND al.ParentAgentID = b2b.FKUserID)
LEFT JOIN mUser usr 
    ON bk.RiyaUserId = usr.ID          
LEFT JOIN RAIL.BookingItems bki 
    ON bk.Id = bki.fk_bookingId     
INNER JOIN Rail.PaxDetails pax 
    ON pax.fk_ItemId = bki.Id     
  where     
  (Convert(varchar(12),bk.creationDate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                          
  case when @BookingToDate <> ''             
  then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)            
  else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))           
  And(( @RiyaUserID ='') or (bk.RiyaUserId IN  (select Data from sample_split(@RiyaUserID,','))) )              
  And (( @Branch ='') or (b2b.BranchCode IN  (select Data from sample_split(@Branch,','))) )             
  And ((@Agent ='') or (bk.AgentID IN  (select Data from sample_split(@Agent,','))) )    
 And ((@Status='') or (@Status='All')or (bk.bookingStatus IN (select Data from sample_Split(@Status,','))) )    
  And ((@BookingID ='') or (bk.BookingReference = @BookingID))  
   --AND ((@RiyaPnr IS NULL OR @RiyaPnr = '') and (bk.RiyaPnr = @RiyaPnr))  
   AND ((@RiyaPnr ='') OR (bk.RiyaPnr = @RiyaPnr))  
     GROUP BY bk.Id, bk.RiyaPnr, bk.AgentId, bk.RiyaUserId, bk.BookingId, bk.BookingReference
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
 SELECT 
    bk.Id,
    bk.RiyaPnr, 
    MAX(bk.bookingStatus) AS bookingStatus,  
    MAX(bk.expirationDate) AS expirationDate,
    MAX(b2b.AgencyName) AS AgencyName,  
    MAX(Al.FirstName) AS AgentName,    
    MAX(b2b.CustomerCode) AS ICUST, 
    bk.AgentId, 
    bk.RiyaUserId,         
    bk.BookingId, 
    bk.BookingReference AS BookingReferenceId,    
    MAX(pax.Pan) AS PanNo,    

    -- Selecting one Status based on bookingStatus
    CASE     
        WHEN MAX(bk.bookingStatus) = 'INVOICED' THEN 'CONFIRMED'    
        WHEN MAX(bk.bookingStatus) = 'PREBOOKED' THEN 'ON-HOLD'    
        WHEN MAX(bk.bookingStatus) = 'MODIFIED' THEN 'MODIFIED'    
        WHEN MAX(bk.bookingStatus) = 'CREATED' THEN 'CREATED'    
    END AS Status,    

    MAX(bk.creationDate) AS BookingFromDate,
    MAX(bk.expirationDate) AS BookingToDate,
    MAX(b2b.BranchCode) AS Branch,          
CONCAT('INR ', MAX(bk.AmountPaidbyAgent)) AS AmountPaidbyAgent,
    -- Get the first passenger name using MAX()
    MAX(pax.FirstName + ' ' + pax.LastName) AS PassengerName,    

    -- Fix: Use MAX() for BookingItems.Id to avoid errors
    MAX(bki.Id) AS BookingItemId  

FROM Rail.Bookings bk          
LEFT JOIN AgentLogin al 
    ON bk.AgentId = al.UserID          
LEFT JOIN B2BRegistration b2b 
    ON (al.ParentAgentID IS NULL AND bk.AgentId = b2b.FKUserID) 
    OR (al.ParentAgentID IS NOT NULL AND al.ParentAgentID = b2b.FKUserID)
LEFT JOIN mUser usr 
    ON bk.RiyaUserId = usr.ID          
LEFT JOIN RAIL.BookingItems bki 
    ON bk.Id = bki.fk_bookingId     
INNER JOIN Rail.PaxDetails pax 
    ON pax.fk_ItemId = bki.Id     
  where     
  (Convert(varchar(12),bk.creationDate,102) between Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) and                                          
  case when @BookingToDate <> ''             
  then Convert(varchar(12),Convert(datetime,@BookingToDate,103),102)            
  else Convert(varchar(12),Convert(datetime,@BookingFromDate,103),102) end or (@BookingFromDate='' and @BookingToDate=''))           
  And(( @RiyaUserID ='') or (bk.RiyaUserId IN  (select Data from sample_split(@RiyaUserID,','))) )              
  And (( @Branch ='') or (b2b.BranchCode IN  (select Data from sample_split(@Branch,','))) )             
  And ((@Agent ='') or (bk.AgentID IN  (select Data from sample_split(@Agent,','))) )    
  And ((@Status='') or (bk.bookingStatus IN (select Data from sample_Split(@Status,','))) )    
  And ((@BookingID ='') or (bk.BookingReference = @BookingID))  
   --AND ((@RiyaPnr IS NULL OR @RiyaPnr = '') and (bk.RiyaPnr = @RiyaPnr))  
   AND ((@RiyaPnr ='') OR (bk.RiyaPnr = @RiyaPnr))  
     GROUP BY bk.Id, bk.RiyaPnr, bk.AgentId, bk.RiyaUserId, bk.BookingId, bk.BookingReference 
 ) as t    
    
  ;with cteq as (    
  SELECT  ROW_NUMBER() OVER (PARTITION BY #bookings1.Id order by #bookings1.PassengerName) as Rnum, * from #bookings1)    
    
  select * from cteq where cteq.Rnum = 1 order by BookingFromDate desc    
    
    
DROP TABLE #bookings1     
END    
    
     
END    
    
    
--[Rail].[GetAllRailBookingsCON] ' ','','','','','','','Confirme',''; 