CREATE TABLE [Invoice].[BankReceipts] (
    [Id]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [OrderId]      VARCHAR (100)   NULL,
    [Amount]       DECIMAL (19, 2) NULL,
    [Currency]     VARCHAR (50)    NULL,
    [BankRefId]    VARCHAR (100)   NULL,
    [BankCode]     VARCHAR (100)   NULL,
    [Url]          VARCHAR (MAX)   NULL,
    [ApprovedBy]   BIGINT          NULL,
    [Status]       VARCHAR (MAX)   NULL,
    [Module]       VARCHAR (100)   NULL,
    [Remarks]      VARCHAR (MAX)   NULL,
    [ChequeNo]     VARCHAR (100)   NULL,
    [CreatedBy]    BIGINT          NULL,
    [CreatedDate]  DATETIME        CONSTRAINT [DF_BankReceipts_CreatedDate] DEFAULT (getdate()) NULL,
    [ModifiedBy]   BIGINT          NULL,
    [ModifiedDate] DATETIME        NULL,
    CONSTRAINT [PK_BankReceipts] PRIMARY KEY CLUSTERED ([Id] ASC)
);

