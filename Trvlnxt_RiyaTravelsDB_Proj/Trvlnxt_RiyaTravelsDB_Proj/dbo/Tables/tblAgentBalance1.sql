CREATE TABLE [dbo].[tblAgentBalance1] (
    [PKID]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [AgentNo]           INT            NULL,
    [BookingRef]        VARCHAR (50)   NULL,
    [PaymentMode]       VARCHAR (20)   NULL,
    [OpenBalance]       MONEY          NULL,
    [TranscationAmount] MONEY          NULL,
    [CloseBalance]      MONEY          NULL,
    [CreatedOn]         DATETIME       NULL,
    [CreatedBy]         INT            NULL,
    [IsActive]          TINYINT        NULL,
    [TransactionType]   VARCHAR (10)   NULL,
    [Remark]            VARCHAR (2000) NULL,
    [Reference]         VARCHAR (50)   NULL,
    [DueClear]          VARCHAR (50)   NULL,
    [ProductType]       VARCHAR (50)   NULL
);

