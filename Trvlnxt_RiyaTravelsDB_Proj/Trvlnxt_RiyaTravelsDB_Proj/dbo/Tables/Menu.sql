CREATE TABLE [dbo].[Menu] (
    [MenuID]       INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MenuName]     VARCHAR (100)  NULL,
    [Path]         NVARCHAR (500) NULL,
    [Status]       BIT            CONSTRAINT [DF_Menu_Status] DEFAULT ((1)) NULL,
    [OrderID]      INT            NULL,
    [ParentMenuID] INT            NULL,
    CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED ([MenuID] ASC)
);

