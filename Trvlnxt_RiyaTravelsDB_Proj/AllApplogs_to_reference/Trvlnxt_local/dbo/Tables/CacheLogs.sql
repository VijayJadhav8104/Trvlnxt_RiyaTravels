CREATE TABLE [dbo].[CacheLogs] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LogKey]        VARCHAR (300) NULL,
    [LogData]       VARCHAR (MAX) NULL,
    [InsertedDate]  DATETIME2 (7) CONSTRAINT [DF_CacheLogs_InsertedDate] DEFAULT (getdate()) NULL,
    [DepartureDate] DATE          NULL,
    [APIName]       VARCHAR (200) NULL,
    [FromSector]    VARCHAR (50)  NULL,
    [ToSector]      VARCHAR (50)  NULL,
    [IsReturn]      VARCHAR (10)  NULL,
    [UpdatedDate]   DATETIME2 (7) NULL,
    CONSTRAINT [PK_CacheLogs] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ__CacheLog__D2A1D93177ED4DFC] UNIQUE NONCLUSTERED ([LogKey] ASC)
);

