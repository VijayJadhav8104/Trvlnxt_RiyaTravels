CREATE TABLE [dbo].[CacheLogs_MultiAvailability] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LogKey]        VARCHAR (200) NULL,
    [LogData]       VARCHAR (MAX) NULL,
    [InsertedDate]  DATETIME2 (7) CONSTRAINT [DF_CacheLogs_MultiAvailability_InsertedDate] DEFAULT (getdate()) NULL,
    [DepartureDate] DATE          NULL,
    [APIName]       VARCHAR (50)  NULL,
    [FromSector]    VARCHAR (50)  NULL,
    [ToSector]      VARCHAR (50)  NULL,
    [IsReturn]      VARCHAR (10)  NULL,
    [SelectedFrom]  VARCHAR (5)   NULL,
    CONSTRAINT [PK_CacheLogs_MultiAvailability] PRIMARY KEY CLUSTERED ([Id] ASC)
);

