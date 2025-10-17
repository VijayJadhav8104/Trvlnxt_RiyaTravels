CREATE PROCEDURE [Hotel].[Proc_rptChainWiseCountReport_NEW]      
    @StartDate DATETIME = NULL,              
    @EndDate DATETIME = NULL,      
    @SupplierName VARCHAR(500) = NULL,         
    @SearchBy VARCHAR(50) = '0'          
AS      
BEGIN      
    SET NOCOUNT ON;    
    
    DECLARE @sql NVARCHAR(MAX) = '';    
    DECLARE @supplierColumns NVARCHAR(MAX) = '';    
    DECLARE @whereClause NVARCHAR(MAX) = '';    
    DECLARE @groupBy NVARCHAR(MAX) = 'GROUP BY HB.cityName, HB.ChainName, HB.HotelName, HotelBookCountryName, countryname, CONVERT(DATE, HB.inserteddate)';    
    DECLARE @orderBy NVARCHAR(MAX) = 'ORDER BY CountryName, cityName DESC';    
    
    -- Step 1: Build dynamic SUM(CASE...) columns for all suppliers (FIXED using VARCHAR(MAX) + QUOTENAME)    
    SELECT @supplierColumns = STRING_AGG(    
        CAST('SUM(CASE WHEN SM.SupplierName = ''' + SupplierName + ''' THEN 1 ELSE 0 END) AS ' + QUOTENAME(SupplierName) AS VARCHAR(MAX)),    
        ', '    
    )    
    FROM (    
        SELECT DISTINCT SupplierName    
        FROM B2BHotelSupplierMaster    
        WHERE (@SupplierName IS NULL OR SupplierName IN (SELECT value FROM STRING_SPLIT(@SupplierName, ',')))    
    ) AS Suppliers;    
    
    -- Step 2: Start building the SELECT statement    
    SET @sql = '    
    SELECT     
        HB.cityName AS cityName,    
        UPPER(LTRIM(RTRIM(ISNULL(NULLIF(HotelBookCountryName, ''''), ISNULL(countryname, ''-NA-''))))) AS CountryName,    
        HB.ChainName,    
        HB.HotelName,    
        ' + @supplierColumns + '    
    FROM Hotel_BookMaster HB WITH (NOLOCK)    
    INNER JOIN B2BHotelSupplierMaster SM ON HB.SupplierPkId = SM.Id    
    ';    
    
    -- Step 3: Build WHERE clause based on @SearchBy    
    IF @SearchBy = '0' -- Booking date    
    BEGIN    
        SET @whereClause = 'WHERE CONVERT(DATE, HB.inserteddate) BETWEEN @StartDate AND @EndDate AND HB.CurrentStatus IN (''Vouchered'', ''Confirmed'')';    
    END    
    ELSE IF @SearchBy = '1' -- Check-in date    
    BEGIN    
        SET @whereClause = 'WHERE CONVERT(DATE, HB.CheckInDate) BETWEEN @StartDate AND @EndDate AND HB.CurrentStatus IN (''Vouchered'', ''Confirmed'')';    
    END    
    
    -- Step 4: Combine SQL parts    
    SET @sql = @sql + ' ' + @whereClause + ' ' + @groupBy + ' ' + @orderBy;    
    
    -- Step 5: Execute the dynamic SQL    
    EXEC sp_executesql @sql, N'@StartDate DATETIME, @EndDate DATETIME', @StartDate, @EndDate;    
END; 