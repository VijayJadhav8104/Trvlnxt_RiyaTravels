CREATE TABLE [dbo].[BookingHotelContentData] (
    [SrNo]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [HotelId]           VARCHAR (50)   NULL,
    [HotelName]         VARCHAR (500)  NULL,
    [HotelAddress]      VARCHAR (1000) NULL,
    [HotelCity]         VARCHAR (50)   NULL,
    [HotelCountryName]  VARCHAR (50)   NULL,
    [BookingAmount]     VARCHAR (500)  NULL,
    [BookingNight]      INT            NULL,
    [NoOfRoom]          INT            NULL,
    [NOofAdult]         VARCHAR (50)   NULL,
    [NOofChild]         VARCHAR (50)   NULL,
    [SupplierName]      VARCHAR (100)  NULL,
    [ChainName]         VARCHAR (100)  NULL,
    [InsertedDate]      DATETIME       NULL,
    [HotelBookingCount] INT            NULL,
    CONSTRAINT [PK_BookingHotelContentData] PRIMARY KEY CLUSTERED ([SrNo] ASC)
);

