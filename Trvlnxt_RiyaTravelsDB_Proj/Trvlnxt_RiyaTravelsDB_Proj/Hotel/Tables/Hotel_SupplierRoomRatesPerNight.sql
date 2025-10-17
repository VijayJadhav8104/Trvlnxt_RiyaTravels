CREATE TABLE [Hotel].[Hotel_SupplierRoomRatesPerNight] (
    [Id]          INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Amount]      DECIMAL (18, 2) NULL,
    [taxIncluded] BIT             NULL,
    [Date]        DATETIME        NULL,
    [discount]    DECIMAL (18, 2) NULL,
    [insertDate]  DATETIME        NULL,
    [FkBookingId] INT             NULL,
    [Room_No]     INT             NULL,
    [Roomfkid]    INT             NULL,
    [RoomId]      VARCHAR (200)   NULL,
    CONSTRAINT [PK_Hotel_SupplierRoomRatesPerNight] PRIMARY KEY CLUSTERED ([Id] ASC)
);

