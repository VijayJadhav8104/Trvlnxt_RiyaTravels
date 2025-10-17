
CREATE PROCEDURE Hotel.HotelAttributeInsert                                    
    @AgentId int = 0,  
    @AttributeId int = 0,  
    @Mandate bit = 0,  
    @IsActive bit = 0,  
    @Insertedby int = 0  
AS  
BEGIN                                    
    BEGIN TRY  
        BEGIN TRANSACTION;  
  
        IF @IsActive = 1  
        BEGIN  
            IF NOT EXISTS (SELECT 1 FROM Hotel.mHotelAgentAttributeMapping WHERE AgenId = @AgentId AND AttributeId = @AttributeId)  
            BEGIN  
                INSERT INTO Hotel.mHotelAgentAttributeMapping (AgenId, AttributeId, IsMandate, IsActive, CreatedBy, CreatedDate)  
                VALUES (@AgentId, @AttributeId, @Mandate, @IsActive, @Insertedby, GETDATE());  
            END  
            ELSE  
            BEGIN  
                UPDATE Hotel.mHotelAgentAttributeMapping  
                SET IsMandate = @Mandate,  
                    IsActive = @IsActive,  
                    ModifiedBy = @Insertedby,  
                    ModifiedDate = GETDATE()  
                WHERE AgenId = @AgentId AND AttributeId = @AttributeId;  
            END  
        END  
        ELSE -- @IsActive = 0  
        BEGIN  
            IF EXISTS (SELECT 1 FROM Hotel.mHotelAgentAttributeMapping WHERE AgenId = @AgentId AND AttributeId = @AttributeId)  
            BEGIN  
                UPDATE Hotel.mHotelAgentAttributeMapping  
                SET IsActive = @IsActive,  
                    ModifiedBy = @Insertedby,  
                    ModifiedDate = GETDATE()  
                WHERE AgenId = @AgentId AND AttributeId = @AttributeId;  
            END  
        END  
  
        COMMIT TRANSACTION;  
    END TRY  
    BEGIN CATCH  
        ROLLBACK TRANSACTION;  
        -- Log or handle the error appropriately  
    END CATCH;  
END  