CREATE TABLE [Cruise].[CabinMappCrusDiscount] (
    [Id]         INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FK_CrusId]  INT NULL,
    [FK_CabinId] INT NULL,
    CONSTRAINT [PK_CabinMappCrusDiscount] PRIMARY KEY CLUSTERED ([Id] ASC)
);

