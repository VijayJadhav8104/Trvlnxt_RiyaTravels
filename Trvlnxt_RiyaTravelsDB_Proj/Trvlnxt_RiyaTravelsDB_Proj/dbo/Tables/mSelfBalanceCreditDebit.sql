CREATE TABLE [dbo].[mSelfBalanceCreditDebit] (
    [ID]              INT             IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [UserId]          INT             NULL,
    [CountryId]       INT             NULL,
    [TransactionType] VARCHAR (10)    NULL,
    [Amount]          DECIMAL (18, 3) NULL,
    [Remark]          VARCHAR (MAX)   NULL,
    [CreatedBy]       INT             NULL,
    [CreatedOn]       DATETIME        CONSTRAINT [DF_mSelfBalanceCreditDebit_CreatedOn] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_mSelfBalanceCreditDebit] PRIMARY KEY CLUSTERED ([ID] ASC)
);

