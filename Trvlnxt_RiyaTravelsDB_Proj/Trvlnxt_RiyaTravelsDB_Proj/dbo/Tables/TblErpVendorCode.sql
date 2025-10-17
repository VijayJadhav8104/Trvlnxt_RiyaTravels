CREATE TABLE [dbo].[TblErpVendorCode] (
    [Id]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OfficeID]   VARCHAR (50) NULL,
    [VendorCode] VARCHAR (50) NULL,
    CONSTRAINT [PK_TblErpVendorCode] PRIMARY KEY CLUSTERED ([Id] ASC)
);

