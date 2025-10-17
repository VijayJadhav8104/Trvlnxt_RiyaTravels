CREATE TABLE [SS].[SS_ActivitySearchAvailablityData] (
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
    [InsertedDate]       DATETIME      NULL,
    [CheckIn]            DATETIME      NULL,
    [CheckOut]           DATETIME      NULL,
    [SearchType]         VARCHAR (50)  NULL,
    [Residence]          VARCHAR (50)  NULL
);

