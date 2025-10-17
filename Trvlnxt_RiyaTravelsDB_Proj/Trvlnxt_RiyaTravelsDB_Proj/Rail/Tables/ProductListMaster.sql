CREATE TABLE [Rail].[ProductListMaster] (
    [Id]                  INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Fk_SupplierMasterId] VARCHAR (50) NULL,
    [Name]                VARCHAR (50) NULL,
    [ProductType]         VARCHAR (50) NULL,
    CONSTRAINT [PK_ProductListMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

