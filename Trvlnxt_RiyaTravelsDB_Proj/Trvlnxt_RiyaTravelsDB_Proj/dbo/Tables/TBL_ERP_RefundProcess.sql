CREATE TABLE [dbo].[TBL_ERP_RefundProcess] (
    [ID]               BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [BMID]             BIGINT        NULL,
    [PBID]             BIGINT        NULL,
    [CustomerNumber]   VARCHAR (50)  NULL,
    [TicketNumber]     VARCHAR (50)  NULL,
    [Canfees]          VARCHAR (50)  NULL,
    [ServiceFees]      VARCHAR (50)  NULL,
    [MarkupOnBaseFare] VARCHAR (50)  NULL,
    [MarkupOnTaxFare]  VARCHAR (50)  NULL,
    [MarkuponPenalty]  VARCHAR (50)  NULL,
    [Narration]        VARCHAR (MAX) NULL,
    [User]             VARCHAR (50)  NULL,
    [CreatedDate]      DATETIME      CONSTRAINT [DF_TBL_ERP_RefundProcess_CreatedDate] DEFAULT (getdate()) NULL,
    [Flag]             VARCHAR (50)  NULL,
    CONSTRAINT [PK_TBL_ERP_RefundProcess] PRIMARY KEY CLUSTERED ([ID] ASC)
);

