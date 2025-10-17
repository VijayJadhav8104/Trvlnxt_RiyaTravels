CREATE TABLE [dbo].[mRole] (
    [ID]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [RoleName]   VARCHAR (50) NULL,
    [CreatedOn]  DATETIME     CONSTRAINT [DF_mRole_CreatedOn_Value] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]  INT          NOT NULL,
    [ModifiedOn] DATETIME     CONSTRAINT [DF_mRole_ModifiedOn_Value] DEFAULT (getdate()) NULL,
    [ModifiedBy] INT          NULL,
    [isActive]   BIT          DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

