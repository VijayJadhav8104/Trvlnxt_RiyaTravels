CREATE TABLE [dbo].[WinYatraDataLog] (
    [Id]              INT           IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [fk_bookmasterId] INT           NULL,
    [type]            VARCHAR (MAX) NULL,
    [Request]         VARCHAR (MAX) NULL,
    [Response]        VARCHAR (MAX) NULL,
    [InvoiceNo]       VARCHAR (100) NULL,
    [Error]           VARCHAR (MAX) NULL,
    [CreatedOn]       DATETIME      CONSTRAINT [DF_WinYatraDataLog_CreatedOn] DEFAULT (getdate()) NULL,
    [ObtcRequest]     VARCHAR (MAX) NULL,
    [ObtcResponse]    VARCHAR (MAX) NULL,
    [ObtcCreatedOn]   DATETIME      NULL,
    CONSTRAINT [PK_WinYatraDataLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

