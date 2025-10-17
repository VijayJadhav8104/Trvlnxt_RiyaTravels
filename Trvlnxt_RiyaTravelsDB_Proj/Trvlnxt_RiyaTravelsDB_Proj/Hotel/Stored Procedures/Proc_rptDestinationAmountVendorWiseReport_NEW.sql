CREATE PROCEDURE [Hotel].[Proc_rptDestinationAmountVendorWiseReport_NEW]      
    @StartDate DATETIME = NULL,              
    @EndDate DATETIME = NULL,      
    @SupplierName VARCHAR(500) = NULL,         
    @SearchBy VARCHAR(50) = '0'          
AS      
BEGIN      
    SET NOCOUNT ON;    
    
    DECLARE @sql NVARCHAR(MAX);      
    DECLARE @columns NVARCHAR(MAX);      
    DECLARE @dateFilter NVARCHAR(MAX);  
    DECLARE @supplierFilter NVARCHAR(MAX) = N'';  
  
    -- Get pivot column list with ISNULL to avoid NULLs in final output
    SELECT @columns = STRING_AGG('ISNULL(' + QUOTENAME(SupplierName) + ', 0) AS ' + QUOTENAME(SupplierName), ',')
    FROM (SELECT DISTINCT SupplierName FROM B2BHotelSupplierMaster) AS Suppliers;  
  
    -- Build date filter
    IF @SearchBy = '0'  
        SET @dateFilter = 'CONVERT(DATE, HB.InsertedDate) BETWEEN @StartDate AND @EndDate';  
    ELSE  
        SET @dateFilter = 'CONVERT(DATE, HB.CheckInDate) BETWEEN @StartDate AND @EndDate';  
  
    -- Optional SupplierName filter
    IF ISNULL(@SupplierName, '') <> ''  
        SET @supplierFilter = ' AND SM.SupplierName IN (''' + REPLACE(@SupplierName, ',', ''',''') + ''')';  
  
    -- Construct dynamic SQL  
    SET @sql = '  
        SELECT     
            PivotTable.cityName AS CityName,    
            ISNULL(
                UPPER(LTRIM(RTRIM(
                    ISNULL(NULLIF(PivotTable.HotelBookCountryName, ''''), PivotTable.countryname)
                ))), ''-'') AS CountryName,    
            ' + @columns + '    
        FROM (    
            SELECT     
                HB.cityName,    
                HB.HotelBookCountryName,    
                HB.countryname,    
                SM.SupplierName,    
                ISNULL(CAST(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate, 0) AS DECIMAL(18,2)), 0) AS Amount    
            FROM     
                B2BHotelSupplierMaster SM    
            INNER JOIN     
                Hotel_BookMaster HB ON SM.Id = HB.SupplierPkId AND SM.isdelete = 0   
            WHERE ' + @dateFilter + '  
                AND HB.CurrentStatus IN (''Vouchered'', ''Confirmed'')' + @supplierFilter + '  
        ) AS SourceTable    
        PIVOT (    
            SUM(Amount)    
            FOR SupplierName IN (' + 
            -- Raw column names for pivot
            (SELECT STRING_AGG(QUOTENAME(SupplierName), ',') 
             FROM (SELECT DISTINCT SupplierName FROM B2BHotelSupplierMaster) AS Suppliers) + 
        ')    
        ) AS PivotTable    
        ORDER BY CountryName;';  
  
    -- Execute the dynamic SQL
    EXEC sp_executesql @sql,   
                       N'@StartDate DATETIME, @EndDate DATETIME',   
                       @StartDate, @EndDate;  
END;
