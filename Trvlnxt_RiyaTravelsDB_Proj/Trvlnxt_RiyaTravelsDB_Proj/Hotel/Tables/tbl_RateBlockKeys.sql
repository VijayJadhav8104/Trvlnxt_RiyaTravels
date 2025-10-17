CREATE TABLE [Hotel].[tbl_RateBlockKeys] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [SoldOutKey]   VARCHAR (500) NULL,
    [IsActive]     BIT           NULL,
    [Remark]       VARCHAR (MAX) NULL,
    [SupplierName] VARCHAR (300) NULL,
    CONSTRAINT [PK_tbl_RateBlockKeys] PRIMARY KEY CLUSTERED ([ID] ASC)
);

