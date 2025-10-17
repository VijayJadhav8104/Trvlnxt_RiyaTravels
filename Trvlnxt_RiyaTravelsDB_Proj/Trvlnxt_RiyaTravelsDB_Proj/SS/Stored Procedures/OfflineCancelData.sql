        
        --SS.OfflineCancelData 408
CREATE PROCEDURE SS.OfflineCancelData        
@Id INT        
AS        
BEGIN        
    SELECT        
        HB.PaymentMode as 'paymentmodetype',        
        ISNULL(HB.AmountBeforePgCommission, 0) AS BookingAmount,        
       'BookingRefId' as OrderId,        
        ISNULL(MCC.ID, 0) AS 'Agentcountry',        
        HB.MainAgentID AS 'MainAgentID',        
        -- Convert CurrentStatus to proper case        
        CONCAT(        
            UPPER(SUBSTRING(HB.BookingStatus, 1, 1)),        
            LOWER(SUBSTRING(HB.BookingStatus, 2, LEN(HB.BookingStatus)))        
        ) AS 'CurrentStatus',        
        HB.AgentID as 'RiyaUserID',
		HB.BookingRefId as 'BookingReference'
	
    FROM        
        SS.SS_BookingMaster HB WITH (NOLOCK)        
    LEFT JOIN mCountry MCC WITH (NOLOCK) ON HB.CountryCode = MCC.CountryCode        
    WHERE        
        BookingId = @Id;        
END; 