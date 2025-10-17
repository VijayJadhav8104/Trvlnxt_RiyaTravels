CREATE TABLE [dbo].[mMenu_newui_bckup01112022] (
    [ID]           INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MenuName]     VARCHAR (50)  NULL,
    [Path]         VARCHAR (200) NULL,
    [ItemOrder]    INT           NULL,
    [ParentMenuID] INT           NULL,
    [isActive]     BIT           DEFAULT ((1)) NOT NULL,
    [Module]       VARCHAR (50)  NULL,
    [IsParent]     BIT           DEFAULT ((0)) NOT NULL,
    [MenuClass]    VARCHAR (50)  NULL,
    [NewPath]      VARCHAR (200) NULL,
    [Products]     VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

