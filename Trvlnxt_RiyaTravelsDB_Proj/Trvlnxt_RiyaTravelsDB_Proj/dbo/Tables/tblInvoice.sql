CREATE TABLE [dbo].[tblInvoice] (
    [PKID]             BIGINT       IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [OrderID]          VARCHAR (50) NULL,
    [PaymentInvoiceNo] VARCHAR (50) NULL,
    [TaxInvoiceNo]     VARCHAR (50) NULL,
    [InsertedDate]     DATETIME     CONSTRAINT [DF_tblInvoice_InsertedDate] DEFAULT (getdate()) NULL,
    [PInvoice]         BIGINT       NULL,
    [TInvoice]         BIGINT       NULL,
    CONSTRAINT [PK_tblInvoice] PRIMARY KEY CLUSTERED ([PKID] ASC)
);

