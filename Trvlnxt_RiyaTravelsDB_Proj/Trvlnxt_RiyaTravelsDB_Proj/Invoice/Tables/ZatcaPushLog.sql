CREATE TABLE [Invoice].[ZatcaPushLog] (
    [Id]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [Fk_Id]        BIGINT        NULL,
    [Uuid]         VARCHAR (100) NULL,
    [InvoiceNo]    VARCHAR (100) NULL,
    [RequestXML]   VARCHAR (MAX) NULL,
    [SignedXML]    VARCHAR (MAX) NULL,
    [Response]     VARCHAR (MAX) NULL,
    [Hash]         VARCHAR (MAX) NULL,
    [QrCode]       VARCHAR (MAX) NULL,
    [Sequence]     BIGINT        NULL,
    [IsPushed]     BIT           NULL,
    [CreatedDate]  DATETIME      CONSTRAINT [DF_ZatcaPushLog_CreatedDate] DEFAULT (getdate()) NULL,
    [ModifiedDate] DATETIME      NULL,
    CONSTRAINT [PK_ZatcaPushLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

