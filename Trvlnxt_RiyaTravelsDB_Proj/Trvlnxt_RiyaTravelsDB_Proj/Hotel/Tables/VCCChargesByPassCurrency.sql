CREATE TABLE [Hotel].[VCCChargesByPassCurrency] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyName] VARCHAR (150) NULL,
    [IsActive]     BIT           CONSTRAINT [DF_VCCChargesByPassCurrency_IsActive] DEFAULT ((1)) NULL,
    [Remark]       VARCHAR (500) NULL,
    [InsertedDate] DATETIME      CONSTRAINT [DF_VCCChargesByPassCurrency_InsertedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_VCCChargesByPassCurrency] PRIMARY KEY CLUSTERED ([Id] ASC)
);

