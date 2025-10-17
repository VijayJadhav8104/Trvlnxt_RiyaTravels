CREATE TABLE [dbo].[TaxDescTest] (
    [Document Type]     INT           NULL,
    [Document No_]      VARCHAR (20)  NULL,
    [Document Line No_] INT           NULL,
    [Line No_]          INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [Tax Code]          VARCHAR (10)  NULL,
    [Tax Nature Code]   VARCHAR (10)  NULL,
    [Currency Code]     VARCHAR (10)  NULL,
    [Amount]            NVARCHAR (50) NULL,
    [Currency Factor]   DECIMAL (18)  NULL,
    [Exchange Rate]     DECIMAL (18)  NULL,
    [Company ID]        INT           NULL,
    CONSTRAINT [PK_TaxDescTest] PRIMARY KEY CLUSTERED ([Line No_] ASC)
);

