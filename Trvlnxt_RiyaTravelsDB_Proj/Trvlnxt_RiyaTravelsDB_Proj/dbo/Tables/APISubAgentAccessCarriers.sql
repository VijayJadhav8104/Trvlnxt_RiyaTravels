CREATE TABLE [dbo].[APISubAgentAccessCarriers] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [APIKey]        VARCHAR (500) NULL,
    [AgentID]       VARCHAR (50)  NULL,
    [InsertedDate]  VARCHAR (50)  NULL,
    [AccessCarrier] VARCHAR (50)  NULL,
    [Status]        BIT           NULL,
    [AllBlock]      BIT           NULL,
    CONSTRAINT [PK_APISubAgentAccessCarriers] PRIMARY KEY CLUSTERED ([Id] ASC)
);

