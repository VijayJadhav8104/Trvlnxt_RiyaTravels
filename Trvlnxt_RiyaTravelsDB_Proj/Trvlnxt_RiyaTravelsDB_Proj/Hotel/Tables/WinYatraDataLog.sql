CREATE TABLE [Hotel].[WinYatraDataLog] (
    [Id]              INT           NOT NULL,
    [fk_bookmasterId] INT           NULL,
    [type]            VARCHAR (MAX) NULL,
    [Request]         VARCHAR (MAX) NULL,
    [Response]        VARCHAR (MAX) NULL,
    [InvoiceNo]       VARCHAR (100) NULL,
    [Error]           VARCHAR (MAX) NULL,
    [CreatedOn]       DATETIME      NULL,
    [ObtcRequest]     VARCHAR (MAX) NULL,
    [ObtcResponse]    VARCHAR (MAX) NULL,
    [ObtcCreatedOn]   DATETIME      NULL
);

