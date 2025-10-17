CREATE TABLE [Cruise].[CacheRoomPrices] (
    [Id]          INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Search_UID]  VARCHAR (100)   NULL,
    [Room_Type]   VARCHAR (100)   NULL,
    [Price]       DECIMAL (18, 2) NULL,
    [CreatedOn]   DATETIME        NULL,
    [ValidTill]   DATETIME        NULL,
    [ItineraryId] VARCHAR (50)    NULL,
    CONSTRAINT [PK_RoomPrices] PRIMARY KEY CLUSTERED ([Id] ASC)
);

