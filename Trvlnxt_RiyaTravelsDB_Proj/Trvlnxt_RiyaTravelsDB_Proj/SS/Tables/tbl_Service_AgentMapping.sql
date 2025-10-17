CREATE TABLE [SS].[tbl_Service_AgentMapping] (
    [Id]        INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]   NVARCHAR (50) NULL,
    [ServiceId] INT           NULL,
    CONSTRAINT [PK_tbl_Service_AgentMapping] PRIMARY KEY CLUSTERED ([Id] ASC)
);

