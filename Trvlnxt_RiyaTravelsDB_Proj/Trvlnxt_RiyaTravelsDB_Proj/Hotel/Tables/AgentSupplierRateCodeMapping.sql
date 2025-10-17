CREATE TABLE [Hotel].[AgentSupplierRateCodeMapping] (
    [Id]         INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentId]    INT NULL,
    [RateCodeId] INT NULL,
    [SupplierId] INT NULL,
    [CreatedBy]  INT NULL,
    [UpdatedBy]  INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([AgentId] ASC, [RateCodeId] ASC, [SupplierId] ASC)
);

