CREATE TABLE [dbo].[mAllApiExceptionLogs_Hotel] (
    [ID]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [APIName]        VARCHAR (MAX) NULL,
    [Request]        VARCHAR (MAX) NULL,
    [Response]       VARCHAR (MAX) NULL,
    [URL]            VARCHAR (100) NULL,
    [MethodType]     VARCHAR (100) NULL,
    [CorrelationID]  VARCHAR (100) NULL,
    [RZAPIAccountID] VARCHAR (100) NULL,
    [RZAPIchannelId] VARCHAR (100) NULL,
    [APIKEY]         VARCHAR (100) NULL,
    [extraHeaders]   VARCHAR (MAX) NULL,
    [Excepetion]     VARCHAR (MAX) NULL,
    [CreatedDate]    DATETIME      CONSTRAINT [DF_mAllApiExceptionLogs_Hotel_CreatedDate] DEFAULT (getdate()) NOT NULL
);

