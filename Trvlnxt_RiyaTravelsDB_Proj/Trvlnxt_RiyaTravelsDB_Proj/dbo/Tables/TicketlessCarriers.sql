CREATE TABLE [dbo].[TicketlessCarriers] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [AirlineCode] VARCHAR (20)  NULL,
    [AirlineName] VARCHAR (255) NULL,
    CONSTRAINT [PK_TicketlessCarriers] PRIMARY KEY CLUSTERED ([Id] ASC)
);

