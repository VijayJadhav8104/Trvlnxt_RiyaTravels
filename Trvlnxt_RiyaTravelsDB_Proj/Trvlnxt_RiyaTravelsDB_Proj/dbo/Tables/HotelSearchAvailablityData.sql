CREATE TABLE [dbo].[HotelSearchAvailablityData] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [AgentId]            INT           NULL,
    [CityId]             VARCHAR (100) NULL,
    [CityName]           VARCHAR (500) NULL,
    [TravelFrom]         VARCHAR (500) NULL,
    [Nationality]        VARCHAR (100) NULL,
    [State]              VARCHAR (100) NULL,
    [BookingCountryCode] VARCHAR (100) NULL,
    [Lat]                VARCHAR (500) NULL,
    [Long]               VARCHAR (500) NULL,
    [AdultCount]         INT           NULL,
    [ChildCount]         INT           NULL,
    [InsertedDate]       DATETIME      NULL,
    [CheckIn]            DATETIME      NULL,
    [CheckOut]           DATETIME      NULL,
    [RoomCount]          INT           NULL,
    [SearchType]         VARCHAR (50)  NULL,
    [Residence]          VARCHAR (50)  NULL,
    [OccupancyAsJson]    VARCHAR (MAX) NULL,
    [ReferenceID]        INT           CONSTRAINT [DF_HotelSearchAvailablityData_ReferenceID] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_HotelSearchAvailablityData] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Searchtype]
    ON [dbo].[HotelSearchAvailablityData]([SearchType] ASC)
    INCLUDE([CityId], [Id]);


GO
CREATE NONCLUSTERED INDEX [IX_HotelSearchAvailablityData_SearchType_CityId]
    ON [dbo].[HotelSearchAvailablityData]([SearchType] ASC, [CityId] ASC)
    INCLUDE([AgentId], [CityName], [TravelFrom], [Nationality], [State], [BookingCountryCode], [Lat], [Long], [AdultCount], [ChildCount], [InsertedDate], [CheckIn], [CheckOut], [RoomCount], [Residence], [OccupancyAsJson], [ReferenceID]);

