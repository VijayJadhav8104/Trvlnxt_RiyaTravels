CREATE TABLE [dbo].[tblVendor] (
    [Id]         INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [VendorName] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblVendor] PRIMARY KEY CLUSTERED ([Id] ASC)
);

