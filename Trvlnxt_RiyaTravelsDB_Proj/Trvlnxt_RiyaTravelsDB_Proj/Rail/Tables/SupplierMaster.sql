CREATE TABLE [Rail].[SupplierMaster] (
    [Id]   INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Name] VARCHAR (50) NULL,
    CONSTRAINT [PK_SupplierMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

