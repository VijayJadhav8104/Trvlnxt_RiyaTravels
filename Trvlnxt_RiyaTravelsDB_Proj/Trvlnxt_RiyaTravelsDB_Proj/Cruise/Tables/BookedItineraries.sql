CREATE TABLE [Cruise].[BookedItineraries] (
    [Id]                   BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkBookingId]          BIGINT        NULL,
    [RouteId]              VARCHAR (100) NULL,
    [StartingPort]         VARCHAR (50)  NULL,
    [Ports]                VARCHAR (500) NULL,
    [DestinationPort]      VARCHAR (100) NULL,
    [Iti_Title]            VARCHAR (100) NULL,
    [Image]                VARCHAR (500) NULL,
    [Nights]               INT           NULL,
    [Ship]                 VARCHAR (50)  NULL,
    [StartDate]            DATETIME      NULL,
    [EndDate]              DATETIME      NULL,
    [EmbarkationStartTime] DATETIME      NULL,
    [EmbarkationEndTime]   DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

