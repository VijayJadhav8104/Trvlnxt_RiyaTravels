CREATE PROCEDURE GetTrvlNxtApiOutBookingData            
AS            
BEGIN            
    -- TNH Yearly          
    SELECT DISTINCT          
        SupplierName,          
        'TNH' AS BookingPortal,           
        'Year' AS SeparatedBy,           
        COUNT(pkId) AS BookingCount,           
        SUM(DisplayDiscountRate * FinalROE) AS TotalAmount           
    FROM           
        Hotel_BookMaster h WITH (NOLOCK)          
    JOIN           
        Hotel_Status_History sh WITH (NOLOCK)          
    ON           
        h.pkId = sh.FKHotelBookingId           
    WHERE           
        YEAR(inserteddate) = YEAR(Getdate())    
        AND sh.FkStatusId in(4,3)           
        AND sh.IsActive = 1           
        AND h.BookingPortal = 'TNH'          
    GROUP BY           
        SupplierName          
          
    UNION ALL          
          
    -- TNH Monthly          
    SELECT DISTINCT          
        SupplierName,          
        'TNH' AS BookingPortal,           
        'Month' AS SeparatedBy,           
        COUNT(pkId) AS BookingCount,           
        SUM(DisplayDiscountRate * FinalROE) AS TotalAmount           
    FROM           
        Hotel_BookMaster h WITH (NOLOCK)          
    JOIN           
        Hotel_Status_History sh WITH (NOLOCK)          
    ON           
        h.pkId = sh.FKHotelBookingId           
    WHERE           
        MONTH(inserteddate) = MONTH(Getdate())    
  AND YEAR(inserteddate) = YEAR(Getdate())     
        AND sh.FkStatusId in(4,3)           
        AND sh.IsActive = 1           
        AND h.BookingPortal = 'TNH'          
    GROUP BY           
        SupplierName          
          
    UNION ALL          
          
    -- TNH Yesterday          
    SELECT DISTINCT          
        SupplierName,          
        'TNH' AS BookingPortal,           
        'Yesterday' AS SeparatedBy,           
        COUNT(pkId) AS BookingCount,           
        SUM(DisplayDiscountRate * FinalROE) AS TotalAmount           
    FROM           
        Hotel_BookMaster h WITH (NOLOCK)          
    JOIN           
        Hotel_Status_History sh WITH (NOLOCK)          
    ON           
        h.pkId = sh.FKHotelBookingId           
    WHERE           
        InsertedDate >= CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)   AND InsertedDate < CAST(GETDATE() AS DATE)         
       AND sh.FkStatusId in(4,3)          
        AND sh.IsActive = 1           
        AND h.BookingPortal = 'TNH'          
    GROUP BY           
        SupplierName          
          
    UNION ALL          
          
 -- TNH Daily          
    SELECT DISTINCT          
        SupplierName,          
        'TNH' AS BookingPortal,           
        'Day' AS SeparatedBy,           
        COUNT(pkId) AS BookingCount,           
        SUM(DisplayDiscountRate * FinalROE) AS TotalAmount           
    FROM           
        Hotel_BookMaster h WITH (NOLOCK)          
    JOIN           
        Hotel_Status_History sh WITH (NOLOCK)          
    ON           
        h.pkId = sh.FKHotelBookingId           
    WHERE           
        inserteddate BETWEEN CONVERT(DATE, GETDATE()) AND GETDATE()          
       AND sh.FkStatusId in(4,3)          
        AND sh.IsActive = 1           
        AND h.BookingPortal = 'TNH'          
    GROUP BY           
        SupplierName          
          
    UNION ALL    
    
    -- TNHAPI Yearly          
    SELECT DISTINCT          
        SupplierName,          
        'TNHAPI' AS BookingPortal,           
        'Year' AS SeparatedBy,           
        COUNT(pkId) AS BookingCount,           
        SUM(DisplayDiscountRate * FinalROE) AS TotalAmount           
    FROM           
        Hotel_BookMaster h WITH (NOLOCK)          
    JOIN           
        Hotel_Status_History sh WITH (NOLOCK)          
    ON           
        h.pkId = sh.FKHotelBookingId           
    WHERE           
        YEAR(inserteddate) = YEAR(Getdate())    
        AND sh.FkStatusId = 4           
        AND sh.IsActive = 1       
        AND h.BookingPortal = 'TNHAPI'          
    GROUP BY           
        SupplierName          
          
    UNION ALL          
          
    -- TNHAPI Monthly          
    SELECT DISTINCT          
        SupplierName,          
        'TNHAPI' AS BookingPortal,           
        'Month' AS SeparatedBy,           
        COUNT(pkId) AS BookingCount,           
        SUM(DisplayDiscountRate * FinalROE) AS TotalAmount           
    FROM           
        Hotel_BookMaster h WITH (NOLOCK)          
    JOIN           
        Hotel_Status_History sh WITH (NOLOCK)          
    ON           
        h.pkId = sh.FKHotelBookingId           
    WHERE           
        MONTH(inserteddate) = MONTH(Getdate())    
  AND YEAR(inserteddate) = YEAR(Getdate())    
        AND sh.FkStatusId = 4           
        AND sh.IsActive = 1           
        AND h.BookingPortal = 'TNHAPI'          
    GROUP BY           
        SupplierName          
          
    UNION ALL          
          
  -- TNHAPI Yesterday          
    SELECT DISTINCT          
        SupplierName,          
        'TNHAPI' AS BookingPortal,           
        'Yesterday' AS SeparatedBy,           
        COUNT(pkId) AS BookingCount,           
        SUM(DisplayDiscountRate * FinalROE) AS TotalAmount           
    FROM           
        Hotel_BookMaster h WITH (NOLOCK)          
    JOIN           
        Hotel_Status_History sh WITH (NOLOCK)          
    ON           
        h.pkId = sh.FKHotelBookingId           
    WHERE           
        InsertedDate >= CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)   AND InsertedDate < CAST(GETDATE() AS DATE)          
        AND sh.FkStatusId = 4           
  AND sh.IsActive = 1           
        AND h.BookingPortal = 'TNHAPI'          
    GROUP BY           
        SupplierName          
        
 UNION ALL    
        
 -- TNHAPI Daily          
    SELECT DISTINCT          
        SupplierName,          
        'TNHAPI' AS BookingPortal,           
        'Day' AS SeparatedBy,           
        COUNT(pkId) AS BookingCount,           
        SUM(DisplayDiscountRate * FinalROE) AS TotalAmount           
    FROM           
        Hotel_BookMaster h WITH (NOLOCK)          
    JOIN           
        Hotel_Status_History sh WITH (NOLOCK)          
    ON           
        h.pkId = sh.FKHotelBookingId           
    WHERE           
        inserteddate BETWEEN CONVERT(DATE, GETDATE()) AND GETDATE()          
        AND sh.FkStatusId = 4           
  AND sh.IsActive = 1           
        AND h.BookingPortal = 'TNHAPI'          
    GROUP BY           
        SupplierName          
        
 UNION ALL    
    
 --TNA Yearly      
 SELECT DISTINCT          
        providerName,          
        'TNA' AS BookingPortal,           
        'Year' AS SeparatedBy,           
        COUNT(h.BookingId) AS BookingCount,           
        SUM(BookingRate * FinalROE) AS TotalAmount           
    FROM           
        SS.SS_BookingMaster h WITH (NOLOCK)          
    JOIN           
        SS.SS_Status_History sh WITH (NOLOCK)          
    ON           
        h.bookingid = sh.BookingId           
    WHERE           
        YEAR(CreateDate) = YEAR(Getdate())    
  AND h.BookingSource IS NULL      
        AND sh.FkStatusId in(4,3)           
        AND sh.IsActive = 1                   
    GROUP BY           
        providerName          
          
    UNION ALL          
          
    -- TNA Monthly          
    SELECT DISTINCT          
        providerName,          
        'TNA' AS BookingPortal,           
        'Month' AS SeparatedBy,           
        COUNT(h.BookingId) AS BookingCount,           
        SUM(BookingRate * FinalROE) AS TotalAmount           
    FROM           
        SS.SS_BookingMaster h WITH (NOLOCK)          
    JOIN           
        SS.SS_Status_History sh WITH (NOLOCK)          
    ON           
        h.bookingid = sh.BookingId           
    WHERE          
        MONTH(CreateDate) = MONTH(Getdate())    
  AND YEAR(CreateDate) = YEAR(Getdate())   
  AND h.BookingSource IS NULL      
       AND sh.FkStatusId in(4,3)            
        AND sh.IsActive = 1                    
    GROUP BY           
        providerName          
          
    UNION ALL          
          
    -- TNA Yesterday          
     SELECT DISTINCT          
        providerName,          
        'TNA' AS BookingPortal,           
        'Yesterday' AS SeparatedBy,           
        COUNT(h.BookingId) AS BookingCount,           
        SUM(BookingRate * FinalROE) AS TotalAmount           
    FROM           
        SS.SS_BookingMaster h WITH (NOLOCK)          
    JOIN           
        SS.SS_Status_History sh WITH (NOLOCK)          
    ON           
        h.bookingid = sh.BookingId           
    WHERE        
        creationDate >= CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)    
  AND creationDate < CAST(GETDATE() AS DATE)         
  AND h.BookingSource IS NULL      
       AND sh.FkStatusId in(4,3)            
        AND sh.IsActive = 1           
    GROUP BY           
        providerName    
      
 UNION ALL          
          
    -- TNA Daily          
    SELECT DISTINCT          
        providerName,          
        'TNA' AS BookingPortal,           
        'Day' AS SeparatedBy,           
        COUNT(h.BookingId) AS BookingCount,           
        SUM(BookingRate * FinalROE) AS TotalAmount           
    FROM           
        SS.SS_BookingMaster h WITH (NOLOCK)          
    JOIN           
        SS.SS_Status_History sh WITH (NOLOCK)          
    ON           
        h.bookingid = sh.BookingId           
    WHERE        
        CreateDate BETWEEN CONVERT(DATE, GETDATE()) AND GETDATE()         
  AND h.BookingSource IS NULL      
        AND sh.FkStatusId in(4,3)       
        AND sh.IsActive = 1               
    GROUP BY           
        providerName    
		
 UNION ALL    
    
 --TNC Yearly      
 SELECT DISTINCT          
        providerName,          
        'TNC' AS BookingPortal,           
        'Year' AS SeparatedBy,           
        COUNT(c.BookingId) AS BookingCount,           
        SUM(AgentDiscountPrice) AS TotalAmount           
    FROM           
        TR.TR_BookingMaster c WITH (NOLOCK)          
    JOIN           
        TR.TR_Status_History ch WITH (NOLOCK)          
    ON           
        c.bookingid = ch.BookingId           
    WHERE           
        YEAR(CreateDate) = YEAR(Getdate())    
  --AND c.BookingSource IS NULL      
        AND ch.FkStatusId in(4,3)           
        AND ch.IsActive = 1                   
    GROUP BY           
        providerName          
          
    UNION ALL          
          
    -- TNC Monthly          
    SELECT DISTINCT          
        providerName,          
        'TNC' AS BookingPortal,           
        'Month' AS SeparatedBy,           
        COUNT(c.BookingId) AS BookingCount,           
        SUM(AgentDiscountPrice) AS TotalAmount           
    FROM           
        TR.TR_BookingMaster c WITH (NOLOCK)          
    JOIN           
        TR.TR_Status_History ch WITH (NOLOCK)          
    ON           
        c.bookingid = ch.BookingId           
    WHERE          
        MONTH(CreateDate) = MONTH(Getdate())    
  AND YEAR(CreateDate) = YEAR(Getdate())   
  --AND c.BookingSource IS NULL      
       AND ch.FkStatusId in(4,3)            
        AND ch.IsActive = 1                    
    GROUP BY           
        providerName          
          
    UNION ALL          
          
    -- TNC Yesterday          
     SELECT DISTINCT          
        providerName,          
        'TNC' AS BookingPortal,           
        'Yesterday' AS SeparatedBy,           
        COUNT(c.BookingId) AS BookingCount,           
        SUM(AgentDiscountPrice) AS TotalAmount           
    FROM           
        TR.TR_BookingMaster c WITH (NOLOCK)          
    JOIN           
        TR.TR_Status_History ch WITH (NOLOCK)          
    ON           
        c.bookingid = ch.BookingId           
    WHERE        
        creationDate >= CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)    
  AND creationDate < CAST(GETDATE() AS DATE)         
  --AND c.BookingSource IS NULL      
       AND ch.FkStatusId in(4,3)            
        AND ch.IsActive = 1           
    GROUP BY           
        providerName    
      
	UNION ALL          
          
    -- TNC Daily          
    SELECT DISTINCT          
        providerName,          
        'TNC' AS BookingPortal,           
        'Day' AS SeparatedBy,           
        COUNT(c.BookingId) AS BookingCount,           
        SUM(AgentDiscountPrice) AS TotalAmount           
    FROM           
        TR.TR_BookingMaster c WITH (NOLOCK)          
    JOIN           
        TR.TR_Status_History ch WITH (NOLOCK)          
    ON           
        c.bookingid = ch.BookingId           
    WHERE        
        CreateDate BETWEEN CONVERT(DATE, GETDATE()) AND GETDATE()         
    --AND c.BookingSource IS NULL      
        AND ch.FkStatusId in(4,3)       
        AND ch.IsActive = 1               
    GROUP BY           
        providerName
END 