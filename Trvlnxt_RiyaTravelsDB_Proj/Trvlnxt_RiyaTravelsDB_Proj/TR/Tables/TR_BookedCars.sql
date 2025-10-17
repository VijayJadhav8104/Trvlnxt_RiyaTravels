CREATE TABLE [TR].[TR_BookedCars] (
    [CarId]              INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BookingId]          INT             NOT NULL,
    [Carcode]            VARCHAR (50)    NULL,
    [CarName]            VARCHAR (500)   NULL,
    [CarDesc]            TEXT            NULL,
    [BookingStatus]      VARCHAR (50)    NULL,
    [PricingPackageType] VARCHAR (50)    NULL,
    [SessionId]          VARCHAR (50)    NULL,
    [CarDetailJson]      TEXT            NULL,
    [InsertedDate]       DATETIME        DEFAULT (getdate()) NULL,
    [Distance]           NUMERIC (10, 3) NULL,
    [VehicleImage]       VARCHAR (100)   NULL,
    [Luggage]            INT             NULL,
    [TotalLuggage]       INT             NULL,
    CONSTRAINT [PK_TR_BookedCars] PRIMARY KEY CLUSTERED ([CarId] ASC)
);

