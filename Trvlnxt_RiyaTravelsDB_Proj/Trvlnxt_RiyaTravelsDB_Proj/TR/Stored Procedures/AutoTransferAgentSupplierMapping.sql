-- EXEC TR.AutoTransferAgentSupplierMapping 1007        
        
CREATE PROCEDURE [TR].[AutoTransferAgentSupplierMapping]        
    @AgentId INT = 0        
AS        
BEGIN        
    SET NOCOUNT ON;        
        
    BEGIN TRY        
        -- Get all active transfer-type suppliers        
        DECLARE @ActiveSuppliers TABLE (SupplierId INT);        
        
        INSERT INTO @ActiveSuppliers (SupplierId)        
        SELECT Id        
        FROM B2BHotelSupplierMaster        
        WHERE SupplierType = 'Transfer'  and Id in (75)      
          AND Action = 1        
          AND IsActive = 1        
          AND IsDelete = 0;        
        
        -- Perform UPSERT using MERGE        
        ;MERGE TR.Transfer_AgentSupplierProfileMapper AS target        
        USING (        
            SELECT SupplierId FROM @ActiveSuppliers        
        ) AS source        
        ON target.AgentId = @AgentId AND target.SupplierId = source.SupplierId        
        
        WHEN MATCHED THEN        
            UPDATE SET         
                ProfileId = 55,        
                CancellationHours = 48,        
                ServiceChargeAmt = 0,        
                GSTOnServiceCharge = 0,        
                IsActive = 1,        
                CreateDate = GETDATE(),
				CreatedBy=1
        
        WHEN NOT MATCHED THEN        
            INSERT (        
                AgentId, SupplierId, ProfileId, CancellationHours,         
                ServiceChargeAmt, GSTOnServiceCharge, CreateDate,IsActive,CreatedBy        
            )        
            VALUES (        
                @AgentId, source.SupplierId, 55, 48, 0, 0, GETDATE() ,1,1       
            );        
        
        RETURN 1; -- Success        
    END TRY        
    BEGIN CATCH        
        RETURN 0; -- Failure        
    END CATCH        
END;        
      
      
select * from PricingProfile