-- EXEC SS.Auto_Activities_AgentSupplierMapping 1007         
        
CREATE PROCEDURE [SS].[Auto_Activities_AgentSupplierMapping]        
    @AgentId INT = 0        
AS        
BEGIN        
    SET NOCOUNT ON;        
        
    BEGIN TRY        
        -- Get all active activity-type suppliers        
        DECLARE @ActiveSuppliers TABLE (SupplierId INT);        
        
        INSERT INTO @ActiveSuppliers (SupplierId)        
        SELECT Id        
        FROM B2BHotelSupplierMaster        
        WHERE SupplierType = 'Activity' and Id in (40,39,38)        
          AND Action = 1        
          AND IsActive = 1        
          AND IsDelete = 0;        
        
        -- Perform UPSERT using MERGE        
        ;MERGE AgentSupplierProfileMapper AS target        
        USING (        
            SELECT SupplierId FROM @ActiveSuppliers        
        ) AS source        
        ON target.AgentId = @AgentId AND target.SupplierId = source.SupplierId        
        
        WHEN MATCHED THEN        
            UPDATE SET         
                ProfileId = 49,        
                CancellationHours = 48,        
                ServiceChargeAmt = 0,        
                servicecharge = 0,        
                GSTOnServiceCharge = 0,        
                IsActive = 1,        
                CreateDate = GETDATE(),
				Createdby=1
        
        WHEN NOT MATCHED THEN        
            INSERT (        
                AgentId, SupplierId, ProfileId, CancellationHours,         
                ServiceChargeAmt, servicecharge, GSTOnServiceCharge, CreateDate,Createdby        
            )        
            VALUES (        
                @AgentId, source.SupplierId, 49, 48, 0, 0, 0, GETDATE(),1        
            );        
        
        RETURN 1;  -- Success        
    END TRY        
    BEGIN CATCH        
        RETURN 0;  -- Failure        
    END CATCH        
END;     
    
