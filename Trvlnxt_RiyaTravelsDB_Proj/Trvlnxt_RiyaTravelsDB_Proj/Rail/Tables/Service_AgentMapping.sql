CREATE TABLE [Rail].[Service_AgentMapping] (
    [Id]        INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]   VARCHAR (50) NULL,
    [ServiceId] INT          NULL,
    CONSTRAINT [PK_Service_AgentMapping_1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

