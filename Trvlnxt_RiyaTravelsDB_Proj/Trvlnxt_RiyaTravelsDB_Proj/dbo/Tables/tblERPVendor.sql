CREATE TABLE [dbo].[tblERPVendor] (
    [ID]           INT          IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OwnerID]      VARCHAR (50) NULL,
    [Country]      VARCHAR (2)  NULL,
    [VendorCode]   VARCHAR (50) NULL,
    [CustomerCode] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblERPVendor] PRIMARY KEY CLUSTERED ([ID] ASC)
);

