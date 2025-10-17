CREATE TABLE [Hotel].[soldOutHotelList] (
    [Id]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [HotelId]      VARCHAR (150) NULL,
    [CheckInDate]  DATE          NULL,
    [CheckOutDate] DATE          NULL,
    [Amount]       MONEY         NULL,
    [RoomCategory] VARCHAR (100) NULL,
    [InsertedDate] DATETIME      NULL,
    CONSTRAINT [PK_soldOutHotelList] PRIMARY KEY CLUSTERED ([Id] ASC)
);

