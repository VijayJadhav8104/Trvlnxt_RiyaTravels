Create procedure Proc_SupplierDailyBookingCountAndAmount
AS
Begin
SELECT
    B2BS.SupplierName,
    COUNT(h.pkId) AS BookingCount,
    SUM(DisplayDiscountRate * FinalROE) AS TotalAmount
FROM
    B2BHotelSupplierMaster B2BS
    LEFT JOIN Hotel_BookMaster h WITH (NOLOCK)
        ON B2BS.SupplierName = h.SupplierName
    LEFT JOIN Hotel_Status_History sh WITH (NOLOCK)
        ON h.pkId = sh.FKHotelBookingId
        AND sh.FkStatusId = 4
        AND sh.IsActive = 1
WHERE
    inserteddate BETWEEN CONVERT(DATE, GETDATE()) AND GETDATE()
    AND (h.BookingPortal IN ('TNH', 'TNHAPI') OR h.BookingPortal IS NULL)
GROUP BY
    B2BS.SupplierName

-- Union with suppliers that might not have any bookings
UNION ALL

SELECT
    B2BHS.SupplierName,
    0 AS BookingCount,
    0 AS TotalAmount
FROM
    B2BHotelSupplierMaster B2BHS WITH (NOLOCK)
WHERE
	B2BHS.IsActive=1 AND
    NOT EXISTS (
        SELECT 1
        FROM Hotel_BookMaster h
        WHERE B2BHS.SupplierName = h.SupplierName
        AND EXISTS (
            SELECT 1
            FROM Hotel_Status_History sh
            WHERE h.pkId = sh.FKHotelBookingId
            AND sh.FkStatusId = 4
            AND sh.IsActive = 1
        )
        AND inserteddate BETWEEN CONVERT(DATE, GETDATE()) AND GETDATE()
        AND h.BookingPortal IN ('TNH', 'TNHAPI')
    )
END