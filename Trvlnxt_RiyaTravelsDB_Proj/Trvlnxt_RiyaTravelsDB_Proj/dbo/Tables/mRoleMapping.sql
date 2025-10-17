CREATE TABLE [dbo].[mRoleMapping] (
    [ID]         INT      IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RoleID]     INT      NULL,
    [ActionID]   INT      NULL,
    [MenuID]     INT      NULL,
    [CreatedOn]  DATETIME CONSTRAINT [DF_mRoleMapping_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]  INT      NOT NULL,
    [ModifiedOn] DATETIME NULL,
    [ModifiedBy] INT      NULL,
    [isActive]   BIT      NOT NULL,
    CONSTRAINT [PK_mRoleMapping] PRIMARY KEY CLUSTERED ([ID] ASC)
);

