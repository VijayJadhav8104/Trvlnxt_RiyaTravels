    
CREATE PROCEDURE [dbo].[TR_BookingMaster_Insert]    
    
 @BookingRefId varchar(50),    
 @CorrelationId varchar(max),    
 @AgentID int,    
 @RiyaSubUserId int    
    
AS     
    
BEGIN    
    
-- Declare and initialize the variables    
DECLARE @BookingNumber varchar(500)    
    
-- Your logic to set the BookingRefId    
IF @BookingRefId = ''    
BEGIN    
    SET @BookingRefId = (SELECT TOP 1 BookingRefId FROM [TR].[TR_BookingMaster] WITH(NOLOCK) ORDER BY BookingId DESC);    
        
    IF ISNULL(@BookingRefId, '') = ''    
        SET @BookingRefId = 'TNC0000001';    
    ELSE    
    BEGIN    
        -- Extract the numeric part of the BookingRefId    
        DECLARE @NumericPart INT;    
        SET @NumericPart = CAST(SUBSTRING(@BookingRefId, 4, LEN(@BookingRefId) - 3) AS INT) + 1;    
    
        -- Format the new BookingRefId    
        SET @BookingRefId = 'TNC' + RIGHT('0000000' + CAST(@NumericPart AS NVARCHAR(10)), 7);    
    END    
END    
    
SET @BookingNumber=@BookingRefId    
    
-- Now perform the INSERT    
INSERT INTO [TR].[TR_BookingMaster] (    
    [BookingRefId],    
    [CorrelationId],    
    [AgentID]   
   
) VALUES (    
    @BookingNumber,  -- Use the calculated BookingRefId    
    @CorrelationId,    
    @AgentID   
   
);    
    
END 