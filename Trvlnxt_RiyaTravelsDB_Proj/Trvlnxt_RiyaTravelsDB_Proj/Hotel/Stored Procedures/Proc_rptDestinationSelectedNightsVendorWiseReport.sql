
--CREATED BY Prakash Suryawanshi(04 Mar 2025)
--Modified BY Prakash Suryawanshi(10 Mar 2025)
--EXEC [Hotel].[Proc_rptDestinationSelectedNightsVendorWiseReport] '01-Mar-2025', '09-Mar-2025'
--select distinct * from B2BHotelSupplierMaster

CREATE PROCEDURE [Hotel].[Proc_rptDestinationSelectedNightsVendorWiseReport]
    @StartDate DateTime = NULL,        
    @EndDate DateTime = NULL,
    @SupplierName varchar(500) = NULL,   
    @SearchBy Varchar(50) = '0'    
AS
BEGIN
    DECLARE @sql AS NVARCHAR(MAX);
    DECLARE @columns AS NVARCHAR(MAX);

    -- Step 1: Get the distinct SupplierNames from the B2BHotelSupplierMaster
    --SELECT @columns = STRING_AGG(QUOTENAME(SupplierName), ', ')
    --FROM (SELECT DISTINCT SupplierName FROM B2BHotelSupplierMaster) AS SupplierList;  -- Added DISTINCT here

    -- Initialize the dynamic SQL query
    SET @sql = N'SELECT HB.cityName as cityName , 				
				upper(Ltrim(Rtrim(isnull(isnull(HotelBookCountryName, countryname), ''-NA-'')))) AS CountryName, 
                
				SUM(CASE 
					WHEN SM.SupplierName = ''Agoda India'' THEN 
					  CONVERT(INT, (CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights)))
					ELSE 0 
				END) AS AgodaIndia,

				SUM(CASE 
					WHEN SM.SupplierName = ''AgodaDomSell'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS AgodaDomSell,

				SUM(CASE 
					WHEN SM.SupplierName = ''AgodaINTSell'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS AgodaINTSell,

				SUM(CASE 
					WHEN SM.SupplierName = ''agoda'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS agoda,
				SUM(CASE 
					WHEN SM.SupplierName = ''agodaINT'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS agodaINT,
				SUM(CASE 
					WHEN SM.SupplierName = ''Amadeus'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Amadeus,
				SUM(CASE 
					WHEN SM.SupplierName = ''Bonotel'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Bonotel,

				SUM(CASE 
					WHEN SM.SupplierName = ''Cleartrip'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Cleartrip,

				SUM(CASE 
					WHEN SM.SupplierName = ''Dida'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Dida,
				SUM(CASE 
					WHEN SM.SupplierName = ''desiya'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS desiya,
				SUM(CASE 
					WHEN SM.SupplierName = ''DERBYSOFT'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Derbysoft,

				SUM(CASE 
					WHEN SM.SupplierName = ''DOTW'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS DOTW,

				SUM(CASE 
					WHEN SM.SupplierName = ''EETGlobal'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS EETGlobal,

				SUM(CASE 
					WHEN SM.SupplierName = ''Ean(PayAtHotel)'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Ean,

				SUM(CASE 
					WHEN SM.SupplierName = ''Expedia'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Expedia,

				SUM(CASE 
					WHEN SM.SupplierName = ''Expedia Corp'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS ExpediaCorp,

				SUM(CASE 
					WHEN SM.SupplierName = ''ExpediaPackage'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS ExpediaPackage,
				SUM(CASE 
					WHEN SM.SupplierName = ''ExpediaROWTEST'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS ExpediaROWTEST,
				SUM(CASE 
					WHEN SM.SupplierName = ''G2B2BTGX'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS G2B2BTGX,
				SUM(CASE 
					WHEN SM.SupplierName = ''HeytripGo'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS HeytripGo,

				SUM(CASE 
					WHEN SM.SupplierName = ''HOTELSPRO'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS HOTELSPRO,

				SUM(CASE 
					WHEN SM.SupplierName = ''Itrip'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Itrip,

				SUM(CASE 
					WHEN SM.SupplierName = ''LuxuryTours'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS LuxuryTours,

				SUM(CASE 
					WHEN SM.SupplierName = ''LuxuryTravels'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS LuxuryTravels,

				SUM(CASE 
					WHEN SM.SupplierName = ''miki'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS miki,

				SUM(CASE 
					WHEN SM.SupplierName = ''MGHoliday'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS MGHoliday,

				SUM(CASE 
					WHEN SM.SupplierName = ''RateHawk'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS RateHawk,

				SUM(CASE 
					WHEN SM.SupplierName = ''Riyaextranet'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Riyaextranet,
				SUM(CASE 
					WHEN SM.SupplierName = ''restel'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS restel,
				SUM(CASE 
					WHEN SM.SupplierName = ''Smyrooms'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Smyrooms,
				CASE 
                    WHEN SM.SupplierName = ''Stuba'' THEN
                     CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
                    ELSE ''0'' 
                END AS Stuba,
				SUM(CASE 
					WHEN SM.SupplierName = ''Sabre'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Sabre,

				SUM(CASE 
					WHEN SM.SupplierName = ''TeamAmerica'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS TeamAmerica,
				CASE 
                    WHEN SM.SupplierName = ''HotelBeds'' THEN
                     CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
                    ELSE ''0'' 
                END AS HotelBeds,
				CASE 
                    WHEN SM.SupplierName = ''Hotelbeds Activities'' THEN
                     CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
                    ELSE ''0'' 
                END AS HotelbedsActivities,
				CASE 
                    WHEN SM.SupplierName = ''HyperGuestNative'' THEN
                     CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
                    ELSE ''0'' 
                END AS HyperGuestNative,				
				SUM(CASE 
					WHEN SM.SupplierName = ''Travelguru'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Travelguru,
				SUM(CASE 
					WHEN SM.SupplierName = ''Travco'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Travco,
				SUM(CASE 
					WHEN SM.SupplierName = ''TripAffiliate'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS TripAffiliate,				
				SUM(CASE 
					WHEN SM.SupplierName = ''W2M'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS W2M,
				SUM(CASE 
					WHEN SM.SupplierName = ''Veturis'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS Veturis,
				SUM(CASE 
					WHEN SM.SupplierName = ''Veturis INR'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS VeturisINR,
				SUM(CASE 
					WHEN SM.SupplierName = ''yalago'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS yalago,
				SUM(CASE 
					WHEN SM.SupplierName = ''Yalago Corporate'' THEN 
					  CONVERT(INT, CONVERT(INT, HB.totalRooms) * CONVERT(INT, SelectedNights))
					ELSE 0 
				END) AS YalagoCorporate

				

                FROM Hotel_BookMaster HB WITH (NOLOCK)
                INNER JOIN B2BHotelSupplierMaster SM ON HB.SupplierPkId = SM.Id
';


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
    SET @sql = @sql + N' GROUP BY HB.cityName, HotelBookCountryName, SM.SupplierName, HB.totalRooms, SelectedNights, countryname, convert(date, HB.inserteddate)';

	-- Add the ORDER BY clause
	SET @sql = @sql + N' order by CountryName';	

    -- Execute the dynamic SQL with parameters
    EXEC sp_executesql @sql, N'@StartDate DATETIME, @EndDate DATETIME', @StartDate, @EndDate;
END
