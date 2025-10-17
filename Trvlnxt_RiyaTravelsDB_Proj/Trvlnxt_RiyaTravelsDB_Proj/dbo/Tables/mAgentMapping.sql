CREATE TABLE [dbo].[mAgentMapping] (
    [ID]         INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentID]    INT      NULL,
    [MenuID]     INT      NULL,
    [CreatedOn]  DATETIME CONSTRAINT [DF_mAgentMapping_CreatedOn_1] DEFAULT (getdate()) NULL,
    [CreatedBy]  INT      NOT NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] INT      NULL,
    [isActive]   BIT      NOT NULL,
    CONSTRAINT [PK_mAgentMapping_1] PRIMARY KEY CLUSTERED ([ID] ASC)
);

