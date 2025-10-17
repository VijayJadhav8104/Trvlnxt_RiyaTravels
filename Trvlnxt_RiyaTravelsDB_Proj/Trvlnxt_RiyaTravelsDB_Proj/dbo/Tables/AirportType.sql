CREATE TABLE [dbo].[AirportType] (
    [AirportId]   INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirportName] NVARCHAR (50) NULL,
    CONSTRAINT [PK_AirportType] PRIMARY KEY CLUSTERED ([AirportId] ASC)
);

