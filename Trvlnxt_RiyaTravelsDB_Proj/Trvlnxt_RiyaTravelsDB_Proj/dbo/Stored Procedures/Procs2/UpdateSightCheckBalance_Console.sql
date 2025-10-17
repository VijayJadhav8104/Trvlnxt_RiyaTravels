CREATE PROCEDURE [dbo].[UpdateSightCheckBalance_Console]  
(  
    @UserId INT,  
    @Balance DECIMAL(18,2),  
    @AgentNo INT,  
    @CreatedBy INT = 0,  
    @BookingRef VARCHAR(50) = NULL  
)  
AS    
BEGIN  
    -- Declare variables  
    DECLARE @Amt DECIMAL(18,2) = 0;  
    DECLARE @LatestOpenBalance DECIMAL(18,2);  
      
    -- Find the latest close balance for the agent  
    SELECT TOP 1  
        @LatestOpenBalance = CloseBalance  
    FROM tblAgentBalance  
    WHERE AgentNo = @AgentNo  
    ORDER BY PKID DESC;  
  
    -- Set the status of the last transaction to inactive  
    IF @LatestOpenBalance IS NOT NULL  
    BEGIN  
        UPDATE tblAgentBalance  
        SET IsActive = 0  
        WHERE PKID = (SELECT TOP 1 PKID  
                      FROM tblAgentBalance  
                      WHERE AgentNo = @AgentNo  
                      ORDER BY PKID DESC);  
    END  
  
    -- Calculate the new open balance  
    DECLARE @CloseBalance DECIMAL(18,2) = ISNULL(@LatestOpenBalance, 0) + @Balance;  
  
    -- Insert the transaction into tblAgentBalance  
    INSERT INTO tblAgentBalance  
    (  
        AgentNo,  
        OpenBalance,  
        TranscationAmount,  
        CloseBalance,  
        IsActive,  
        TransactionType,  
        BookingRef,  
        CreatedBy,  
        Remark  
    )  
    VALUES  
    (  
        @AgentNo,  
        @LatestOpenBalance,  
        @Balance,  
        @CloseBalance, -- Use the latest close balance  
        1, -- Set IsActive to 1 for the new entry  
        'Credit',  
        @BookingRef,  
        @CreatedBy,  
        'payment received by console'  
    );  
  
    -- Update the AgentLogin table with the new AgentBalance  
    UPDATE AgentLogin  
    SET AgentBalance = @CloseBalance  
    WHERE UserID = @UserId;  
END;  