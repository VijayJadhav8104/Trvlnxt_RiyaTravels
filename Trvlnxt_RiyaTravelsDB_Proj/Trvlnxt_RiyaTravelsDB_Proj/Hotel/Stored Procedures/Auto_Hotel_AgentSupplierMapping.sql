          
          
--exec  Hotel.Auto_Hotel_AgentSupplierMapping 2670          
          
CREATE PROCEDURE [Hotel].[Auto_Hotel_AgentSupplierMapping]          
    @AgentId INT = 0          
AS          
BEGIN          
    SET NOCOUNT ON;          
          
    BEGIN TRY          
        -- Prepare temp table to hold suppliers and resolved profile IDs          
        DECLARE @ActiveSuppliers TABLE (SupplierId INT, ProfileId INT);          
          
        -- Populate active suppliers along with ProfileId from Auto_Hotel_AgentSupplierMapping table          
        INSERT INTO @ActiveSuppliers (SupplierId, ProfileId)          
        SELECT           
            sm.Id AS SupplierId,          
            ISNULL(autoMap.ProfileId, 0) AS ProfileId          
        FROM B2BHotelSupplierMaster sm          
        INNER JOIN Auto_HotelAgentSupplierMapping autoMap          
            ON autoMap.SupplierId = sm.Id          
        WHERE sm.SupplierType = 'Hotel'          
          AND sm.Action = 1          
          AND sm.IsActive = 1          
          AND sm.IsDelete = 0;          
          
        -- Perform UPSERT into AgentSupplierProfileMapper          
        ;MERGE AgentSupplierProfileMapper AS target          
        USING (          
            SELECT SupplierId, ProfileId FROM @ActiveSuppliers          
        ) AS source          
        ON target.AgentId = @AgentId AND target.SupplierId = source.SupplierId          
          
        WHEN MATCHED THEN          
            UPDATE SET           
                ProfileId = source.ProfileId,          
                CancellationHours = 48,          
                ServiceChargeAmt = 100,   
    IsInterNationalChargesApplicable=1,  
                servicecharge = 0,          
                GSTOnServiceCharge = 18,          
                IsActive = 1,          
                CreateDate = GETDATE(),
				Createdby=1
          
        WHEN NOT MATCHED THEN          
            INSERT (          
                AgentId, SupplierId, ProfileId, CancellationHours,          
                ServiceChargeAmt, servicecharge, GSTOnServiceCharge, CreateDate,IsInterNationalChargesApplicable,Createdby         
            )          
            VALUES (          
                @AgentId, source.SupplierId, source.ProfileId, 48, 100, 0, 18, GETDATE(),1,1          
            );          
          
        RETURN 1; -- Success          
    END TRY          
    BEGIN CATCH          
        RETURN 0; -- Failure          
    END CATCH          
END; 