CREATE TABLE [Insurance].[Insurance_Service_AgentMapping] (
    [Id]        INT           IDENTITY (1, 1) NOT NULL,
    [AgentId]   NVARCHAR (50) NULL,
    [ServiceId] INT           NULL,
    CONSTRAINT [PK_Cruise_Service_AgentMapping] PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([AgentId] ASC, [ServiceId] ASC)
);

