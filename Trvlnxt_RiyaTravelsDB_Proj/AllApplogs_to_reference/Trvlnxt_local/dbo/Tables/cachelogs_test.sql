CREATE TABLE [dbo].[cachelogs_test] (
    [Id]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [LogKey]        VARCHAR (300) NULL,
    [LogData]       VARCHAR (MAX) NULL,
    [InsertedDate]  DATETIME2 (7) NULL,
    [DepartureDate] DATE          NULL,
    [APIName]       VARCHAR (50)  NULL,
    [FromSector]    VARCHAR (50)  NULL,
    [ToSector]      VARCHAR (50)  NULL,
    [IsReturn]      VARCHAR (10)  NULL,
    [UpdatedDate]   DATETIME2 (7) NULL
);

