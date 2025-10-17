CREATE TABLE [dbo].[tblBlockTransaction] (
    [Id]       INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]  BIGINT   NULL,
    [TillDate] DATETIME NULL,
    CONSTRAINT [PK_tblBlockTransaction] PRIMARY KEY CLUSTERED ([Id] ASC)
);

