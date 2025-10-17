CREATE PROCEDURE [Hotel].[Proc_rptChainAmountVendorWiseReport_NEW]      
    @StartDate DATETIME = NULL,      
    @EndDate DATETIME = NULL,      
    @SupplierName VARCHAR(500) = NULL,      
    @SearchBy VARCHAR(50) = '0'      
AS      
BEGIN      
    SET NOCOUNT ON;      
      
    DECLARE @cols NVARCHAR(MAX),      
            @colsWithNullsHandled NVARCHAR(MAX),      
            @sql NVARCHAR(MAX),      
            @whereClause NVARCHAR(MAX);      
      
    -- Step 1: Get list of supplier names to pivot      
    SELECT   
        @cols = STRING_AGG(QUOTENAME(SupplierName), ','),  
        @colsWithNullsHandled = STRING_AGG('ISNULL(' + QUOTENAME(SupplierName) + ', 0) AS ' + QUOTENAME(SupplierName), ', ')  
    FROM (      
        SELECT DISTINCT SupplierName      
        FROM B2BHotelSupplierMaster      
        WHERE (@SupplierName IS NULL OR SupplierName IN (SELECT value FROM STRING_SPLIT(@SupplierName, ',')))      
    ) AS SupplierList;      
      
    -- Step 2: Build WHERE clause based on SearchBy      
    SET @whereClause = CASE       
        WHEN @SearchBy = '0' THEN 'CONVERT(DATE, HB.InsertedDate) BETWEEN @StartDate AND @EndDate'      
        WHEN @SearchBy = '1' THEN 'CONVERT(DATE, HB.CheckInDate) BETWEEN @StartDate AND @EndDate'      
        ELSE '1 = 1'      
    END;      
      
    -- Step 3: Build main SQL      
    SET @sql = '      
    WITH DataSource AS (      
        SELECT      
            HB.cityName,      
            UPPER(LTRIM(RTRIM(ISNULL(NULLIF(HB.HotelBookCountryName, ''''), ISNULL(HB.countryname, ''-NA-''))))) AS CountryName,      
            HB.ChainName,      
            HB.HotelName,      
            SM.SupplierName,      
            CAST(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate, 0) AS DECIMAL(18, 2)) AS Amount      
        FROM B2BHotelSupplierMaster SM      
        INNER JOIN Hotel_BookMaster HB ON SM.Id = HB.SupplierPkId      
        WHERE ' + @whereClause + '      
          AND HB.CurrentStatus IN (''Vouchered'', ''Confirmed'')      
    )      
    SELECT       
        cityName,      
        CountryName,      
        ChainName,      
        HotelName, ' + @colsWithNullsHandled + '      
    FROM       
        DataSource      
    PIVOT (      
        SUM(Amount) FOR SupplierName IN (' + @cols + ')      
    ) AS PivotTable      
    ORDER BY CountryName;';      
      
    -- Step 4: Execute dynamic SQL safely      
    EXEC sp_executesql @sql,      
        N'@StartDate DATETIME, @EndDate DATETIME',      
        @StartDate, @EndDate;      
END;  