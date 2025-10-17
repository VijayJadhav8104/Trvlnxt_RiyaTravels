CREATE TABLE [dbo].[HistorySuppAgentProfileMapper] (
    [Id]         INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SupplierId] INT      NULL,
    [AgentId]    INT      NULL,
    [ProfileId]  INT      NULL,
    [CreatedBy]  INT      NULL,
    [CreatedOn]  DATETIME NULL,
    [ModifiedBy] INT      NULL,
    [ModifiedOn] DATETIME NULL,
    CONSTRAINT [PK_HistorySuppAgentProfileMapper] PRIMARY KEY CLUSTERED ([Id] ASC)
);

