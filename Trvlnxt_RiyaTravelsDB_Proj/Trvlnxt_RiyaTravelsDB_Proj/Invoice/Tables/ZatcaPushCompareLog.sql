CREATE TABLE [Invoice].[ZatcaPushCompareLog] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [InvoiceNo]    VARCHAR (MAX) NULL,
    [Status]       VARCHAR (50)  NULL,
    [CreatedDate]  DATETIME      NULL,
    [CreatedBy]    BIGINT        NULL,
    [ModifiedDate] DATETIME      NULL,
    [ModifiedBy]   BIGINT        NULL,
    CONSTRAINT [PK_ZatcaPushCompareLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

