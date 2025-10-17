CREATE PROCEDURE [Rail].[GetAllRailBookingsCON]     
    @Id INT = 0,            
    @BookingFromDate VARCHAR(50) = '',                                          
    @BookingToDate VARCHAR(50) = '',            
    @RiyaUserID NVARCHAR(200) = '',                                          
    @Branch NVARCHAR(200) = '',                                          
    @Agent NVARCHAR(200) = '',            
    @BookingID NVARCHAR(200) = '',      
    @Status NVARCHAR(200) = '',    
    @RiyaPnr NVARCHAR(50) = ''    
AS            
BEGIN            
    IF OBJECT_ID(N'tempdb..#bookings') IS NOT NULL      
    BEGIN      
        DROP TABLE #bookings      
    END      
  
    -- Insert filtered data into #bookings  
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
        --CASE       
        --    WHEN MAX(bk.bookingStatus) = 'INVOICED' THEN 'CONFIRMED'      
        --    WHEN MAX(bk.bookingStatus) = 'PREBOOKED' THEN 'ON-HOLD'      
        --    WHEN MAX(bk.bookingStatus) = 'MODIFIED' THEN 'MODIFIED'      
        --    WHEN MAX(bk.bookingStatus) = 'CREATED' THEN 'CREATED'      
        --END AS Status,      
  CASE   
    WHEN bk.bookingStatus = 'INVOICED' THEN 'CONFIRMED'  
    WHEN bk.bookingStatus = 'PREBOOKED' THEN 'ON-HOLD'  
    WHEN bk.bookingStatus = 'MODIFIED' THEN 'CANCELED'  
    WHEN bk.bookingStatus = 'CREATED' THEN 'CREATED'  
    ELSE 'UNKNOWN'
END 
+ ' / ' + 
REPLACE(REPLACE(ISNULL(Bk.PaymentMode, 'Hold'), 'RiyaAgent', ''), 'Agent', '') AS Status,
        MAX(bk.CreatedDate) AS BookingFromDate,  
        MAX(bk.expirationDate) AS BookingToDate,  
        MAX(b2b.BranchCode) AS Branch,  
		CONCAT(bk.AgentCurrency, ' ', MAX(bk.AmountPaidbyAgent)) AS AmountPaidbyAgent,

       -- CONCAT(bk.AgentCurrency, MAX(bk.AmountPaidbyAgent)) AS AmountPaidbyAgent,
		 'EuRail' as SupplierName,  
    CASE 
    WHEN Bki.Departure IS NOT NULL THEN Bki.Departure
    WHEN Bki.activationPeriodStart IS NOT NULL THEN Bki.activationPeriodStart
    ELSE Bki.validityPeriodStart
  END AS TravelStartDate,
   CASE
  WHEN bki.Type = 'Pass' THEN Bki.Country
  WHEN bki.Type = 'Ticket' THEN Bki.Origin + ' ==> ' + Bki.Destination
  ELSE NULL
END AS Destination,
  
        -- Get the first passenger name using MAX()  
        MAX(pax.FirstName + ' ' + pax.LastName) AS PassengerName,      
  
        -- Fix: Use MAX() for BookingItems.Id to avoid errors  
        MAX(bki.Id) AS BookingItemId    
  
    INTO #bookings      
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
        ON pax.fk_ItemId = bki.Id and leadTraveler=1      
    WHERE       
        (Convert(VARCHAR(12), bk.creationDate, 102)   
            BETWEEN Convert(VARCHAR(12), Convert(DATETIME, @BookingFromDate, 103), 102)   
            AND CASE WHEN @BookingToDate <> ''               
                     THEN Convert(VARCHAR(12), Convert(DATETIME, @BookingToDate, 103), 102)              
                     ELSE Convert(VARCHAR(12), Convert(DATETIME, @BookingFromDate, 103), 102)   
                END   
            OR (@BookingFromDate = '' AND @BookingToDate = ''))             
        AND ((@RiyaUserID = '') OR (bk.RiyaUserId IN (SELECT Data FROM sample_split(@RiyaUserID, ','))))                
        AND ((@Branch = '') OR (b2b.BranchCode IN (SELECT Data FROM sample_split(@Branch, ','))))               
        AND ((@Agent = '') OR (bk.AgentID IN (SELECT Data FROM sample_split(@Agent, ','))))      
        AND ((@Status = 'All') OR (@Status = '') OR (bk.bookingStatus IN (SELECT Data FROM sample_Split(@Status, ','))))      
        AND ((@BookingID = '') OR (bk.BookingReference = @BookingID))    
        AND ((@RiyaPnr = '') OR (bk.RiyaPnr = @RiyaPnr))    
    GROUP BY bk.Id, bk.RiyaPnr, bk.AgentId, bk.RiyaUserId, bk.BookingId, bk.BookingReference,bk.bookingStatus,bk.PaymentMode,bki.Departure 
  ,bki.activationPeriodStart,bki.validityPeriodStart,bki.Type,bki.Country,bki.Origin,bki.Destination,bk.AgentCurrency;
    -- Get distinct PassengerName with Row Numbering  
    ;WITH cteq AS (      
        SELECT ROW_NUMBER() OVER (PARTITION BY #bookings.Id ORDER BY #bookings.PassengerName) AS Rnum, *   
        FROM #bookings  
    )      
    SELECT * FROM cteq WHERE cteq.Rnum = 1 ORDER BY BookingFromDate DESC;  
  
    -- Drop temp table  
    DROP TABLE #bookings;        
END  