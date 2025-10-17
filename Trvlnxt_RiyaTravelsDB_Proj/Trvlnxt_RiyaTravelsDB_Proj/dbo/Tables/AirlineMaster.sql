CREATE TABLE [dbo].[AirlineMaster] (
    [Id]          INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AirlineName] NVARCHAR (MAX) NULL,
    [Airlinecode] NVARCHAR (MAX) NULL,
    [Ticketcode]  NVARCHAR (MAX) NULL,
    [Status]      CHAR (1)       CONSTRAINT [DF_AirlineMaster_Status] DEFAULT ('A') NULL,
    CONSTRAINT [PK_AirlineMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

