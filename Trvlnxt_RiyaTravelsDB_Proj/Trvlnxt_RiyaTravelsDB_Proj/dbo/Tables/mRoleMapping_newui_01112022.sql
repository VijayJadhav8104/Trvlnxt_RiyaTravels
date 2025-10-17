CREATE TABLE [dbo].[mRoleMapping_newui_01112022] (
    [ID]         INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RoleID]     INT      NULL,
    [ActionID]   INT      NULL,
    [MenuID]     INT      NULL,
    [CreatedOn]  DATETIME CONSTRAINT [DF_CreatedOn_Value] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]  INT      NOT NULL,
    [ModifiedOn] DATETIME CONSTRAINT [DF_ModifiedOn_Value] DEFAULT (getdate()) NULL,
    [ModifiedBy] INT      NULL,
    [isActive]   BIT      CONSTRAINT [DF__mRoleMapp__isAct__21187D8D] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK__mRoleMap__DE152E89BE2A804D] PRIMARY KEY CLUSTERED ([ID] ASC)
);

