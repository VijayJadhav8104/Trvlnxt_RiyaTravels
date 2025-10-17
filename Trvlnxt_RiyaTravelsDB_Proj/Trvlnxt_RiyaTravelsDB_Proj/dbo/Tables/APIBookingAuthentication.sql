CREATE TABLE [dbo].[APIBookingAuthentication] (
    [Id]                 INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentID]            VARCHAR (255) NULL,
    [TrackID]            VARCHAR (255) NULL,
    [FlightKey]          VARCHAR (MAX) NULL,
    [SessionToken]       VARCHAR (MAX) NULL,
    [SellKey]            VARCHAR (MAX) NULL,
    [GDSPNR]             VARCHAR (50)  NULL,
    [InsertedDate]       VARCHAR (50)  NULL,
    [Departure]          VARCHAR (50)  NULL,
    [Arrival]            VARCHAR (50)  NULL,
    [DepartureDate]      VARCHAR (100) NULL,
    [ArrivalDate]        VARCHAR (100) NULL,
    [UpdatedDate]        VARCHAR (100) NULL,
    [Environment]        VARCHAR (100) NULL,
    [ErrorMessage]       VARCHAR (MAX) NULL,
    [IsHoldBooking]      BIT           NULL,
    [IPAddress]          VARCHAR (100) NULL,
    [ServerInsertedDate] VARCHAR (255) NULL,
    [RequestType]        VARCHAR (50)  NULL,
    CONSTRAINT [PK_APIBookingAuthentication] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NONCLUSTERE_index_trackid]
    ON [dbo].[APIBookingAuthentication]([TrackID] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20250911-211805]
    ON [dbo].[APIBookingAuthentication]([TrackID] ASC, [AgentID] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Inserteddate]
    ON [dbo].[APIBookingAuthentication]([InsertedDate] ASC);

