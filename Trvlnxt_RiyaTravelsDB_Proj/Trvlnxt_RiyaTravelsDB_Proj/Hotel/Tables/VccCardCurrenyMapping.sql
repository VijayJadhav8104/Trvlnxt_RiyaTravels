CREATE TABLE [Hotel].[VccCardCurrenyMapping] (
    [pkId]            INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fk_vccmappingId] INT           NULL,
    [currencyCode]    VARCHAR (100) NULL,
    [currencyCodeNum] VARCHAR (100) NULL,
    CONSTRAINT [PK_VccCardCurrenyMapping] PRIMARY KEY CLUSTERED ([pkId] ASC)
);

