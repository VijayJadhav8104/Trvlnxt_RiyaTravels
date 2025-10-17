CREATE PROCEDURE [Hotel].[Proc_rptDestinationWiseReport_NEW]  
    @StartDate DATETIME = '2025-05-15',  
    @EndDate DATETIME = '2025-05-15',  
    @SupplierName VARCHAR(500) = NULL,  
    @SearchBy VARCHAR(50) = '0'  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    DECLARE @sql NVARCHAR(MAX);  
    DECLARE @dynamicColumns NVARCHAR(MAX);  
    DECLARE @filterClause NVARCHAR(MAX) = '';  
    DECLARE @groupBy NVARCHAR(MAX) = ' GROUP BY HB.cityName, HotelBookCountryName, countryname ';  
    DECLARE @orderBy NVARCHAR(MAX) = ' ORDER BY CountryName ';  
  
    -- 1. Get dynamic supplier columns (only for SupplierType = 'Hotel' and IsDelete = 0)  
    SELECT @dynamicColumns = STRING_AGG(  
        CAST('SUM(CASE WHEN SM.SupplierName = ''' + SupplierName + ''' THEN 1 ELSE 0 END) AS [' + SupplierName + ']' AS NVARCHAR(MAX)),  
        ', '  
    )  
    FROM (  
        SELECT DISTINCT SupplierName  
        FROM B2BHotelSupplierMaster  
        WHERE SupplierType = 'Hotel' AND IsDelete = 0  
    ) AS SupplierList;  
  
    -- 2. Build FROM and JOIN clause  
    SET @sql = N'  
        SELECT   
            UPPER(LTRIM(RTRIM(HB.cityName))) AS cityName,  
            UPPER(LTRIM(RTRIM(ISNULL(NULLIF(HotelBookCountryName, ''''), ISNULL(countryname, ''-NA-''))))) AS CountryName,  
            ' + @dynamicColumns + '  
        FROM Hotel_BookMaster HB WITH (NOLOCK)  
        INNER JOIN B2BHotelSupplierMaster SM ON HB.SupplierPkId = SM.Id  
    ';  
  
    -- 3. Add filter by date and status  
    SET @filterClause = CASE   
        WHEN @SearchBy = '0' THEN   
            ' WHERE CONVERT(DATE, HB.InsertedDate) BETWEEN @StartDate AND @EndDate AND HB.CurrentStatus IN (''Vouchered'', ''Confirmed'') '  
        WHEN @SearchBy = '1' THEN   
            ' WHERE CONVERT(DATE, HB.CheckInDate) BETWEEN @StartDate AND @EndDate AND HB.CurrentStatus IN (''Vouchered'', ''Confirmed'') '  
        ELSE   
            ' WHERE HB.CurrentStatus IN (''Vouchered'', ''Confirmed'') '  
    END;  
  
    -- 4. Append filters and group/order  
    SET @sql = @sql + @filterClause + @groupBy + @orderBy;  
  
    -- 5. Execute  
    EXEC sp_executesql @sql,   
        N'@StartDate DATETIME, @EndDate DATETIME',   
        @StartDate, @EndDate;  
END  