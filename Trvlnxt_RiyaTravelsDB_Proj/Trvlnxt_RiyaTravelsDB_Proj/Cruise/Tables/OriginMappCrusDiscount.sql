CREATE TABLE [Cruise].[OriginMappCrusDiscount] (
    [Id]          INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FK_CrusId]   INT NULL,
    [FK_OriginId] INT NULL,
    CONSTRAINT [PK_OriginMappCrusDiscount] PRIMARY KEY CLUSTERED ([Id] ASC)
);

