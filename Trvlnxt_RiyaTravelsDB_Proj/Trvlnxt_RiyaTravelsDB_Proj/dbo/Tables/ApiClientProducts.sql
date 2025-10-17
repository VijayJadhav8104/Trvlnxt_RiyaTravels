CREATE TABLE [dbo].[ApiClientProducts] (
    [Id]       INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name]     VARCHAR (30) NULL,
    [IsActive] BIT          NULL,
    CONSTRAINT [PK_ApiClientProducts] PRIMARY KEY CLUSTERED ([Id] ASC)
);

