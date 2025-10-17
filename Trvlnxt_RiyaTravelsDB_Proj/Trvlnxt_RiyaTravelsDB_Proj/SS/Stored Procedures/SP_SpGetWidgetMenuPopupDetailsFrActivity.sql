CREATE PROCEDURE SS.SP_SpGetWidgetMenuPopupDetailsFrActivity                    
    @AgentId int = NULL                    
AS                    
BEGIN                    
    -- Declare a table variable to hold the combined results            
    DECLARE @Results TABLE (            
        count INT,            
        AgentId int,            
        CityId VARCHAR(100),            
        CityName VARCHAR(500),            
        TravelFrom VARCHAR(500),            
        Nationality VARCHAR(100),            
        State VARCHAR(100),            
        BookingCountryCode VARCHAR(100),            
        Lat VARCHAR(500),            
        Long VARCHAR(500),                   
        InsertedDate DATETIME,            
        CheckIn DATETIME,            
        CheckOut DATETIME,                    
        SearchType VARCHAR(50),            
        Residence VARCHAR(50),         
  record_type VARCHAR(100)          
    );            
            
    -- First query: Latest 3 inserted records for the selected AgentId based on CityId                    
    INSERT INTO @Results            
    SELECT TOP 3             
        NULL AS count,  -- No count for latest records                    
        AgentId,              
        CityId,                     
        TravelFrom as CityName,                         
        TravelFrom,                    
        Nationality,                    
        State,                    
        BookingCountryCode,                    
        Lat,                    
        Long,               
        InsertedDate,              
        CheckIn,                  
        CheckOut,                  
        SearchType,              
        Residence,              
        'Latest 3 Distinct Cities' AS record_type            
    FROM (            
        SELECT              
            AgentId,              
            CityId,                     
            TravelFrom as CityName,                         
            TravelFrom,                    
            Nationality,                    
            State,                    
            BookingCountryCode,                    
            Lat,                    
            Long,                 
            InsertedDate,              
            CheckIn,                  
            CheckOut,                
            SearchType,              
            Residence,            
            ROW_NUMBER() OVER (PARTITION BY CityId ORDER BY InsertedDate DESC) AS RowNum  -- Rank by InsertedDate per CityId              
        FROM SS.SS_ActivitySearchAvailablityData                    
        WHERE (@AgentId IS NULL OR AgentId = @AgentId)  -- Filter by AgentId if provided                    
    ) AS RankedRecords            
    WHERE RowNum = 1  -- Get the latest record for each CityId            
    ORDER BY InsertedDate DESC;  -- Order by the latest InsertedDate across distinct cities            
            
    -- Second query: Top 20 records with the highest duplicate counts from the previous month (no AgentId filter)                    
    INSERT INTO @Results            
    SELECT               
        COUNT(*) AS count,                
        MAX(AgentId) AS AgentId,              
        CityId,                     
        MAX(CityName) AS CityName,                    
        MAX(TravelFrom) AS TravelFrom,                    
        MAX(Nationality) AS Nationality,                    
        MAX(State) AS State,                    
        MAX(BookingCountryCode) AS BookingCountryCode,                    
        MAX(Lat) AS Lat,                    
        MAX(Long) AS Long,               
        MAX(InsertedDate) AS InsertedDate,              
        MAX(CheckIn) AS CheckIn,                  
        MAX(CheckOut) AS CheckOut,                
        MAX(SearchType) AS SearchType,              
        MAX(Residence) AS Residence,             
        'Top 20 by Duplicate Counts Previous Month' AS record_type              
    FROM SS.SS_ActivitySearchAvailablityData                    
    WHERE SearchType='City'       
   --AND InsertedDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)  -- Start of previous month            
   --   AND InsertedDate < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)  -- Start of current month            
    GROUP BY CityId        
    --HAVING COUNT(*) > 1            
    ORDER BY COUNT(*) DESC  -- Order by duplicate counts            
    OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY;  -- Get the top 20 by count                    
            
    -- Final selection from the table variable            
    SELECT * FROM @Results;            
END; 