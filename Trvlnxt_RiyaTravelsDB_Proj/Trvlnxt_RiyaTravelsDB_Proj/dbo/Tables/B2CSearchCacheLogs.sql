CREATE TABLE [dbo].[B2CSearchCacheLogs] (
    [Id]                     INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [IPAddress]              VARCHAR (50)  NULL,
    [FromSector]             VARCHAR (50)  NULL,
    [ToSector]               VARCHAR (50)  NULL,
    [DeviceInfoWithLocation] VARCHAR (MAX) NULL,
    [TripType]               VARCHAR (50)  NULL,
    [DepartureDate]          DATE          NULL,
    [ReturnDate]             VARCHAR (30)  NULL,
    [NoOfPassanger]          VARCHAR (50)  NULL,
    [Airline]                VARCHAR (50)  NULL,
    [Stop]                   VARCHAR (50)  NULL,
    [UserId]                 VARCHAR (10)  NULL,
    [LogDate]                DATETIME      NULL,
    [IsVPNEnabled]           BIT           NULL,
    CONSTRAINT [PK_B2CSearchCacheLogs] PRIMARY KEY CLUSTERED ([Id] ASC)
);

