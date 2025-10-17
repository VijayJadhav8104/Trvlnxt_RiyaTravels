CREATE TABLE [dbo].[Hotel_Menu] (
    [MenuID]       INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MenuName]     VARCHAR (100)  NOT NULL,
    [Path]         NVARCHAR (500) NULL,
    [Status]       BIT            NULL,
    [OrderID]      INT            NULL,
    [ParentMenuID] INT            NULL,
    CONSTRAINT [PK_Hotel_Menu] PRIMARY KEY CLUSTERED ([MenuID] ASC)
);

