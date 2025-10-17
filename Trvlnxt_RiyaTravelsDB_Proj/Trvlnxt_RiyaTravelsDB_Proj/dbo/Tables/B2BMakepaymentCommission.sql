CREATE TABLE [dbo].[B2BMakepaymentCommission] (
    [Id]                     INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [FkBookId]               INT             NULL,
    [ModeOfPayment]          VARCHAR (200)   NULL,
    [ConvenienFeeInPercent]  DECIMAL (18, 2) NULL,
    [TotalCommission]        DECIMAL (18, 2) NULL,
    [AmountBeforeCommission] DECIMAL (18, 2) NULL,
    [CreateDate]             DATETIME        CONSTRAINT [DF_B2BMakepaymentCommission_CreateDate] DEFAULT (getdate()) NULL,
    [AmountWithCommission]   DECIMAL (18, 2) NULL,
    [ProductType]            VARCHAR (10)    DEFAULT ('Hotel') NULL,
    [OrderId]                VARCHAR (30)    NULL,
    [GSTOnPGCharge]          DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_B2BMakepaymentCommission] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Noncluster_CompositeIndex]
    ON [dbo].[B2BMakepaymentCommission]([FkBookId] ASC, [ProductType] ASC)
    INCLUDE([Id]);

