CREATE TABLE [dbo].[Hotel_userPermission] (
    [Id]       INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserId]   NVARCHAR (50) NULL,
    [MenuId]   INT           NULL,
    [updateon] DATE          NULL,
    CONSTRAINT [PK_Hotel_userPermission] PRIMARY KEY CLUSTERED ([Id] ASC)
);

