CREATE PROC [Hotel].[DestinationRPTMailer_v]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Country,
        City,
        SupplierName,
        Booking_Count,
        Amount_in_INR,
        Total_Room_Nights,

        -- Country-level totals
        SUM(Booking_Count) OVER (PARTITION BY Country) AS Total_Booking_Count_By_Country,
        SUM(Amount_in_INR) OVER (PARTITION BY Country) AS Total_Amount_in_INR_By_Country,
        SUM(Total_Room_Nights) OVER (PARTITION BY Country) AS Total_Room_Nights_By_Country,
        SortOrder
    FROM (
        -- Main grouped data
        SELECT 
            UPPER(ISNULL(NULLIF(HotelBookCountryName, ''), NULLIF(CountryName, ''))) AS RawCountry,
            UPPER(ISNULL(NULLIF(CityName, ''), 'NA')) AS City,
            UPPER(ISNULL(NULLIF(SupplierName, ''), 'NA')) AS SupplierName,
            COUNT(pkId) AS Booking_Count,
            SUM(TRY_CAST(DisplayDiscountRate AS DECIMAL(18, 2))) AS Amount_in_INR,
            SUM(TRY_CAST(SelectedNights AS INT)) AS Total_Room_Nights,
            0 AS SortOrder
        FROM Hotel_BookMaster WITH (NOLOCK)
        WHERE 
            CurrentStatus IN ('Confirmed', 'Vouchered')
            AND CAST(InsertedDate AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)
            AND (
                UPPER(ISNULL(HotelBookCountryName, '')) IN ('UAE','UNITED ARAB EMIRATES','THAILAND','SAUDI ARABIA')
                OR UPPER(ISNULL(CountryName, '')) IN ('UAE','UNITED ARAB EMIRATES','THAILAND','SAUDI ARABIA')
                OR (HotelBookCountryName IS NULL AND CountryName IS NULL) -- allow null countries for later 'NA' bucket
            )
        GROUP BY 
            ISNULL(NULLIF(HotelBookCountryName, ''), NULLIF(CountryName, '')),
            CityName,
            SupplierName

        UNION ALL

        -- Total row
        SELECT 
            'Total' AS Country,
            '' AS City,
            '' AS SupplierName,
            COUNT(pkId),
            SUM(TRY_CAST(DisplayDiscountRate AS DECIMAL(18, 2))),
            SUM(TRY_CAST(SelectedNights AS INT)),
            1 AS SortOrder
        FROM Hotel_BookMaster WITH (NOLOCK)
        WHERE 
            CurrentStatus IN ('Confirmed', 'Vouchered')
            AND CAST(InsertedDate AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)
            AND (
                UPPER(ISNULL(HotelBookCountryName, '')) IN ('UAE','UNITED ARAB EMIRATES','THAILAND','SAUDI ARABIA')
                OR UPPER(ISNULL(CountryName, '')) IN ('UAE','UNITED ARAB EMIRATES','THAILAND','SAUDI ARABIA')
                OR (HotelBookCountryName IS NULL AND CountryName IS NULL)
            )
    ) AS FinalResult
    OUTER APPLY (
        SELECT UPPER(ISNULL(RawCountry, 'NA')) AS Country
    ) AS Mapped
    ORDER BY SortOrder, Country, City, SupplierName;
END
