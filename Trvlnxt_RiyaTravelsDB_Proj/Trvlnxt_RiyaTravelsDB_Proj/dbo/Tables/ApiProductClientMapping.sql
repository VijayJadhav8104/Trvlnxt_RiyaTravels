CREATE TABLE [dbo].[ApiProductClientMapping] (
    [Id]        INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ProductId] INT NULL,
    [ClientId]  INT NULL,
    CONSTRAINT [PK_tbl_ApiClientMapping] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ApiProductClientMapping_ApiClients] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[ApiClients] ([Id])
);

