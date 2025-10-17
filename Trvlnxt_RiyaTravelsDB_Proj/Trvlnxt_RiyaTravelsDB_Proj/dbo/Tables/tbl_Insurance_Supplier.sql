CREATE TABLE [dbo].[tbl_Insurance_Supplier] (
    [PKID]         BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [SupplierName] VARCHAR (500) NOT NULL,
    [InsertedDate] DATETIME      CONSTRAINT [DF_tbl_Insurance_Supplier_InsertedDate] DEFAULT (getdate()) NOT NULL,
    [Status]       BIT           CONSTRAINT [DF_tbl_Insurance_Supplier_Status] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tbl_Insurance_Supplier] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

