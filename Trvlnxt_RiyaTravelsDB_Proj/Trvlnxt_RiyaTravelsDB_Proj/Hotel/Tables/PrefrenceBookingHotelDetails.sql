CREATE TABLE [Hotel].[PrefrenceBookingHotelDetails] (
    [Id]                 INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Active]             BIT           NULL,
    [InsertedDate]       DATETIME      NULL,
    [BookingId]          VARCHAR (300) NULL,
    [ExpiryDate]         VARCHAR (50)  NULL,
    [Refundable]         BIT           NULL,
    [Refundability]      VARCHAR (200) NULL,
    [Meal]               VARCHAR (250) NULL,
    [TotalRate]          DECIMAL (18)  NULL,
    [SupplierName]       VARCHAR (350) NULL,
    [SupplierId]         VARCHAR (350) NULL,
    [Remark]             VARCHAR (MAX) NULL,
    [CancellationPolicy] VARCHAR (MAX) NULL,
    [NoOfRooms]          INT           NULL,
    CONSTRAINT [PK_PrefrenceBookingHotelDetails] PRIMARY KEY CLUSTERED ([Id] ASC)
);

