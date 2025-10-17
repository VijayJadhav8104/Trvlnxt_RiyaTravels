
--exec [Hotel].[GetSupplierHistory] 45
CREATE PROCEDURE [Hotel].[GetSupplierHistory]
    @Id INT = 0
AS
BEGIN
    ;WITH CombinedHistory AS (
        SELECT 
            SM.Id AS SupplierId, 
            SM.ModifiedOn AS CreatedDate,
            MU.FullName + ' - ' + MU.UserName AS CreatedBy
        FROM B2BHotelSupplierMaster SM
        LEFT JOIN mUser MU ON SM.ModifiedBy = MU.ID
        WHERE SM.Id = @Id

        UNION ALL

        SELECT 
            SM.Pkid AS SupplierId,  
            SM.CreateDate AS CreatedDate,
            MU.FullName + ' - ' + MU.UserName AS CreatedBy
        FROM B2BHotelSupplierMaster_History SM
        LEFT JOIN mUser MU ON SM.CreatedBy = MU.ID
        WHERE SM.Pkid = @Id
    )

    SELECT TOP 3 * FROM CombinedHistory
    ORDER BY SupplierId DESC;  
END
