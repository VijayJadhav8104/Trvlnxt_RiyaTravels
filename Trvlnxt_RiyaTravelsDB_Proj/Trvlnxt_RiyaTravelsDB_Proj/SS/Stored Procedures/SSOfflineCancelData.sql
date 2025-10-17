          
          
CREATE PROCEDURE SS.SSOfflineCancelData       
@BookingId INT          
AS          
BEGIN          
    SELECT          
       SSB.AgentID AS 'AgentID',          
        -- Convert CurrentStatus to proper case          
        CONCAT(          
            UPPER(SUBSTRING(SSB.BookingStatus, 1, 1)),          
            LOWER(SUBSTRING(SSB.BookingStatus, 2, LEN(SSB.BookingStatus)))          
        ) AS 'CurrentStatus',          
        SSB.BookingRefId ,          
        SSB.MainAgentID    
      
    FROM          
        ss.SS_BookingMaster SSB          
    LEFT JOIN mCountry MCC ON SSB.CountryCode= MCC.CountryCode     
     
    WHERE          
        BookingId = @BookingId;          
END; 