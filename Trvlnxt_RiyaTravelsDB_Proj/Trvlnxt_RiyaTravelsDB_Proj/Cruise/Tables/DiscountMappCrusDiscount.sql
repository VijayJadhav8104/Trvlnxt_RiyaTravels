CREATE TABLE [Cruise].[DiscountMappCrusDiscount] (
    [Id]          INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FK_CrusId]   INT NULL,
    [FK_Discount] INT NULL,
    CONSTRAINT [PK_DiscountMappCrusDiscount] PRIMARY KEY CLUSTERED ([Id] ASC)
);

