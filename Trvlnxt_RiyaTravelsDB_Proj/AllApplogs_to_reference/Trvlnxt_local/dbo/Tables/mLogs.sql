CREATE TABLE [dbo].[mLogs] (
    [ID]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [MethodType]    VARCHAR (100) NULL,
    [CorrelationID] VARCHAR (100) NULL,
    [Excepetion]    VARCHAR (MAX) NULL,
    [CreatedDate]   DATETIME      CONSTRAINT [DF_mLogs_CreatedDate] DEFAULT (getdate()) NOT NULL
);

