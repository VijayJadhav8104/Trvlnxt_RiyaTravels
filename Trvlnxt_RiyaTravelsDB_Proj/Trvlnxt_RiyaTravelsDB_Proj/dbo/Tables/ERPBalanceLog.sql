CREATE TABLE [dbo].[ERPBalanceLog] (
    [ID]           BIGINT        IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [CustNo]       VARCHAR (50)  NULL,
    [RequestXML]   VARCHAR (MAX) NOT NULL,
    [ResponseXML]  VARCHAR (MAX) NULL,
    [InsertedDate] DATETIME      CONSTRAINT [DF_ERPBalanceLog_InsertedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ERPBalanceLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);

