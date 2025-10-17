
--CREATED BY Prakash Suryawanshi(18 Feb 2025)
--Modified BY Prakash Suryawanshi(10 Mar 2025)
--EXEC [Hotel].[Proc_rptDestinationAmountVendorWiseReport] '01-Mar-2025', '09-Mar-2025'
--select distinct * from B2BHotelSupplierMaster

CREATE PROCEDURE [Hotel].[Proc_rptDestinationAmountVendorWiseReport]
    @StartDate DateTime = NULL,        
    @EndDate DateTime = NULL,
    @SupplierName varchar(500) = NULL,   
    @SearchBy Varchar(50) = '0'    
AS
BEGIN
    DECLARE @sql AS NVARCHAR(MAX);
    DECLARE @columns AS NVARCHAR(MAX);

    -- Step 1: Get the distinct SupplierNames from the B2BHotelSupplierMaster
    SELECT @columns = STRING_AGG(QUOTENAME(SupplierName), ', ')
    FROM (SELECT DISTINCT SupplierName FROM B2BHotelSupplierMaster) AS SupplierList;  -- Added DISTINCT here

    -- Initialize the dynamic SQL query
  SET @sql = N'SELECT HB.cityName as cityName, 
                upper(Ltrim(Rtrim(isnull(isnull(HotelBookCountryName, countryname), ''-NA-'')))) AS CountryName, 
				CASE 
                    WHEN SM.SupplierName = ''Agoda'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Agoda,
                CASE 
                    WHEN SM.SupplierName = ''Agoda India'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS AgodaIndia,
                CASE 
                    WHEN SM.SupplierName = ''AgodaDomSell'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS AgodaDomSell,
                CASE 
                    WHEN SM.SupplierName = ''AgodaINTSell'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS agodaINTSell,
				CASE 
                    WHEN SM.SupplierName = ''AgodaINT'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS agodaINT,
				CASE 
                    WHEN SM.SupplierName = ''Amadeus'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Amadeus,
                CASE 
                    WHEN SM.SupplierName = ''Bonotel'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Bonotel,
                CASE 
                    WHEN SM.SupplierName = ''Cleartrip'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Cleartrip,
				CASE 
                    WHEN SM.SupplierName = ''Derbysoft'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Derbysoft,
                CASE 
                    WHEN SM.SupplierName = ''desiya'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS desiya,
                CASE 
                    WHEN SM.SupplierName = ''Dida'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Dida,
                CASE 
                    WHEN SM.SupplierName = ''DOTW'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS DOTW,
                CASE 
                    WHEN SM.SupplierName = ''EETGlobal'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS EETGlobal,
                CASE 
                    WHEN SM.SupplierName = ''Ean(PayAtHotel)'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Ean,
                CASE 
                    WHEN SM.SupplierName = ''Expedia'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Expedia,
                CASE 
                    WHEN SM.SupplierName = ''Expedia Corp'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS ExpediaCorp,
                CASE 
                    WHEN SM.SupplierName = ''ExpediaPackage'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS ExpediaPackage,
                CASE 
                    WHEN SM.SupplierName = ''ExpediaROWTEST'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS ExpediaROWTEST,
                CASE 
                    WHEN SM.SupplierName = ''G2B2BTGX'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS G2B2BTGX,
                CASE 
                    WHEN SM.SupplierName = ''HeytripGo'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS HeytripGo,
                CASE 
                    WHEN SM.SupplierName = ''HOTELSPRO'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS HOTELSPRO,				
                CASE 
                    WHEN SM.SupplierName = ''Hotelbeds'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS hotelbeds,
				 CASE 
                    WHEN SM.SupplierName = ''Hotelbeds Activities'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS HotelbedsActivities,
				CASE 
                    WHEN SM.SupplierName = ''HyperGuestNative'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS HyperGuestNative,
                CASE 
                    WHEN SM.SupplierName = ''Itrip'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Itrip,
                CASE 
                    WHEN SM.SupplierName = ''LuxuryTours'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS LuxuryTours,
                CASE 
                    WHEN SM.SupplierName = ''LuxuryTravels'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS LuxuryTravels,
                CASE 
                    WHEN SM.SupplierName = ''miki'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS miki,
                CASE 
                    WHEN SM.SupplierName = ''MGHoliday'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS MGHoliday,
                CASE 
                    WHEN SM.SupplierName = ''RateHawk'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS RateHawk,
                CASE 
                    WHEN SM.SupplierName = ''Riyaextranet'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Riyaextranet,
                CASE 
                    WHEN SM.SupplierName = ''restel'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS restel,
				
				CASE 
                    WHEN SM.SupplierName = ''Sabre'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Sabre,
                CASE 
                    WHEN SM.SupplierName = ''Smyrooms'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Smyrooms,
				CASE 
                    WHEN SM.SupplierName = ''Stuba'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Stuba,
                CASE 
                    WHEN SM.SupplierName = ''TeamAmerica'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS TeamAmerica,                
                CASE 
                    WHEN SM.SupplierName = ''Travelguru'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Travelguru,
				CASE 
                    WHEN SM.SupplierName = ''Travco'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Travco,
                CASE 
                    WHEN SM.SupplierName = ''TripAffiliate'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS TripAffiliate,
                CASE 
                    WHEN SM.SupplierName = ''Veturis'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS Veturis,
				CASE 
                    WHEN SM.SupplierName = ''Veturis INR'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS VeturisINR,
                CASE 
                    WHEN SM.SupplierName = ''yalago'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS yalago,
				CASE 
                    WHEN SM.SupplierName = ''Yalago Corporate'' 
                    THEN CAST(COALESCE(SUM(COALESCE(HB.SupplierRate * HB.ROEValue, HB.DisplayDiscountRate)), 0) AS DECIMAL(18,2)) 
                    ELSE ''0'' 
                END AS YalagoCorporate

            FROM 
                B2BHotelSupplierMaster SM      
            INNER JOIN  
                Hotel_BookMaster HB      
                ON SM.Id = HB.SupplierPkId';

    -- Depending on the @SearchBy parameter, modify the WHERE clause
    IF @SearchBy = '0'  -- bookingdatewise
    BEGIN
        SET @sql = @sql + N' WHERE convert(date, HB.inserteddate) BETWEEN @StartDate AND @EndDate AND HB.CurrentStatus in (''Vouchered'', ''Confirmed'')';
    END
    ELSE IF @SearchBy = '1'  -- checkindatewise
    BEGIN
        SET @sql = @sql + N' WHERE convert(date, HB.CheckInDate) BETWEEN @StartDate AND @EndDate AND HB.CurrentStatus in (''Vouchered'', ''Confirmed'')';
    END

    -- Add the GROUP BY clause
    SET @sql = @sql + N' GROUP BY HB.cityName, HotelBookCountryName,countryname, convert(date, HB.inserteddate), SM.SupplierName';

	-- Add the ORDER BY clause
	SET @sql = @sql + N' order by CountryName';	

    -- Execute the dynamic SQL with parameters
    EXEC sp_executesql @sql, N'@StartDate DATETIME, @EndDate DATETIME', @StartDate, @EndDate;
END
