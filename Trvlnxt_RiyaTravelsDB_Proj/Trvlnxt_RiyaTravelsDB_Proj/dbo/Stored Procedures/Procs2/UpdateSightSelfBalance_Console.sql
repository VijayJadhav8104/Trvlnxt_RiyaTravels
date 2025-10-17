CREATE PROCEDURE [dbo].[UpdateSightSelfBalance_Console]        
(        
    @UserId INT,        
    @Balance DECIMAL(18,2),        
    @AgentNo INT,        
    @CreatedBy INT = 0,        
    @BookingRef VARCHAR(50) = NULL,      
    @Country int=0 -- Specify the correct length for @Country      
)        
AS          
BEGIN        
    -- Declare variables        
    DECLARE @LatestCloseBalance DECIMAL(18,2);        
          
    -- Get the latest inserted CloseBalance from tblSelfBalance      
    SELECT TOP 1  @LatestCloseBalance=CloseBalance      
    FROM tblSelfBalance      
    WHERE UserID = @AgentNo      
    ORDER BY PKID DESC;      
      
    -- Calculate the new open balance      
    DECLARE @finalclosebalance DECIMAL(18,2) = ISNULL(@LatestCloseBalance, 0) + @Balance;        
      
  -- Insert the transaction into tblSelfBalance      
    INSERT INTO tblSelfBalance        
    (        
        UserID,      
        BookingRef,      
        OpenBalance,        
        TranscationAmount,        
        CloseBalance,      
        CreatedOn,      
        CreatedBy,      
        TransactionType,      
        Remark,      
        ProductType      
    )        
    VALUES        
    (        
        @AgentNo,       
        @BookingRef,        
        @LatestCloseBalance,  -- Use the latest CloseBalance      
        @Balance,        
        @finalclosebalance,    -->@finalclosebalance      
        GETDATE(),      
        @UserId,      
        'Credit',      
        'Refund from Console', -- Set IsActive to 1 for the new entry        
        'SightSeeing'       
    );        
      
 begin      
   -- Update the mUserCountryMapping table with the new AgentBalance      
    UPDATE mUserCountryMapping      
    SET AgentBalance = @finalclosebalance , ModifiedOn=GETDATE(), ModifiedBy=@UserId      
    WHERE UserID = @AgentNo AND CountryId = @Country;      
 end      
END; 