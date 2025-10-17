
--CREATED BY Prakash Suryawanshi(02 Apr 2025)
--Modified BY Prakash Suryawanshi(02 Apr 2025)
--EXEC [Hotel].[Proc_rptChainWiseCountReport] '01-Apr-2025', '02-Apr-2025'
--select distinct * from B2BHotelSupplierMaster

CREATE PROCEDURE [Hotel].[Proc_rptChainWiseCountReport]
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
  SET @sql = N'SELECT 
				HB.cityName as cityName, 
                upper(Ltrim(Rtrim(isnull(isnull(HotelBookCountryName, countryname), ''-NA-'')))) AS CountryName, 
				HB.ChainName,
				HB.HotelName,
				sum(case when SM.SupplierName=''Agoda'' then 1 else 0 end) as Agoda,  
				sum(case when SM.SupplierName=''Agoda India'' then 1 else 0 end) as AgodaIndia,  
                sum(case when SM.SupplierName=''AgodaDomSell'' then 1 else 0 end) as AgodaDomSell,  
                sum(case when SM.SupplierName=''AgodaINT'' then 1 else 0 end) as agodaINT,  
				sum(case when SM.SupplierName=''AgodaINTSell'' then 1 else 0 end) as AgodaINTSell,  
                sum(case when SM.SupplierName=''Amadeus'' then 1 else 0 end) as Amadeus,  
                sum(case when SM.SupplierName=''Bonotel'' then 1 else 0 end) as Bonotel,  
                sum(case when SM.SupplierName=''Cleartrip'' then 1 else 0 end) as Cleartrip,  
				sum(case when SM.SupplierName=''Derbysoft'' then 1 else 0 end) as Derbysoft,      
                sum(case when SM.SupplierName=''desiya'' then 1 else 0 end) as desiya,  
                sum(case when SM.SupplierName=''Dida'' then 1 else 0 end) as Dida,  
                sum(case when SM.SupplierName=''DOTW'' then 1 else 0 end) as DOTW,  
                sum(case when SM.SupplierName=''Ean(PayAtHotel)'' then 1 else 0 end) as Ean,  
                sum(case when SM.SupplierName=''EETGlobal'' then 1 else 0 end) as EETGlobal,  
                sum(case when SM.SupplierName=''Expedia'' then 1 else 0 end) as Expedia,  
                sum(case when SM.SupplierName=''Expedia Corp'' then 1 else 0 end) as ExpediaCorp,  
                sum(case when SM.SupplierName=''ExpediaPackage'' then 1 else 0 end) as ExpediaPackage,  
                sum(case when SM.SupplierName=''ExpediaROW TEST'' then 1 else 0 end) as ExpediaROWTEST,  
                sum(case when SM.SupplierName=''G2B2BTGX'' then 1 else 0 end) as G2B2BTGX,  
                sum(case when SM.SupplierName=''HeytripGo'' then 1 else 0 end) as HeytripGo,  
                sum(case when SM.SupplierName=''Hotelbeds'' then 1 else 0 end) as hotelbeds,  
				sum(case when SM.SupplierName=''Hotelbeds Activities'' then 1 else 0 end) as HotelbedsActivities,  
                sum(case when SM.SupplierName=''HOTELSPRO'' then 1 else 0 end) as HOTELSPRO,  
                sum(case when SM.SupplierName=''HyperGuestNative'' then 1 else 0 end) as HyperGuestNative,  
                sum(case when SM.SupplierName=''Itrip'' then 1 else 0 end) as Itrip,  
                sum(case when SM.SupplierName=''Luxury Tours'' then 1 else 0 end) as LuxuryTours,  
                sum(case when SM.SupplierName=''LuxuryTravels'' then 1 else 0 end) as LuxuryTravels,  
                sum(case when SM.SupplierName=''miki'' then 1 else 0 end) as miki,  
                sum(case when SM.SupplierName=''MGHoliday'' then 1 else 0 end) as MGHoliday,  
                sum(case when SM.SupplierName=''RateHawk'' then 1 else 0 end) as RateHawk,  
                sum(case when SM.SupplierName=''Riyaextranet'' then 1 else 0 end) as Riyaextranet,  
                sum(case when SM.SupplierName=''restel'' then 1 else 0 end) as restel,  
                sum(case when SM.SupplierName=''Sabre'' then 1 else 0 end) as Sabre,  
                sum(case when SM.SupplierName=''Smyrooms'' then 1 else 0 end) as Smyrooms,  
				sum(case when SM.SupplierName=''Stuba'' then 1 else 0 end) as Stuba,  
                sum(case when SM.SupplierName=''TeamAmerica'' then 1 else 0 end) as TeamAmerica,                 
                sum(case when SM.SupplierName=''Travelguru'' then 1 else 0 end) as Travelguru,  
				sum(case when SM.SupplierName=''Travco'' then 1 else 0 end) as Travco,  
                sum(case when SM.SupplierName=''TripAffiliate'' then 1 else 0 end) as TripAffiliate, 
				sum(case when SM.SupplierName=''W2M'' then 1 else 0 end) as W2M,
                sum(case when SM.SupplierName=''Veturis'' then 1 else 0 end) as Veturis,  
				sum(case when SM.SupplierName=''Veturis INR'' then 1 else 0 end) as VeturisINR,  
                sum(case when SM.SupplierName=''yalago'' then 1 else 0 end) as yalago,  
				sum(case when SM.SupplierName=''Yalago Corporate'' then 1 else 0 end) as YalagoCorporate  
                
            FROM Hotel_BookMaster HB WITH (NOLOCK)
            INNER JOIN B2BHotelSupplierMaster SM ON HB.SupplierPkId = SM.Id';

-- Depending on the @SearchBy parameter, modify the WHERE clause
IF @SearchBy = '0'  -- bookingdatewise
BEGIN
    SET @sql = @sql + N' WHERE convert(date, HB.inserteddate) BETWEEN @StartDate AND @EndDate AND HB.CurrentStatus in (''Vouchered'', ''Confirmed'')';
END
ELSE IF @SearchBy = '1'  -- checkindatewise
BEGIN
    -- If there was already a WHERE clause, use AND instead of WHERE
    IF CHARINDEX('WHERE', @sql) > 0
    BEGIN
        SET @sql = @sql + N' AND convert(date, HB.CheckInDate) BETWEEN @StartDate AND @EndDate AND HB.CurrentStatus in (''Vouchered'', ''Confirmed'')';
    END
    ELSE
    BEGIN
        SET @sql = @sql + N' WHERE convert(date, HB.CheckInDate) BETWEEN @StartDate AND @EndDate AND HB.CurrentStatus in (''Vouchered'', ''Confirmed'')';
    END
END


    -- Add the GROUP BY clause
    SET @sql = @sql + N' GROUP BY HB.cityName, HB.ChainName, HB.HotelName, HotelBookCountryName,countryname, convert(date, HB.inserteddate)';

	-- Add the ORDER BY clause
	SET @sql = @sql + N' order by CountryName, cityName desc';	

    -- Execute the dynamic SQL with parameters
    EXEC sp_executesql @sql, N'@StartDate DATETIME, @EndDate DATETIME', @StartDate, @EndDate;
END
