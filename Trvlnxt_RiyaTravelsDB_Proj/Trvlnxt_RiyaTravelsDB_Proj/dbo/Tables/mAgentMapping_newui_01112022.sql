CREATE TABLE [dbo].[mAgentMapping_newui_01112022] (
    [ID]         INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentID]    INT      NULL,
    [MenuID]     INT      NULL,
    [CreatedOn]  DATETIME CONSTRAINT [DF_mAgentMapping_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]  INT      NOT NULL,
    [ModifiedOn] DATETIME CONSTRAINT [DF_mAgentMapping_ModifiedOn] DEFAULT (getdate()) NULL,
    [ModifiedBy] INT      NULL,
    [isActive]   BIT      CONSTRAINT [DF_mAgentMapping_isActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_mAgentMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

