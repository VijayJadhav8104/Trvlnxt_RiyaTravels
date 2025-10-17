CREATE TABLE [dbo].[TagsMaster] (
    [Id]         INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [TagName]    NVARCHAR (50) NULL,
    [InsertDate] NVARCHAR (50) NULL,
    CONSTRAINT [PK_TagsName] PRIMARY KEY CLUSTERED ([Id] ASC)
);

