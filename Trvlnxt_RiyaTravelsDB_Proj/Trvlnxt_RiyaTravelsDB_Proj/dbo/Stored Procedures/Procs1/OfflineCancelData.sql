    
    
CREATE PROCEDURE OfflineCancelData    
@Id INT    
AS    
BEGIN    
    SELECT    
        HB.B2BPaymentMode,    
        ISNULL(DisplayDiscountRate, 0) AS BookingAmount,    
        OrderId,    
        ISNULL(MCC.ID, 0) AS 'Agentcountry',    
        HB.MainAgentID AS 'MainAgentID',    
        -- Convert CurrentStatus to proper case    
        CONCAT(    
            UPPER(SUBSTRING(HB.CurrentStatus, 1, 1)),    
            LOWER(SUBSTRING(HB.CurrentStatus, 2, LEN(HB.CurrentStatus)))    
        ) AS 'CurrentStatus',    
        HB.BookingReference,    
        HB.RiyaAgentID    
    FROM    
        Hotel_BookMaster HB WITH (NOLOCK)    
    LEFT JOIN mCountry MCC WITH (NOLOCK) ON HB.BookingCountry = MCC.CountryCode    
    WHERE    
        pkId = @Id;    
END;    