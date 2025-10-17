CREATE TABLE [dbo].[BlockedAirlines] (
    [Id]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]       VARCHAR (50) NULL,
    [WebService] VARCHAR (50) NULL,
    [Status]     BIT          NULL,
    CONSTRAINT [PK_BlockedAirlines] PRIMARY KEY CLUSTERED ([Id] ASC)
);

