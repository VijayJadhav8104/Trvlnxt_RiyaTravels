CREATE PROCEDURE [Hotel].[Proc_rptChainSelectedNightsVendorWiseReport_NEW]        
    @StartDate DATETIME = NULL,                
    @EndDate DATETIME = NULL,        
    @SupplierName VARCHAR(500) = NULL,           
    @SearchBy VARCHAR(50) = '0'            
AS        
BEGIN        
    SET NOCOUNT ON;      
      
    DECLARE @sql NVARCHAR(MAX);        
    DECLARE @cols NVARCHAR(MAX);        
    DECLARE @colsWithNullsHandled NVARCHAR(MAX);      
    DECLARE @whereClause NVARCHAR(MAX);        
      
    -- Step 1: Build the dynamic column list for pivot      
    SELECT   
        @cols = STRING_AGG(QUOTENAME(SupplierName), ', '),  
        @colsWithNullsHandled = STRING_AGG('ISNULL(' + QUOTENAME(SupplierName) + ', 0) AS ' + QUOTENAME(SupplierName), ', ')  
    FROM (      
        SELECT DISTINCT SupplierName      
        FROM B2BHotelSupplierMaster      
        WHERE (@SupplierName IS NULL OR SupplierName IN (SELECT value FROM STRING_SPLIT(@SupplierName, ',')))      
    ) AS SupplierList;      
      
    -- Step 2: Build WHERE clause based on SearchBy parameter      
    SET @whereClause = CASE       
        WHEN @SearchBy = '0' THEN 'CONVERT(DATE, HB.InsertedDate) BETWEEN @StartDate AND @EndDate'      
        WHEN @SearchBy = '1' THEN 'CONVERT(DATE, HB.CheckInDate) BETWEEN @StartDate AND @EndDate'      
        ELSE '1=1'      
    END;      
      
    -- Step 3: Build dynamic SQL      
    SET @sql = '      
    SELECT       
        cityName,         
        CountryName,         
        ChainName,      
        HotelName, ' + @colsWithNullsHandled + '      
    FROM (      
        SELECT       
            HB.cityName,      
            UPPER(LTRIM(RTRIM(ISNULL(NULLIF(HB.HotelBookCountryName, ''''), HB.countryname)))) AS CountryName,      
            HB.ChainName,      
            HB.HotelName,      
            SM.SupplierName,      
            CONVERT(INT, ISNULL(HB.totalRooms, 0)) * ISNULL(HB.SelectedNights, 0) AS SelectedRoomNights      
        FROM Hotel_BookMaster HB WITH (NOLOCK)      
        INNER JOIN B2BHotelSupplierMaster SM ON HB.SupplierPkId = SM.Id      
        WHERE ' + @whereClause + '      
          AND HB.CurrentStatus IN (''Vouchered'', ''Confirmed'')      
    ) AS SourceTable      
    PIVOT (      
        SUM(SelectedRoomNights)      
        FOR SupplierName IN (' + @cols + ')      
    ) AS PivotTable      
    ORDER BY CountryName, cityName;      
    ';      
      
    -- Step 4: Execute dynamic SQL      
    EXEC sp_executesql @sql,       
        N'@StartDate DATETIME, @EndDate DATETIME',       
        @StartDate, @EndDate;        
END;  