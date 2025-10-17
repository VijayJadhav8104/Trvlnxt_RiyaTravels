          
          
CREATE PROCEDURE TR_OfflineCancelData          
@Id INT          
AS          
BEGIN          
    SELECT          
        HB.PaymentMode ,          
        ISNULL(AgentDiscountPrice, 0) AS BookingAmount,          
        HB.CorrelationId AS 'OrderId',          
        ISNULL(MCC.ID, 0) AS 'Agentcountry',          
        HB.MainAgentID AS 'MainAgentID',          
        -- Convert CurrentStatus to proper case          
        CONCAT(          
            UPPER(SUBSTRING(HB.BookingStatus, 1, 1)),          
            LOWER(SUBSTRING(HB.BookingStatus, 2, LEN(HB.BookingStatus)))          
        ) AS 'CurrentStatus',          
        HB.BookingRefId AS 'BookingReference',          
        HB.AgentID AS 'RiyaAgentID',
		HB.SubMainAgntId,
  HB.ProviderConfirmationNumber    
    FROM          
        TR.TR_BookingMaster HB          
    LEFT JOIN mCountry MCC ON HB.BookingCurrency = MCC.Currency          
    WHERE          
        BookingId = @Id;          
END; 