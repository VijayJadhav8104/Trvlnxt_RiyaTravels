CREATE PROCEDURE [TR].[TR_UpdateCheckBalance_Console]   --   51534,3024.00,51534,137,'TNH20231003180541533'    
(          
    @UserId INT,          
    @Balance DECIMAL(18,2),          
    @AgentNo INT,          
    @CreatedBy INT = 0,          
    @BookingRef VARCHAR(50) = NULL          
)          
AS            
BEGIN          
             
  BEGIN TRAN          
             
   -- Declare variables          
    DECLARE @Amt DECIMAL(18,2) = 0;          
    DECLARE @LatestOpenBalance DECIMAL(18,2);      
    declare @ModelID varchar(max);      
    DECLARE @TransactionPkId INT;        DECLARE @BookingStatus VARCHAR(50);               
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
      PRINT 1    
    -- Update the AgentLogin table with the new AgentBalance          
    UPDATE AgentLogin          
    SET AgentBalance = @CloseBalance          
    WHERE UserID = @UserId;          
          
   PRINT 2    
 SELECT @TransactionPkId= SCOPE_IDENTITY()     
 PRINT 3   
 SELECT TOP 1 @BookingStatus= ISNULL(BM.BookingStatus,'')   
 FROM TR.TR_Status_History HSH   
 JOIN TR.TR_BookingMaster BM ON BM.BookingId=HSH.BookingId     
 --JOIN Hotel_Status_Master HSM ON HSH.FkStatusId=HSM.Id   
 WHERE BM.CorrelationId=@BookingRef ORDER BY HSH.CreateDate DESC      
PRINT 4    
INSERT INTO  [TR].[Agentbalance_StatusLog](FKtransactionID,BookingStatus) VALUES (@TransactionPkId,@BookingStatus)    
 PRINT 5    
    
SET @ModelID = 'UPDATE AgentLogin SET AgentBalance = ('+cast(cast(@Amt as varchar) +'+'+ cast(@Balance as varchar) as varchar)+') WHERE UserID = '+cast(@UserId as varchar);                                                     
insert into [TR].[TR_ExceptionLog](ErrorMessage,ErrorProcedure,ErrorNumber) values(@BookingRef,@ModelID,@UserId)     
      
   PRINT 6    
 COMMIT          
          
END; 