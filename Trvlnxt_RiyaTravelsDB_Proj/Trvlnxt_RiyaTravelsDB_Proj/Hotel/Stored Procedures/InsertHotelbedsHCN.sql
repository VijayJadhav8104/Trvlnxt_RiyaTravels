	
---	select * from hotel.HotelAutoHCN


	CREATE PROCEDURE [Hotel].[InsertHotelbedsHCN]
    @RecievedDate NVARCHAR(200) = NULL,
    @BookingReference NVARCHAR(400) = NULL,
    @ProviderRefNumber NVARCHAR(500) = NULL,
    @HotelConfirmationNumber NVARCHAR(800) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 1: Deactivate existing records with the same BookingReference
        IF EXISTS (SELECT 1 FROM hotel.HotelAutoHCN WHERE BookingReference = @BookingReference AND isactive = 1)
        BEGIN
            UPDATE hotel.HotelAutoHCN
            SET isactive = 0
            WHERE BookingReference = @BookingReference AND isactive = 1;
        END

        -- Step 2: Insert new record
        INSERT INTO hotel.HotelAutoHCN (
            CreatedDate,
            BookingReference,
            HotelConfirmationNumber,
            isactive,
            ProviderRefNumber
        )
        VALUES (
            GETDATE(),
            @BookingReference,
            @HotelConfirmationNumber,
            1,
            @ProviderRefNumber
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Optionally log error here or return error code/message
       -- THROW;
    END CATCH
END


--select * from  testHCN

--Create table testHCN
--( 
--  Pkid int identity,
--  CreatedDate Datetime,
--  BookingReference nvarchar(400),
--  ProviderRefNumber  nvarchar(500),
-- HotelConfirmationNumber nvarchar(800)

--)

--alter table testHCN
--add isactive bit