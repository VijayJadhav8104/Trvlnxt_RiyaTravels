CREATE PROCEDURE [Hotel].[Proc_rptDestinationSelectedNightsVendorWiseReport_NEW]      
    @StartDate DATETIME = NULL,              
    @EndDate DATETIME = NULL,      
    @SupplierName VARCHAR(500) = NULL,         
    @SearchBy VARCHAR(50) = '0'          
AS      
BEGIN      
    SET NOCOUNT ON;    
  
    DECLARE @sql NVARCHAR(MAX);    
    DECLARE @supplierSum NVARCHAR(MAX);  
  
    -- Build dynamic SUM(CASE...) for each supplier using FOR XML PATH to avoid 8000-byte limit
    SELECT @supplierSum = 
        STUFF((
            SELECT ',' + CHAR(13) +
            'SUM(CASE WHEN SM.SupplierName = ''' + REPLACE(S.SupplierName, '''', '''''') + ''' THEN   
                CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))   
             ELSE 0 END) AS [' + REPLACE(S.SupplierName, ']', ']]') + ']'
            FROM (SELECT DISTINCT SupplierName FROM B2BHotelSupplierMaster) S
            FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '');
  
    -- Compose full SQL statement  
    SET @sql = N'  
    SELECT     
        HB.cityName,    
        UPPER(LTRIM(RTRIM(ISNULL(NULLIF(HB.HotelBookCountryName, ''''), HB.countryname)))) AS CountryName,    
        ' + @supplierSum + '  
    FROM Hotel_BookMaster HB WITH (NOLOCK)  
    INNER JOIN B2BHotelSupplierMaster SM ON HB.SupplierPkId = SM.Id  
    WHERE HB.CurrentStatus IN (''Vouchered'', ''Confirmed'')';  
  
    -- Add date filter  
    IF @SearchBy = '0'  
        SET @sql += N' AND CONVERT(DATE, HB.InsertedDate) BETWEEN @StartDate AND @EndDate';  
    ELSE IF @SearchBy = '1'  
        SET @sql += N' AND CONVERT(DATE, HB.CheckInDate) BETWEEN @StartDate AND @EndDate';  
  
    -- Add optional supplier filter  
    IF @SupplierName IS NOT NULL AND @SupplierName <> ''  
        SET @sql += N' AND SM.SupplierName IN (''' + REPLACE(@SupplierName, ',', ''',''') + ''')';  
  
    -- Group and order  
    SET @sql += N'  
    GROUP BY HB.cityName, HB.HotelBookCountryName, HB.countryname  
    ORDER BY CountryName';  
  
    -- Execute dynamic SQL with parameters  
    EXEC sp_executesql @sql, N'@StartDate DATETIME, @EndDate DATETIME', @StartDate, @EndDate;  
END;
