CREATE TABLE [dbo].[mMenu] (
    [ID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MenuName]     VARCHAR (50)  NULL,
    [Path]         VARCHAR (200) NULL,
    [ItemOrder]    INT           NULL,
    [ParentMenuID] INT           NULL,
    [isActive]     BIT           NOT NULL,
    [Module]       VARCHAR (50)  NULL,
    [IsParent]     BIT           NOT NULL,
    [MenuClass]    VARCHAR (50)  NULL,
    [NewPath]      VARCHAR (200) NULL,
    [Products]     VARCHAR (50)  NULL,
    [MenuUrl]      VARCHAR (200) NULL,
    [MenuIcon]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_mMenu] PRIMARY KEY CLUSTERED ([ID] ASC)
);

