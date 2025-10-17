CREATE TABLE [Cruise].[BookedExcursions] (
    [Id]                 BIGINT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkBookingId]        BIGINT          NOT NULL,
    [shore_excursion_id] VARCHAR (100)   NULL,
    [Title]              VARCHAR (500)   NULL,
    [TransferTypeId]     BIGINT          NULL,
    [Amount]             DECIMAL (18, 2) NULL,
    [Gst]                DECIMAL (18, 2) NULL,
    [Total]              DECIMAL (18, 2) NULL,
    [Status]             VARCHAR (50)    NULL,
    CONSTRAINT [PK_BookedExcursions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_BookedExcursions_Bookings] FOREIGN KEY ([FkBookingId]) REFERENCES [Cruise].[Bookings] ([Id])
);

