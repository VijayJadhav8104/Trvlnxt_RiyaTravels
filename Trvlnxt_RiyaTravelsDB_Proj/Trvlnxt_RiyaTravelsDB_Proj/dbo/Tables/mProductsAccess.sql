CREATE TABLE [dbo].[mProductsAccess] (
    [Pkid]           INT IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [MenuId]         INT NOT NULL,
    [AccessToUser]   BIT NULL,
    [AccessToAgency] BIT NULL,
    PRIMARY KEY CLUSTERED ([Pkid] ASC),
    UNIQUE NONCLUSTERED ([MenuId] ASC)
);

