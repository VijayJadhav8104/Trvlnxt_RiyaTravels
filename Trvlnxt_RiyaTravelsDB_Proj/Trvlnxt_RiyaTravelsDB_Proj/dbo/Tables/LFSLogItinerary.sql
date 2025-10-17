CREATE TABLE [dbo].[LFSLogItinerary] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Airline]       NVARCHAR (100) NULL,
    [FlightNo]      NVARCHAR (100) NULL,
    [FromSector]    NVARCHAR (100) NULL,
    [ToSector]      NVARCHAR (100) NULL,
    [TravelDate]    DATETIME       NULL,
    [RBDClass]      NVARCHAR (100) NULL,
    [LFS_RBD]       NVARCHAR (100) NULL,
    [SegementTatto] NVARCHAR (100) NULL,
    [Baggage]       NVARCHAR (100) NULL,
    [LFSBaggage]    NVARCHAR (100) NULL,
    [fk_LFSLog]     BIGINT         NOT NULL,
    CONSTRAINT [PK_LFSLogItinerary] PRIMARY KEY CLUSTERED ([Id] ASC),
    FOREIGN KEY ([fk_LFSLog]) REFERENCES [dbo].[LFS_Log] ([Id]),
    FOREIGN KEY ([fk_LFSLog]) REFERENCES [dbo].[LFS_Log] ([Id]),
    CONSTRAINT [FK_LFSLogItinerary_LFSLogItinerary] FOREIGN KEY ([Id]) REFERENCES [dbo].[LFSLogItinerary] ([Id])
);

